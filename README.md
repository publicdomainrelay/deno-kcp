# deno-kcp

A Go service provider that runs Deno workloads as multi-tenant API resources on
[kcp](https://kcp.io) (Kubernetes Control Plane, the upstream of OpenShift's
multicluster control plane). One binary, `cmd/deno-kcp-provider`, reconciles
eight custom kinds in the `deno.computer/v1alpha1` API group, all defined in
`api/v1alpha1/types_*.go`:

- long-running: `DenoPod`, `PolicyEngine`, `PolicyWorkflowPod`
- one-shot: `DenoRun`, `DenoJob`, `PolicyWorkflowRun`, `RunTrigger`
- certificate authority: `OpenBao`

`OpenBao` is not a workload. It binds a Kubernetes namespace to an OpenBao
namespace that holds a certificate authority for it, which is where the serving
certificates of the workloads in that namespace come from: see
`docs/OPENBAO_PKI.md`.

For each workload the provider mints a KCP service account token and writes the
script into a fresh per-workload tempdir, then forks one `deno run` process per
workload. Objects live in a Kubernetes namespace inside a KCP workspace, and each
kind is namespaced, so an object's identity is its workspace, namespace and name.
`DenoJob` owns `DenoRun`s, `PolicyWorkflowPod` owns
`PolicyWorkflowRun`s, and `RunTrigger` fires a `DenoJob` when a policy verdict
matches.

## Documentation

| Document | What it is |
|---|---|
| `docs/DENO_RUNTIME_KCP.md` | **Main document.** The whole runtime model: the seven workload kinds, their phases, ownership and garbage collection, how a `PolicyWorkflowPod` run is requested, quick start, live end-to-end test, file map, gotchas. |
| `docs/POLICY_ENGINE_KCP.md` | Follow-up. The warm `PolicyEngine` server and one-shot `PolicyWorkflowRun` execution: engine HTTP API, gha-lite workflow shape, Kubernetes Job semantics. |
| `docs/OPENBAO_PKI.md` | The `OpenBao` kind, the namespace-per-namespace mapping, and the CA hierarchy: root in the OpenBao root namespace, one intermediate per Kubernetes namespace, leaves issued from it. |

Also present: `docs/POLICY_ENGINE_HOW_TO.md`, `docs/DENO_EMBEDDING_RESEARCH.md`,
and `docs/adrs/`.

**Two documents in `docs/` describe other codebases, not this one.**

- **`docs/KCP_DEV_HOW_TO.md`** is a reverse-engineering and porting guide written
  against an ANCESTOR repo, `socialweb-computer-kcp`. It refers throughout to
  packages that do not exist here - `internal/materialiser` (the phase machine)
  and `internal/clusterprovider`; neither directory exists under `internal/`. Its
  section 4.1 also describes reconcile as a 2 s poll ticker, which was true of
  that repo and of this one before ADR 0003. Read it for the KCP integration
  pattern and the traps it records; do not read it as a description of this code.
  Note that `docs/DENO_RUNTIME_KCP.md` cites it as background, which is exactly
  how a new reader gets misled.
- **`docs/POLICY_ENGINE_HOW_TO.md`** targets `policy-engine/` (Deno +
  TypeScript) and its use from `atproto-market/` and `digitalocean-bidder/`, all
  in the org root. It is not about the Go provider in this repo.

Neither warning is a criticism of the documents; both are useful for what they
are. The point is only that `docs/` is not a single-repo folder.

## Quick start

Runs a real local KCP (with kine as its store), installs the provider and the
API schemas, and walks the full lifecycle:

```bash
cd deno-kcp
bash deploy/demo-deno-runtime.sh
```

The script builds `./deno-kcp-provider`, creates the `root:runtime` workspace,
applies `deploy/examples/policyengine.yaml`, `policyworkflowpod.yaml`,
`native-fire-pod.yaml` and `runtrigger.yaml`, and prints the phase of each object -
`PolicyEngine`, `PolicyWorkflowPod`, `DenoPod`, `PolicyWorkflowRun`,
`RunTrigger`, `DenoJob`, `DenoRun`. It needs `kcp` and `kine` (override with
`KCP_BIN` / `KINE_BIN`, `deploy/start-kcp.sh:7-8`), `kubectl` (override with
`KUBECTL`, `deploy/demo-deno-runtime.sh:9`) and `deno` on `PATH`, plus a
`../policy-engine` checkout. State goes to `.kcp-demo/` and `runs/`.

The demo leaves its KCP and kine running so you can keep querying them. Stop that
instance with:

```bash
bash deploy/stop-kcp.sh
```

`deploy/demo.sh` is a smaller demo of the directly created `PolicyWorkflowRun`
path - a run carrying its own `spec.engineEndpoint`, with no
`PolicyWorkflowPod`, `RunTrigger`, `DenoJob` or `DenoRun` involved. It applies
`deploy/examples/policy-workflow-run.yaml` with the live endpoint substituted.

## Tests

```bash
make test                 # everything: fmt + vet + tidy, then every test including the live ones
make test-unit            # fast tier: needs no cluster, live tests skip
make test-race            # the offline tier under the race detector
make test-integration     # live tier of test/integration/ only
make test-live            # every live test in the module, one package at a time
make check                # gofmt -l, go vet, go mod tidy -diff
```

`make test` runs the live tier, so it needs `kcp`, `kine`, `deno` and `kubectl`
on `PATH` plus a sibling `../policy-engine` checkout. It checks for those first
and exits with a message naming what is missing, rather than skipping quietly.

The OpenBao live tests need no `bao` on `PATH`: they build the server from the
checkout pinned in `third_party/openbao`, through the small module in
`internal/baoembed`, so the version the certificates are issued by is the version
the repository pins. The first build downloads OpenBao's dependencies and Go
1.27 (its `go.mod` requires it) and takes a few minutes; after that the build
cache makes it seconds.

Raw commands, if you would rather not use make:

```bash
go test ./...                                                       # unit
DENO_KCP_REQUIRE_LIVE=1 go test -run TestTheFullDenoRuntimeLifecycleOnRealKCP -v ./internal/provider/
```

The last command is the live gate: it starts its own kine and kcp, applies the
API schemas, and drives a real `DenoPod` and `DenoRun` end to end.

## Environment variables

### Live tests

A live test hard-fails when `DENO_KCP_REQUIRE_LIVE=1` and a prerequisite is
missing, and skips otherwise (`internal/livegate/livegate.go:8-18`). All live
tests need a **sibling `../policy-engine` checkout**; the tests resolve it
relative to the repo root and fail with "the policy engine was not found at ..."
when absent (`internal/provider/live_denoruntime_test.go:33-36`).

| Variable | Default | Source |
|---|---|---|
| `DENO_KCP_REQUIRE_LIVE` | unset (tests skip); must equal `1` to run | `internal/livegate/livegate.go:9` |
| `KCP_BIN` | `kcp` | `internal/provider/live_denoruntime_test.go:23` |
| `KINE_BIN` | `kine` | `internal/provider/live_denoruntime_test.go:24` |
| `DENO_BIN` | `deno` | `internal/provider/live_denoruntime_test.go:26` |
| `POLICY_ENGINE_DIR` | `<repo>/../policy-engine/lib/policy-engine-server-gha-lite` | `internal/provider/live_denoruntime_test.go:33` |
| `BUNDLED_ACTIONS_DIR` | `<repo>/../policy-engine/lib/policies/gha-lite/bundled-actions` | `internal/provider/live_denoruntime_test.go:34` |

`kubectl` is required on `PATH` with no override
(`internal/provider/live_denoruntime_test.go:25`).

### Drain harness (`TestNativeAdmissionAndQueueDrainOnRealKCP`)

| Variable | Default | Source |
|---|---|---|
| `DRAIN_RUNS` | `24` | `internal/provider/live_native_admission_test.go:32` |
| `DRAIN_CONCURRENCY` | `4` | `internal/provider/live_native_admission_test.go:33` |
| `DRAIN_CREATORS` | `64` | `internal/provider/live_native_admission_test.go:34` |
| `DRAIN_WAIT` | `45s` (Go duration) | `internal/provider/live_native_admission_test.go:246` |

### Job harness (`TestDenoJobAllowDrainOnRealKCP`)

| Variable | Default | Source |
|---|---|---|
| `DENOJOB_RUNS` | `100` | `internal/provider/live_denojob_drain_test.go:219` |
| `DENOJOB_PARALLELISM` | `20` | `internal/provider/live_denojob_drain_test.go:220` |
| `DENOJOB_INTERVAL` | `2s` (Go duration) | `internal/provider/live_denojob_drain_test.go:221` |
| `DENOJOB_MIN_POLL` | `0`, meaning the provider default of `Options.MinTransitionPoll` | `internal/provider/live_denojob_drain_test.go:222` |
| `DENOJOB_WATCH_WORKERS` | `0`, meaning `min(16, GOMAXPROCS)` | `internal/provider/live_denojob_drain_test.go:223` |

`DENOJOB_MIN_POLL` and `DENOJOB_WATCH_WORKERS` exist to re-run the sweeps
recorded in `docs/adrs/0003-event-driven-reconcile-loop.md`.

Integer knobs are parsed by `liveEnvInt` (a non-positive or unparsable value
falls back to the default, `internal/provider/live_denojob_drain_test.go:25`);
duration knobs by `liveEnvDuration` (`:32`).

### Benchmark

The provider benchmark harness is the drain test above; run it with
`DENOJOB_RUNS` and `DENOJOB_PARALLELISM` to reproduce the tables in
`docs/adrs/0003-event-driven-reconcile-loop.md`.

### Provider CLI

Every provider flag has an environment fallback except the ones marked n/a
(`cmd/deno-kcp-provider/main.go:62-108`). A flag beats its environment variable.

| Variable | Flag | Default | Source |
|---|---|---|---|
| `KUBECONFIG` | `--kubeconfig` | none; required, the process exits with code 2 if empty | `main.go:51` |
| `KCP_HOST` | `--host` | none; overrides the kubeconfig server | `main.go:53` |
| `RUNS_DIR` | `--runs-dir` | `runs` | `main.go:55` |
| `POLICY_ENGINE_DIR` | `--policy-engine-dir` | `../policy-engine/lib/policy-engine-server-gha-lite` | `main.go:57-59` |
| `BUNDLED_ACTIONS_DIR` | `--bundled-actions-dir` | empty, then `<policy-engine-dir>/../policies/gha-lite/bundled-actions` | `main.go:60-62`, fallback at `main.go:80-82` |
| `DENO_BIN` | `--deno-bin` | `deno` | `main.go:63` |
| `METRICS_LISTEN` | `--metrics-listen` | empty, which disables the Prometheus endpoint | `main.go:69` |
| `RUN_TTL_SECONDS` | `--run-ttl-seconds` | `3600` (negative disables) | `main.go:71` |
| `OPENBAO_ADDR` | `--openbao-addr` | empty, which means workloads serve plain HTTP | `main.go:95` |
| `OPENBAO_TOKEN` | `--openbao-token` | empty | `main.go:97` |
| `OPENBAO_CACERT` | `--openbao-ca-cert` | empty, for a `https` address | `main.go:99` |
| `OPENBAO_MOUNT` | `--openbao-mount` | `pki` | `main.go:101` |
| `OPENBAO_ROLE` | `--openbao-role` | `denopod` | `main.go:103` |
| `OPENBAO_INTERMEDIATE_TTL` | `--openbao-intermediate-ttl` | `43800h` | `main.go:105` |
| `OPENBAO_LEAF_TTL` | `--openbao-leaf-ttl` | `720h` | `main.go:107` |

Flags with no environment fallback: `--pod-timeout` (`5m`, `main.go:67`),
`--token-ttl` (`1h`, `main.go:68`), `--write-status` (`true`, `main.go:73`).

## License

Unlicense (public domain). See `LICENSE`, which matches the sibling repos in
the org root.
