# The Deno runtime on KCP: long-running pods and one-shot runs

`deno-kcp` runs Deno processes on a real local KCP. There are two lifecycle
axes:

- **long-running / available** - a process that keeps running and exposes
  readiness (`DenoPod`, `PolicyEngine`, `PolicyWorkflowPod`).
- **one-shot / terminal** - a process or execution that finishes and reports a
  result (`DenoRun`, `DenoJob`, `PolicyWorkflowRun`, `RunTrigger`).

An eighth kind, `OpenBao`, is not a workload: it binds a Kubernetes namespace to
an OpenBao namespace that holds a certificate authority for it, which is where
the serving certificates of the workloads in that namespace come from.
`docs/OPENBAO_PKI.md` is that document.

Every command and output block below was produced by a real local KCP.

Builds on `docs/POLICY_ENGINE_KCP.md` (the warm policy engine) and
`docs/KCP_DEV_HOW_TO.md` (the KCP integration pattern). The policy engine is
`../policy-engine`; its HTTP API is `main.ts api`.

---

## 1. TL;DR / mental model

```
PolicyEngine (warm deno HTTP API, provider-chosen port, status.endpoint + Ready)
      ^ evaluatePolicy (inline workflow)
      |
PolicyWorkflowPod (long-running; a run names it by spec.policyWorkflowPod)
      ^ POST a PolicyWorkflowRun to the KCP API under RBAC
      |
DenoPod (long-running, Ready, restartPolicy, exec probes)
      |
      +--> PolicyWorkflowRun (one-shot; POSTs its workflow to the PolicyEngine)
                 |
                 +--> status.outputs.allow
                          |
                          v
                       RunTrigger --match--> DenoJob --owns--> DenoRun
```

- The provider mints a KCP service account token, writes the script into a
  fresh per-process tempdir, and runs `deno run <permission flags> main.ts`.
- Long-running kinds carry a `Ready` **condition**; they are never "Succeeded"
  unless they exit on purpose with `restartPolicy: Never`.
- One-shot kinds carry a terminal `Succeeded`/`Failed` phase, an `exitCode`,
  `outputs` and completion times.
- Parent/child ownership uses Kubernetes `ownerReferences`; KCP's garbage
  collector deletes the children. A finalizer stays only where a live process
  must be stopped before the object disappears.

---

## 2. Two lifecycle axes, side by side

| Kind | Axis | Phases | Terminal? | Finalizer | Owns |
|---|---|---|---|---|---|
| `DenoPod` | long-running | `Pending Running Failed` (+`Succeeded` only on `Never`+exit 0) | no (by default) | yes (stop process) | - |
| `DenoRun` | one-shot | `Pending Running Succeeded Failed` | yes | yes (stop process) | - |
| `DenoJob` | one-shot batch | `Pending Running Succeeded Failed` | yes | no | `DenoRun` |
| `PolicyEngine` | long-running | `Pending Running Failed` | no | yes (stop process) | - |
| `PolicyWorkflowPod` | long-running | `Pending Running Failed` | no | no | `PolicyWorkflowRun` |
| `PolicyWorkflowRun` | one-shot | `Pending Running Succeeded Failed Cancelled` | yes | yes (release) | - |
| `RunTrigger` | one-shot | `Pending Triggered Skipped Failed` | yes | no | `DenoJob` |

`Ready` is a `metav1.Condition`, not a phase, on `DenoPod`, `PolicyEngine` and
`PolicyWorkflowPod`.

---

## 3. DenoPod (long-running)

`api/v1alpha1/types_denopod.go`; pure reconcile in `internal/denopod`; runner in
`impl/execrunner` in the `kcp-libs` sibling.

```yaml
apiVersion: deno.computer/v1alpha1
kind: DenoPod
metadata:
  name: read-policy-result
  finalizers: [denopod.deno.computer/run]
spec:
  restartPolicy: Always            # Always | OnFailure | Never (default Always)
  script: |
    const res = await fetch(`${Deno.env.get("KCP_SERVER")}/apis/...`, { headers: { authorization: `Bearer ${Deno.env.get("KCP_TOKEN")}` } });
    await Deno.writeTextFile("result.json", JSON.stringify({ httpStatus: String(res.status) }));
    while (true) await new Promise((r) => setTimeout(r, 5000));
  permissions: { read: {allow: true}, write: {allowList: [result.json]}, net: {allow: true},
                 env: {allowList: [KCP_TOKEN, KCP_SERVER]}, noPrompt: true }
  serviceAccount: { name: deno-runner, namespace: default }
  readinessProbe: { command: ["true"], periodSeconds: 2, failureThreshold: 3, timeoutSeconds: 2 }
  livenessProbe:  { command: ["true"], periodSeconds: 10, failureThreshold: 3 }
  activeDeadlineSeconds: 600
```

Behaviour:

- `status.phase` is `Pending|Running|Failed`. A process that exits is restarted
  per `restartPolicy`, incrementing `status.restarts`; the default `Always`
  never lets a healthy pod become terminal.
- `restartPolicy: Never` with exit code 0 sets `Succeeded`; any other exit sets
  `Failed`. `OnFailure` succeeds on exit 0, restarts otherwise.
- `readinessProbe` runs an exec command in the process directory each pass;
  `status.ready` and the `Ready` condition reflect the result. `livenessProbe`
  failures past `failureThreshold` restart the process.
- A finalizer stops the process group on delete. There is no kubelet; the
  provider runs the probes.

## 4. DenoRun (one-shot primitive)

`api/v1alpha1/types_denorun.go`; pure reconcile in `internal/denorun`.

```yaml
apiVersion: deno.computer/v1alpha1
kind: DenoRun
metadata:
  name: read-policy-run
  finalizers: [denorun.deno.computer/run]
spec:
  backoff: 1                       # process restarts before the run fails
  script: |
    ...writes result.json...
  permissions: { ... }
  serviceAccount: { name: deno-runner, namespace: default }
  activeDeadlineSeconds: 60
  ttlSecondsAfterFinished: 300
```

One Deno process. `status` carries `exitCode`, `outputs`, `startTime`,
`completionTime`, `retries`. `backoff: N` buys `N+1` attempts: a failed attempt
increments `retries` and clears `status.runID`, so the next attempt starts a
fresh process, and the run fails once `retries` exceeds `backoff`. The finalizer
stops the process on delete.

## 5. DenoJob (batch over DenoRuns)

`api/v1alpha1/types_denojob.go`; pure reconcile in `internal/denojob`.

```yaml
apiVersion: deno.computer/v1alpha1
kind: DenoJob
metadata: { name: read-policy-job }
spec:
  completions: 5                   # default 1
  parallelism: 2                   # default 1
  backoffLimit: 1                  # default 6
  template:                        # a DenoRun spec
    script: "..."
    permissions: { ... }
    serviceAccount: { name: deno-runner, namespace: default }
```

The job creates `DenoRun` children named `<job>-1`, `<job>-2`, ... **owned by the
job via `ownerReference`** (no finalizer) and labelled
`deno.computer/job: <job>`. Each reconcile lists those children, counts them by
phase and runs the scheduler, matching a Kubernetes `batch/v1` Job:

- `completions` (default 1): the job is `Succeeded` once that many children are
  `Succeeded`. Completion is non-indexed: any successful run counts, and a
  completed run counts once (`status.succeeded` is capped at `completions`).
- `parallelism` (default 1): at most that many children are `Pending`/`Running`
  at once. Each pass starts `min(parallelism - active, completions - succeeded)`
  new runs.
- `backoffLimit` (default 6): the job is `Failed` once `status.failed` exceeds
  it.
- `suspend`: no new runs, and every active run is stopped.
- `activeDeadlineSeconds` (from `status.startTime`): on expiry the active runs
  are stopped and the job is `Failed`.
- `ttlSecondsAfterFinished`: after `completionTime + ttl` the job and its
  children are deleted.

`status.runs` lists the child names, `status.active`/`succeeded`/`failed` the
counts, `status.ready` the number of `Running` children, and `status.runName`
stays as the most recent run for single-run jobs. With `completions` and
`parallelism` unset the behaviour is the original one-run-at-a-time job.

## 6. PolicyEngine (warm engine server)

`api/v1alpha1/types_policyengine.go`; pure reconcile in `internal/policyengine`;
runner in `impl/execrunner` in the `kcp-libs` sibling.

```yaml
apiVersion: deno.computer/v1alpha1
kind: PolicyEngine
metadata:
  name: policy-engine
  finalizers: [policyengine.deno.computer/run]
spec:
  restartPolicy: Always
  env: { POLICY_ENGINE_LOG_LEVEL: warn }
```

The provider picks a free port, runs
`deno run --allow-all --unstable-worker-options main.ts api --bind 127.0.0.1:<port>`
in the policy-engine server directory, and writes `status.endpoint` and
`status.ready`. Readiness defaults to an HTTP `GET <endpoint>/health`; an
`readinessProbe` (exec) overrides it. This is the shared warm endpoint the runs
call.

## 7. PolicyWorkflowPod (run creator)

`api/v1alpha1/types_policyworkflowpod.go`; pure reconcile in
`internal/policyworkflowpod`.

```yaml
apiVersion: deno.computer/v1alpha1
kind: PolicyWorkflowPod
metadata: { name: open-policy-pod }
spec:
  policyEngine: policy-engine        # same workspace
  concurrencyPolicy: Forbid          # Allow | Forbid | Replace (default Forbid)
  maxConcurrent: 2                   # Allow only: at most this many runs execute at once
  runTTLSecondsAfterFinished: 300    # this pod's runs self-delete this long after completion
  perspective: requester
  selfDid: did:plc:example
  workflow:                          # the gha-lite workflow (data)
    name: open policy
    jobs:
      evaluate:
        runs-on: self-hosted
        steps:
        - uses: tangy/policy-open@v1
          id: policy
          with: { self-did: ${{ inputs.self-did || '' }} }
        - run: test "${{ steps.policy.outputs.allow }}" = "true"
  inputs: { self-did: did:plc:example }
```

The pod holds the workflow, the inputs and the concurrency policy. A client asks
for a run by creating a `PolicyWorkflowRun` that names the pod (ADR 0002,
decision 2):

```yaml
apiVersion: deno.computer/v1alpha1
kind: PolicyWorkflowRun
metadata:
  name: open-policy-pod-1
  finalizers: [policyworkflowrun.deno.computer/run]
  labels: { deno.computer/policyworkflowpod: open-policy-pod }
  ownerReferences:
    - apiVersion: deno.computer/v1alpha1
      kind: PolicyWorkflowPod
      name: open-policy-pod
      uid: <the pod's uid>
      controller: true
      blockOwnerDeletion: true
spec: { policyWorkflowPod: open-policy-pod }
```

The client sets the name, the label, the finalizer and the `ownerReference`
itself, and it needs RBAC for `create` on `policyworkflowruns` and `get` on
`policyworkflowpods` (to read the pod uid). `deploy/examples/native-fire-pod.yaml`
is a `DenoPod` that does exactly this over its minted KCP token.

This replaced a loopback HTTP endpoint the provider used to run, where a pod
carrying the label `deno.computer/policyworkflowpod: <pod>` was handed
`POLICY_FIRE_URL` and `POLICY_FIRE_TOKEN` at start and POSTed to it. That shim
re-implemented authn/authz outside the API server and only worked inside one
provider process; ADR 0002 decision 4 retired it once no client used it.

`concurrencyPolicy` gates **execution**, in the run controller, over the runs
that name the pod:

- `Forbid` (default): cap of 1. `maxConcurrent` is ignored.
- `Allow`: at most `maxConcurrent` runs execute at once. `maxConcurrent` unset
  (nil) or not positive means unlimited.
- `Replace`: the newest run supersedes the others; cap effectively 1 and
  `maxConcurrent` is ignored.

No create is rejected. A run with no free slot stays `Pending` with a
`Complete=False` `AtCapacity` condition whose message names `concurrencyPolicy`
and `maxConcurrent`, and it starts when a slot frees. The queue is ordered
oldest-first, so runs start in creation order.

The engine endpoint, workflow, inputs and TTL resolve **at submit time** from the
referenced pod, not at create time, so a queued run picks up a restarted engine.
A run whose pod is gone, or whose engine has no endpoint yet, stays `Pending`
with reason `PolicyWorkflowPodMissing` or `EngineNotReady`.

## 8. PolicyWorkflowRun (one-shot policy execution)

`api/v1alpha1/types_policyworkflowrun.go`; pure reconcile in
`internal/policyworkflowrun`.

It executes by submitting its inline workflow to the referenced engine's HTTP
API and polling the task. Status is Job-like: `phase`, `runID` (the engine task
id), `startTime`, `completionTime`, `active`, `succeeded`, `failed`, `retries`,
`exitStatus`, `outputs`, `conditions`. The verdict lands in
`status.outputs.allow` (`"true"` / `"false"`), with `violations` when present.
Retries use `backoffLimit` (default 6); `backoffLimit: 0` fails immediately.

A run that names `spec.policyWorkflowPod` gets its engine endpoint, workflow,
inputs and TTL from that pod at submit time. A run that names nothing must set
`spec.engineEndpoint` (the `PolicyEngine.status.endpoint`) and `spec.workflow`
itself; `deploy/examples/policy-workflow-run.yaml` and `deploy/demo.sh` show that
path.

### Cancellation

`spec.cancel: true` cancels a run; deleting the object cancels it too. A
cancelled run takes the terminal `Cancelled` phase, clears `status.runID` so the
provider stops polling the engine, releases the finalizer, and records a
`Cancelled` condition (with the run's `generation`) plus a terminal `Complete`
condition. `spec.cancel` on an already-terminal run is a no-op. Cancelling a run
never touches the client that created it, and a `RunTrigger` watching a cancelled
run goes `Skipped` (`reason: WorkflowCancelled`) instead of creating a `DenoJob`.

The gha-lite engine's real cancellation surface, read from
`lib/policy-engine-server-gha-lite/src/server.ts`, is **none**: the only routes
are `POST /request/create`, `GET /request/status/:id`,
`GET /request/console_output/:id`, `GET /request/console_output_stream/:id`,
`GET /health`, `GET /rate_limit` and `POST /webhook/github`. Its `TaskManager`
has no cancel/delete either. So the engine task runs to completion on its side
and keeps a slot in the warm engine; the provider cannot stop it. The ceiling is
recorded as a `ponytail:` comment on `policyworkflowrun.cancel`; the upgrade path
is a `/request/cancel/:id` on the engine plus a `PolicyClient.Cancel` call.

### Retention

A long-running `PolicyWorkflowPod` never goes away, so KCP's garbage collector
never cascades to its runs (GC only deletes a child when the owner is deleted)
and its runs would accumulate in etcd forever. The TTL therefore reaps them: a
run that names a pod takes `spec.runTTLSecondsAfterFinished` from that pod, else
the provider default (`--run-ttl-seconds`, env `RUN_TTL_SECONDS`, default
`3600`), else no TTL (a negative value disables it). A terminal run self-deletes
at `completionTime + ttl` via the `internal/policyworkflowrun` `finish` branch.
A run with no pod sets `spec.ttlSecondsAfterFinished` itself.

The run TTL must exceed the wake latency plus queue wait. A `RunTrigger` is now
woken by the event that makes a policy run terminal, so the enqueue is ordered
before the delete: the terminal phase, `outputs` and `completionTime` land in one
status write, and a watch delivers that object's events in resourceVersion
order, so the delete is observed after the run has already been announced. What
is not bounded is the reconcile: it is queued work reading the run from the
informer cache, which the delete also empties, so a stalled worker pool or a
provider restart inside the window still misses the run and nothing repairs it
afterwards. The 3600 s default is three orders of magnitude clear of that
window; a TTL of a few seconds, as the TTL live test uses, is protected only by
the event path.

### Engine inline-workflow finding

`main.ts api` does **not** expose an `evaluatePolicy` XRPC endpoint and does not
accept a `policyRecord`. That surface is `hono-policy-engine`. The gha-lite
server accepts an inline workflow directly:

| Method | Path | Body | Response |
|---|---|---|---|
| POST | `/request/create` | `{"workflow": <object\|yaml-string>, "inputs": {...}}` | `{"status":"submitted","detail":{"id":"<task>"}}` |
| GET | `/request/status/<id>` | - | `{"status":"complete","detail":{"exit_status":"success","outputs":{...},"cache":{...}}}` |
| GET | `/health` | - | `{"status":"ok"}` |

So `PolicyWorkflowRun` uses the engine's `run` path
(`create` + poll), not a `policyRecord`. The client is
`impl/policyclient` in the `kcp-libs` sibling; `parseWorkflow` in
`policy-engine/.../src/workflow.ts` accepts an object or a YAML string, so the
CR's structured `spec.workflow` is sent verbatim. Verdicts are read from
`detail.outputs` plus each `policy/<name>/<refs>` cache entry's `result.json`
(`outputsFrom`).

## 9. RunTrigger

`api/v1alpha1/types_runtrigger.go`; pure reconcile in `internal/trigger`.

```yaml
apiVersion: deno.computer/v1alpha1
kind: RunTrigger
metadata: { name: on-policy-allow }
spec:
  policyWorkflowPod: open-policy-pod   # the pod whose runs this trigger watches
  match: { allow: "true" }             # every key must equal status.outputs[key]; empty = any success
  jobTemplate:                         # a DenoJob spec
    backoffLimit: 1
    template:
      script: "..."
      serviceAccount: { name: deno-runner, namespace: default }
```

The trigger lists the runs labelled
`deno.computer/policyworkflowpod: <policyWorkflowPod>`, picks the newest by
`metadata.creationTimestamp` among the terminal ones, and waits while none has
finished. Once it succeeds and the outputs match it creates a `DenoJob` named
`<trigger>-<run>` once (`phase: Triggered`), owns it via `ownerReference`, and
records the run in `status.lastRun`. A later, newer matching run triggers again
because its name differs from `lastRun`. A failed or cancelled run, or a
non-matching result, is `Skipped`. The trigger is idempotent for a given run.

## 10. Ownership and garbage collection

`ownerReferences` (with the parent's UID) are set on the child at creation:

| Parent | Child | Finalizer on parent |
|---|---|---|
| `DenoJob` | `DenoRun` | none |
| `PolicyWorkflowPod` | `PolicyWorkflowRun` | none |
| `RunTrigger` | `DenoJob` | none |

KCP's garbage collector (`kcp/pkg/reconciler/garbagecollector`, installed by
default) deletes the children when the parent goes away, so parents no longer
hand-delete children. It only cascades on owner deletion; a long-running owner
(`PolicyWorkflowPod`) never triggers it, so that pod's runs carry their own TTL
(see section 8, Retention). A finalizer remains
**only** where a live process must be stopped first: `DenoPod`, `DenoRun`,
`PolicyEngine`, `PolicyWorkflowRun` (the run releases its finalizer on cancel or
delete; the engine API has no cancel endpoint, so a cancelled engine task runs to
completion on the engine side).

## 11. Quick start (one command)

```bash
cd deno-kcp
bash deploy/demo-deno-runtime.sh
```

Real output (this run):

```
workspace.tenancy.kcp.io/deno-provider created
apiresourceschema.apis.kcp.io/v1alpha1-3.policyworkflowruns.deno.computer created
apiexport.apis.kcp.io/policyworkflowruns created
apiresourceschema.apis.kcp.io/v1alpha1-2.denopods.deno.computer created
apiresourceschema.apis.kcp.io/v1alpha1-1.denoruns.deno.computer created
apiresourceschema.apis.kcp.io/v1alpha1-3.denojobs.deno.computer created
apiresourceschema.apis.kcp.io/v1alpha1-2.runtriggers.deno.computer created
apiresourceschema.apis.kcp.io/v1alpha1-1.policyengines.deno.computer created
apiresourceschema.apis.kcp.io/v1alpha1-4.policyworkflowpods.deno.computer created
apiexport.apis.kcp.io/denoruntime created
workspacetype.tenancy.kcp.io/workflow created
workspacetype.tenancy.kcp.io/denoruntime created
provider workspace: root:deno-provider
provider server:    https://127.0.0.1:16443/clusters/root:deno-provider
NAME
v1alpha1-1.denoruns.deno.computer
v1alpha1-1.policyengines.deno.computer
v1alpha1-2.denopods.deno.computer
v1alpha1-2.runtriggers.deno.computer
v1alpha1-3.denojobs.deno.computer
v1alpha1-3.policyworkflowruns.deno.computer
v1alpha1-4.policyworkflowpods.deno.computer
NAME                 IDENTITYHASH
denoruntime          ab42b5cc8d4e93f794d5a626f4dd7c74e46fcb6f6ab34d11c8df5a16a9356a66
policyworkflowruns   dac9233301158fdf0e7e0885ce4a68d7eea426a36e6571cdbeee9bf6bbce4759
workspace.tenancy.kcp.io/runtime created
serviceaccount/deno-runner created
clusterrole.rbac.authorization.k8s.io/deno-runner-read created
clusterrolebinding.rbac.authorization.k8s.io/deno-runner-read created
clusterrole.rbac.authorization.k8s.io/deno-runner-fire created
clusterrolebinding.rbac.authorization.k8s.io/deno-runner-fire created
policyengine.deno.computer/policy-engine created
policyworkflowpod.deno.computer/open-policy-pod created
denopod.deno.computer/native-fire-open-policy created
runtrigger.deno.computer/on-policy-allow created
== PolicyEngine ==
phase=Running ready=true endpoint=http://127.0.0.1:36459
== PolicyWorkflowPod ==
phase=Running endpoint=http://127.0.0.1:36459
== DenoPod (native run create) ==
phase=Succeeded http=201
== PolicyWorkflowRun ==
name=open-policy-pod-lsxbf phase=Succeeded allow=true
== RunTrigger ==
phase=Triggered matched=true lastRun=open-policy-pod-lsxbf job=on-policy-allow-open-policy-pod-lsxbf
== DenoJob ==
name=on-policy-allow-open-policy-pod-lsxbf phase=Succeeded succeeded=1 run=on-policy-allow-open-policy-pod-lsxbf-1 allow=true http=200
== DenoRun ==
phase=Succeeded exit=0 allow=true http=200
```

The run and job names are generated. The demo reads the run by its
`deno.computer/policyworkflowpod` label and the job from
`RunTrigger.status.jobName`, so the exact suffixes change every run.

The chain is: the run creator pod POSTs a `PolicyWorkflowRun` straight to the
KCP API under RBAC (`http=201`), the warm engine evaluates the run (`allow=true`),
the trigger fires a `DenoJob`, and the job's `DenoRun` reads the result back over
the minted KCP token (`http=200`).

## 12. Live end-to-end test

```bash
DENO_KCP_REQUIRE_LIVE=1 go test ./internal/provider \
  -run TestTheFullDenoRuntimeLifecycleOnRealKCP -v -count=1 -timeout 12m
```

Real output:

```
=== RUN   TestTheFullDenoRuntimeLifecycleOnRealKCP
    live_denoruntime_test.go:319: deno runtime lifecycle complete: run=Succeeded allow=true trigger=Triggered job=Succeeded denoRun=on-policy-allow-open-policy-pod-f9jm7-1 http=200
--- PASS: TestTheFullDenoRuntimeLifecycleOnRealKCP (17.99s)
PASS
```

Environment: `KCP_BIN`, `KINE_BIN`, `DENO_BIN`, `POLICY_ENGINE_DIR`,
`BUNDLED_ACTIONS_DIR`. Missing prerequisites hard-fail when
`DENO_KCP_REQUIRE_LIVE=1` and skip otherwise.

## 13. Lifecycle diagrams

Daemon axes (no terminal phase; restart on death, `Ready` condition):

```
Pending --start--> Running --process exits--> (restartPolicy)
                    |  ^                            Always  -> Running (restarts++)
                    |  +----------------------------+
                    |                               OnFailure + exit 0 -> Succeeded
                    +-- readiness/liveness probe      Never     + exit 0 -> Succeeded
                                                              + exit!=0 -> Failed
```

One-shot axis:

```
Pending --start--> Running --success--> Succeeded --ttl--> deleted
                     |
                     +--failure--> retries++ --> Pending (retry)
                     |                +--> Failed --ttl--> deleted
                     |
                     +--cancel/delete--> Cancelled --ttl--> deleted
```

## 14. File map

```
api/v1alpha1/types_denopod.go|denorun.go|denojob.go   Deno runtime kinds
api/v1alpha1/types_policyengine.go|policyworkflowpod.go|policyworkflowrun.go|runtrigger.go
api/v1alpha1/types_openbao.go                         the certificate authority kind
api/v1alpha1/types_shared.go                          permissions, templates, probes
internal/denopod|denorun|denojob/                     pure phase machines
internal/policyengine|policyworkflowpod|policyworkflowrun|trigger/  pure phase machines
internal/provider/provider.go|provider_runtime.go     Provider: options, ports and the shared runtime state
internal/provider/reconcile_*.go                      the per-kind reconcilers (engine, workflowpod, trigger, job, run, pod)
internal/provider/registry.go|registry_*.go           the Registry: kcpstore Resources per kind + their status patches
internal/provider/watch.go|watch_cache.go             the event-driven watch driver + the informer cache reader
internal/provider/driver.go                           work identity (kind + ref) + the terminal-phase helpers
internal/provider/admission.go                        maxConcurrent run admission leases
internal/provider/metrics.go                          provider gauges (reconciles/conflicts/errors) + the library metrics server
internal/provider/live_*_test.go                      gated live tests (DENO_KCP_REQUIRE_LIVE)
deploy/*-apiresourceschema.yaml                       one schema per kind (immutable)
deploy/denoruntime-apiexport.yaml                     the runtime export
deploy/policyworkflowrun-apiexport.yaml               the policy export
deploy/examples/*.yaml                                example CRs
deploy/demo-deno-runtime.sh                           one-command demo
```

Dependency direction stays `api <- internal <- cmd`, plus one arrow out:
`internal` and `api` consume `github.com/publicdomainrelay/kcp-libs` (the
sibling checkout, wired with a `replace`). The OpenBao client, the PKI
provisioner, the process runners, the DNS assets, the policy engine client,
`kcpstore`, the run index, the probe tracker and the shared `ref`/`kcp`/
`denospec`/`denocomputer` vocabulary all come from there rather than being
copied here. Pure packages never touch the network; the provider does all I/O;
the runners are interfaces.

## 15. Gotchas

1. **KCP CRDs are `APIResourceSchema` + `APIExport`.** Apply them in the
   provider workspace (`--server=.../clusters/root:deno-provider`).
2. **`APIResourceSchema.spec` is immutable.** A changed kind needs a new
   `metadata.name` (`v1alpha1-1.denopods...` -> `v1alpha1-2...`) and a
   re-pointed export. Current schema names: `denopods`-3, `denoruns`-2,
   `denojobs`-4, `policyengines`-2, `policyworkflowruns`-4, `runtriggers`-3,
   `policyworkflowpods`-5. Earlier bumps: `policyworkflowruns`-2 (added
   `spec.cancel` and the `Cancelled` phase), `runtriggers`-2 (`spec.workflowRun`
   -> `spec.policyWorkflowPod`, added `status.lastRun`), `policyworkflowpods`-2
   (added `spec.maxConcurrent`), -3 (added `spec.runTTLSecondsAfterFinished`),
   -4 (dropped `status.fireURL` when the fire endpoint was retired).
3. **`permissions`, `denoJson`, probes and templates are preserve-unknown
   objects**; without `x-kubernetes-preserve-unknown-fields: true` KCP prunes
   every nested key to `{}`.
4. **`subresources: {status: {}}` is required** or inline status is dropped.
5. **kubectl needs `--validate=false`** for KCP APIs.
6. **`--feature-gates=WorkspaceMounts=true` is mandatory** and kcp needs an
   external kine (`--etcd-servers`).
7. **The trigger is woken by the event that makes a policy run terminal**, not by
   a subscription of its own and no longer by a 2 s tick. A terminal
   `PolicyWorkflowRun` enqueues every `RunTrigger` naming that run's
   `deno.computer/policyworkflowpod` label. `internal/trigger` has no requeue
   constant at all; the driver supplies a one-minute backstop so an event lost
   without a watch error cannot leave a trigger stuck until the next relist.
   Measured: fire-to-`Triggered` went from ~1.57 s to under 10 ms.
   `docs/adrs/0003-event-driven-reconcile-loop.md` records the migration.

## 16. Deferred / ambiguities

- **`PolicyWorkflowRun` cancellation** is wired (`spec.cancel` or delete): the
  run reaches `Cancelled`, stops polling and releases the finalizer. The engine
  itself cannot cancel a submitted task - it exposes no cancel/delete route and
  its `TaskManager` has none - so that task runs to completion on the engine
  side. See the cancellation section above and the `ponytail:` ceiling.
- **Retention of a pod's runs** is handled: the pod is long-running, so its runs
  take their TTL from `spec.runTTLSecondsAfterFinished` (or the provider
  default) resolved at submit time, and self-delete on completion. See section 8.
- **`PolicyEngine` restart** reuses the port from `status.endpoint`, so the
  endpoint is stable across a provider-managed restart.
