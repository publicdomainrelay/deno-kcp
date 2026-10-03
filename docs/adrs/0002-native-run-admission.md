# ADR 0002: Native run admission and a per-pod queue

Status: accepted
Date: 2026-09-24

## Problem

A `PolicyWorkflowPod` caps how many policy runs execute at once. The first
design enforced the cap at create time: a `DenoPod` POSTed to a bespoke loopback
HTTP endpoint the provider runs in-process, with an HMAC bearer token, and the
provider rejected a fire above `maxConcurrent` with HTTP 409.

Two questions followed. Is create-time admission the right KCP construct for a
per-workload concurrency cap, and is the bespoke HTTP endpoint idiomatic when
the client already holds a KCP service-account token.

## What KCP actually offers

KCP serves `admissionregistration.k8s.io` (`pkg/cache/server/bootstrap/bootstrap.go`).
Its admission plugins are `pkg/admission/validatingwebhook`, `pkg/admission/mutatingwebhook`,
`pkg/admission/validatingadmissionpolicy` and `pkg/admission/mutatingadmissionpolicy`
(registered in `pkg/admission/plugins.go`).

Admission is synchronous and per object. For a resource bound through an
`APIBinding`, the plugin dispatches to the `APIExport` owner's workspace:
`pkg/admission/validatingwebhook/plugin.go` resolves the source with
`getSourceClusterForGroupResource` and builds a webhook source from the
`APIExportClusterName`. `docs/content/concepts/apis/admission-webhooks.md`
describes the same cross-workspace dispatch and notes the reviewed object is
annotated with `kcp.io/cluster`.

A webhook is an out-of-process HTTP call, so it *could* list sibling runs to
count active ones. A `ValidatingAdmissionPolicy` cannot: CEL sees only the
object, the policy params, and the authorizer, with no list access. Even a
webhook only rejects; it cannot queue. KCP's own counting plugin,
`pkg/admission/objectcountlimit`, confirms the cost: it keeps a
`objectcount.Registry` from a periodic etcd scan plus per-create deltas, and it
still rejects when a limit is hit.

Kubernetes caps Job concurrency in the controller (`spec.parallelism`), not in
admission. Admission validates and mutates; the controller accepts and schedules.

The loopback endpoint re-implements authn/authz outside the API server. The
client already gets `KCP_SERVER`, `KCP_TOKEN` and `KCP_WORKSPACE` when it names a
service account (`impl/execrunner` in `kcp-libs`), and KCP does RBAC on bound
resources in the consumer workspace. The endpoint also only works inside one
provider process.

## Decision

1. Accept every request run. Gate execution in the controller with a per-pod
   queue, ordered oldest-first. A run with no free slot stays `Pending` with a
   `Complete=False` `AtCapacity` condition, and starts when one frees.
2. Let the client create the run directly through the KCP API under RBAC. A
   `PolicyWorkflowRun` with `spec.policyWorkflowPod` is the request.
3. Resolve the engine endpoint, workflow, inputs and TTL from the referenced
   `PolicyWorkflowPod` at submit time, not at create time.
4. Keep the fire endpoint as a compatibility shim that queues the same request
   run; retire it when no client uses it.

`Forbid` (default) and `Replace` are caps of 1; `Allow` uses `maxConcurrent`,
where unset or not positive means unlimited. `Replace` lets the newest run
supersede the others instead of rejecting.

## How the decision runs on the watch driver

ADR 0003 owns the driver: shared informers over the APIExport virtual
workspace, one workqueue, a fixed worker pool. This ADR only says what the
reconciler does with each key; the two are independent, and the admission math
is a pure function of a run list and a pod.

1. `internal/provider/admission.go` computes a `runAdmission` per run from the
   pod and the pod's runs. `buildRunAdmissions`/`buildPodAdmissions` sort the
   pod's runs oldest-first, count `Running` as active, and call
   `policyworkflowpod.QueueDecision(policy, maxConcurrent, active, position)`
   for each `Pending` run. `Forbid` and `Allow` fill free slots; `Replace`
   admits only the newest pending run and preempts the rest.
2. The queue condition message names only `concurrencyPolicy` and
   `maxConcurrent`. It does not embed the live active count, so a run parked at
   capacity does not churn its status while it waits.
3. The pod's runs are grouped by `runPodName` inside `buildRunAdmissions`
   (`internal/provider/admission.go`) from the list the worker already holds,
   not a per-event LIST, so admitting a create needs no extra list.
4. A run whose execution frees a slot (it leaves `Running`) wakes its queued
   siblings by enqueueing the pod's oldest pending runs, capped at the pod's
   capacity, plus the pod itself. The next run starts on that event, not on a
   timer.
5. The controller still writes the ordinary `RequeueAfter`; the wake only makes
   the common case immediate. A queued run that no event reaches is retried by
   the workqueue, so a dropped wake degrades to a delay, never a stall.

## Consequences

- Callers are never rejected at capacity; the queue absorbs bursts.
- A queued run picks up a restarted engine because the endpoint is resolved at
  submit time.
- `policyworkflowruns` gains `spec.policyWorkflowPod` and drops the `workflow`
  requirement, so the schema was bumped to `v1alpha1-3` (it is `v1alpha1-4`
  today).
- `status.active` on the pod counts `Running` runs, not all non-terminal runs.
- A native client must set the run's label, finalizer, and `ownerReference` (it
  can read the pod uid under RBAC). The TTL, not KCP GC, reaps runs because the
  `PolicyWorkflowPod` is long-running.
- Accepted-but-queued runs are real API objects: one create write each before
  they execute. A burst of N runs costs N creates and N `Pending` statuses even
  though only `maxConcurrent` execute. This is the price of never rejecting; it
  is bounded by the caller's burst, not by the concurrency cap.

## Alternatives rejected

- **ValidatingAdmissionWebhook.** Can count siblings, but cannot queue, adds an
  API list and a network round trip to every create, and needs an HTTPS server,
  a CA bundle and a provider-workspace webhook configuration. A rejection still
  reaches the caller.
- **ValidatingAdmissionPolicy (CEL).** Cannot list siblings, so it cannot count.
- **Keep the loopback endpoint as the only path.** Duplicates KCP authn/authz
  and does not scale past one provider process.
- **Poll the queue on an interval.** The old branch drained a `Replace`/pool
  loop with sleeps. The watch driver already delivers a run's terminal event, so
  waking the siblings on that event removes the sleep without new machinery.

## As built

Landed on `main` (merge `ea87bbd`), re-based onto the watch driver. Live drain,
`TestNativeAdmissionAndQueueDrainOnRealKCP`, 100 runs at `maxConcurrent` 20:
peak executing 20, 100/100 succeeded, 10.4s, zero rejections (the old reject
path measured 22.7s for the same run count).

Two defects had to be fixed before it would drain at all, both introduced by
moving this design onto the watch driver:

- **Admission matched the wrong ref.** The watch worker passes
  `key.ref.withResourceVersion(...)` into `Reconcile`, but `buildRunAdmissions`
  keys its result on `{cluster,name}`. The lookup always missed, so every run
  was admitted ungated with an empty endpoint and failed with "no engine
  endpoint", never starting. Admission now looks the run up by identity only.
- **The cap leaked before a run was observed Running.** Admission counted only
  runs already visible as `Running` in the informer cache, so several pending
  runs could each see `active=0` and be admitted in the same window. A live run
  reached peak 5 at `maxConcurrent` 2. Admitted-but-unobserved runs are now held
  by an in-memory lease that counts toward `active` and is released once the run
  is seen `Running` or terminal.

The iteration loop was also the reason this took a 25 minute timeout to surface:
the live test waited 120s for a single run and up to 30 minutes for the drain,
with no state dump. It now honours `DRAIN_WAIT` (a Go duration such as `45s` or
`2m`; a bare number does not parse and falls back to the default), prints run
phases, their conditions and the pod every few seconds, and dumps that state on
failure. The hang above is a 30 second diagnosis instead of a 25 minute wait.
