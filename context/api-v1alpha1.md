# Context: api-v1alpha1

Repository: `deno-kcp`

This context exists so the operator can persist and reconcile deno-kcp custom resources through the Kubernetes API machinery. The package defines the on-cluster schema (specs, statuses, phase enums), the list types the informers and clientsets need, the kubebuilder deep-copy implementations that keep informer caches free of aliasing bugs, and the bridge that turns the CRD-shaped DenoPermissions and ServiceAccountRef into the denospec types the runtime layer consumes. It is the shared vocabulary between the controllers, the provider registry and the denospec execution library.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

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
- `method:3846c936f898af39cc3e185598df8409` method ServiceAccountRef.DenoSpec (api/v1alpha1/denospec.go)
- `method:4853a11212ee93729970106d66fe9a6c` method DenoPermissions.DenoSpec (api/v1alpha1/denospec.go)
- `struct:05cdd79e23617fbecdb398d34c9d5ad7` struct ServiceAccountRef (api/v1alpha1/types_shared.go)
- `struct:06c63fea51925dbd41f3c4df59e93f41` struct PolicyEngineSpec (api/v1alpha1/types_policyengine.go)
- `struct:0c79e3dee3b764f7f5257847216d72fc` struct PolicyWorkflowPodList (api/v1alpha1/types_policyworkflowpod.go)
- `struct:11ada3025e8b3e4cb83fea05d838d25b` struct DenoJobSpec (api/v1alpha1/types_denojob.go)
- `struct:163c94c497ab49465c39a0cfdcff529b` struct PolicyWorkflowRun (api/v1alpha1/types_policyworkflowrun.go)
- `struct:1cf3dab88f5e645f4aecb8ee5a1452b7` struct DenoRunSpec (api/v1alpha1/types_denorun.go)
- `struct:1ec205881eb7af10ea8b319f43c8b79f` struct PolicyEngine (api/v1alpha1/types_policyengine.go)
- `struct:2acd645a0c495c069ad6a7de77c53b69` struct PolicyWorkflowPod (api/v1alpha1/types_policyworkflowpod.go)
- `struct:329701e6df45ea80e4b2746b82c4b04b` struct RunTriggerList (api/v1alpha1/types_runtrigger.go)
- `struct:3d4f3a77df9eff3913283e3193ebdc0c` struct OpenBaoStatus (api/v1alpha1/types_openbao.go)
- `struct:4e814833e5abc93cd307dbef4a0d5abb` struct DenoPodList (api/v1alpha1/types_denopod.go)
- `struct:54c96eeeceda1a4a8f5e63ef4beba6b5` struct DenoPodSpec (api/v1alpha1/types_denopod.go)
- `struct:5adb7a53bc10bdd5ca15164597335d81` struct PolicyEngineList (api/v1alpha1/types_policyengine.go)
- `struct:628eff8a6ce37cfb048106d4d94a8fd0` struct RunTriggerStatus (api/v1alpha1/types_runtrigger.go)
- `struct:6347366d6293ec3914c67cd0fde6f6b6` struct RunTrigger (api/v1alpha1/types_runtrigger.go)
- `struct:682deb678875ecbd72066fc7eee1adaa` struct OpenBaoSpec (api/v1alpha1/types_openbao.go)
- `struct:6d3c4a2c540c216efa9cefae9ca36db4` struct PolicyWorkflowRunStatus (api/v1alpha1/types_policyworkflowrun.go)
- `struct:76a56119c3f73bd4c3368f000990397f` struct PolicyWorkflowRunSpec (api/v1alpha1/types_policyworkflowrun.go)
- `struct:78eecda4a2199493218816c567945e6d` struct DenoPodStatus (api/v1alpha1/types_denopod.go)
- `struct:852948a2a15890447c7fa5d4b4132edf` struct RunTriggerSpec (api/v1alpha1/types_runtrigger.go)
- `struct:8592ae201b80a86fa2aea2b4ff73a6a7` struct DenoRun (api/v1alpha1/types_denorun.go)
- `struct:9b5ce2a07cecc427a4df5c9186d4ddc8` struct DenoRunList (api/v1alpha1/types_denorun.go)
- `struct:9cd31281556cc318318824f59ed761c4` struct PolicyWorkflowRunList (api/v1alpha1/types_policyworkflowrun.go)
- `struct:9f31aa5c4a5874f591d074bb6f87c0d7` struct DenoJob (api/v1alpha1/types_denojob.go)
- `struct:a6b2c82ee80cb3d8639351da73b016d6` struct ExecProbe (api/v1alpha1/types_shared.go)
- `struct:ad8c97baa6157384096c06159cfb2dbe` struct DenoPod (api/v1alpha1/types_denopod.go)
- `struct:b1b033afbaf6fab9e420675da77463a6` struct DenoPodTemplate (api/v1alpha1/types_shared.go)
- `struct:b33f39d50e564c386868bc724e62059e` struct OpenBaoList (api/v1alpha1/types_openbao.go)
- `struct:ba9f5eda95c2cc504892ba97f6840615` struct DenoRunStatus (api/v1alpha1/types_denorun.go)
- `struct:bb8f8c07c85fb14822c6df3a9b260b18` struct PolicyWorkflowPodStatus (api/v1alpha1/types_policyworkflowpod.go)
- `struct:c316e42aef9d55ae6fd71743c1fde990` struct PolicyEngineStatus (api/v1alpha1/types_policyengine.go)
- `struct:c61a776387495a41e314bf8a3bc46c7e` struct OpenBao (api/v1alpha1/types_openbao.go)
- `struct:c8831499bb53beff7d2fc49579535570` struct DenoJobStatus (api/v1alpha1/types_denojob.go)
- `struct:da40f37a9ba38a5f2a353dd41f480892` struct DenoPermissions (api/v1alpha1/types_shared.go)
- `struct:e23b6c675e266e96e349726b82e81264` struct DenoJobList (api/v1alpha1/types_denojob.go)
- `struct:e95b0c824023d610cd8dd79e9b10330c` struct DenoPermission (api/v1alpha1/types_shared.go)
- `struct:f5ddc2d2343853d756015a53254dbce3` struct PolicyWorkflowPodSpec (api/v1alpha1/types_policyworkflowpod.go)
- `type_alias:0e2883e159e4826141f3b8dbf5a8951d` type_alias DenoPodPhase (api/v1alpha1/types_denopod.go)
- `type_alias:3228acbcc876296a83b038db20f5ba53` type_alias PolicyWorkflowPodPhase (api/v1alpha1/types_policyworkflowpod.go)
- `type_alias:71e9ec98b426f5ba2a6f0fa861505f90` type_alias PolicyEnginePhase (api/v1alpha1/types_policyengine.go)
- `type_alias:95711bd9c109c1c963d90415abeb221a` type_alias RunTriggerPhase (api/v1alpha1/types_runtrigger.go)
- `type_alias:b301d0b47a8b87747f72eb4dd29c1213` type_alias DenoJobPhase (api/v1alpha1/types_denojob.go)

_4 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
