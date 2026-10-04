# Context: third-party-openbao-sdk-helper-testcluster

Repository: `deno-kcp`

This context exists so the repository can stand up disposable OpenBao/Vault clusters inside Go tests without a container runtime, and so test code can drive those clusters through a stable interface. types.go fixes the contract (cluster, node, storage), exec.go supplies the subprocess-backed implementation of that contract, util.go supplies the polling helpers that wait for sealing, health and leader election, and logging.go and consts.go carry the shared logging and constant surface. The package is vendored under third_party so the wider deno-kcp project can import testcluster directly and reuse the upstream test topology rather than reimplementing it.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/helper/testcluster/consts.go` file consts.go (third_party/openbao/sdk/helper/testcluster/consts.go)
- `file:third_party/openbao/sdk/helper/testcluster/exec.go` file exec.go (third_party/openbao/sdk/helper/testcluster/exec.go)
- `file:third_party/openbao/sdk/helper/testcluster/logging.go` file logging.go (third_party/openbao/sdk/helper/testcluster/logging.go)
- `file:third_party/openbao/sdk/helper/testcluster/types.go` file types.go (third_party/openbao/sdk/helper/testcluster/types.go)
- `file:third_party/openbao/sdk/helper/testcluster/util.go` file util.go (third_party/openbao/sdk/helper/testcluster/util.go)
- `function:0146bb5ccbb0ec8d4a996677dda5aaf9` function WaitForActiveNode (third_party/openbao/sdk/helper/testcluster/util.go)
- `function:2df1b9fc77d27beae39d19d3b2923415` function WaitForNCoresSealed (third_party/openbao/sdk/helper/testcluster/util.go)
- `function:5f7f2b4a9e59daae077b4bd648402dc1` function NewExecDevCluster (third_party/openbao/sdk/helper/testcluster/exec.go)
- `function:60ad00a57c7dcfae83ed622d5a21f3b1` function GenerateRoot (third_party/openbao/sdk/helper/testcluster/util.go)
- `function:6aa04bce1ab30e35ac4040a1e16e4d95` function JSONLogNoTimestamp (third_party/openbao/sdk/helper/testcluster/logging.go)
- `function:880628a9238a2c5b4cf3909f898c06d6` function NodeHealthy (third_party/openbao/sdk/helper/testcluster/util.go)
- `function:99757a60b985a6c8541eb571d3e825b2` function SealNode (third_party/openbao/sdk/helper/testcluster/util.go)
- `function:cdc6803ac291cc8c807424b7aad5978e` function UnsealNode (third_party/openbao/sdk/helper/testcluster/util.go)
- `function:d1e7f7d30fffd1f72669f6e45899dacd` function NewTestExecDevCluster (third_party/openbao/sdk/helper/testcluster/exec.go)
- `function:eb87099bb9833b31e8d9a06d9b69bb9d` function UnsealAllNodes (third_party/openbao/sdk/helper/testcluster/util.go)
- `function:ec1223d1172264fbf95ed6585041b34d` function NodeSealed (third_party/openbao/sdk/helper/testcluster/util.go)
- `function:ee2aca76a6bad467eb4a4d1af3d0d339` function SealAllNodes (third_party/openbao/sdk/helper/testcluster/util.go)
- `function:fe4ea10fed896bc137e8020d551a9fef` function LeaderNode (third_party/openbao/sdk/helper/testcluster/util.go)
- `interface:0bfa70e287a4b23775516953f3803ce0` interface NodeStorage (third_party/openbao/sdk/helper/testcluster/types.go)
- `interface:3a94c6fcfb2896122e745b296f92a9a2` interface ClusterStorage (third_party/openbao/sdk/helper/testcluster/types.go)
- `interface:7af47d1788aea06db6e011e65491b444` interface Storage (third_party/openbao/sdk/helper/testcluster/types.go)
- `interface:c82e80352814240122d396841bd63b91` interface VaultCluster (third_party/openbao/sdk/helper/testcluster/types.go)
- `interface:c8b5888ea5fd84ceac6bbf7132de69fa` interface VaultClusterNode (third_party/openbao/sdk/helper/testcluster/types.go)
- `method:012ca9cbcc878acb3dd88e32af7e2afa` method VaultClusterNode.TLSConfig (third_party/openbao/sdk/helper/testcluster/types.go)
- `method:040473ed5c9a317f5e4b23187f930d25` method ClusterStorage.ForNode (third_party/openbao/sdk/helper/testcluster/types.go)
- `method:08f8c5c734a5cc379d244d844d9bbee1` method NodeStorage.Opts (third_party/openbao/sdk/helper/testcluster/types.go)
- `method:0e85dcfe431d8254745b6cda78c6f3bf` method execDevClusterNode.APIClient (third_party/openbao/sdk/helper/testcluster/exec.go)
- `method:1252b6fc28586b9f87b1fcae5210834e` method VaultCluster.GetBarrierKeys (third_party/openbao/sdk/helper/testcluster/types.go)
- `method:1ad1a571366e43507e26a719a8f71892` method ExecDevCluster.GetCACertPEMFile (third_party/openbao/sdk/helper/testcluster/exec.go)
- `method:202edc02b59cad312a7b09b10a41a9e2` method execDevClusterNode.TLSConfig (third_party/openbao/sdk/helper/testcluster/exec.go)
- `method:274aadfca451345fa3f0891b9ca8ecc7` method ExecDevCluster.GetBarrierOrRecoveryKeys (third_party/openbao/sdk/helper/testcluster/exec.go)
- `method:48e911144da687228f7496bb10771ff4` method ExecDevCluster.GetRootToken (third_party/openbao/sdk/helper/testcluster/exec.go)
- `method:5fa6dc622da3639235b51a84613c3edb` method execDevClusterNode.Name (third_party/openbao/sdk/helper/testcluster/exec.go)
- `method:70f02699552b028ad747b957c560408e` method ExecDevCluster.SetRootToken (third_party/openbao/sdk/helper/testcluster/exec.go)
- `method:785d1f28440789f61017bfd43aded710` method ExecDevCluster.Cleanup (third_party/openbao/sdk/helper/testcluster/exec.go)
- `method:887a90c1eb74b3997ca40b322db2d763` method VaultCluster.Cleanup (third_party/openbao/sdk/helper/testcluster/types.go)
- `method:919422381644f8246877da487a66e01b` method VaultCluster.GetRootToken (third_party/openbao/sdk/helper/testcluster/types.go)
- `method:9233390135dc4ccafb32746ced567f0e` method Storage.Type (third_party/openbao/sdk/helper/testcluster/types.go)
- `method:96cad317df0450e700bff0dc32da0f05` method ExecDevCluster.NamedLogger (third_party/openbao/sdk/helper/testcluster/exec.go)
- `method:96f121c4d347c1098605379fb209c2db` method VaultCluster.SetBarrierKeys (third_party/openbao/sdk/helper/testcluster/types.go)
- `method:9b22cfbbd5903ebd87e7fac8a6690b2a` method VaultCluster.GetRecoveryKeys (third_party/openbao/sdk/helper/testcluster/types.go)
- `method:aa1274cc5540d299e9e6c460ee88acfb` method VaultCluster.SetRootToken (third_party/openbao/sdk/helper/testcluster/types.go)
- `method:aafa30d30ff3a883aa151fe8e8bd63fd` method Storage.Cleanup (third_party/openbao/sdk/helper/testcluster/types.go)
- `method:b4e4b6396185342bbdfc9a9bc7b9c838` method VaultCluster.GetBarrierOrRecoveryKeys (third_party/openbao/sdk/helper/testcluster/types.go)
- `method:b52e7d106976e2e26643adaa754da2a7` method VaultCluster.NamedLogger (third_party/openbao/sdk/helper/testcluster/types.go)
- `method:c5fcc7809638b702bc7f0d40bcf14c3c` method ExecDevCluster.Nodes (third_party/openbao/sdk/helper/testcluster/exec.go)

_19 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
