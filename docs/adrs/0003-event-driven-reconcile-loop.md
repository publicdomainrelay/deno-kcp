# ADR 0003: Event-driven reconcile loop (informers over the APIExport virtual workspace)

Status: Accepted

Reading note: code references below are as of this ADR's writing. The poll driver
it analyses was deleted in migration step 4 and `internal/provider` was later
split into per-kind files, so the line numbers no longer resolve and some symbols
(`RunOnce`, `RunRuntimeOnce`, `reconcile*Ref`, `WorkspacePaths`, `Refs`) no longer
exist. The analysis is still the reason the change was made; treat the symbol
names as the historical record and do not go looking for the code.

Numbering note: 0002 (native run admission) and this ADR are a pair. 0002 owns
the admission semantics (accept and queue per `PolicyWorkflowPod`); this ADR
owns the driver that delivers the events those semantics need.

## Context

The provider is a Kubernetes-style controller: it watches custom resources and
drives Deno workloads. Its reconciliation logic is already pure. Each concept
package (`internal/denojob`, `internal/denorun`, `internal/denopod`,
`internal/policyengine`, `internal/policyworkflowrun`) exposes a function of the
form `Reconcile(Observed) (Result, error)`, where `Result` carries a phase, a
status, and a list of `Ops` (start run, stop run, remove finalizer, delete). The
packages do not talk to the API server.

The problem is the driver that calls those functions.

`Provider.Run` (`internal/provider/provider.go:172`) is:

```go
for {
    RunOnce(ctx)
    time.After(p.opts.Interval)   // default 2s
}
```

`RunOnce` (`provider.go:185`) lists policy workflow runs and reads each one.
`RunRuntimeOnce` (`provider_runtime.go:145`) then, for every workspace, LISTs six
resource types (engines, workflow pods, triggers, jobs, runs, pods) and, for each
listed object, issues a second GET through `reconcileXRef` (for example
`reconcileRunRef` at `provider_runtime.go:584` re-reads the run the list already
returned, and `reconcileJobRef` at `provider_runtime.go:521` re-LISTs runs).
Every pass therefore re-reads and, where status changed, re-writes every object
of every type, including objects that reached a terminal phase long ago, and then
sleeps for a fixed two seconds. `WorkspacePaths` (`registry_runtime.go:21`) walks
the whole workspace tree (depth 6) on every pass to find the workspaces to visit.

`Result.RequeueAfter` is computed by every reconciler and is carried as far as
`provider.go:242`, but the loop never reads it.

### Measured cost

Deno execution is negligible. On the measurement host (16 cores, Deno 2.9.3), a
run of the allow script costs about 13 ms; one hundred runs all at once cost
0.177 s; one hundred sequential runs cost 1.297 s.

The end-to-end numbers for one hundred trivial runs at parallelism 20 do not
match that floor:

| path | admission | total to all-terminal | peak active |
| --- | --- | --- | --- |
| DenoJob (DenoRun children) | 22.84 s (scheduler-bounded) | 27.419 s | 20 |
| PolicyWorkflowPod (warm engine) | 0.531 s | 22.693 s | 20 |

Per-run latency in the DenoJob path is quantized to 2 s and 3 s, both multiples
of the poll interval.

The poll interval was then swept over the same DenoJob, 100 runs at parallelism
20, with the runtime interface counting every provider API call:

| interval | total to all-terminal | passes | in-pass wall | fixed sleep |
| --- | --- | --- | --- | --- |
| 2 s | 27.416 s | 11 | 7.29 s | 20.005 s |
| 100 ms | 8.191 s | 11 | 7.19 s | 1.003 s |
| 1 ms | 7.158 s | 11 | 7.15 s | 0.011 s |

Two facts follow.

- The pass count is 11 at every interval. One hundred runs at parallelism 20 need
  five waves at roughly two passes per wave; the interval changes only how much
  idle is inserted between passes, never how many are needed. At 2 s, 20 s of the
  27.4 s are pure sleep.
- What remains is 7.15 s of in-pass REST, from 1573-1643 provider calls at about
  4.4 ms each. The calls do not scale with active runs; they scale with
  passes times total runs, because every pass re-lists and re-reads (and
  re-writes status for) all one hundred children, terminal ones included. The
  essential calls for this workload are nearer 400 (create, status start, observe,
  status final, per run), or about 2 s at the same per-call latency.

Attribution of the 27.416 s baseline: 20.005 s fixed sleep, 7.234 s in-pass REST,
56 ms client CPU, 121 ms residual, and about 0.2 s of Deno work that runs
concurrently and is not on the critical path. In other words, 100 runs that need
about 0.2 s of CPU spend 27 s wall clock, and none of the excess is Deno.

### What kcp provides

kcp serves a wildcard LIST/WATCH, `/clusters/*/apis/<group>/<version>/<resource>`,
which returns objects across logical clusters and stamps each object with the
`kcp.io/cluster` annotation identifying its logical cluster. On a bare shard that
endpoint is privileged (system:masters) and reachable only when talking directly
to the shard.

The supported, unprivileged equivalent for a service provider is the APIExport
virtual workspace: for an export `denoruntime` in workspace `root:deno-provider`,
the endpoint `/services/apiexport/root:deno-provider/denoruntime/clusters/*/...`
serves the exported resources across every logical cluster that has an APIBinding
to that export. kcp documents this as the way a provider "set[s] up shared
informers that can list and watch resources across all the consumer workspaces".

This repository already has that structure. `deploy/install-provider.sh` applies
`denoruntime-apiexport.yaml` and `policyworkflowrun-apiexport.yaml` into
`root:deno-provider` and waits for `IdentityValid`.
`deploy/workspacetype-denoruntime.yaml` gives the `denoruntime` workspace type
`defaultAPIBindings` for both exports, so every tenant workspace of that type is
bound automatically and the virtual workspace URLs are published in
`APIExport.status.virtualWorkspaceURLs`.

## Decision

Replace the poll driver with shared informers over the APIExport virtual
workspace wildcard, feeding a work keyed by object, while keeping the pure
`Reconcile(Observed) (Result, error)` seam unchanged.

Concretely:

1. Start one shared informer per watched GVR against the wildcard base
   `/services/apiexport/<provider-workspace>/<export>/clusters/*`. The watched
   GVRs are `deno.computer/v1alpha1` `denopods`, `denoruns`, `denojobs`,
   `runtriggers`, `policyengines`, `policyworkflowpods` (export `denoruntime`)
   and `policyworkflowruns` (export `policyworkflowruns`).
2. On every add/update/delete event, compute the key
   `Ref{LogicalCluster: annotations["kcp.io/cluster"], Name: metadata.name}` and
   enqueue it on a `workqueue` with rate limiting. Object type maps to reconciler.
3. Run a fixed pool of workers (default `min(16, GOMAXPROCS)`, since reconcilers
   do blocking work: process start, HTTP to the engine, status writes). One key
   is processed by one worker at a time, which serializes per-object work.
   `Result.RequeueAfter` becomes `queue.AddAfter(key, d)`; a transient error
   becomes `queue.AddRateLimited(key)`.
4. Reconcilers read from the informer cache through a `Reader` seam instead of
   `Registry.ReadX`, removing the per-object GET. The existing `Registry` remains
   the writer (create, status patch, finalizer, delete) against
   `/clusters/<logical-cluster>/...`.
5. Status writes use optimistic concurrency: include the cached
   `metadata.resourceVersion` in the patch (or a JSON-patch `test`), and re-enqueue
   on conflict rather than overwriting.
6. Start the informers from `APIExport.status.virtualWorkspaceURLs`, discovered at
   startup. If the list is empty (kcp only publishes the URL once the first
   APIBinding exists; see kcp issue #1183), wait and re-check rather than
   crash-looping. For a multi-shard topology, one informer set per advertised URL.

## Why this and not something else

- The APIExport virtual workspace is the mechanism kcp documents for a provider
  to inform across consumer workspaces without shard privileges. The repository
  already publishes these exports and auto-binds them, so this is a change of
  driver, not of ownership model.
- It removes all three sources of the 27 s at once: the fixed 2 s sleep, the
  workspace-tree walk, and the O(N) per-pass GETs. An event, not a timer, becomes
  the reason to reconcile a key.
- The reconcilers are already pure, and `docs/KCP_DEV_HOW_TO.md` records the
  intent that the ticker be replaced by an informer behind the same
  `Reconcile(ctx, ref) -> Result` seam. No reconciliation logic is rewritten.
- The dependency cost is zero: `k8s.io/client-go` (informer cache) and
  `k8s.io/client-go/util/workqueue` are already in `go.mod`.

## Alternatives considered

- Shorten `Interval`, or make it adaptive, and reuse the LIST result instead of a
  second GET. Measured: dropping the interval from 2 s to 1 ms takes the DenoJob
  drain from 27.4 s to 7.2 s, because it removes only the 20 s of idle. It does
  not reduce the pass count (11 in both cases) and leaves the 7.15 s of O(passes
  x runs) REST, where the essential per-run calls are nearer 2 s. It is a viable
  stopgap (see Migration step 1) and not the correct shape.
- Use the bare shard wildcard `/clusters/*/apis/...`. It works and avoids the
  APIBinding dependency, but it needs system:masters and a direct shard
  connection. The virtual workspace is the supported equivalent.
- Adopt `sigs.k8s.io/multicluster-runtime` with the kcp provider
  `github.com/kcp-dev/multicluster-provider` (the `apiexport` provider) over
  `sigs.k8s.io/controller-runtime`. This is the canonical kcp controller stack,
  and it buys manager lifecycle, leader election, metrics, and engagement of
  logical clusters. It is also a manager rewrite plus three new module families,
  and its supported controller-runtime versions must be reconciled with this
  repository's `k8s.io/* v0.36.4`. Defer until multi-replica or leader election
  is actually required; the informer-plus-workqueue design above is the part that
  removes the measured latency, and it can later be lifted onto the framework.

## Migration

1. Stopgap (optional, small): reuse the LIST result inside `reconcileXRef`
   (drop the second GET), have `RunRuntimeOnce` honor `Result.RequeueAfter`
   through a per-key next-attempt map, and lower the interval for objects that are
   mid-transition. This is reversible and takes the edge off while the informer
   work lands.
2. Add `internal/provider/watch`: an informer factory over the wildcard bases,
   the object-to-reconciler dispatch table, the workqueue, and the worker pool.
3. Add the `Reader` seam so `reconcileXRef` takes the observed object from the
   cache. Keep `Registry` for writes.
4. Gate the driver behind a flag (`--driver=poll|watch`) so both paths run from
   the same reconcilers and can be measured against each other, then make `watch`
   the default and delete `WorkspacePaths`, `RunRuntimeOnce`, and the policy-run
   list/read loop.
5. Add metrics: queue depth, reconcile latency, cache sync age, conflicts.

## Validation

Re-run the live benchmarks through the watch driver and compare with the table
above. Success criteria, at 100 and 1000 runs and at concurrency 20:

- admission time approaches the raw create rate (the policy path already shows
  about 188 creates/s; the DenoJob path should stop being scheduler-tick bound at
  roughly 4 creates/s);
- total-to-terminal falls well below the current-architecture floor of 7.15 s
  (interval 1 ms, same workload) and approaches the essential per-run REST cost,
  about 2 s at the measured 4.4 ms per call, plus cache propagation;
- per-run latency is no longer quantized to the poll interval;
- 10000 runs complete without the status churn seen on the poll path.

## Risks

- Virtual workspace URLs are published only after the first APIBinding exists
  (kcp issue #1183). Startup must await them.
- Informer cache lag: the DenoJob scheduler derives its active count from child
  run status. A stale cache can under- or over-count. Read children from the
  indexer and re-enqueue the job when a child transitions, instead of trusting
  wall-clock sampling.
- Concurrent reconciliation of parent and child can race on status. The
  per-key serialization plus optimistic concurrency on writes is the guard; a
  conflict must re-enqueue, never overwrite.
- On a multi-shard installation the virtual workspace advertises several URLs;
  the driver must run one informer set per URL and merge keys.

## As built

Landed on `main` (merge `c2f586a`). Both stages are one driver change behind the
unchanged reconcilers.

| run | total to all-terminal | passes | provider calls |
| --- | --- | --- | --- |
| poll, 2 s (before) | 27.423 s | 11 | 1643 |
| poll, after Stage 1 | 7.658 s | 18 | 487 |
| watch, 100 runs / 20 | 3.628 s | n/a | 481 writes |
| watch, 1000 runs / 20 | 17.17 s | n/a | 4607 writes |

All runs succeeded (100/100 and 1000/1000, zero failed) with peak active equal
to parallelism.

Deviations from the text above, as implemented:

- Endpoint discovery uses `APIExportEndpointSlice.status.endpoints` in the
  provider workspace. `APIExport.status.virtualWorkspaceURLs` is deprecated in
  kcp v0.33.1 and is empty unless `EnableDeprecatedAPIExportVirtualWorkspacesUrls`
  is set.
- A `DenoRun` that is mid-transition is re-checked every 250 ms instead of
  honoring its 2 s `RequeueAfter`. Strict honoring plateaued at 16.3 s, because a
  running process is only noticed at the next observation.
- Status writes are skipped when the computed status equals the cached one. This
  was needed to stop a conflict storm: without it the job status write raced the
  informer and the first watch run took 12.75 s.
- Migration step 4 landed: the poll driver is deleted (`--driver`, `--interval`,
  `RunOnce`, `RunRuntimeOnce`, `Refs`, `WorkspacePaths`, `pollSchedule`), the
  watch driver is the only path, and `Runtime` is narrowed to writes. The
  deletion left the drain benchmark unmoved: 17.221 s / 3044 calls / 1000 of 1000
  / peak active 20, against 17.205 s / 3045 immediately before it.
- A provider built without `Options.RestConfig` fails in `New`, rather than
  nil-dereferencing in the informer factory.
- Migration step 5 (metrics) landed: `internal/provider/metrics.go` serves the
  `denokcp_*` series on `--metrics-listen`. Post-startup endpoint-URL changes are
  still not implemented: `watchEndpointSlices` (`internal/provider/watch.go`)
  is a startup wait that returns once `APIExportEndpointSlice.status.endpoints`
  is ready, not a reactor to later changes.
- `RunTrigger` moved to events last, and was the only kind still discovering
  another object's fact on a tick. A terminal `PolicyWorkflowRun` now enqueues
  every trigger naming that run's `deno.computer/policyworkflowpod` label
  (`internal/provider/watch.go`, index `indexByClusterTriggerPod`). The requeue
  constant is gone from `internal/trigger`; the driver supplies a one-minute
  backstop so an event lost without a watch error cannot leave a trigger stuck
  until the next relist. Measured fire-to-`Triggered`: **~1.57 s before, under
  10 ms after**.
- What this does *not* cover: `RequeueAfter = 2 s` remains in `internal/denojob`,
  `denorun`, `denopod` and `policyworkflowrun`, and `runWatchWorker` substitutes
  `p.opts.Interval` for any key that returns 0 without being terminal. Those
  waits observe a live Deno process, which the API server knows nothing about,
  so they cannot be event-driven. What this ADR removes is ticker-based discovery
  of a fact held by another object; sampled observation of a running process
  stays, which is what `minTransitionPoll` exists for.

The watch path's remaining cost is write volume, not reads: at 1000 runs, 11.9 s
of the 17.2 s is Registry writes (4607 calls at 2.6 ms), largely job status
writes that race informer updates. That is the next lever, and it is a status-
write concern rather than a discovery one.

**Corrected below.** This paragraph is wrong twice over, and the follow-up
sections in this file already contain the evidence against it. See "Follow-up:
the last poll" at the end.

## Follow-up: status-write and startup work (feat/perf-loop)

Measured on the same host with `TestDenoJobAllowDrainOnRealKCP`, watch driver,
live kcp + kine, `DENOJOB_RUNS=1000 DENOJOB_PARALLELISM=20`.

| revision | total | create->first-seen | first-seen->terminal | runtime calls | per run |
| --- | --- | --- | --- | --- | --- |
| watch baseline (main, 4607 writes) | 17.17 s | 2.108 s | 15.05 s | 4590 | 4.59 |
| item 1: coalesce status | 17.21 s | 2.108 s | 15.16 s | 3474 | 3.47 |
| item 2: event-driven discovery | 17.21 s | 2.107 s | 15.20 s | 3489 | 3.49 |
| item 3: pod label index | 17.19 s | 2.110 s | 15.19 s | 3483 | 3.48 |
| item 4: debounce job status | 17.22 s | 2.108 s | 15.22 s | 3053 | 3.05 |
| item 5: merge fast run status | 17.26 s | 2.108 s | 15.26 s | 3038 | 3.04 |
| item 6: metrics | 17.28 s | 2.109 s | 15.29 s | 3040 | 3.04 |

A run writes status twice (start to persist `status.runID`, then the terminal
transition) and the job writes once per 500 ms window; that is the floor at
3.0 calls per run without dropping the start write, which would lose the run
handle across a provider restart. The remaining `CreateRun` is one per run.

The fixed 2.1 s `create->first-seen` is not provider startup. Instrumenting the
test shows the `CreateJob` POST alone takes 2.105 s, with `pre-create-list-after`
at 2 ms, and the same 2.1 s appears with `DENOJOB_DRIVER=poll` where no
informers run. The first write to `denojobs.deno.computer` triggers kcp's lazy
`quota admission added evaluator`; the provider reacts within the test's 500 ms
poll granularity. It is a kcp first-write cost, removed only by a synthetic
warm-up write, which would move it rather than remove it.

## Parallelism sweep

1000 runs, watch driver, this host has 16 CPUs.

| DENOJOB_PARALLELISM | total to all-terminal | admission | peak active | avg call |
| --- | --- | --- | --- | --- |
| 8 | 38.013 s | 38.011 s | 8 | 2.33 ms |
| 20 | 17.283 s | 17.280 s | 20 | 2.38 ms |
| 32 | 11.862 s | 11.298 s | 32 | 2.49 ms |
| 64 | 7.700 s | 7.698 s | 58 | 3.57 ms |
| 128 | 6.705 s | 6.702 s | 68 | 4.93 ms |

The knee is at 64, four times `nproc`. The drain is latency-bound, not CPU-bound:
a run costs about 13 ms of Deno but is only noticed at the next observation, so
throughput scales with parallelism until the REST path saturates. Past 64 the
gain shrinks (7.70 s to 6.71 s) while the average call latency nearly doubles
and peak active saturates near 68, so the extra slots are unused. No provider
default is changed; the worker pool stays `min(16, GOMAXPROCS)` and parallelism
remains a per-job field.

## Follow-up: the last poll

Measured on the same host and harness as everything above,
`TestDenoJobAllowDrainOnRealKCP`, `DENOJOB_RUNS=1000 DENOJOB_PARALLELISM=20`.

This section corrects two claims in "As built".

**Read the third correction before the second.** The event-driven completion
described below was built on the worker host, and the worker host has since been
removed: the provider forks one `deno run` per workload again and `ExecPod` is
the only runner. `RunCompletionSource`, `runCompleted`, its cache-freshness gate
and the `completionDriven` skip of the clamp all went with it, so every clamp
figure below applies to `exec` and the rows measuring the host are history. What
survives belongs to the poll path, because the tighter clamp is what exposed it:
the duplicate-start guard, without which `exec` at 25 ms starts a second workload
for 6.2 percent of runs, and the active-runs gauge that made that visible. The
claim the second correction makes still stands — a terminal transition is
knowable in-process for a runner that owns the process, and the worker host
proved it while it existed.

**Write volume is not the lever.** The follow-up table above disproves it in its
own numbers: items 1 through 6 cut provider calls from 4590 to 3040, a reduction
of 34 percent, and total time moved from 17.17 s to 17.28 s. Cutting a third of
the writes bought 0.11 s of regression. Reads were never the problem either.

**The terminal transition of a run can be event-driven.** The paragraph claiming
otherwise is true only of `exec`, where the provider owns a child process and
must ask it. For the worker host the runner learns the transition in-process:
`host.ts` already emits exactly one `{"event":"state",...}` frame per run, after
all stdout and stderr frames, and `HostPod` already receives it. Nothing was
done with it.

### What the poll actually cost

The drain fits `(runs / parallelism) x (observation interval + per-slot
overhead)` at every point of the parallelism sweep, within one percent. At
parallelism 20 that is 50 waves, so 50 x 250 ms = 12.5 s of the measured 15.14 s
`first-seen->terminal` was pure poll idle.

Sweeping `Options.MinTransitionPoll` on the `exec` runtime:

| clamp | total | first-seen->terminal | reconciles | avg call |
| --- | --- | --- | --- | --- |
| 250 ms (before) | 17.147 s | 15.138 s | 6576 | 2.262 ms |
| 50 ms | 7.633 s | 5.603 s | 5838 | 3.025 ms |
| 25 ms | 7.115 s | 5.098 s | 5836 | 2.93 ms |
| 10 ms | 7.100 s | 5.098 s | 7131 | 3.4 ms |

The knee is 25 ms, which is now the default: 10 ms buys 15 ms and costs 22
percent more reconciles at 16 percent higher per-call latency. The remaining
cost is not the loop, it is REST: about 2.1 s of `create->first-seen` is kcp's
lazy quota-admission evaluator on the first write to the resource, and the calls
themselves now run concurrently enough that `restWall` exceeds wall clock.

### The worker pool was not the constraint

Re-swept at the new clamp, since the poll no longer masks contention:

| parallelism | workers | total | peak active | avg call |
| --- | --- | --- | --- | --- |
| 64 | default (16) | 6.578 s | 14 | 4.5 ms |
| 64 | 64 | 6.607 s | 17 | 4.56 ms |
| 128 | default (16) | 6.579 s | 14 | 4.751 ms |
| 128 | 128 | 6.566 s | 15 | 4.694 ms |

Raising the pool changes nothing, and parallelism 64 and 128 are
indistinguishable. The pool stays `min(16, GOMAXPROCS)`; `Options.WatchWorkers`
exists so the negative result can be re-tested, and no default moved.

### Event-driven completion, and the hazard it introduces

The provider now installs a completion callback on a runner that offers one
(`runner.RunCompletionSource`, implemented by `HostPod` and `MemoryPod`;
`ExecPod` keeps polling). The callback is not the interesting part. **The gate
is.**

`denorun` is a stateless decider whose only memory is the run's own status, so a
pass that reads a run whose `status.runID` has not yet reached the informer
cache emits `OpStartRun` again and starts a **second workload**. Optimistic
concurrency does not prevent this, because `Start` is a side effect that runs
before the write. A wake that merely enqueued the key would therefore have been
a correctness regression, not a speed-up.

So `runCompleted` reads the run from the cache and drops the wake unless the
cached status already names that runID. Dropping is safe rather than
conservative: the start write's own informer update already enqueues the same
key, so the loss is propagation delay, never the poll interval. `CompletionDrops`
counts them; on the live worker-host test two of three runs are dropped, because
a run that finishes inside its own starting pass legitimately beats its own
status write.

The wake is best-effort by construction, so the poll is not deleted. A clean
provider shutdown calls `Deno.exit(0)` before the host drains its runs, and a
killed host emits nothing at all. `minTransitionPoll` and the runner's own
timeout remain the backstop, and `Options.MinTransitionPoll` now applies only to
a runner that does not report completion.

That last part is measured. Through the worker host, where the wake does the
work, the clamp is pure added cost:

| clamp | total | reconciles |
| --- | --- | --- |
| 250 ms | 9.688 s / 10.178 s | 6323 / 6323 |
| 25 ms | 10.197 s / 10.227 s | 6977 / 7010 |
| skipped (completion-driven) | 10.22 s | 6142 |

The reconcile counts are deterministic across runs, and the direction is
consistent, but the wall-clock difference is inside noise: the host runtime
costs about 10 s for this workload whatever the loop does. The wake made the
poll irrelevant; it did not make the worker host faster than `exec`, which
finishes the same workload in 7.09 s. That gap is the host's own per-run
overhead and is a separate question from discovery.

Net effect on the drain, `exec` at the new default: **17.147 s to 7.094 s**, and
the full chain still passes (`TestExampleChainOnRealKCP`,
`TestTheFullDenoRuntimeLifecycleOnRealKCP`).

`DENOJOB_MIN_POLL` and `DENOJOB_WATCH_WORKERS` are the test knobs that produced
these tables.
