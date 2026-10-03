# KCP + CRD dev HOW-TO, reverse-engineered from `socialweb-computer-kcp`

Reference repo studied: `/home/johnandersen777/src/publicdomainrelay-kcp/socialweb-computer-kcp`
(module `github.com/johnandersen777/socialweb-computer-kcp`). Everything below is real code
from that repo, with paths you can open. Where the repo contradicts itself (docs say
controller-runtime, go.mod says no) the code is the authority and it is called out.

---------------------------------------------------------------------------

## TL;DR / mental model

- **KCP is a plain external binary, started as a subprocess.** `kcp start --root-directory=...
  --etcd-servers=... --secure-port=... --feature-gates=WorkspaceMounts=true`. It is never
  embedded as a library and never linked in. In tests it is started with `exec.Command`.
- **There is no controller-runtime, no kubebuilder, no controller-gen, no Makefile, no
  `go:generate`.** The module's direct Go deps are only `k8s.io/{api,apimachinery,client-go}`,
  `github.com/kcp-dev/sdk`, `sigs.k8s.io/yaml`, plus a few unrelated libs. See `go.mod`.
- **CRDs are KCP `APIResourceSchema` + `APIExport`, not `apiextensions.k8s.io` CRDs.**
  `APIExport.spec.resources[].storage` is `crd: {}`. Types are Go structs with
  `TypeMeta/ObjectMeta/Spec/Status`, a hand-written `groupversion_info.go`, and a
  **hand-written** `zz_generated.deepcopy.go`. The schema YAML is hand-written too.
- **Talk to KCP with client-go `rest.Interface`**, one REST client per (logical cluster,
  group-version), `APIPath = "/clusters/" + logicalCluster + "/apis"`. No informers, no
  watches. The "reconcile loop" is a **2-second poll ticker** that re-lists and re-reads.
- **Status is written through the `/status` subresource with a JSON merge patch.** The schema
  declares `subresources.status: {}`, so an inline status on create is silently discarded.
- **Lifecycle = phase enum + `metav1.Condition` list + finalizer.** Phases are strings and
  `status.phase == "Ready"` is read as a literal by KCP's mount controller.
- **The value of this repo for you:** it is a working, tested template for
  `define types -> export via APIResourceSchema -> bind in workspaces -> poll-reconcile ->
  write phase/conditions/outputs -> teardown via finalizer`. Replace "virtual cluster" with
  "policy workflow instance" and the skeleton is identical.

---------------------------------------------------------------------------

## 1. Repo layout and naming conventions

```
api/v1alpha1/          wire types only. No logic, no I/O.
internal/${concept}/   one package per concern; the interface is declared where consumed.
cmd/${binary}/         the CLI layer; nothing else builds a binary.
deploy/                install scripts, YAML manifests, audit policy, the container build.
test/                  cross-cutting tests (no-comments/ASCII rule, auth chain).
docs/ARCHITECTURE.md   the single design document. There are no code comments (see Sec 6).
kcp/                   vendored KCP SOURCE, read-only reference. gitignored.
cluster-api/           vendored reference. gitignored.
handoff.yaml, NEXT.yaml  machine-readable state: how_to_run, known_traps, backlog items.
```

Real tree (authored code, excluding vendored dirs):

```
api/v1alpha1/groupversion_info.go
api/v1alpha1/types_cluster.go
api/v1alpha1/types_node.go
api/v1alpha1/types_atprotoidentity.go
api/v1alpha1/zz_generated.deepcopy.go        (hand-written)
api/v1alpha1/types_test.go
cmd/socialweb-clusterprovider/{main,config,wiring,startup,nodes,tokenstore,postgresregistry}.go
cmd/socialweb-gateway/...
cmd/socialweb-nodeagent/...
cmd/socialweb-nodeimage/...
cmd/socialweb-vault/...
internal/materialiser/{materialiser.go,host.go}   the phase machine (the "run engine")
internal/clusterprovider/{provider.go,registry.go,steps.go,tenant.go,...}
internal/scale/scale.go                            pure intent predicate (Job-aware)
internal/scaledriver/scaledriver.go                performs the decision, keeps between-pass state
internal/kcpclient/{kcpclient.go,names.go}         KCP REST client + path/name derivation
internal/noderecord/{record.go,liveness.go}        pid+starttime+cmdline identity, reap-never-adopt
deploy/*.yaml, deploy/*.sh
```

Naming conventions that matter:
- Package name = single concept, lower-case, no underscores (`materialiser`, `noderecord`).
- Interface lives in the consuming package, not the producer (`clusterprovider.Clusters`,
  `materialiser.Host`).
- Dependency direction is one-way and enforced by convention: `api <- internal <- cmd`.
  `api/v1alpha1` imports only `k8s.io/apimachinery`.
- Binaries are one `cmd/${name}` directory each; the project name is a prefix
  (`socialweb-*`). For you: `deno-*` style names.
- **No comments in Go code** except `//go:` directives and `ponytail:` comment groups. See Sec 6.

---------------------------------------------------------------------------

## 2. KCP integration

### 2.1 How KCP runs

External binary, started as a child process. Two shapes exist in the repo.

**a) Host systemd unit (the deployed shape before the container refactor).**
The installer `deploy/install-kcp.sh` was deleted from the working tree at commit
`81e5cbe` ("run the whole deployment as one container") but survives in git history and in
`.claude/worktrees/*/deploy/install-kcp.sh`. It downloads the release tarball, pins the
digest, installs `/usr/local/bin/kcp`, writes an audit policy, and installs the unit:

```bash
KCP_VERSION=v0.33.0
KCP_VERSION_NO_V=${KCP_VERSION#v}
KCP_ARCH=linux_amd64
wget "https://github.com/kcp-dev/kcp/releases/download/${KCP_VERSION}/kcp_${KCP_VERSION_NO_V}_${KCP_ARCH}.tar.gz"
# (SEC-4 later added: sha256sum -c against KCP_SHA256 before extraction)
tar -xzf "kcp_${KCP_VERSION_NO_V}_${KCP_ARCH}.tar.gz"
install -m 0755 bin/kcp /usr/local/bin/kcp
```

The unit (`/etc/systemd/system/kcp.service`):

```
ExecStart=/usr/local/bin/kcp start \
  --root-directory=/var/.kcp/ \
  --bind-address=127.0.0.1 \
  --feature-gates=WorkspaceMounts=true \
  --audit-policy-file=/var/.kcp/audit-policy.yaml \
  --audit-log-path=/var/.kcp/audit.log \
  --audit-log-maxsize=100 --audit-log-maxage=0 --audit-log-maxbackup=0
```

`deploy/run-kcp-instance.sh` is the generic launcher and is still in the tree. It refuses
`--secure-port=0` and requires an external kine:

```bash
exec "$BIN" start \
  --root-directory="$ROOT" \
  --etcd-servers="$KINE" \
  --bind-address="$BIND" \
  --secure-port="$PORT" \
  --feature-gates="$GATES" \
  --audit-policy-file="$POLICY" \
  --audit-log-path="$AUDIT_LOG"
```

**b) One container (current shape).** `deploy/container-entrypoint.sh` starts everything as
children of PID 1 and supervises them. kcp is one of five:

```
bao server -config=... &          ROOT_VAULT_PID
kcp start --root-directory=... --bind-address=127.0.0.1 --secure-port=6443 \
    --feature-gates=WorkspaceMounts=true ... &   KCP_PID
socialweb-gateway &               GATEWAY_PID
socat OPENSSL-LISTEN:8443,... &   TLS_PID
socialweb-clusterprovider &       PROVIDER_PID
```

Built by `deploy/control-plane-container/Dockerfile` and `build.sh`; validated by
`validate.sh`. The container runs as `USER 1000:1000`.

**Critical invariant** (from `internal/versions/versions.json`): kcp MUST run with
`--feature-gates=WorkspaceMounts=true`. With the gate off the mount scheduler returns early
and every tenant's mounted API silently stops being served.

### 2.2 How the code talks to KCP

`client-go` `rest.Interface`, one client per logical cluster. See
`internal/kcpclient/kcpclient.go:116-134` and `internal/clusterprovider/registry.go:288-298`:

```go
func (r *Registry) resource(logicalCluster string, gv schema.GroupVersion) (rest.Interface, error) {
    cfg := rest.CopyConfig(r.cfg)
    cfg.GroupVersion = &gv
    cfg.APIPath = "/clusters/" + logicalCluster + "/apis"
    cfg.NegotiatedSerializer = r.codecs
    return rest.RESTClientForConfigAndClient(cfg, r.http)
}
```

The client config comes from a kubeconfig: `cmd/socialweb-clusterprovider/main.go:86`:

```go
restCfg, err := clientcmd.BuildConfigFromFlags("", cfg.KCPKubeconfig)
```

The scheme registers both your types and KCP's tenancy types
(`kcpclient.go:104-114`):

```go
s := runtime.NewScheme()
v1alpha1.AddToScheme(s)                       // socialweb.computer/v1alpha1
kcpv1alpha1.AddToScheme(s)                    // tenancy.kcp.io/v1alpha1 (Workspace)
metav1.AddToGroupVersion(s, schema.GroupVersion{Version: "v1"})
codecs := serializer.NewCodecFactory(s).WithoutConversion()
```

Writes on the status subresource use a merge patch (`registry.go:184-198`):

```go
body, _ := statusPatch(st)   // {"status": {...}}
c.Patch(types.MergePatchType).SubResource("status").
    Resource("clusters").Name(ref.Name).Body(body).Do(ctx).Into(&v1alpha1.Cluster{})
```

Finalizer removal is a JSON patch with a `test` guard (`registry.go:200-230`):

```go
{"op":"test","path":"/metadata/finalizers","value": cl.Finalizers},
{"op":"add","path":"/metadata/finalizers","value": remaining},
```

### 2.3 APIExport / APIResourceSchema / APIBinding / Workspaces

The provider workspace is `root:socialweb-provider` (workspace name
`socialweb-provider` under `root`). `deploy/install-provider.sh` creates it, then applies
the schemas and exports **through the provider workspace's own URL** (`--server=$SERVER/clusters/root:socialweb-provider`):

```bash
SERVER=$(kubectl ... config view --minify -o jsonpath='{.clusters[0].cluster.server}')
SERVER=${SERVER%%/clusters/*}
PROVIDER_SERVER=${SERVER}/clusters/${PROVIDER_PATH}

KW apply -f "$DEPLOY_DIR/cluster-apiresourceschema.yaml"
KW apply -f "$DEPLOY_DIR/node-apiresourceschema.yaml"
KW apply -f "$DEPLOY_DIR/atprotoidentity-apiresourceschema.yaml"
KW apply -f "$DEPLOY_DIR/cluster-apiexport.yaml"
KW apply -f "$DEPLOY_DIR/atprotoidentity-apiexport.yaml"
K apply -f "$DEPLOY_DIR/workspacetype-account.yaml"
K apply -f "$DEPLOY_DIR/workspacetype-cluster.yaml"
```

`APIResourceSchema` (`deploy/cluster-apiresourceschema.yaml`) is the CRD equivalent:

```yaml
apiVersion: apis.kcp.io/v1alpha1
kind: APIResourceSchema
metadata:
  name: v1alpha1-1.clusters.socialweb.computer
spec:
  group: socialweb.computer
  names: {kind: Cluster, listKind: ClusterList, plural: clusters, singular: cluster}
  scope: Cluster
  versions:
    - name: v1alpha1
      served: true
      storage: true
      subresources: {status: {}}
      schema:
        type: object
        properties:
          apiVersion: {type: string}
          kind: {type: string}
          metadata: {type: object}
          spec:
            type: object
            properties:
              account: {type: string}
              running: {type: boolean}
            required: [account]
          status:
            type: object
            properties:
              phase: {type: string, enum: [Initializing, Ready, Unavailable, Draining]}
              URL: {type: string}
              instance: {type: string}
              nodeExpiry: {type: integer, format: int64}
              conditions:
                type: array
                items: {type: object, x-kubernetes-preserve-unknown-fields: true}
```

`APIExport` (`deploy/cluster-apiexport.yaml`) points at one or more schemas. Note
`storage: crd: {}` and that **Cluster and Node ride ONE export named `clusters`**:

```yaml
apiVersion: apis.kcp.io/v1alpha2
kind: APIExport
metadata: {name: clusters}
spec:
  resources:
    - {group: socialweb.computer, name: clusters, schema: v1alpha1-1.clusters.socialweb.computer, storage: {crd: {}}}
    - {group: socialweb.computer, name: nodes,   schema: v1alpha1-1.nodes.socialweb.computer,   storage: {crd: {}}}
```

`WorkspaceType` (`deploy/workspacetype-cluster.yaml`) is how tenants get the API bound
without a manual APIBinding:

```yaml
apiVersion: tenancy.kcp.io/v1alpha1
kind: WorkspaceType
metadata: {name: cluster}
spec:
  extend: {with: [{name: universal, path: root}]}
  defaultAPIBindings:
    - {export: clusters, path: root:socialweb-provider}
```

`workspacetype-account.yaml` binds `atprotoidentities` and sets
`defaultChildWorkspaceType: {name: cluster, path: root}`.

**Workspace tree** (derived in `internal/kcpclient/names.go`):

```
root
  root:<accounthash>            WorkspaceType account   (AtprotoIdentity CR lives here)
    root:<accounthash>:<name>   WorkspaceType cluster   (Cluster + Node CRs live here)
      root:<accounthash>:<name>:clusters   a MOUNT workspace whose spec.mount.ref names the Cluster CR
```

`ChildLabel = "clusters"`. The user's kubeconfig server is
`<host>/clusters/<MountPath>` where `MountPath = AccountPath(did) + ":" + name + ":" + ChildLabel`.

The mount workspace is created by `kcpclient.ensure` (`kcpclient.go:159-197`) with:

```go
child := kcpv1alpha1.WorkspaceSpec{Mount: &kcpv1alpha1.Mount{
    Reference: kcpv1alpha1.ObjectReference{
        APIVersion: "socialweb.computer/v1alpha1", Kind: "Cluster", Name: name,
    },
}}
c.createWorkspace(ctx, home, ChildLabel, child)
```

**Mount gate, measured** (`docs/ARCHITECTURE.md` sections 6 and 15): KCP's mount controller
reads the referenced object's `status.phase` and requires the literal string `"Ready"`.
`status.URL` alone is not enough. With phase `Initializing` the mount reports
`WorkspaceMountReady=False(MountObjectNotReady)` and the front proxy answers 503. kcp
populates the child's `spec.URL` FROM `Cluster.status.URL`.

### 2.4 Bootstrap / install flow

1. Start kcp (`install-kcp.sh`, `run-kcp-instance.sh`, or the container entrypoint).
2. Wait for `/readyz`, read `/var/.kcp/admin.kubeconfig` (or the root dir's `admin.kubeconfig`).
3. `install-provider.sh`: create provider workspace, apply schemas + exports, apply
   workspace types, wait for each `APIExport.status.conditions[type=IdentityValid].status == "True"`.
4. `apply-permission-inventory.sh`: render `permission-inventory.yaml`, mint real tokens, and
   assert each identity can do exactly its verbs in its origin workspace.
5. Create the cluster: account workspace -> home workspace -> `Cluster` CR
   (see `container-entrypoint.sh` `bootstrap_cluster`, quoted in Sec 8).

---------------------------------------------------------------------------

## 3. CRD / API type definition

### 3.1 The Go structs

Exact pattern, `api/v1alpha1/types_cluster.go`:

```go
type Cluster struct {
    metav1.TypeMeta   `json:",inline"`
    metav1.ObjectMeta `json:"metadata,omitempty"`

    Spec   ClusterSpec   `json:"spec,omitempty"`
    Status ClusterStatus `json:"status,omitempty"`
}

type ClusterList struct {
    metav1.TypeMeta `json:",inline"`
    metav1.ListMeta `json:"metadata,omitempty"`
    Items []Cluster `json:"items"`
}

type ClusterSpec struct {
    Account string `json:"account"`
    Running bool   `json:"running"`
}

type ClusterPhase string

const (
    ClusterInitializing ClusterPhase = "Initializing"
    ClusterReady        ClusterPhase = "Ready"
    ClusterUnavailable  ClusterPhase = "Unavailable"
    ClusterDraining     ClusterPhase = "Draining"
)

type ClusterStatus struct {
    Phase      ClusterPhase         `json:"phase,omitempty"`
    URL        string               `json:"URL,omitempty"`      // deliberately not Go-idiomatic
    Instance   string               `json:"instance,omitempty"`
    NodeExpiry *int64               `json:"nodeExpiry,omitempty"`
    Conditions []metav1.Condition   `json:"conditions,omitempty"`
}

const FinalizerCluster = "cluster.socialweb.computer/teardown"
```

Notes:
- `NodeExpiry` is `*int64` on purpose. Absent, `0` (UNLIMITED), and a deadline are three
  distinct states; the test `TestNodeExpiryDistinguishesUnlimitedFromAbsent` guards it.
  A plain `int64` would make "unlimited" and "unknown" identical.
- `URL` is capitalized in JSON because KCP reads that name. The test
  `TestMountContractFieldNamesAreNotGoIdiomatic` guards it.
- Phases are defined in Go; the enum lives in the schema YAML as well. `ClusterReady` must be
  the literal `"Ready"` (`TestOnlyTheLiteralReadySatisfiesAMount`).

### 3.2 groupversion_info.go

`api/v1alpha1/groupversion_info.go` (exact):

```go
const GroupName = "socialweb.computer"
const Version = "v1alpha1"
var GroupVersion = schema.GroupVersion{Group: GroupName, Version: Version}
var SchemeBuilder = runtime.NewSchemeBuilder(addKnownTypes)
var AddToScheme = SchemeBuilder.AddToScheme

func addKnownTypes(scheme *runtime.Scheme) error {
    scheme.AddKnownTypes(GroupVersion,
        &Cluster{}, &ClusterList{}, &Node{}, &NodeList{},
        &AtprotoIdentity{}, &AtprotoIdentityList{})
    return nil
}
```

Collection names are **not** derived in code; the REST client hardcodes the plural at call
sites (`r.Get().Resource("clusters")`, `r.Post().Resource("atprotoidentities")`). Keep the
plural consistent with the schema and the KCP path; nothing validates it for you except a
404 at runtime.

### 3.3 DeepCopy: hand-written, not generated

`api/v1alpha1/zz_generated.deepcopy.go` is committed but there is **no `go:generate`, no
controller-gen, no codegen tool anywhere in the repo**. It is maintained by hand and guarded
by `TestDeepCopyDoesNotAliasNodeExpiryOrConditions`. Pattern per type:

```go
func (in *Cluster) DeepCopyInto(out *Cluster) {
    *out = *in
    out.TypeMeta = in.TypeMeta
    in.ObjectMeta.DeepCopyInto(&out.ObjectMeta)
    out.Spec = in.Spec                 // value type: plain copy
    in.Status.DeepCopyInto(&out.Status)  // pointer/slice fields: deep copy
}
func (in *Cluster) DeepCopy() *Cluster { ... out := new(Cluster); in.DeepCopyInto(out); return out }
func (in *Cluster) DeepCopyObject() runtime.Object { if c := in.DeepCopy(); c != nil { return c }; return nil }
```

`ClusterStatus.DeepCopyInto` must copy `NodeExpiry` (new `*int64`) and the `Conditions`
slice. A shallow copy aliases and the guard test fails.

### 3.4 Schema YAML: hand-written, must match the Go struct

There is no generation step, so the schema is a hand-maintained mirror. Every field you add
to a Go type and every phase/enum must be added to the matching
`deploy/*-apiresourceschema.yaml` by hand. Also note (from `internal/versions/versions.json`):
`APIResourceSchema.spec` is IMMUTABLE. An added enum is a NEW schema revision, so you bump
the `metadata.name` (e.g. `v1alpha1-1.<plural>.<group>` -> `v1alpha1-2...`) and re-point the
`APIExport`. The `identityHash` survives a re-point; changing it would read from an empty
etcd prefix.

### 3.5 Scope

Both Cluster and Node are `scope: Cluster` (KCP cluster-scoped, i.e. logical-cluster scoped,
no namespaces). AtprotoIdentity is also cluster-scoped. If your workflow instance needs
per-tenant namespacing, namespace it in KCP workspaces instead (the workspace is the
isolation unit), matching this repo.

---------------------------------------------------------------------------

## 4. Controllers / reconcilers

### 4.1 There is no controller-runtime; it is a poll loop

`go.mod` has no `sigs.k8s.io/controller-runtime` and no authored file imports it. The
"controller" is `internal/clusterprovider.Provider.Run` (`provider.go:378-410`):

```go
func (p *Provider) Run(ctx context.Context) error {
    for {
        refs, err := p.opts.Registry.Refs(ctx)
        if err != nil { return err }
        p.reclaim(refs)
        for _, ref := range refs {
            pass, err := p.Reconcile(ctx, ref)
            ...
        }
        select {
        case <-ctx.Done(): return nil
        case <-time.After(p.opts.Interval):   // DefaultInterval = 2 * time.Second
        }
    }
}
```

`Registry.Refs` walks the workspace tree by LIST (`registry.go:83-119`): list workspaces in
`root`, then each account, then list `clusters` in each home. There is no workqueue and no
informer; the ticker is the queue. Selection/queue-by-key is replaced by
"re-list everything every 2s and reconcile each". For a Job-like system with many short
lived instances this is the first thing to reconsider: 2s full re-list is fine for tens of
long-lived clusters, not for thousands of short Jobs. Consider an informer if you need
watch latency, but keep the same `Reconcile(ctx, ref) -> Result` seam so the logic is
testable without a cluster.

### 4.2 The phase machine is a separate pure package: `internal/materialiser`

The controller does I/O; the decision is pure. `materialiser.Reconciler.Reconcile`
(`materialiser.go:185-211`) takes an `Observed` struct (a snapshot of the CR plus probes)
and returns a `Result` (phase, outputs, conditions, ops, requeue):

```go
type Observed struct {
    Cluster       v1alpha1.Cluster
    PathStatus    int          // HTTP status of the mount path probe
    Reachable     bool
    IdentityState v1alpha1.IdentityState
    ServiceAccountPresent bool
    Now           time.Time
}

type Result struct {
    Phase      v1alpha1.ClusterPhase
    URL        string
    Instance   string
    Conditions []metav1.Condition
    Alert      string
    Ops        []Op
    RequeueAfter time.Duration
    RemoveFinalizer bool
    Halted bool
}

func (r *Reconciler) Reconcile(ctx context.Context, o Observed) (Result, error) {
    if o.Cluster.DeletionTimestamp != nil { return r.teardown(ctx, o) }  // delete path
    if halted(o.Cluster.Status.Conditions) { ... }                       // terminal failure
    if !o.Cluster.Spec.Running { return r.off(ctx, o) }                  // suspended
    return r.on(ctx, o)                                                   // desired running
}
```

This is the single most copyable pattern. The decision path never touches the network except
through the small `Host`/`Ports`/`Networks` interfaces it is handed, so the whole lifecycle
is unit-testable with fakes (see `materialiser_test.go`, which also re-execs itself as a
fake child process, line 951).

The controller wraps it (`internal/clusterprovider/provider.go:261-326`):

```go
cl, err := p.opts.Registry.Read(ctx, ref)
...
o, err := p.observe(ctx, ref, cl)      // fill Observed: probe URL, read identity state
res, err := p.opts.Decider.Reconcile(ctx, o)
if !p.opts.WriteStatus { return pass, nil }
p.opts.Registry.WriteStatus(ctx, ref, statusOf(cl, res))
if res.RemoveFinalizer { p.opts.Registry.RemoveFinalizer(ctx, ref) }
if res.Phase == readyPhase && cl.Status.Phase != readyPhase && p.opts.OnReady != nil {
    p.opts.OnReady(ctx, ref, after)     // one-shot on transition into Ready
}
```

`OnReady` is the hook the composition root uses to run bootstrap exactly once on the
transition into Ready (not on every pass). Equivalent to a Job's "on first success".

### 4.3 Status and outputs

Outputs for an instance are its status fields: `phase`, `URL`, `instance`, `nodeExpiry`,
`conditions`. There is no separate "outputs" CR. `status.instance` is a token minted once per
bring-up generation and bumped on restart (`main.go:405-411`):

```go
func instanceMinter() func() string {
    start := time.Now().UTC().Format("20060102T150405Z")
    var n atomic.Int64
    return func() string { return fmt.Sprintf("gen-%s-%d", start, n.Add(1)) }
}
```

Conditions use `k8s.io/apimachinery/pkg/api/meta`. `meta.SetStatusCondition` sets
`ObservedGeneration` from `o.Cluster.Generation`:

```go
meta.SetStatusCondition(&res.Conditions, metav1.Condition{
    Type:               ConditionReady,             // "Ready"
    Status:             metav1.ConditionFalse,
    Reason:             ReasonInitializing,         // "Initializing"
    Message:            "bringing up ...",
    LastTransitionTime: metav1.NewTime(o.Now),
    ObservedGeneration: o.Cluster.Generation,
})
```

Condition types are string consts in the API package, e.g.
`ConditionTeardownBlocked`, `ConditionTenantPathShut`, `ConditionReachable`,
`ConditionRevocationPending`, `ConditionIdentityVerificationFailed`, and
`materialiser.ConditionReady = "Ready"`.

### 4.4 Finalizer and teardown

The CR is created with a finalizer (`kcpclient.go:278-281`):
`Finalizers: []string{v1alpha1.FinalizerCluster}`. On delete,
`materialiser.teardown` (`materialiser.go:300-371`) runs a gated sequence: mark `Draining`,
refuse if the expiry gate cannot compare, shut the tenant path, wait for it to be shut,
then reap, release ports, release subnet, and set `RemoveFinalizer = true`. The controller
removes the finalizer via the JSON test+add patch.

### 4.5 Watches, queues, and requeue timing

- No watches. Every pass re-lists.
- `materialiser.RequeueAfter = 2 * time.Second` is advisory only; the outer loop already
  ticks at 2s. It is carried in the Result so a future informer-based driver can honour it.
- "Queue by key" is unnecessary because each pass reconciles every visible `Ref`.

---------------------------------------------------------------------------

## 5. Kubernetes-Job-like semantics already present (and what is absent)

Map the reference lifecycle onto the Job controller:

| Kubernetes Job | Reference equivalent | Where |
|---|---|---|
| `spec.suspend` | `ClusterSpec.Running` (false = parked, `off()` path) | `types_cluster.go`, `materialiser.off` |
| `spec.activeDeadlineSeconds` | `materialiser.DefaultInitTimeout` = 15m, then park to `Unavailable` | `materialiser.go:41,477-481` |
| `spec.parallelism` / completions | none. v1 is 0-or-1 workers (`Node`) per instance | `docs/ARCHITECTURE.md` Sec 2 |
| `spec.backoffLimit` (retries) | **none.** A spawn failure requeues; a failed bring-up parks after the init timeout. No retry counter in status | `materialiser.bringUp` |
| `ttlSecondsAfterFinished` | **none.** Instead: `status.nodeExpiry` (session cap, gate) and the scale idle `Hold` | Sec below |
| `status.startTime` | implicit: `ConditionReady.LastTransitionTime` | `materialiser.readySince` |
| `status.completionTime` | **none.** "Finished successfully" is expressed as `phase: Ready`, not a completion time |  |
| `status.succeeded/failed` | `phase` enum + `conditions` | `types_cluster.go` |
| finalizer / foreground deletion | `FinalizerCluster` + gated teardown | `materialiser.teardown` |
| Job's "anything still running" predicate | `internal/scale.Decide` -- a pure intent test over Pods/Jobs/Deployments/StatefulSets/DaemonSets | `internal/scale/scale.go` |

What `internal/scale` already gets right for job-like work (`scale.go:42-94`):
- A completed Job (`status.completionTime != nil`) is NOT intent.
- A suspended Job (`spec.suspend == true`) is NOT intent.
- `Succeeded`/`Failed` pods are NOT intent.
- An absent `spec.replicas` is `1`, not `0` (the API server defaults it).
- A list failure is an ERROR, never an empty observation (invariant 14). An unreadable
  cluster is not an idle one.

What `internal/scaledriver` adds (`scaledriver.go:48-94`): the decision is pure, the driver
performs it and remembers only `IdleSince` between passes ("state advances only on success").
`State.Nodes` is re-read from the CRs every pass, never trusted from a variable.

**If you want closer Job semantics, add to your Status:** `startTime`, `completionTime`,
`active/succeeded/failed int32`, and a `retries`/`backoff` counter. The reference deliberately
kept only `phase`+`conditions`; that is a design choice, not a limitation of KCP.

**Idle hold / TTL mapping:** the reference has `SOCIALWEB_CLUSTERPROVIDER_SCALE_HOLD`
(`cmd/socialweb-clusterprovider/config.go:48`, default 2m in `scale.DefaultHold`). It is the
"how long to keep the worker after the work finished" grace. For a Job-like TTL, this is the
field to reuse; it is a runtime option, not a CR field.

---------------------------------------------------------------------------

## 6. Dev environment and iteration

### 6.1 Required tools and exact versions

From `internal/versions/versions.json` (pinned) and confirmed on this host:

| Tool | Pinned | On this host |
|---|---|---|
| Go | `go 1.26.6` (go.mod) | go1.26.6 linux/amd64 |
| kcp | `v1.36.0+kcp-v0.33.0` (release binary) | `/usr/local/bin/kcp` -> `kcp version v1.36.0+kcp-v0.33.0` |
| k3s | `v1.36.4+k3s1` | `/usr/local/bin/k3s` |
| kine | `v0.17.1`, built `CGO_ENABLED=1` | `/home/johnandersen777/Documents/go/bin/kine` |
| OpenBao | `v2.6.2` | `/usr/local/bin/bao` |
| kubectl | any current | `/usr/local/bin/kubectl` |
| modules | `k8s.io/* v0.36.4`, `github.com/kcp-dev/sdk v0.33.1` | go.mod |

kine: `go install github.com/k3s-io/kine@v0.17.1` with `CGO_ENABLED=1`. It ships no prebuilt
release for every target, so the CGO build is part of the recipe. kine IS the store: k3s must
DIAL it (`--etcd-servers`), never consume its bucket.

### 6.2 Build, vet, test, format

There is **no Makefile, no Taskfile, no justfile, no go:generate**. The loop is `go` directly.
`handoff.yaml:78`:

```
go build ./... && go vet ./... && go test ./... ; gofmt -l internal/ cmd/
```

Measured on a 16-core host (from `NEXT.yaml` and `README.md`):
- `go build ./...` warm 0.99s, cold 12.96s.
- `go vet ./...` warm 0.15s, cold 15.05s.
- `go test -count=1 ./...` ~68-70s; `internal/clusterprovider` alone ~66-68s.
- `go test -short -count=1 ./...` ~24s.

`gofmt -l internal/ cmd/` must print nothing. `go mod tidy -diff` must be clean.

Dev-tool trap (`handoff.yaml` known_traps + NEXT.yaml DEV-2): the installed `gopls`,
`staticcheck`, `govulncheck` must be rebuilt with the same Go toolchain as the module
(go1.26.4/1.26.6). A tool built with an older Go reports false undefined symbols. Rule:
**the compiler is the authority; run `go build ./...` before acting on any diagnostic.**

### 6.3 Getting a local KCP

Two ways, both real:

**Host binary.** `/usr/local/bin/kcp` already exists here. Start it against a local kine with
`deploy/run-kcp-instance.sh`:

```bash
KCP_INSTANCE=demo \
KCP_SECURE_PORT=6443 \
KCP_KINE_ENDPOINT=http://127.0.0.1:20001 \
./deploy/run-kcp-instance.sh
# admin kubeconfig lands at $PWD/.kcp-demo/admin.kubeconfig
```

You must start kine first (kcp otherwise starts an embedded etcd on the host-fixed
2379/2380, which no flag can move):

```bash
kine --endpoint sqlite:///tmp/kine.db --listen-address 127.0.0.1:20001 --metrics-bind-address=0
```

**In tests.** `internal/clusterprovider/live_mount_test.go:832-914` starts a real kcp and
kine as children of the test, in the test's own temp dir, and tears them down with
`SIGTERM`/`SIGKILL` to the process group:

```go
mountProofStartProcess(t, filepath.Join(dir, "kcp-kine.log"), "kine",
    "--endpoint", "sqlite://"+filepath.Join(dir, "kcp-kine.db"),
    "--listen-address", fmt.Sprintf("127.0.0.1:%d", kinePort),
    "--metrics-bind-address=0")
...
mountProofStartProcess(t, filepath.Join(dir, "kcp.log"), bin,  // bin = $KCP_BIN or "kcp"
    "start",
    "--root-directory="+root,
    "--etcd-servers="+fmt.Sprintf("http://127.0.0.1:%d", kinePort),
    "--bind-address=127.0.0.1",
    "--secure-port="+strconv.Itoa(kcpPort),
    "--feature-gates=WorkspaceMounts=true",
    "--audit-policy-file="+policy,
    "--audit-log-path="+filepath.Join(root, "audit.log"),
)
// then wait for <root>/admin.kubeconfig, then for https://127.0.0.1:<kcpPort>/readyz
```

`KCP_BIN` overrides the binary path. This is the pattern to copy for your own
integration tests: a per-test root directory, a per-test kine, a leased secure port, and a
readiness poll on the kubeconfig file then `/readyz`.

### 6.4 Applying manifests

Use `kubectl` with `--server` pointed at a specific logical cluster. Workspace-scoped apply:

```bash
KUBECONFIG=/var/.kcp/admin.kubeconfig
SERVER=$(kubectl --kubeconfig="$KUBECONFIG" config view --minify -o jsonpath='{.clusters[0].cluster.server}')
SERVER=${SERVER%%/clusters/*}

# root-level objects (WorkspaceType)
kubectl --kubeconfig="$KUBECONFIG" apply -f deploy/workspacetype-account.yaml

# provider-workspace objects (schemas + exports)
kubectl --kubeconfig="$KUBECONFIG" --server="$SERVER/clusters/root:socialweb-provider" \
  apply -f deploy/cluster-apiresourceschema.yaml
```

Measured gotcha (`install-provider.sh:64-74`): after applying an APIExport you must wait for
`status.conditions[?(@.type=="IdentityValid")].status == "True"` before binding. `install-provider.sh`
polls up to `WAIT_SECONDS=120`.

### 6.5 The iteration loop (copy this)

1. Edit Go types in `api/v1alpha1/`.
2. Update `zz_generated.deepcopy.go` by hand for any pointer/slice/map field.
3. Update the matching `deploy/*-apiresourceschema.yaml` by hand; bump the schema name if the
   change is not backward compatible (spec is immutable).
4. `go build ./...` (authority), then `go vet ./...` and `gofmt -l api internal cmd`.
5. `go test -short ./...` for the fast loop (seconds to ~24s).
6. For anything touching KCP: start a local kcp+kine (Sec 6.3) and run the specific live test
   by name, e.g.
   `go test ./internal/clusterprovider -run TestTheMountShutsBeforeTheTenantProcessGroupDies -v -count=1`.
7. `deploy/install-provider.sh` re-applies schemas/exports/workspace types against the local
   kcp. If the schema changed, delete/re-point the export first (immutable spec).
8. Recreate the instance (account -> home -> `Cluster` CR, Sec 8) and read outputs with
   `kubectl ... -o jsonpath`, or over the mounted API.
9. `go test ./...` and, when live inputs exist, `SOCIALWEB_REQUIRE_LIVE=1 go test ./...`.

`handoff.yaml:80-83` gives the concrete named proofs:
```
go test ./internal/clusterprovider -run TestTheControlPlaneReachesReadyAtZeroNodes -v -count=1
go test ./internal/clusterprovider -run TestTheMountShutsBeforeTheTenantProcessGroupDies -v -count=1
go run ./cmd/socialweb-computer-kcp-check-host
```

---------------------------------------------------------------------------

## 7. Test strategy

- **Unit tests per package, no framework.** Plain `testing`. Fakes are hand-written structs
  implementing the consuming interface (see `test/auth_chain_test.go` `denyStub`, `storeStub`).
  The pure packages (`scale`, `materialiser`, `noderecord`, `portallocator`) carry the bulk
  of the logic tests.
- **Live/integration proofs are in the same `_test.go` files** and gated by env. They start
  real kcp, kine, k3s, openbao, firecracker. `internal/livegate` is the gate:

  ```go
  func Require(t *testing.T, format string, args ...any) {
      if os.Getenv("SOCIALWEB_REQUIRE_LIVE") == "1" { t.Fatalf(format, args...) }
      t.Skipf(format, args...)
  }
  func Short(t *testing.T, format string, args ...any) {
      if testing.Short() { Require(t, format, args...) }
  }
  ```

  So `-short` skips long live tests; `SOCIALWEB_REQUIRE_LIVE=1` turns every skip into a
  failure ("a skip is not a pass").
- **No envtest, no kind, no controller-runtime test harness.** Integration is "start the real
  binary and assert".
- **Meta-tests** in `test/`:
  - `test/nocomments_test.go` `TestNoCommentsAndASCII` walks `api`, `internal`, `cmd`, `test`
    and fails on any comment that is not a `//go:` directive or `ponytail:` group, and on any
    byte above 0x7F.
  - `test/auth_chain_test.go` exercises the auth chain against stubs.
- **Guard-against-vacuous-tests** pattern (from `handoff.yaml`): tests are written so they can
  FAIL. `deploy/control-plane-container/validate.sh` refuses to read `go test`'s exit code
  as proof; it requires a literal `--- PASS: <TestName>` line, because `go test` exits 0 on
  SKIP and on `[no tests to run]`.

---------------------------------------------------------------------------

## 8. Copy-pastable examples

### 8.1 Install kcp on a host (from `deploy/install-kcp.sh`, git history at 03542ca)

```bash
#!/bin/bash
set -eux -o pipefail
KCP_VERSION=v0.33.0
KCP_VERSION_NO_V=${KCP_VERSION#v}
KCP_ARCH=linux_amd64
wget "https://github.com/kcp-dev/kcp/releases/download/${KCP_VERSION}/kcp_${KCP_VERSION_NO_V}_${KCP_ARCH}.tar.gz"
tar -xzf "kcp_${KCP_VERSION_NO_V}_${KCP_ARCH}.tar.gz"
install -m 0755 bin/kcp /usr/local/bin/kcp
rm -rf bin "kcp_${KCP_VERSION_NO_V}_${KCP_ARCH}.tar.gz"
```

Use `deploy/run-kcp-instance.sh` (still in the tree) to run it against a local kine.

### 8.2 Bootstrap an instance by hand (from `container-entrypoint.sh:97-161`)

```bash
ROOT_SERVER="$SOCIALWEB_KCP_HOST/clusters/root"
K() { kubectl --kubeconfig="$SOCIALWEB_KCP_KUBECONFIG" "$@"; }

account=socialweb; home=live; cluster=socialweb
did=did:plc:container000000000000000

K --server="$ROOT_SERVER" apply -f - <<YAML
apiVersion: tenancy.kcp.io/v1alpha1
kind: Workspace
metadata: {name: ${account}}
spec: {type: {name: account, path: root}}
YAML

K --server="$SOCIALWEB_KCP_HOST/clusters/root:${account}" apply -f - <<YAML
apiVersion: tenancy.kcp.io/v1alpha1
kind: Workspace
metadata: {name: ${home}}
spec: {type: {name: cluster, path: root}}
YAML

K --server="$SOCIALWEB_KCP_HOST/clusters/root:${account}:${home}" apply -f - <<YAML
apiVersion: socialweb.computer/v1alpha1
kind: Cluster
metadata: {name: ${cluster}}
spec: {account: ${did}, running: true}
YAML

K --server="$SOCIALWEB_KCP_HOST/clusters/root:${account}:${home}" get cluster "$cluster" -o name
```

Read outputs:

```bash
K --server=".../clusters/root:socialweb:live" get cluster socialweb \
  -o jsonpath='{.status.phase}{" "}{.status.URL}{" "}{.status.instance}{"\n"}'
```

### 8.3 Apply the provider stack

```bash
KUBECTL=kubectl KUBECONFIG_PATH=/var/.kcp/admin.kubeconfig \
  PROVIDER_WORKSPACE=socialweb-provider GRANT_CONTEXT=system:admin \
  ./deploy/install-provider.sh
```

### 8.4 Minimal "install my stack" skeleton for deno-kcp

```bash
set -euo pipefail
KUBECONFIG=${KUBECONFIG:-/var/.kcp/admin.kubeconfig}
K() { kubectl --kubeconfig="$KUBECONFIG" "$@"; }
ROOT_SERVER=$(K config view --minify -o jsonpath='{.clusters[0].cluster.server}'); ROOT_SERVER=${ROOT_SERVER%%/clusters/*}

# 1. provider workspace
K --server="$ROOT_SERVER/clusters/root" apply -f - <<'YAML'
apiVersion: tenancy.kcp.io/v1alpha1
kind: Workspace
metadata: {name: deno-provider}
spec: {type: {name: universal, path: root}}
YAML

# 2. schemas + export in the provider workspace
K --server="$ROOT_SERVER/clusters/root:deno-provider" apply -f deploy/workflowinstance-apiresourceschema.yaml
K --server="$ROOT_SERVER/clusters/root:deno-provider" apply -f deploy/workflowinstance-apiexport.yaml

# 3. tenant workspace type at root
K --server="$ROOT_SERVER/clusters/root" apply -f deploy/workspacetype-workflow.yaml

# 4. wait for IdentityValid, then create a tenant workspace and an instance
```

(Put the manifests under your `deploy/` before running.)

---------------------------------------------------------------------------

## 9. Gotchas / traps (measured in the reference repo)

1. **No controller-runtime / kubebuilder / controller-gen.** Do not add them expecting the
   reference to have used them; it did not. If you want them, that is a deliberate departure.
2. **`status` needs the subresource.** `APIResourceSchema` must declare
   `subresources: {status: {}}`; an inline status on POST is silently dropped. The reference's
   own error message states this at `kcpclient.go:729-733`.
3. **The mount gate is `status.phase == "Ready"` literally**, not the conditions. A written
   `status.URL` with `phase: Initializing` is a 503.
4. **`APIResourceSchema.spec` is immutable.** A schema change is a new `metadata.name` and a
   re-pointed export. `identityHash` changes the etcd prefix; do not churn it.
5. **Cluster and Node share one export** (`clusters`) because
   `WorkspaceType.defaultAPIBindings` names an export and the guard test requires every entry
   to equal the export name. Plan your exports accordingly.
6. **`--feature-gates=WorkspaceMounts=true` is mandatory.** Off means mounts silently stop.
7. **KCP needs a default route at start** (`kcp v0.33 has no --advertise-address`); the unit
   uses `After=network-online.target` and `RestartSec=5s` for that reason.
8. **`go test` exits 0 on SKIP.** Gates must read the `--- PASS: <name>` line.
9. **No comments in Go, ASCII only.** `test/nocomments_test.go` enforces it. In this repo that
   is a hard code rule, not a style preference.
10. **A poll loop re-lists everything every 2s.** Fine for long-lived instances; reconsider
    for high-cardinality short-lived Jobs.
11. **Deepcopy is hand-written.** Adding a pointer/slice field without updating it aliases
    state across passes.
12. **Toolchain skew.** Debug tools must be built with the module's Go version.
13. **`govulncheck` reports standard-library vulnerabilities** in the pinned toolchain
    (`NEXT.yaml`); they are recorded, not silently ignored.

---------------------------------------------------------------------------

## 10. Concrete checklist for deno-kcp ("policy workflow instances" as Job-like runs)

Copy these five things, in this order:

1. **API types + hand-written deepcopy + schema YAML**, one group/version, cluster-scoped.
   Suggested type: `WorkflowInstance` with `Spec{Policy, Inputs, Suspended, ...}` and
   `Status{Phase, Instance, Outputs, StartTime, CompletionTime, Active/Succeeded/Failed,
   Conditions}`, plus `FinalizerWorkflow = "workflowinstance.deno/teardown"`. Add a
   `WorkflowStep` (or reuse a single type) for the per-step worker, mirroring `Node`.
   Files: `api/v1alpha1/groupversion_info.go`, `types_workflowinstance.go`,
   `zz_generated.deepcopy.go`; `deploy/workflowinstance-apiresourceschema.yaml`,
   `deploy/workflow-apiexport.yaml`.

2. **A pure reconcile package** `internal/workflow/` with
   `Reconcile(ctx, Observed) (Result, error)`, phase consts, condition types, and a
   `DeletionTimestamp` teardown branch. No network inside; take interfaces for the outside
   world. This is `internal/materialiser` for you.

3. **A controller package** `internal/workflowprovider/` (analogue of
   `clusterprovider/registry.go` + `provider.go`) that:
   - builds a client-go `rest.Interface` with `APIPath = "/clusters/<lc>/apis"`;
   - lists instances (start with a 2s poll loop; move to an informer if cardinality grows);
   - writes phase/outputs through the `/status` merge patch;
   - removes the finalizer with the JSON test+add patch;
   - runs a one-shot hook on the transition into `Ready`/`Completed`.

4. **KCP install/export flow**: `install-provider.sh`-style script (create provider
   workspace, apply schema+export through its `--server` URL, apply the tenant
   `WorkspaceType`, wait for `IdentityValid`). A `WorkspaceType` with
   `defaultAPIBindings` is how your instance type becomes visible in tenant workspaces
   without hand-written APIBindings.

5. **Tests and version pins**: `internal/livegate` (`-short` / `SOCIALWEB_REQUIRE_LIVE`), a
   real-kcp integration test that starts `kcp`+`kine` from a temp dir and polls
   `<root>/admin.kubeconfig` then `/readyz`, and `internal/versions/versions.json` pinning
   kcp/k3s/kine/bao with the "how" and "invariant" for each.

Deliberately add, because the reference lacks them and Jobs have them:
`startTime`/`completionTime`, a failure/retry counter with `backoffLimit`, and a
`ttlSecondsAfterFinished` that a reconciler enforces by deleting the CR after
`completionTime + ttl`. Represent them as status fields plus one condition, exactly the way
`nodeExpiry` is represented (`*int64`, absent vs `0` vs a deadline -- test the distinction).

---------------------------------------------------------------------------

## Appendix: file/line index used in this doc

- KCP REST client: `internal/kcpclient/kcpclient.go` (client build 75-134; ensure/mount 159-197; status patch 695-735)
- Path/name derivation: `internal/kcpclient/names.go`
- Registry (list/read/write): `internal/clusterprovider/registry.go`
- Phase machine: `internal/materialiser/materialiser.go` (Reconcile 185-211; teardown 300-371; on 373-397; bringUp 457-547)
- Process host: `internal/materialiser/host.go`
- Controller loop: `internal/clusterprovider/provider.go` (Run 378-410; reconcile 261-326; Clusters interface 40-56)
- Job-aware intent: `internal/scale/scale.go`; driver: `internal/scaledriver/scaledriver.go`
- API types: `api/v1alpha1/{groupversion_info,types_cluster,types_node,types_atprotoidentity,zz_generated.deepcopy}.go`
- Schemas/exports: `deploy/{cluster,node,atprotoidentity}-apiresourceschema.yaml`, `deploy/{cluster,atprotoidentity}-apiexport.yaml`, `deploy/workspacetype-{account,cluster}.yaml`
- Install/bootstrap: `deploy/install-provider.sh`, `deploy/container-entrypoint.sh`, `deploy/run-kcp-instance.sh`, `deploy/control-plane-container/{Dockerfile,build.sh,validate.sh}`
- Live-test kcp: `internal/clusterprovider/live_mount_test.go:832-914`
- Test gate: `internal/livegate/livegate.go`; meta-tests: `test/nocomments_test.go`, `test/auth_chain_test.go`
- Version pins: `internal/versions/versions.json`, `internal/versions/versions.go`
- State/backlog: `handoff.yaml` (`how_to_run`, `known_traps`), `NEXT.yaml`
- Design doc: `docs/ARCHITECTURE.md` (Sec 6 CRDs/API, 10 scale, 11 teardown, 12 layout, 13 invariants)
