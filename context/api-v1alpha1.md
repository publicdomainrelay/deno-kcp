# Context: api-v1alpha1

Repository: `deno-kcp`

This context exists so the operator can persist and reconcile deno-kcp custom resources through the Kubernetes API machinery. The package defines the on-cluster schema (specs, statuses, phase enums), the list types the informers and clientsets need, the kubebuilder deep-copy implementations that keep informer caches free of aliasing bugs, and the bridge that turns the CRD-shaped DenoPermissions and ServiceAccountRef into the denospec types the runtime layer consumes. It is the shared vocabulary between the controllers, the provider registry and the denospec execution library.

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
interfaces:
- file: api/v1alpha1/types_shared.go
  kind: type_alias
  name: ConcurrencyPolicy
  signature: ()
- file: api/v1alpha1/types_denojob.go
  kind: struct
  name: DenoJob
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: DenoJob.DeepCopy
  signature: () *DenoJob
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: DenoJob.DeepCopyInto
  signature: (out *DenoJob)
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: DenoJob.DeepCopyObject
  signature: () runtime.Object
- file: api/v1alpha1/types_denojob.go
  kind: struct
  name: DenoJobList
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: DenoJobList.DeepCopy
  signature: () *DenoJobList
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: DenoJobList.DeepCopyInto
  signature: (out *DenoJobList)
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: DenoJobList.DeepCopyObject
  signature: () runtime.Object
- file: api/v1alpha1/types_denojob.go
  kind: type_alias
  name: DenoJobPhase
  signature: ()
- file: api/v1alpha1/types_denojob.go
  kind: struct
  name: DenoJobSpec
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: DenoJobSpec.DeepCopyInto
  signature: (out *DenoJobSpec)
- file: api/v1alpha1/types_denojob.go
  kind: struct
  name: DenoJobStatus
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: DenoJobStatus.DeepCopyInto
  signature: (out *DenoJobStatus)
- file: api/v1alpha1/types_shared.go
  kind: struct
  name: DenoPermission
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: DenoPermission.DeepCopyInto
  signature: (out *DenoPermission)
- file: api/v1alpha1/types_shared.go
  kind: struct
  name: DenoPermissions
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: DenoPermissions.DeepCopyInto
  signature: (out *DenoPermissions)
- file: api/v1alpha1/denospec.go
  kind: method
  name: DenoPermissions.DenoSpec
  signature: () *denospec.Permissions
- file: api/v1alpha1/types_denopod.go
  kind: struct
  name: DenoPod
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: DenoPod.DeepCopy
  signature: () *DenoPod
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: DenoPod.DeepCopyInto
  signature: (out *DenoPod)
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: DenoPod.DeepCopyObject
  signature: () runtime.Object
- file: api/v1alpha1/types_denopod.go
  kind: struct
  name: DenoPodList
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: DenoPodList.DeepCopy
  signature: () *DenoPodList
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: DenoPodList.DeepCopyInto
  signature: (out *DenoPodList)
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: DenoPodList.DeepCopyObject
  signature: () runtime.Object
- file: api/v1alpha1/types_denopod.go
  kind: type_alias
  name: DenoPodPhase
  signature: ()
- file: api/v1alpha1/types_denopod.go
  kind: struct
  name: DenoPodSpec
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: DenoPodSpec.DeepCopyInto
  signature: (out *DenoPodSpec)
- file: api/v1alpha1/types_denopod.go
  kind: struct
  name: DenoPodStatus
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: DenoPodStatus.DeepCopyInto
  signature: (out *DenoPodStatus)
- file: api/v1alpha1/types_shared.go
  kind: struct
  name: DenoPodTemplate
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: DenoPodTemplate.DeepCopyInto
  signature: (out *DenoPodTemplate)
- file: api/v1alpha1/types_shared.go
  kind: type_alias
  name: DenoRestartPolicy
  signature: ()
- file: api/v1alpha1/types_denorun.go
  kind: struct
  name: DenoRun
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: DenoRun.DeepCopy
  signature: () *DenoRun
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: DenoRun.DeepCopyInto
  signature: (out *DenoRun)
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: DenoRun.DeepCopyObject
  signature: () runtime.Object
- file: api/v1alpha1/types_denorun.go
  kind: struct
  name: DenoRunList
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: DenoRunList.DeepCopy
  signature: () *DenoRunList
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: DenoRunList.DeepCopyInto
  signature: (out *DenoRunList)
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: DenoRunList.DeepCopyObject
  signature: () runtime.Object
- file: api/v1alpha1/types_denorun.go
  kind: type_alias
  name: DenoRunPhase
  signature: ()
- file: api/v1alpha1/types_denorun.go
  kind: struct
  name: DenoRunSpec
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: DenoRunSpec.DeepCopyInto
  signature: (out *DenoRunSpec)
- file: api/v1alpha1/types_denorun.go
  kind: struct
  name: DenoRunStatus
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: DenoRunStatus.DeepCopyInto
  signature: (out *DenoRunStatus)
- file: api/v1alpha1/types_shared.go
  kind: struct
  name: ExecProbe
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: ExecProbe.DeepCopyInto
  signature: (out *ExecProbe)
- file: api/v1alpha1/types_openbao.go
  kind: struct
  name: OpenBao
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: OpenBao.DeepCopy
  signature: () *OpenBao
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: OpenBao.DeepCopyInto
  signature: (out *OpenBao)
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: OpenBao.DeepCopyObject
  signature: () runtime.Object
- file: api/v1alpha1/types_openbao.go
  kind: struct
  name: OpenBaoList
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: OpenBaoList.DeepCopy
  signature: () *OpenBaoList
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: OpenBaoList.DeepCopyInto
  signature: (out *OpenBaoList)
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: OpenBaoList.DeepCopyObject
  signature: () runtime.Object
- file: api/v1alpha1/types_openbao.go
  kind: struct
  name: OpenBaoSpec
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: OpenBaoSpec.DeepCopy
  signature: () *OpenBaoSpec
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: OpenBaoSpec.DeepCopyInto
  signature: (out *OpenBaoSpec)
- file: api/v1alpha1/types_openbao.go
  kind: struct
  name: OpenBaoStatus
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: OpenBaoStatus.DeepCopy
  signature: () *OpenBaoStatus
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: OpenBaoStatus.DeepCopyInto
  signature: (out *OpenBaoStatus)
- file: api/v1alpha1/types_policyengine.go
  kind: struct
  name: PolicyEngine
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: PolicyEngine.DeepCopy
  signature: () *PolicyEngine
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: PolicyEngine.DeepCopyInto
  signature: (out *PolicyEngine)
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: PolicyEngine.DeepCopyObject
  signature: () runtime.Object
- file: api/v1alpha1/types_policyengine.go
  kind: struct
  name: PolicyEngineList
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: PolicyEngineList.DeepCopy
  signature: () *PolicyEngineList
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: PolicyEngineList.DeepCopyInto
  signature: (out *PolicyEngineList)
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: PolicyEngineList.DeepCopyObject
  signature: () runtime.Object
- file: api/v1alpha1/types_policyengine.go
  kind: type_alias
  name: PolicyEnginePhase
  signature: ()
- file: api/v1alpha1/types_policyengine.go
  kind: struct
  name: PolicyEngineSpec
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: PolicyEngineSpec.DeepCopyInto
  signature: (out *PolicyEngineSpec)
- file: api/v1alpha1/types_policyengine.go
  kind: struct
  name: PolicyEngineStatus
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: PolicyEngineStatus.DeepCopyInto
  signature: (out *PolicyEngineStatus)
- file: api/v1alpha1/types_policyworkflowrun.go
  kind: type_alias
  name: PolicyWorkflowPhase
  signature: ()
- file: api/v1alpha1/types_policyworkflowpod.go
  kind: struct
  name: PolicyWorkflowPod
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: PolicyWorkflowPod.DeepCopy
  signature: () *PolicyWorkflowPod
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: PolicyWorkflowPod.DeepCopyInto
  signature: (out *PolicyWorkflowPod)
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: PolicyWorkflowPod.DeepCopyObject
  signature: () runtime.Object
- file: api/v1alpha1/types_policyworkflowpod.go
  kind: struct
  name: PolicyWorkflowPodList
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: PolicyWorkflowPodList.DeepCopy
  signature: () *PolicyWorkflowPodList
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: PolicyWorkflowPodList.DeepCopyInto
  signature: (out *PolicyWorkflowPodList)
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: PolicyWorkflowPodList.DeepCopyObject
  signature: () runtime.Object
- file: api/v1alpha1/types_policyworkflowpod.go
  kind: type_alias
  name: PolicyWorkflowPodPhase
  signature: ()
- file: api/v1alpha1/types_policyworkflowpod.go
  kind: struct
  name: PolicyWorkflowPodSpec
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: PolicyWorkflowPodSpec.DeepCopyInto
  signature: (out *PolicyWorkflowPodSpec)
- file: api/v1alpha1/types_policyworkflowpod.go
  kind: struct
  name: PolicyWorkflowPodStatus
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: PolicyWorkflowPodStatus.DeepCopyInto
  signature: (out *PolicyWorkflowPodStatus)
- file: api/v1alpha1/types_policyworkflowrun.go
  kind: struct
  name: PolicyWorkflowRun
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: PolicyWorkflowRun.DeepCopy
  signature: () *PolicyWorkflowRun
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: PolicyWorkflowRun.DeepCopyInto
  signature: (out *PolicyWorkflowRun)
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: PolicyWorkflowRun.DeepCopyObject
  signature: () runtime.Object
- file: api/v1alpha1/types_policyworkflowrun.go
  kind: struct
  name: PolicyWorkflowRunList
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: PolicyWorkflowRunList.DeepCopy
  signature: () *PolicyWorkflowRunList
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: PolicyWorkflowRunList.DeepCopyInto
  signature: (out *PolicyWorkflowRunList)
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: PolicyWorkflowRunList.DeepCopyObject
  signature: () runtime.Object
- file: api/v1alpha1/types_policyworkflowrun.go
  kind: struct
  name: PolicyWorkflowRunSpec
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: PolicyWorkflowRunSpec.DeepCopyInto
  signature: (out *PolicyWorkflowRunSpec)
- file: api/v1alpha1/types_policyworkflowrun.go
  kind: struct
  name: PolicyWorkflowRunStatus
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: PolicyWorkflowRunStatus.DeepCopyInto
  signature: (out *PolicyWorkflowRunStatus)
- file: api/v1alpha1/types_runtrigger.go
  kind: struct
  name: RunTrigger
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: RunTrigger.DeepCopy
  signature: () *RunTrigger
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: RunTrigger.DeepCopyInto
  signature: (out *RunTrigger)
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: RunTrigger.DeepCopyObject
  signature: () runtime.Object
- file: api/v1alpha1/types_runtrigger.go
  kind: struct
  name: RunTriggerList
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: RunTriggerList.DeepCopy
  signature: () *RunTriggerList
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: RunTriggerList.DeepCopyInto
  signature: (out *RunTriggerList)
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: RunTriggerList.DeepCopyObject
  signature: () runtime.Object
- file: api/v1alpha1/types_runtrigger.go
  kind: type_alias
  name: RunTriggerPhase
  signature: ()
- file: api/v1alpha1/types_runtrigger.go
  kind: struct
  name: RunTriggerSpec
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: RunTriggerSpec.DeepCopyInto
  signature: (out *RunTriggerSpec)
- file: api/v1alpha1/types_runtrigger.go
  kind: struct
  name: RunTriggerStatus
  signature: ()
- file: api/v1alpha1/zz_generated.deepcopy.go
  kind: method
  name: RunTriggerStatus.DeepCopyInto
  signature: (out *RunTriggerStatus)
- file: api/v1alpha1/types_shared.go
  kind: struct
  name: ServiceAccountRef
  signature: ()
- file: api/v1alpha1/denospec.go
  kind: method
  name: ServiceAccountRef.DenoSpec
  signature: () *denospec.ServiceAccountRef
requirements:
- codeRefs:
  - file:api/v1alpha1/zz_generated.deepcopy.go
  id: r.deepcopy-for-every-type
  level: MUST
  text: Every API type has generated DeepCopyInto and DeepCopy methods so handlers
    and caches never share backing arrays or maps.
- codeRefs:
  - file:api/v1alpha1/deno_types_test.go
  - method:28449716ad97a01ee9ad4a4ede89f392
  id: r.deepcopy-no-aliasing
  level: MUST
  text: Deep copy of a kind with slices such as DenoJob must not alias the source
    slices, verified by TestDenoJobDeepCopyDoesNotAlias.
- codeRefs:
  - method:14ac68953d812f04afeefde4c03d0b12
  - method:19cedd9072bab383a6d03e1c2ca6f96e
  - method:1d9fcdc42679a9919592e4c28a3e74f8
  - method:3178bd6762b6a7343a330a5804f732f4
  - method:40a4bbe7776080bc239b955a5ec3c5ca
  - method:97a18054cf35b3ba841a31198ca24b02
  - method:a4967ab3a26c061c8378b3d92104b613
  - method:b8e83f017166d220cee8c04269e072c7
  id: r.deepcopy-object-for-roots-and-lists
  level: MUST
  text: Every root kind and its List type implement DeepCopyObject returning runtime.Object
    so they satisfy runtime.Object for the scheme and client code.
- codeRefs:
  - method:0dd42034ce69416d2233ce9e55bb6d3d
  - method:4853a11212ee93729970106d66fe9a6c
  id: r.deno-permissions-conversion
  level: MUST
  text: DenoPermissions.DenoSpec converts the CRD permission block into the denospec.Permissions
    struct, mapping every permission field, and returns nil for a nil receiver.
- codeRefs:
  - file:api/v1alpha1/deno_types_test.go
  - file:api/v1alpha1/types_test.go
  id: r.deno-spec-contract-tests
  level: SHOULD
  text: Type behaviour and deep-copy invariants stay covered by the package tests
    in types_test.go and deno_types_test.go.
- codeRefs:
  - file:api/v1alpha1/groupversion_info.go
  id: r.group-version-registration
  level: MUST
  text: The v1alpha1 group-version registers every custom kind plus its list type
    with the scheme so clients and informers can decode them.
- codeRefs:
  - file:api/v1alpha1/types_denojob.go
  - file:api/v1alpha1/types_denopod.go
  - file:api/v1alpha1/types_denorun.go
  - file:api/v1alpha1/types_openbao.go
  - file:api/v1alpha1/types_policyengine.go
  - file:api/v1alpha1/types_policyworkflowpod.go
  - file:api/v1alpha1/types_policyworkflowrun.go
  - file:api/v1alpha1/types_runtrigger.go
  id: r.kind-root-list-spec-status
  level: MUST
  text: Each custom kind (DenoPod, DenoRun, DenoJob, RunTrigger, PolicyEngine, PolicyWorkflowPod,
    PolicyWorkflowRun, OpenBao) has a root type, a matching List type, a Spec and
    a Status struct.
- codeRefs:
  - type_alias:0e2883e159e4826141f3b8dbf5a8951d
  - type_alias:3228acbcc876296a83b038db20f5ba53
  - type_alias:71e9ec98b426f5ba2a6f0fa861505f90
  - type_alias:95711bd9c109c1c963d90415abeb221a
  - type_alias:b301d0b47a8b87747f72eb4dd29c1213
  - type_alias:cb7db6e321bd704e6960895aa2922ada
  - type_alias:f1812e2547cdacd2b9d3b0c4591ef2e2
  id: r.phase-enums
  level: MUST
  text: 'Every reconcilable kind exposes a phase string alias describing its lifecycle
    states: DenoPodPhase, DenoRunPhase, DenoJobPhase, RunTriggerPhase, PolicyEnginePhase,
    PolicyWorkflowPodPhase and PolicyWorkflowPhase.'
- codeRefs:
  - method:3846c936f898af39cc3e185598df8409
  - struct:05cdd79e23617fbecdb398d34c9d5ad7
  id: r.service-account-ref-conversion
  level: MUST
  text: ServiceAccountRef.DenoSpec converts the CRD service-account reference into
    denospec.ServiceAccountRef, copying name and namespace, and returns nil for a
    nil receiver.
- codeRefs:
  - file:api/v1alpha1/types_shared.go
  - struct:05cdd79e23617fbecdb398d34c9d5ad7
  - struct:a6b2c82ee80cb3d8639351da73b016d6
  - struct:b1b033afbaf6fab9e420675da77463a6
  - struct:da40f37a9ba38a5f2a353dd41f480892
  - struct:e95b0c824023d610cd8dd79e9b10330c
  - type_alias:f1737f67a27a8469e8d83ac7bc87a249
  - type_alias:f821022f3e38a5407c14bb767eba914b
  id: r.shared-spec-building-blocks
  level: MUST
  text: Shared types ServiceAccountRef, DenoPermission, DenoPermissions, DenoPodTemplate,
    ExecProbe, DenoRestartPolicy and ConcurrencyPolicy carry the reusable pod, permission
    and probe configuration used across the kinds.
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:api/v1alpha1/deno_types_test.go` file deno_types_test.go (api/v1alpha1/deno_types_test.go)
- `file:api/v1alpha1/denospec.go` file denospec.go (api/v1alpha1/denospec.go)
- `file:api/v1alpha1/groupversion_info.go` file groupversion_info.go (api/v1alpha1/groupversion_info.go)
- `file:api/v1alpha1/types_denojob.go` file types_denojob.go (api/v1alpha1/types_denojob.go)
- `file:api/v1alpha1/types_denopod.go` file types_denopod.go (api/v1alpha1/types_denopod.go)
- `file:api/v1alpha1/types_denorun.go` file types_denorun.go (api/v1alpha1/types_denorun.go)
- `file:api/v1alpha1/types_openbao.go` file types_openbao.go (api/v1alpha1/types_openbao.go)
- `file:api/v1alpha1/types_policyengine.go` file types_policyengine.go (api/v1alpha1/types_policyengine.go)
- `file:api/v1alpha1/types_policyworkflowpod.go` file types_policyworkflowpod.go (api/v1alpha1/types_policyworkflowpod.go)
- `file:api/v1alpha1/types_policyworkflowrun.go` file types_policyworkflowrun.go (api/v1alpha1/types_policyworkflowrun.go)
- `file:api/v1alpha1/types_runtrigger.go` file types_runtrigger.go (api/v1alpha1/types_runtrigger.go)
- `file:api/v1alpha1/types_shared.go` file types_shared.go (api/v1alpha1/types_shared.go)
- `file:api/v1alpha1/types_test.go` file types_test.go (api/v1alpha1/types_test.go)
- `file:api/v1alpha1/zz_generated.deepcopy.go` file zz_generated.deepcopy.go (api/v1alpha1/zz_generated.deepcopy.go)
- `method:0345f4946d456a5c94dd469e079dad10` method PolicyEngineSpec.DeepCopyInto (api/v1alpha1/zz_generated.deepcopy.go)
- `method:03af75d3cbe4b1b3aa212b36c7adff04` method PolicyWorkflowRun.DeepCopyInto (api/v1alpha1/zz_generated.deepcopy.go)
- `method:0b032c818bab5f9539291427480079e3` method PolicyWorkflowPodSpec.DeepCopyInto (api/v1alpha1/zz_generated.deepcopy.go)
- `method:0b304a7a720eb1c3dd56bf3bfc6b3f46` method PolicyEngine.DeepCopy (api/v1alpha1/zz_generated.deepcopy.go)
- `method:0dd42034ce69416d2233ce9e55bb6d3d` method DenoPermissions.DeepCopyInto (api/v1alpha1/zz_generated.deepcopy.go)
- `method:14ac68953d812f04afeefde4c03d0b12` method PolicyWorkflowRun.DeepCopyObject (api/v1alpha1/zz_generated.deepcopy.go)
- `method:198a862c212cb7ddc7ba0eb9c55d0cb4` method OpenBaoStatus.DeepCopyInto (api/v1alpha1/zz_generated.deepcopy.go)
- `method:19cedd9072bab383a6d03e1c2ca6f96e` method PolicyWorkflowRunList.DeepCopyObject (api/v1alpha1/zz_generated.deepcopy.go)
- `method:1a1a205f49f7ea00432a4728d42dc1ab` method ExecProbe.DeepCopyInto (api/v1alpha1/zz_generated.deepcopy.go)
- `method:1cb6af15baaa9e67ab642742b2b11f6d` method DenoJob.DeepCopy (api/v1alpha1/zz_generated.deepcopy.go)
- `method:1d9fcdc42679a9919592e4c28a3e74f8` method DenoPod.DeepCopyObject (api/v1alpha1/zz_generated.deepcopy.go)
- `method:201b872bb86931ae26b0e5f135254adb` method DenoPod.DeepCopy (api/v1alpha1/zz_generated.deepcopy.go)
- `method:28449716ad97a01ee9ad4a4ede89f392` method DenoJob.DeepCopyInto (api/v1alpha1/zz_generated.deepcopy.go)
- `method:2bc89267361d395f7823ae189837a9e1` method RunTriggerStatus.DeepCopyInto (api/v1alpha1/zz_generated.deepcopy.go)
- `method:2c7b3d44ca49d24b8bff773d8444ca4c` method PolicyEngine.DeepCopyInto (api/v1alpha1/zz_generated.deepcopy.go)
- `method:3178bd6762b6a7343a330a5804f732f4` method RunTrigger.DeepCopyObject (api/v1alpha1/zz_generated.deepcopy.go)
- `method:3310f43abe770170ed7fb18b51bc5cfb` method DenoRunStatus.DeepCopyInto (api/v1alpha1/zz_generated.deepcopy.go)
- `method:3846c936f898af39cc3e185598df8409` method ServiceAccountRef.DenoSpec (api/v1alpha1/denospec.go)
- `method:3a2846e252b5e30d39063b2a642545a5` method DenoJobList.DeepCopy (api/v1alpha1/zz_generated.deepcopy.go)
- `method:40a4bbe7776080bc239b955a5ec3c5ca` method DenoJob.DeepCopyObject (api/v1alpha1/zz_generated.deepcopy.go)
- `method:4446482ff01f3a844b1034f181f380a3` method DenoPod.DeepCopyInto (api/v1alpha1/zz_generated.deepcopy.go)
- `method:44a16bb9a05139fda7e596ed2db8b31e` method RunTriggerSpec.DeepCopyInto (api/v1alpha1/zz_generated.deepcopy.go)
- `method:45b7b56af049883c186c6cafc626bd95` method DenoRunList.DeepCopy (api/v1alpha1/zz_generated.deepcopy.go)
- `method:4853a11212ee93729970106d66fe9a6c` method DenoPermissions.DenoSpec (api/v1alpha1/denospec.go)
- `method:49c0dd404c1cc5aeda630e09da5fd449` method PolicyEngineList.DeepCopy (api/v1alpha1/zz_generated.deepcopy.go)
- `method:5a2a1452f27699544c05d498b2a7d1cc` method OpenBaoList.DeepCopyInto (api/v1alpha1/zz_generated.deepcopy.go)
- `method:5ded402e72d1e1351b58b672fd70a148` method DenoRun.DeepCopyInto (api/v1alpha1/zz_generated.deepcopy.go)
- `method:6083589e5790038780d8802e676e0a9c` method DenoPermission.DeepCopyInto (api/v1alpha1/zz_generated.deepcopy.go)
- `method:60c79894e0b77e11d949f310fba6d5df` method PolicyEngineList.DeepCopyObject (api/v1alpha1/zz_generated.deepcopy.go)
- `method:637a294e0317ee7c7b762a9a834a81c3` method PolicyWorkflowPodList.DeepCopyInto (api/v1alpha1/zz_generated.deepcopy.go)
- `method:6508a1d906b6f2b324455806b9ea2385` method DenoPodList.DeepCopyInto (api/v1alpha1/zz_generated.deepcopy.go)
- `method:6808b387eb80cb007458198d24792b30` method PolicyWorkflowRun.DeepCopy (api/v1alpha1/zz_generated.deepcopy.go)
- `method:69cc3ec5c5e6aa9b85388d42e187701f` method PolicyEngineStatus.DeepCopyInto (api/v1alpha1/zz_generated.deepcopy.go)
- `method:6f6b40ea732f8eaa793a74097a0e93ab` method OpenBao.DeepCopy (api/v1alpha1/zz_generated.deepcopy.go)
- `method:7095c2c18f0ca7c1d8965b1dc59c7a17` method PolicyEngineList.DeepCopyInto (api/v1alpha1/zz_generated.deepcopy.go)
- `method:75ef37889a865ee0efe2675192b1e676` method PolicyWorkflowPod.DeepCopy (api/v1alpha1/zz_generated.deepcopy.go)
- `method:777e96bd52d6f7165bf64c05b01dc885` method OpenBaoSpec.DeepCopy (api/v1alpha1/zz_generated.deepcopy.go)
- `method:77f8d9f7728ecb18c39103a2b261e109` method DenoPodSpec.DeepCopyInto (api/v1alpha1/zz_generated.deepcopy.go)

_80 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
