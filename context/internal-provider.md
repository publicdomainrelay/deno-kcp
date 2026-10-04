# Context: internal-provider

Repository: `deno-kcp`

This context exists to hold the provider-side controller logic of deno-kcp as a single describable unit: the reconcile engines and their per-kind reconcile files, the Reader/Runtime/TokenMinter port interfaces the engines depend on, the Registry implementation that satisfies those ports against Kubernetes, the admission adapter that gates runs by capacity, the informer-backed watch cache, and the metrics surface. It is the boundary between the queue/reconcile library code and the concrete cluster API, so the spec here fixes which ports exist, what each method must do, and which invariants (default concurrency policy, finalizer removal, cache-served reads, cluster path resolution) must hold.

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
interfaces:
- file: internal/provider/provider.go
  kind: interface
  name: Instances
  signature: interface Instances { Read; WriteStatus; Delete; RemoveFinalizer }
- file: internal/provider/provider.go
  kind: method
  name: Instances.Delete
  signature: (ctx context.Context, ref Ref) error
- file: internal/provider/provider.go
  kind: method
  name: Instances.Read
  signature: (ctx context.Context, ref Ref) (*v1alpha1.PolicyWorkflowRun, error)
- file: internal/provider/provider.go
  kind: method
  name: Instances.RemoveFinalizer
  signature: (ctx context.Context, ref Ref) error
- file: internal/provider/provider.go
  kind: method
  name: Instances.WriteStatus
  signature: (ctx context.Context, ref Ref, st v1alpha1.PolicyWorkflowRunStatus) error
- file: internal/provider/provider.go
  kind: function
  name: New
  signature: (opts Options) (*Provider, error)
- file: internal/provider/registry.go
  kind: function
  name: NewRegistry
  signature: (opts RegistryOptions) (*Registry, error)
- file: internal/provider/provider.go
  kind: struct
  name: Options
  signature: struct Options
- file: internal/provider/provider.go
  kind: struct
  name: Pass
  signature: struct Pass
- file: internal/provider/provider.go
  kind: struct
  name: Provider
  signature: struct Provider
- file: internal/provider/run_refs.go
  kind: method
  name: Provider.ActiveRuns
  signature: () int64
- file: internal/provider/provider.go
  kind: method
  name: Provider.Close
  signature: () error
- file: internal/provider/run_refs.go
  kind: method
  name: Provider.MaxActiveRuns
  signature: () int64
- file: internal/provider/provider.go
  kind: method
  name: Provider.Reconcile
  signature: (ctx context.Context, ref Ref) (Pass, error)
- file: internal/provider/provider.go
  kind: method
  name: Provider.Reconciles
  signature: () uint64
- file: internal/provider/provider.go
  kind: method
  name: Provider.Run
  signature: (ctx context.Context) error
- file: internal/provider/run_refs.go
  kind: method
  name: Provider.RunStarts
  signature: () int64
- file: internal/provider/watch.go
  kind: method
  name: Provider.RunWatch
  signature: (ctx context.Context) error
- file: internal/provider/provider.go
  kind: method
  name: Provider.TrustBundle
  signature: () []byte
- file: internal/provider/provider.go
  kind: interface
  name: Reader
  signature: interface Reader { Read; ReadRun; ListRuns; ReadPod; ReadJob; ReadTrigger;
    ReadEngine; ReadOpenBao; ReadWorkflowPod; ListWorkflowRuns }
- file: internal/provider/provider.go
  kind: method
  name: Reader.ListRuns
  signature: (ctx context.Context, logicalCluster string) ([]v1alpha1.DenoRun, error)
- file: internal/provider/provider.go
  kind: method
  name: Reader.ListWorkflowRuns
  signature: (ctx context.Context, logicalCluster string) ([]v1alpha1.PolicyWorkflowRun,
    error)
- file: internal/provider/provider.go
  kind: method
  name: Reader.Read
  signature: (ctx context.Context, ref Ref) (*v1alpha1.PolicyWorkflowRun, error)
- file: internal/provider/provider.go
  kind: method
  name: Reader.ReadEngine
  signature: (ctx context.Context, ref Ref) (*v1alpha1.PolicyEngine, error)
- file: internal/provider/provider.go
  kind: method
  name: Reader.ReadJob
  signature: (ctx context.Context, ref Ref) (*v1alpha1.DenoJob, error)
- file: internal/provider/provider.go
  kind: method
  name: Reader.ReadOpenBao
  signature: (ctx context.Context, ref Ref) (*v1alpha1.OpenBao, error)
- file: internal/provider/provider.go
  kind: method
  name: Reader.ReadPod
  signature: (ctx context.Context, ref Ref) (*v1alpha1.DenoPod, error)
- file: internal/provider/provider.go
  kind: method
  name: Reader.ReadRun
  signature: (ctx context.Context, ref Ref) (*v1alpha1.DenoRun, error)
- file: internal/provider/provider.go
  kind: method
  name: Reader.ReadTrigger
  signature: (ctx context.Context, ref Ref) (*v1alpha1.RunTrigger, error)
- file: internal/provider/provider.go
  kind: method
  name: Reader.ReadWorkflowPod
  signature: (ctx context.Context, ref Ref) (*v1alpha1.PolicyWorkflowPod, error)
- file: internal/provider/registry.go
  kind: struct
  name: Registry
  signature: struct Registry
- file: internal/provider/cluster_path.go
  kind: method
  name: Registry.ClusterPath
  signature: (ctx context.Context, id string) (string, error)
- file: internal/provider/registry_job.go
  kind: method
  name: Registry.CreateJob
  signature: (ctx context.Context, logicalCluster string, job *v1alpha1.DenoJob) error
- file: internal/provider/registry_pod.go
  kind: method
  name: Registry.CreatePod
  signature: (ctx context.Context, logicalCluster string, pod *v1alpha1.DenoPod) error
- file: internal/provider/registry_run.go
  kind: method
  name: Registry.CreateRun
  signature: (ctx context.Context, logicalCluster string, run *v1alpha1.DenoRun) error
- file: internal/provider/registry.go
  kind: method
  name: Registry.CreateWorkflowRun
  signature: (ctx context.Context, logicalCluster string, run *v1alpha1.PolicyWorkflowRun)
    error
- file: internal/provider/registry.go
  kind: method
  name: Registry.Delete
  signature: (ctx context.Context, ref Ref) error
- file: internal/provider/registry_engine.go
  kind: method
  name: Registry.DeleteEngine
  signature: (ctx context.Context, ref Ref) error
- file: internal/provider/registry_job.go
  kind: method
  name: Registry.DeleteJob
  signature: (ctx context.Context, ref Ref) error
- file: internal/provider/registry_openbao.go
  kind: method
  name: Registry.DeleteOpenBao
  signature: (ctx context.Context, ref Ref) error
- file: internal/provider/registry_pod.go
  kind: method
  name: Registry.DeletePod
  signature: (ctx context.Context, ref Ref) error
- file: internal/provider/registry_run.go
  kind: method
  name: Registry.DeleteRun
  signature: (ctx context.Context, ref Ref) error
- file: internal/provider/registry_workflowpod.go
  kind: method
  name: Registry.DeleteWorkflowPod
  signature: (ctx context.Context, ref Ref) error
- file: internal/provider/registry_openbao.go
  kind: method
  name: Registry.ListOpenBaos
  signature: (ctx context.Context, logicalCluster, namespace string) ([]v1alpha1.OpenBao,
    error)
- file: internal/provider/registry_run.go
  kind: method
  name: Registry.ListRuns
  signature: (ctx context.Context, logicalCluster string) ([]v1alpha1.DenoRun, error)
- file: internal/provider/registry.go
  kind: method
  name: Registry.ListWorkflowRuns
  signature: (ctx context.Context, logicalCluster string) ([]v1alpha1.PolicyWorkflowRun,
    error)
- file: internal/provider/registry_runtime.go
  kind: method
  name: Registry.MintServiceAccountToken
  signature: (ctx context.Context, logicalCluster, namespace, name string, ttl time.Duration)
    (string, error)
- file: internal/provider/registry.go
  kind: method
  name: Registry.Read
  signature: (ctx context.Context, ref Ref) (*v1alpha1.PolicyWorkflowRun, error)
- file: internal/provider/registry_engine.go
  kind: method
  name: Registry.ReadEngine
  signature: (ctx context.Context, ref Ref) (*v1alpha1.PolicyEngine, error)
- file: internal/provider/registry_job.go
  kind: method
  name: Registry.ReadJob
  signature: (ctx context.Context, ref Ref) (*v1alpha1.DenoJob, error)
- file: internal/provider/registry_openbao.go
  kind: method
  name: Registry.ReadOpenBao
  signature: (ctx context.Context, ref Ref) (*v1alpha1.OpenBao, error)
- file: internal/provider/registry_pod.go
  kind: method
  name: Registry.ReadPod
  signature: (ctx context.Context, ref Ref) (*v1alpha1.DenoPod, error)
- file: internal/provider/registry_run.go
  kind: method
  name: Registry.ReadRun
  signature: (ctx context.Context, ref Ref) (*v1alpha1.DenoRun, error)
- file: internal/provider/registry_trigger.go
  kind: method
  name: Registry.ReadTrigger
  signature: (ctx context.Context, ref Ref) (*v1alpha1.RunTrigger, error)
- file: internal/provider/registry_workflowpod.go
  kind: method
  name: Registry.ReadWorkflowPod
  signature: (ctx context.Context, ref Ref) (*v1alpha1.PolicyWorkflowPod, error)
- file: internal/provider/registry_engine.go
  kind: method
  name: Registry.RemoveEngineFinalizer
  signature: (ctx context.Context, ref Ref) error
- file: internal/provider/registry.go
  kind: method
  name: Registry.RemoveFinalizer
  signature: (ctx context.Context, ref Ref) error
- file: internal/provider/registry_openbao.go
  kind: method
  name: Registry.RemoveOpenBaoFinalizer
  signature: (ctx context.Context, ref Ref) error
- file: internal/provider/registry_pod.go
  kind: method
  name: Registry.RemovePodFinalizer
  signature: (ctx context.Context, ref Ref) error
- file: internal/provider/registry_run.go
  kind: method
  name: Registry.RemoveRunFinalizer
  signature: (ctx context.Context, ref Ref) error
- file: internal/provider/registry_run.go
  kind: method
  name: Registry.RemoveRunFinalizerKnown
  signature: (ctx context.Context, ref Ref, finalizers []string) error
- file: internal/provider/registry_engine.go
  kind: method
  name: Registry.WriteEngineStatus
  signature: (ctx context.Context, ref Ref, st v1alpha1.PolicyEngineStatus) error
- file: internal/provider/registry_job.go
  kind: method
  name: Registry.WriteJobStatus
  signature: (ctx context.Context, ref Ref, st v1alpha1.DenoJobStatus) error
- file: internal/provider/registry_openbao.go
  kind: method
  name: Registry.WriteOpenBaoFinalizer
  signature: (ctx context.Context, ref Ref, finalizers []string) error
- file: internal/provider/registry_openbao.go
  kind: method
  name: Registry.WriteOpenBaoStatus
  signature: (ctx context.Context, ref Ref, st v1alpha1.OpenBaoStatus) error
- file: internal/provider/registry_pod.go
  kind: method
  name: Registry.WritePodStatus
  signature: (ctx context.Context, ref Ref, st v1alpha1.DenoPodStatus) error
- file: internal/provider/registry_run.go
  kind: method
  name: Registry.WriteRunStatus
  signature: (ctx context.Context, ref Ref, st v1alpha1.DenoRunStatus) error
- file: internal/provider/registry.go
  kind: method
  name: Registry.WriteStatus
  signature: (ctx context.Context, ref Ref, st v1alpha1.PolicyWorkflowRunStatus) error
- file: internal/provider/registry_trigger.go
  kind: method
  name: Registry.WriteTriggerStatus
  signature: (ctx context.Context, ref Ref, st v1alpha1.RunTriggerStatus) error
- file: internal/provider/registry_workflowpod.go
  kind: method
  name: Registry.WriteWorkflowPodStatus
  signature: (ctx context.Context, ref Ref, st v1alpha1.PolicyWorkflowPodStatus) error
- file: internal/provider/registry.go
  kind: struct
  name: RegistryOptions
  signature: struct RegistryOptions
- file: internal/provider/provider_runtime.go
  kind: interface
  name: Runtime
  signature: interface Runtime { CreateRun; WriteRunStatus; DeleteRun; RemoveRunFinalizer;
    CreatePod; WritePodStatus; DeletePod; RemovePodFinalizer; CreateJob; WriteJobStatus;
    DeleteJob; WriteTriggerStatus; ListOpenBaos; WriteOpenBaoStatus; WriteOpenBaoFinalizer;
    RemoveOpenBaoFinalizer; DeleteOpenBao; WriteEngineStatus; DeleteEngine; RemoveEngineFinalizer;
    WriteWorkflowPodStatus; DeleteWorkflowPod; CreateWorkflowRun }
- file: internal/provider/provider_runtime.go
  kind: method
  name: Runtime.CreateJob
  signature: (ctx context.Context, logicalCluster string, job *v1alpha1.DenoJob) error
- file: internal/provider/provider_runtime.go
  kind: method
  name: Runtime.CreatePod
  signature: (ctx context.Context, logicalCluster string, pod *v1alpha1.DenoPod) error
- file: internal/provider/provider_runtime.go
  kind: method
  name: Runtime.CreateRun
  signature: (ctx context.Context, logicalCluster string, run *v1alpha1.DenoRun) error
- file: internal/provider/provider_runtime.go
  kind: method
  name: Runtime.CreateWorkflowRun
  signature: (ctx context.Context, logicalCluster string, run *v1alpha1.PolicyWorkflowRun)
    error
- file: internal/provider/provider_runtime.go
  kind: method
  name: Runtime.DeleteEngine
  signature: (ctx context.Context, ref Ref) error
- file: internal/provider/provider_runtime.go
  kind: method
  name: Runtime.DeleteJob
  signature: (ctx context.Context, ref Ref) error
- file: internal/provider/provider_runtime.go
  kind: method
  name: Runtime.DeleteOpenBao
  signature: (ctx context.Context, ref Ref) error
- file: internal/provider/provider_runtime.go
  kind: method
  name: Runtime.DeletePod
  signature: (ctx context.Context, ref Ref) error
- file: internal/provider/provider_runtime.go
  kind: method
  name: Runtime.DeleteRun
  signature: (ctx context.Context, ref Ref) error
- file: internal/provider/provider_runtime.go
  kind: method
  name: Runtime.DeleteWorkflowPod
  signature: (ctx context.Context, ref Ref) error
- file: internal/provider/provider_runtime.go
  kind: method
  name: Runtime.ListOpenBaos
  signature: (ctx context.Context, logicalCluster, namespace string) ([]v1alpha1.OpenBao,
    error)
- file: internal/provider/provider_runtime.go
  kind: method
  name: Runtime.RemoveEngineFinalizer
  signature: (ctx context.Context, ref Ref) error
- file: internal/provider/provider_runtime.go
  kind: method
  name: Runtime.RemoveOpenBaoFinalizer
  signature: (ctx context.Context, ref Ref) error
- file: internal/provider/provider_runtime.go
  kind: method
  name: Runtime.RemovePodFinalizer
  signature: (ctx context.Context, ref Ref) error
- file: internal/provider/provider_runtime.go
  kind: method
  name: Runtime.RemoveRunFinalizer
  signature: (ctx context.Context, ref Ref) error
- file: internal/provider/provider_runtime.go
  kind: method
  name: Runtime.WriteEngineStatus
  signature: (ctx context.Context, ref Ref, st v1alpha1.PolicyEngineStatus) error
- file: internal/provider/provider_runtime.go
  kind: method
  name: Runtime.WriteJobStatus
  signature: (ctx context.Context, ref Ref, st v1alpha1.DenoJobStatus) error
- file: internal/provider/provider_runtime.go
  kind: method
  name: Runtime.WriteOpenBaoFinalizer
  signature: (ctx context.Context, ref Ref, finalizers []string) error
- file: internal/provider/provider_runtime.go
  kind: method
  name: Runtime.WriteOpenBaoStatus
  signature: (ctx context.Context, ref Ref, st v1alpha1.OpenBaoStatus) error
- file: internal/provider/provider_runtime.go
  kind: method
  name: Runtime.WritePodStatus
  signature: (ctx context.Context, ref Ref, st v1alpha1.DenoPodStatus) error
- file: internal/provider/provider_runtime.go
  kind: method
  name: Runtime.WriteRunStatus
  signature: (ctx context.Context, ref Ref, st v1alpha1.DenoRunStatus) error
- file: internal/provider/provider_runtime.go
  kind: method
  name: Runtime.WriteTriggerStatus
  signature: (ctx context.Context, ref Ref, st v1alpha1.RunTriggerStatus) error
- file: internal/provider/provider_runtime.go
  kind: method
  name: Runtime.WriteWorkflowPodStatus
  signature: (ctx context.Context, ref Ref, st v1alpha1.PolicyWorkflowPodStatus) error
- file: internal/provider/provider_runtime.go
  kind: interface
  name: TokenMinter
  signature: interface TokenMinter { MintServiceAccountToken }
- file: internal/provider/provider_runtime.go
  kind: method
  name: TokenMinter.MintServiceAccountToken
  signature: (ctx context.Context, logicalCluster, namespace, name string, ttl time.Duration)
    (string, error)
- file: internal/provider/admission.go
  kind: struct
  name: admissionSource
  signature: struct admissionSource
- file: internal/provider/admission.go
  kind: method
  name: admissionSource.Capacity
  signature: (ctx context.Context, parent Ref) (queue.Capacity, *queue.Blocker, error)
- file: internal/provider/admission.go
  kind: method
  name: admissionSource.Parent
  signature: (ctx context.Context, run queue.Run) (Ref, bool, error)
- file: internal/provider/admission.go
  kind: method
  name: admissionSource.Runs
  signature: (ctx context.Context, parent Ref) ([]queue.Run, error)
- file: internal/provider/watch_cache.go
  kind: method
  name: cacheReader.ListRuns
  signature: (_ context.Context, logicalCluster string) ([]v1alpha1.DenoRun, error)
- file: internal/provider/watch_cache.go
  kind: method
  name: cacheReader.ListRunsForJob
  signature: (_ context.Context, logicalCluster, namespace, jobName string) ([]v1alpha1.DenoRun,
    error)
- file: internal/provider/watch_cache.go
  kind: method
  name: cacheReader.ListWorkflowRuns
  signature: (_ context.Context, logicalCluster string) ([]v1alpha1.PolicyWorkflowRun,
    error)
- file: internal/provider/watch_cache.go
  kind: method
  name: cacheReader.ListWorkflowRunsForPod
  signature: (_ context.Context, logicalCluster, namespace, podName string) ([]v1alpha1.PolicyWorkflowRun,
    error)
- file: internal/provider/watch_cache.go
  kind: method
  name: cacheReader.Read
  signature: (_ context.Context, ref Ref) (*v1alpha1.PolicyWorkflowRun, error)
- file: internal/provider/watch_cache.go
  kind: method
  name: cacheReader.ReadEngine
  signature: (_ context.Context, ref Ref) (*v1alpha1.PolicyEngine, error)
- file: internal/provider/watch_cache.go
  kind: method
  name: cacheReader.ReadJob
  signature: (_ context.Context, ref Ref) (*v1alpha1.DenoJob, error)
- file: internal/provider/watch_cache.go
  kind: method
  name: cacheReader.ReadOpenBao
  signature: (_ context.Context, ref Ref) (*v1alpha1.OpenBao, error)
- file: internal/provider/watch_cache.go
  kind: method
  name: cacheReader.ReadPod
  signature: (_ context.Context, ref Ref) (*v1alpha1.DenoPod, error)
- file: internal/provider/watch_cache.go
  kind: method
  name: cacheReader.ReadRun
  signature: (_ context.Context, ref Ref) (*v1alpha1.DenoRun, error)
- file: internal/provider/watch_cache.go
  kind: method
  name: cacheReader.ReadTrigger
  signature: (_ context.Context, ref Ref) (*v1alpha1.RunTrigger, error)
- file: internal/provider/watch_cache.go
  kind: method
  name: cacheReader.ReadWorkflowPod
  signature: (_ context.Context, ref Ref) (*v1alpha1.PolicyWorkflowPod, error)
- file: internal/provider/provider.go
  kind: method
  name: jobRunLister.ListRunsForJob
  signature: (ctx context.Context, logicalCluster, namespace, jobName string) ([]v1alpha1.DenoRun,
    error)
- file: internal/provider/provider.go
  kind: method
  name: podWorkflowRunLister.ListWorkflowRunsForPod
  signature: (ctx context.Context, logicalCluster, namespace, podName string) ([]v1alpha1.PolicyWorkflowRun,
    error)
- file: internal/provider/reconcile_run.go
  kind: method
  name: runFinalizerRemover.RemoveRunFinalizerKnown
  signature: (ctx context.Context, ref Ref, finalizers []string) error
- file: internal/provider/metrics.go
  kind: interface
  name: summaryObserver
  signature: interface summaryObserver { Observe }
- file: internal/provider/metrics.go
  kind: method
  name: summaryObserver.Observe
  signature: (float64)
requirements:
- codeRefs:
  - file:internal/provider/admission.go
  - method:a07bdbb2bda3bec3a983caa0cbe3f545
  id: r.admission-default-policy-forbid
  level: MUST
  text: Capacity must default the concurrency policy to v1alpha1.ConcurrencyForbid
    when the pod sets none, and must return a blocker with ReasonPolicyWorkflowPodMissing
    when the pod is absent and ReasonEngineNotReady when its endpoint is empty.
- codeRefs:
  - file:internal/provider/admission.go
  - method:a07bdbb2bda3bec3a983caa0cbe3f545
  - method:dedfd34a67b569d3bd5df1bbfd2d518e
  - method:ea874e105ac66c1a2a0d988371fa3509
  id: r.admission-source-gates-runs
  level: MUST
  text: 'admissionSource must answer the queue library: Parent maps a run to its policy
    workflow pod by name, Runs lists the labelled runs of that parent, and Capacity
    reports the concurrency policy and maximum concurrent runs.'
- codeRefs:
  - file:internal/provider/admission.go
  - method:ea874e105ac66c1a2a0d988371fa3509
  id: r.admission-unlabelled-run-still-gated
  level: SHOULD
  text: Runs lists only the labelled runs, so a run naming the pod through spec.policyWorkflowPod
    alone is appended by the admitter and admitted rather than passed through un-gated.
- codeRefs:
  - file:internal/provider/provider.go
  - interface:79e02cbf716ad7f732147264ef6ffc96
  - method:6991aa64677e82d8faedb257a0a4dac9
  - method:7177e5fd2c4cb312cc5bffedc7bb8225
  - method:770a1f486fcb2d924b16f1423b6a6f45
  - method:dbb9820bfd360e31ac1295c45d8f0cd5
  id: r.instances-port-for-workflow-runs
  level: MUST
  text: The Instances interface must expose Read, WriteStatus, Delete and RemoveFinalizer
    for PolicyWorkflowRun objects.
- codeRefs:
  - file:internal/provider/admission_test.go
  - file:internal/provider/live_denojob_drain_test.go
  - file:internal/provider/live_denoruntime_test.go
  - file:internal/provider/live_helpers_test.go
  - file:internal/provider/live_maxconcurrent_test.go
  - file:internal/provider/live_native_admission_test.go
  - file:internal/provider/live_ttl_test.go
  - file:internal/provider/metrics_test.go
  - file:internal/provider/registry_test.go
  - file:internal/provider/run_refs_test.go
  - file:internal/provider/watch_test.go
  id: r.live-tests-cover-behaviour
  level: SHOULD
  text: Live integration tests must cover TTL, max concurrency, native admission,
    Deno job drain and Deno runtime behaviour against a real cluster, alongside unit
    tests for registry, admission, watch, run refs, openbao reconcile, provider runtime
    and metrics.
- codeRefs:
  - file:internal/provider/metrics.go
  - method:783d67229120389163d8738cc3d1a3ec
  id: r.metrics-observed
  level: MUST
  text: The provider records reconcile duration into a summaryObserver and increments
    the error counter on failure.
- codeRefs:
  - file:internal/provider/provider.go
  - method:2493a2c710828f8b4fe3808ad1408907
  - method:40c76b6ba2cb4f1a4bf8529657373b18
  id: r.pod-run-lookup-helpers
  level: MUST
  text: jobRunLister.ListRunsForJob and podWorkflowRunLister.ListWorkflowRunsForPod
    must list the runs belonging to a job or pod within a logical cluster and namespace.
- codeRefs:
  - file:internal/provider/provider.go
  - function:f4e5cfdbb89305e5310f8800b3c5e307
  - struct:616ab943fe3365809df93a906c1942bc
  - struct:cd6145b620673d1d890a45c3b08eaaf5
  - struct:d27a8fecd6ae256e43a6e3e8a3089705
  id: r.provider-constructed-from-options
  level: MUST
  text: New builds a Provider from Options and returns an error when the options are
    unusable; Options, Provider and Pass are the exported structs of the package.
- codeRefs:
  - file:internal/provider/provider.go
  - method:83f50090d7ebe3148f7aa5e0db332b4d
  - method:bedc23e806b40419ad4ae31c624ffdf9
  id: r.provider-runs-reconcile-loop
  level: MUST
  text: Provider.Run drives the reconcile loop until the context is done, and Provider.Reconcile
    returns a Pass together with an error for one Ref; Provider.Reconciles reports
    the total count and Provider.Close releases the underlying clients.
- codeRefs:
  - file:internal/provider/provider.go
  - interface:4823d030f55cc3629f5f52b93b924b77
  - method:17d9aa5639d88e18ced092858a5abe2c
  - method:212b93b0660339a29ad743c47c0a2f5c
  - method:2fd4bea770ce6a63d90f4daec420b54e
  - method:307b5bfc55c641acbb8ada3045f9d25c
  - method:41cf2306d6452e1d718d6ef94ff97566
  - method:478c272d9a449a55c6ed18fadd0618d4
  - method:990b41bd5a2ffe1389dc5d05ce1da085
  - method:d08efa306908e97a03fc66d8df7d9706
  - method:d176f51800814ad517e2c40e2c2e0ee7
  - method:db20977428ee57d0ef1f56f51ca0243e
  id: r.reader-port-covers-all-kinds
  level: MUST
  text: 'The Reader interface must expose a read method per custom resource kind plus
    the two list operations: Read, ReadRun, ListRuns, ReadPod, ReadJob, ReadTrigger,
    ReadEngine, ReadOpenBao, ReadWorkflowPod and ListWorkflowRuns.'
- codeRefs:
  - file:internal/provider/reconcile_engine.go
  - file:internal/provider/reconcile_job.go
  - file:internal/provider/reconcile_openbao.go
  - file:internal/provider/reconcile_pod.go
  - file:internal/provider/reconcile_run.go
  - file:internal/provider/reconcile_trigger.go
  - file:internal/provider/reconcile_workflowpod.go
  id: r.reconcile-per-kind
  level: MUST
  text: 'Each custom resource kind has its own reconcile file: run, job, pod, engine,
    openbao, trigger and workflowpod, driven by the shared reconcile engine.'
- codeRefs:
  - file:internal/provider/cluster_path.go
  - method:1711073a6a2c66ef8dbc0850814be58e
  id: r.registry-resolves-cluster-path
  level: MUST
  text: Registry.ClusterPath must resolve a logical cluster identifier to its kubeconfig
    or cluster path string and return an error when it cannot.
- codeRefs:
  - file:internal/provider/registry.go
  - file:internal/provider/registry_engine.go
  - file:internal/provider/registry_job.go
  - file:internal/provider/registry_openbao.go
  - file:internal/provider/registry_pod.go
  - file:internal/provider/registry_run.go
  - file:internal/provider/registry_runtime.go
  - file:internal/provider/registry_trigger.go
  - file:internal/provider/registry_workflowpod.go
  - function:d8299700880b325d38c3aa20aa84ac24
  - struct:01896200f64256e833b4818f731d0300
  - struct:eafb527137f9ed90cec30417e467987b
  id: r.registry-satisfies-ports
  level: MUST
  text: Registry must satisfy Reader, Instances, Runtime and TokenMinter for every
    custom resource kind, and NewRegistry builds it from RegistryOptions.
- codeRefs:
  - file:internal/provider/registry_run.go
  - method:0336e9c05327f7b15cb6ddb11d9ecda3
  - method:23fc06d135fb3a4b8a0273710865368f
  - method:4ca472be4f4fd37e73d3fb239a03dbec
  - method:73dfeb14f71c1a7d5e2ee751c233cbf1
  - method:9c58b2e5cdc887157dd853e80e10a086
  - method:b57ea92a3ea6bd92ab5c167ae09dbd8e
  - method:d01339d025223140bb9535dcbac67476
  - method:d362b34ab599ab6e512bda32f222f3e6
  id: r.registry-workflow-run-operations
  level: MUST
  text: Registry must implement Read, WriteStatus, Delete, RemoveFinalizer, CreateWorkflowRun
    and ListWorkflowRuns for PolicyWorkflowRun, and RemoveRunFinalizerKnown must remove
    only the named finalizers.
- codeRefs:
  - file:internal/provider/run_refs.go
  - method:2188f1b23ffddba57fd070190f3dfab1
  - method:23233a41823fe7b5628f032a2767752f
  - method:a6a75598b35908e08153f182c3febf00
  id: r.run-gauges-exposed
  level: SHOULD
  text: Provider exposes ActiveRuns, MaxActiveRuns and RunStarts counters for run
    admission accounting.
- codeRefs:
  - file:internal/provider/provider_runtime.go
  - interface:c7e3ce30c0c4b864a4256ae1255ecf6f
  - method:04c9c12ef6ee491671f3ef14f8486cee
  - method:0a1baf118dfd1184e6e20c9bc6c2149d
  - method:0f7acc2d0feaf48c63fed92350649ba4
  - method:6105d5fa8fec2e32966496e6bf32e4b3
  - method:8acde20985786551e6319db9f3851eb0
  - method:8ccafd0b3f41743e3ad8ab9b9c96bae0
  - method:aacfccc54b2b56d00fcf7852988d658c
  - method:b27c6b3d66fe2bf13cb22e4df562eac1
  - method:d43625922ebf891922c49f440fefca1e
  - method:d49d27ff9e2c256263815edfc2d08750
  - method:ea1c6b0ecc9e6f6856824a87e673b682
  id: r.runtime-port-writes-every-kind
  level: MUST
  text: The Runtime interface must expose create, status-write, delete and finalizer
    operations for runs, pods, jobs, triggers, openbaos, engines and workflow pods,
    including WriteOpenBaoFinalizer, and CreateWorkflowRun.
- codeRefs:
  - file:internal/provider/service_dns.go
  - file:internal/provider/service_dns_inject_test.go
  id: r.service-dns-injection
  level: MUST
  text: The provider must inject service DNS configuration into workloads, with tests
    asserting the injected values.
- codeRefs:
  - file:internal/provider/provider_runtime.go
  - interface:d81c0020017b8c1b77c14748b34a1695
  - method:08cbdd1a97d2aeb9d9187918def0a3ff
  - method:9630ebc295fc1d2ed8be58298913156a
  id: r.token-minter-mints-service-account-token
  level: MUST
  text: TokenMinter must mint a service-account token for a logical cluster, namespace
    and name with a requested TTL, returning the token string and an error.
- codeRefs:
  - file:internal/provider/watch.go
  - file:internal/provider/watch_cache.go
  - method:0c338b727be3207f28cbf878427e832a
  - method:233229f09be3f2275ac69f207bb6268b
  - method:3fdfde3c1a480d83c360edc8c048bc7b
  - method:f34958b11727b06606bdafed3381d854
  - method:fec4d29b214cd73931b1d89410112759
  id: r.watch-cache-serves-reader
  level: MUST
  text: cacheReader must implement the Reader port from the informer cache, providing
    Read, ReadRun, ListRuns, ListRunsForJob, ReadPod, ReadJob, ReadTrigger, ReadOpenBao,
    ReadEngine, ReadWorkflowPod, ListWorkflowRuns and ListWorkflowRunsForPod, and
    Provider.RunWatch must drive it.
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

_None yet._
<!-- SPECD_MANAGED_END -->
