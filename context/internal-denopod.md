# Context: internal-denopod

Repository: `deno-kcp`

This context exists so the DenoPod lifecycle can be specified and tested without a Kubernetes client or a live deno process. Reconcile is the single decision point that turns an observed pod plus its execution observation into a target state, and every branch is covered by internal/denopod/denopod_test.go, which drives the reconciler with table-style Observed values and asserts on the returned Result. The package mirrors the shape of internal/policyengine but adds exit-code and output capture, so the spec records the exact contract other reconcile loops in this repository follow.

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
interfaces:
- file: internal/denopod/denopod.go
  kind: struct
  name: ExecutionObservation
  signature: "type ExecutionObservation struct {\n\tRunID string\n\tState ExecutionState\n\tExitCode
    *int32\n\tMessage string\n\tOutputs map[string]string\n}"
- file: internal/denopod/denopod.go
  kind: type_alias
  name: ExecutionState
  signature: type ExecutionState string
- file: internal/denopod/denopod.go
  kind: function
  name: New
  signature: func New(opts Options) *Reconciler
- file: internal/denopod/denopod.go
  kind: struct
  name: Observed
  signature: "type Observed struct {\n\tPod v1alpha1.DenoPod\n\tExecution *ExecutionObservation\n\tReadinessPassed
    *bool\n\tLivenessFailed bool\n\tNow time.Time\n}"
- file: internal/denopod/denopod.go
  kind: type_alias
  name: Op
  signature: type Op string
- file: internal/denopod/denopod.go
  kind: struct
  name: Options
  signature: "type Options struct {\n\tNow func() time.Time\n}"
- file: internal/denopod/denopod.go
  kind: struct
  name: Reconciler
  signature: "type Reconciler struct {\n\topts Options\n}"
- file: internal/denopod/denopod.go
  kind: method
  name: Reconciler.Reconcile
  signature: func (r *Reconciler) Reconcile(ctx context.Context, o Observed) (Result,
    error)
- file: internal/denopod/denopod.go
  kind: struct
  name: Result
  signature: "type Result struct {\n\tPhase v1alpha1.DenoPodPhase\n\tRunID string\n\tRestarts
    int32\n\tStartTime *metav1.Time\n\tCompletionTime *metav1.Time\n\tExitCode *int32\n\tMessage
    string\n\tOutputs map[string]string\n\tReady bool\n\tConditions []metav1.Condition\n\tOps
    []Op\n\tRequeueAfter time.Duration\n\tRemoveFinalizer bool\n\tDelete bool\n}"
requirements:
- codeRefs:
  - struct:4c5bf8db95a5eabcdd5969ee40a83886
  - struct:aff6e789cdee650936e8e9c4badaedd7
  id: r.carries-existing-status
  level: MUST
  text: 'Every decision starts from the observed DenoPod status: phase, run ID, restarts,
    start time, completion time, exit code, message, outputs, readiness and a copy
    of conditions carry into the Result.'
- codeRefs:
  - method:73925188636ee222feadc0ef8ca57514
  - struct:0ffa826db7f6371892be099973c54fbd
  id: r.completion-carries-execution-detail
  level: MUST
  text: A completion copies the execution run ID, exit code, message and outputs into
    the Result, sets the completion time to Now, marks ready false, sets phase Succeeded
    when successful or Failed otherwise, and sets the Ready condition false plus the
    Complete condition to the success value.
- codeRefs:
  - file:internal/denopod/denopod.go
  - struct:aff6e789cdee650936e8e9c4badaedd7
  id: r.conditions-carry-generation
  level: MUST
  text: Every condition Reconcile sets records the observed pod generation as ObservedGeneration.
- codeRefs:
  - method:73925188636ee222feadc0ef8ca57514
  - struct:aff6e789cdee650936e8e9c4badaedd7
  id: r.deadline-fails-the-pod
  level: MUST
  text: When ActiveDeadlineSeconds is set and has elapsed since the status start time,
    Reconcile stops a running execution, sets phase Failed, clears the run ID, marks
    ready false, sets the completion time to Now, sets Failed and Ready conditions
    with reason DeadlineExceeded, and requeues after RequeueAfter.
- codeRefs:
  - file:internal/denopod/denopod_test.go
  id: r.decisions-are-covered-by-tests
  level: SHOULD
  text: Each decision branch is covered by a test in denopod_test.go that builds an
    Observed value and asserts on the returned Result phase, readiness and timestamps.
- codeRefs:
  - method:73925188636ee222feadc0ef8ca57514
  - type_alias:a490e5e249e0847d63dd37e654172f27
  id: r.deletion-tears-down
  level: MUST
  text: When the DenoPod has a deletion timestamp, Reconcile emits OpStopRun if the
    execution is still running, then OpRemoveFinalizer, sets RemoveFinalizer, marks
    ready false with reason Terminating, and requeues after RequeueAfter.
- codeRefs:
  - method:73925188636ee222feadc0ef8ca57514
  - type_alias:26dc5a9867b60f56e7de57f597ef8248
  id: r.exit-policy-is-applied
  level: MUST
  text: 'When the execution has exited, the restart policy decides the outcome, where
    an empty policy means Always: Always restarts; OnFailure completes successfully
    on exit code zero and restarts otherwise; Never and any unrecognised policy complete
    successfully on exit code zero and fail with reason ProcessFailed otherwise.'
- codeRefs:
  - method:73925188636ee222feadc0ef8ca57514
  - struct:4c5bf8db95a5eabcdd5969ee40a83886
  id: r.liveness-failure-restarts
  level: MUST
  text: When LivenessFailed is set while the execution is running, Reconcile stops
    the running execution, keeps phase Running, clears the run ID, increments Restarts
    from the observed status, sets ready false, and records reason LivenessProbeFailed.
- codeRefs:
  - method:73925188636ee222feadc0ef8ca57514
  - type_alias:26dc5a9867b60f56e7de57f597ef8248
  id: r.no-execution-starts-a-run
  level: MUST
  text: When no execution is observed, Reconcile sets phase Running, clears the run
    ID, emits OpStartRun, sets the start time to Now if unset, marks ready false,
    sets Starting and Running conditions, and requeues after RequeueAfter.
- codeRefs:
  - struct:aff6e789cdee650936e8e9c4badaedd7
  - type_alias:a490e5e249e0847d63dd37e654172f27
  id: r.no-io-from-the-decider
  level: MUST
  text: 'Reconcile performs no I/O and touches no Kubernetes client: side effects
    are described only through the Ops list, RemoveFinalizer, Delete and RequeueAfter
    fields of the Result.'
- codeRefs:
  - method:73925188636ee222feadc0ef8ca57514
  id: r.reconcile-honours-context
  level: MUST
  text: Reconcile returns the context error and no Result when the context is already
    cancelled.
- codeRefs:
  - function:3f0c5153e0db566485eab480379f957d
  - method:73925188636ee222feadc0ef8ca57514
  id: r.reconcile-injected-clock
  level: MUST
  text: Reconcile fills a zero Now from the Reconciler's clock, and New defaults that
    clock to time.Now when Options.Now is nil.
- codeRefs:
  - file:internal/denopod/denopod.go
  - method:73925188636ee222feadc0ef8ca57514
  id: r.reconcile-requires-pod-name
  level: MUST
  text: Reconcile returns an error and an empty Result when the observed DenoPod has
    no name.
- codeRefs:
  - file:internal/denopod/denopod.go
  id: r.requeue-interval-exposed
  level: MUST
  text: The package exposes RequeueAfter as a two-second duration, used as the requeue
    interval on the paths that expect another observation.
- codeRefs:
  - method:73925188636ee222feadc0ef8ca57514
  - struct:aff6e789cdee650936e8e9c4badaedd7
  id: r.restart-clears-run-and-counts
  level: MUST
  text: A restart keeps phase Running, clears the run ID, sets Restarts to the observed
    count plus one, sets ready false with the restart message, and requeues after
    RequeueAfter.
- codeRefs:
  - method:73925188636ee222feadc0ef8ca57514
  - struct:0ffa826db7f6371892be099973c54fbd
  id: r.running-reports-readiness
  level: MUST
  text: While the execution state is running, Reconcile keeps phase Running, copies
    the execution run ID, sets Ready from ReadinessPassed (true when that observation
    is nil), sets the Ready condition true with reason Ready or false with reason
    NotReady, and requeues after RequeueAfter.
- codeRefs:
  - method:73925188636ee222feadc0ef8ca57514
  - struct:aff6e789cdee650936e8e9c4badaedd7
  id: r.terminal-phase-stops-making-decisions
  level: MUST
  text: 'When the carried phase is Succeeded or Failed, Reconcile emits no run ops
    and only evaluates TTLSecondsAfterFinished: with a TTL and a completion time it
    sets Delete and OpDelete once expiry has passed, otherwise it requeues for the
    remaining time.'
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

_None yet._
<!-- SPECD_MANAGED_END -->
