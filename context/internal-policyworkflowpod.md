# Context: internal-policyworkflowpod

Repository: `deno-kcp`

This context exists so the PolicyWorkflowPod decider has a describable contract separate from the provider that calls it. The provider owns the watch loop and status writes; this package owns only the decision, which makes the phase transitions, the condition wording, the requeue cadence and the TTL and concurrency helpers testable without a cluster. Capacity and RunTTL are exported because the admission source in internal/provider and the run reconciler need the same precedence rules the pod decider uses, so the rule lives here once instead of being re-derived at each call site.

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
interfaces:
- file: internal/policyworkflowpod/policyworkflowpod.go
  kind: function
  name: Capacity
  signature: func Capacity(policy v1alpha1.ConcurrencyPolicy, maxConcurrent *int32)
    (int32, bool)
- file: internal/policyworkflowpod/policyworkflowpod.go
  kind: function
  name: New
  signature: func New(opts Options) *Reconciler
- file: internal/policyworkflowpod/policyworkflowpod.go
  kind: struct
  name: Observed
  signature: type Observed struct { Pod v1alpha1.PolicyWorkflowPod; EngineReady bool;
    EngineEndpoint string; Active int32; Now time.Time }
- file: internal/policyworkflowpod/policyworkflowpod.go
  kind: struct
  name: Options
  signature: type Options struct { Now func() time.Time }
- file: internal/policyworkflowpod/policyworkflowpod.go
  kind: struct
  name: Reconciler
  signature: type Reconciler struct { opts Options }
- file: internal/policyworkflowpod/policyworkflowpod.go
  kind: method
  name: Reconciler.Reconcile
  signature: func (r *Reconciler) Reconcile(ctx context.Context, o Observed) (Result,
    error)
- file: internal/policyworkflowpod/policyworkflowpod.go
  kind: struct
  name: Result
  signature: type Result struct { Phase v1alpha1.PolicyWorkflowPodPhase; Endpoint
    string; Active int32; Conditions []metav1.Condition; RequeueAfter time.Duration
    }
- file: internal/policyworkflowpod/policyworkflowpod.go
  kind: function
  name: RunTTL
  signature: func RunTTL(pod *v1alpha1.PolicyWorkflowPod, providerDefault *int64)
    *int64
requirements:
- codeRefs:
  - function:bbc6e4753713c4d1d1079ae7e84ed8fa
  id: r.capacity-allow-bounded
  level: MUST
  text: Capacity returns (MaxConcurrent, false) when the policy is ConcurrencyAllow
    and MaxConcurrent is positive.
- codeRefs:
  - function:bbc6e4753713c4d1d1079ae7e84ed8fa
  id: r.capacity-allow-unbounded
  level: MUST
  text: Capacity returns (0, true) when the policy is ConcurrencyAllow and MaxConcurrent
    is nil or not greater than zero, so the caller treats the capacity as unbounded.
- codeRefs:
  - function:bbc6e4753713c4d1d1079ae7e84ed8fa
  id: r.capacity-any-other-policy-is-one
  level: MUST
  text: Capacity returns (1, false) for every policy other than ConcurrencyAllow,
    so a non-allow policy admits at most one run.
- codeRefs:
  - method:84d4636db1ea631ee61b88e98f741d27
  id: r.deletion-timestamp-returns-carried-status
  level: MUST
  text: A pod with a non-nil DeletionTimestamp returns the carried Result unchanged,
    with no phase, endpoint or condition change and no requeue delay.
- codeRefs:
  - file:internal/policyworkflowpod/policyworkflowpod.go
  - method:84d4636db1ea631ee61b88e98f741d27
  id: r.pending-when-engine-not-ready
  level: MUST
  text: When EngineReady is false or EngineEndpoint is empty, Reconcile sets phase
    PolicyWorkflowPodPending, sets the Ready condition to False with reason EngineNotReady
    and message "the referenced policy engine is not reachable yet", and requeues
    after RequeueAfter.
- codeRefs:
  - method:84d4636db1ea631ee61b88e98f741d27
  id: r.ready-condition-true-when-running
  level: MUST
  text: The running path sets the Ready condition to True with reason Ready and message
    "the referenced policy engine is reachable and the pod accepts runs", observed
    against the pod's generation.
- codeRefs:
  - method:84d4636db1ea631ee61b88e98f741d27
  id: r.reconcile-carries-status-first
  level: MUST
  text: Reconcile starts from the observed pod's existing status, copying phase, endpoint,
    active count and conditions, then overwrites Active with the observed Active value.
- codeRefs:
  - function:02acf20c6ae76f4247f2782b39f9905d
  - method:84d4636db1ea631ee61b88e98f741d27
  id: r.reconcile-defaults-now
  level: MUST
  text: Reconcile fills a zero Observed.Now from the Reconciler's Now function, which
    New defaults to time.Now when the caller passes nil.
- codeRefs:
  - method:84d4636db1ea631ee61b88e98f741d27
  id: r.reconcile-propagates-context-error
  level: MUST
  text: Reconcile returns the context error and an empty Result when the passed context
    is already cancelled or expired.
- codeRefs:
  - file:internal/policyworkflowpod/policyworkflowpod.go
  - method:84d4636db1ea631ee61b88e98f741d27
  id: r.reconcile-requires-pod-name
  level: MUST
  text: 'Reconcile returns the error "policyworkflowpod: observed pod has no name"
    and an empty Result when the observed pod has an empty name.'
- codeRefs:
  - file:internal/policyworkflowpod/policyworkflowpod.go
  - method:84d4636db1ea631ee61b88e98f741d27
  id: r.requeue-after-both-live-paths
  level: MUST
  text: Both the pending and the running paths set Result.RequeueAfter to RequeueAfter,
    which is 2 seconds.
- codeRefs:
  - file:internal/policyworkflowpod/policyworkflowpod.go
  - method:84d4636db1ea631ee61b88e98f741d27
  id: r.running-when-engine-ready
  level: MUST
  text: When EngineReady is true and EngineEndpoint is non-empty, Reconcile sets phase
    PolicyWorkflowPodRunning and publishes the observed engine endpoint on the Result.
- codeRefs:
  - function:d4ae60590520385e8ca42957d1cb728f
  id: r.runttl-negative-or-nil-is-nil
  level: MUST
  text: RunTTL returns nil when the resolved TTL is nil or negative, so a negative
    value never becomes a live TTL.
- codeRefs:
  - function:d4ae60590520385e8ca42957d1cb728f
  id: r.runttl-pod-spec-wins
  level: MUST
  text: RunTTL returns the pod's spec RunTTLSecondsAfterFinished when it is set, overriding
    the provider default.
- codeRefs:
  - function:d4ae60590520385e8ca42957d1cb728f
  id: r.runttl-provider-default-fallback
  level: MUST
  text: RunTTL falls back to the provider default when the pod is nil or its RunTTLSecondsAfterFinished
    is nil.
- codeRefs:
  - function:d4ae60590520385e8ca42957d1cb728f
  id: r.runttl-returns-a-copy
  level: MUST
  text: RunTTL returns a pointer to a copy of the resolved value, never a pointer
    into the pod spec.
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:internal/policyworkflowpod/policyworkflowpod.go` file policyworkflowpod.go (internal/policyworkflowpod/policyworkflowpod.go)
- `file:internal/policyworkflowpod/policyworkflowpod_test.go` file policyworkflowpod_test.go (internal/policyworkflowpod/policyworkflowpod_test.go)
<!-- SPECD_MANAGED_END -->
