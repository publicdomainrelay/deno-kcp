# Running policy engine workflows on KCP as one-shot runs

`deno-kcp` runs gha-lite policy workflows on a real local KCP through a warm
policy engine server. One `PolicyEngine` is a long-running Deno process serving
the engine's HTTP API on a provider-chosen port; one `PolicyWorkflowRun` is a
one-shot execution submitted to that engine.

Every command and output block below was produced by a real local KCP. For the
Deno runtime APIs (`DenoPod`, `DenoRun`, `DenoJob`, `PolicyWorkflowPod`,
`RunTrigger`) see `docs/DENO_RUNTIME_KCP.md`.

---

## 1. TL;DR / mental model

```
PolicyEngine (CR)                     long-running deno process:
  main.ts api --bind 127.0.0.1:<port> serving /request/create + /request/status
        ^
        | POST {workflow, inputs}
PolicyWorkflowRun (CR, one-shot)  --poll--> status.outputs.allow = "true"|"false"
```

- The workflow is **data** on the CR: `spec.workflow` is a structured object
  (gha-lite YAML/JSON as a mapping), not a string.
- The **provider** (`cmd/deno-kcp-provider`) reconciles `PolicyEngine` CRs by
  starting the engine process and exposing `status.endpoint` and `status.ready`.
  It reconciles `PolicyWorkflowRun` CRs by POSTing the workflow to the engine
  and polling the task, then writing the Job-like status.
- The **engine** evaluates the workflow with `WorkflowExecutor`; the verdict is
  in `detail.outputs` plus each `policy/<name>` cache entry's `result.json`.
- The **CRD** is a KCP `APIResourceSchema` + `APIExport`; tenants get it through
  a `WorkspaceType` with a `defaultAPIBinding`.

Every kind is namespaced and lives in a Kubernetes namespace inside a KCP
workspace, so isolation is available at both levels: the workspace separates
tenants, the namespace separates workloads within one.

---

## 2. Prerequisites

| Tool | Version used here | Notes |
|---|---|---|
| Go | 1.26.x | `go build ./...` |
| kcp | `v1.36.0+kcp-v0.33.0` | external binary, started as a subprocess |
| kine | `v0.17.1` (CGO) | the etcd-compatible store kcp talks to |
| kubectl | any current | applied with `--validate=false` |
| Deno | 2.9.3 | runs the policy engine (`--unstable-worker-options`) |
| policy-engine | `../policy-engine` | the gha-lite bundled actions must be present |

`kcp` must run with `--feature-gates=WorkspaceMounts=true` and an external kine.

---

## 3. The engine HTTP API

`../policy-engine/lib/policy-engine-server-gha-lite/main.ts api` exposes:

| Method | Path | Body | Response |
|---|---|---|---|
| POST | `/request/create` | `{"workflow": <object\|yaml-string>, "inputs": {...}}` | `{"status":"submitted","detail":{"id":"<task>"}}` |
| GET | `/request/status/<id>` | - | `{"status":"complete","detail":{"exit_status":"success","outputs":{...},"cache":{...}}}` |
| GET | `/health` | - | `{"status":"ok"}` |

This server does **not** expose an `evaluatePolicy` XRPC endpoint and does not
accept a `policyRecord`; that surface is `hono-policy-engine`. The gha-lite
server takes an inline workflow directly, and `parseWorkflow`
(`src/workflow.ts`) accepts an object or a YAML string, so the CR's structured
`spec.workflow` is sent verbatim. `PolicyWorkflowRun` therefore uses the
engine's `run` path (create + poll), implemented in
`impl/policyclient` in the `kcp-libs` sibling.

---

## 4. PolicyEngine

`api/v1alpha1/types_policyengine.go`; pure reconcile in `internal/policyengine`.

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

The provider picks a free port and runs
`deno run --allow-all --unstable-worker-options main.ts api --bind 127.0.0.1:<port>`
in the configured server directory (`--policy-engine-dir`). `status.endpoint`
is the URL; `status.ready` is true once the probe passes (default: HTTP `GET
<endpoint>/health`; an exec `readinessProbe` overrides it). The finalizer stops
the engine process on delete; a provider-managed restart reuses the port.

---

## 5. PolicyWorkflowRun

`api/v1alpha1/types_policyworkflowrun.go`; pure reconcile in
`internal/policyworkflowrun`.

```yaml
apiVersion: deno.computer/v1alpha1
kind: PolicyWorkflowRun
metadata:
  name: open-policy
  finalizers: [policyworkflowrun.deno.computer/run]
spec:
  engineEndpoint: http://127.0.0.1:42999   # from PolicyEngine.status.endpoint
  workflow:
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
  backoffLimit: 1
  ttlSecondsAfterFinished: 300
```

Status (Job-like): `phase`, `runID` (the engine task id), `startTime`,
`completionTime`, `active`, `succeeded`, `failed`, `retries`, `exitStatus`,
`outputs`, `conditions`. `status.outputs.allow` is the verdict; a single policy
yields `allow`/`violations`, multiple policies yield `<name>/allow`.

A run that names `spec.policyWorkflowPod` has its `engineEndpoint`, workflow,
inputs and TTL resolved from that pod at submit time, and the client owns it and
labels it with `deno.computer/policyworkflowpod` so a `RunTrigger` finds it by
label, not by a static name. A run that names no pod must set `engineEndpoint`
(and `workflow`) itself. See `docs/DENO_RUNTIME_KCP.md` section 7.

A run that names a pod also takes its TTL from the pod:
`spec.runTTLSecondsAfterFinished`, else the provider default
(`--run-ttl-seconds`, default `3600`), else none. The pod is long-running, so
KCP's garbage collector never deletes its runs (it only cascades on owner
deletion); the run TTL is what reaps a run, deleting it at
`completionTime + ttl`. Keep the TTL above the `RunTrigger` read latency
(informer cache propagation) or the trigger can miss the run. See
`docs/DENO_RUNTIME_KCP.md` section 8.

Run admission is capped by the workflow pod's `spec.concurrencyPolicy` and
`spec.maxConcurrent`: `Forbid` (default) is a cap of 1 and ignores
`maxConcurrent`; `Allow` runs at most `maxConcurrent` at once, where unset
(nil) or not positive `maxConcurrent` means unlimited; `Replace` lets the newest
run supersede the others (cap 1). No create is rejected - a run with no free slot
stays `Pending` with a `Complete=False` `AtCapacity` condition, oldest-first. See
`docs/DENO_RUNTIME_KCP.md` section 7.

---

## 6. Kubernetes Job semantics

| Kubernetes Job | PolicyWorkflowRun | Where |
|---|---|---|
| `spec.suspend` | `spec.suspend`; releases `runID` | `internal/policyworkflowrun` |
| `spec.backoffLimit` | `spec.backoffLimit` (default 6) | `failed` branch |
| `spec.activeDeadlineSeconds` | `spec.activeDeadlineSeconds` | `deadline` branch |
| `spec.ttlSecondsAfterFinished` | deletes the CR after `completionTime + ttl` | `finish` branch |
| `status.startTime`/`completionTime` | same | |
| `status.succeeded`/`failed`/`retries` | same | |
| `status.conditions[Complete]`/`[Failed]` | same | |
| Job controller | `internal/provider` watch driver | |

One execution at a time. `spec.cancel: true` (or deleting the run) marks it
`Cancelled`, stops polling and releases the finalizer. The engine has no
cancel/delete route, so its task runs to completion on the engine side; see
`docs/DENO_RUNTIME_KCP.md` for the engine's real surface.

---

## 7. Defining a policy workflow (gha-lite)

`spec.workflow` is a structured object interpreted by the policy engine as
GitHub Actions YAML. The APIResourceSchema declares it `type: object` with
`x-kubernetes-preserve-unknown-fields: true`, so KCP stores the mapping
verbatim. The engine ignores `on:` triggers; `workflow_dispatch` inputs are
informational and the values arrive through `spec.inputs`.

Supported: jobs with `needs`/`if`/`env`/`outputs`/`strategy.matrix`, steps with
`uses`/`run`/`with`/`env`/`if`/`continue-on-error`, the `${{ }}` contexts, and
the `GITHUB_OUTPUT`/`GITHUB_ENV`/`GITHUB_PATH`/`GITHUB_CACHE` command files.
`uses:` resolves against `BUNDLED_ACTIONS_DIR` (or downloads from GitHub).

A policy action writes `allow`/`violations`; keep the gate step
`test "${{ steps.policy.outputs.allow }}" = "true"` so `allow=false` fails the
workflow.

---

## 8. Running the provider

Flags (env fallback where shown; `-` means flag only):

| Flag | Env | Default |
|---|---|---|
| `--kubeconfig` | `KUBECONFIG` | required |
| `--host` | `KCP_HOST` | kubeconfig server (a `/clusters/...` suffix is stripped) |
| `--runs-dir` | `RUNS_DIR` | `runs` |
| `--policy-engine-dir` | `POLICY_ENGINE_DIR` | `../policy-engine/lib/policy-engine-server-gha-lite` |
| `--bundled-actions-dir` | `BUNDLED_ACTIONS_DIR` | `<policy-engine-dir>/../policies/gha-lite/bundled-actions` |
| `--deno-bin` | `DENO_BIN` | `deno` |
| `--pod-timeout` | - | `5m` |
| `--token-ttl` | - | `1h` |
| `--metrics-listen` | `METRICS_LISTEN` | empty (disables the endpoint) |
| `--run-ttl-seconds` | `RUN_TTL_SECONDS` | `3600` (negative disables) |
| `--write-status` | - | true |

The provider runs one shared informer set per published APIExport endpoint URL,
over the `denoruntime` and `policyworkflowruns` virtual workspaces. Each event
enqueues the object's `{logical cluster, name}` key on a workqueue served by a
fixed worker pool, and the reconcilers read the object from the informer cache
(`cacheReader`) rather than issuing a GET. Status is written through the
`/status` subresource with a JSON merge patch; finalizers are released with a
JSON `test`+`add` patch.

---

## 9. Tests

```bash
go test ./...            # api, internal/{denopod,denorun,denojob,policyengine,
                         #   policyworkflowpod,policyworkflowrun,trigger,provider,runner}
gofmt -l api internal cmd && go vet ./...
```

The gated live chain test is
`TestTheFullDenoRuntimeLifecycleOnRealKCP` in
`internal/provider/live_denoruntime_test.go`; see
`docs/DENO_RUNTIME_KCP.md` section 12 for the exact command and captured output.

---

## 10. Gotchas

1. **KCP CRDs are `APIResourceSchema` + `APIExport`.** Apply them in the
   provider workspace (`--server=.../clusters/root:deno-provider`).
2. **`APIResourceSchema.spec` is immutable.** A schema change is a new
   `metadata.name` and a re-pointed export.
3. **`spec.workflow` must be a preserve-unknown object.**
4. **`subresources: {status: {}}` is required.**
5. **kubectl needs `--validate=false`** for KCP APIs.
6. **RBAC lags `/readyz`** by a few seconds; `install-provider.sh` waits.
7. **`--feature-gates=WorkspaceMounts=true`** is mandatory.
8. **Status is merge-patched with zeros present**, so `active: 0` clears a
   previous `1`.
9. **`on:` triggers are not enforced**; inputs arrive through `spec.inputs`.
10. **Keep the allow-gate step** or a deny becomes a no-op.
