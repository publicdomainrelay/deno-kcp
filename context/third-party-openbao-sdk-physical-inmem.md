# Context: third-party-openbao-sdk-physical-inmem

Repository: `deno-kcp`

This context specifies the in-memory physical backend that the OpenBao SDK ships for tests and for embedders that need a throwaway store. It exists so readers can tell exactly what the backend guarantees: the synchronized map behind the physical.Backend contract, the delibrate failure injection used to exercise error paths, the transaction overlay that stages writes until Commit, and the in-process HA lock map that simulates lock contention without a real cluster. Read it before relying on in-memory durability, transaction isolation, or HA lock behavior.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/physical/inmem/cache_test.go` file cache_test.go (third_party/openbao/sdk/physical/inmem/cache_test.go)
- `file:third_party/openbao/sdk/physical/inmem/inmem.go` file inmem.go (third_party/openbao/sdk/physical/inmem/inmem.go)
- `file:third_party/openbao/sdk/physical/inmem/inmem_ha.go` file inmem_ha.go (third_party/openbao/sdk/physical/inmem/inmem_ha.go)
- `file:third_party/openbao/sdk/physical/inmem/inmem_ha_test.go` file inmem_ha_test.go (third_party/openbao/sdk/physical/inmem/inmem_ha_test.go)
- `file:third_party/openbao/sdk/physical/inmem/inmem_test.go` file inmem_test.go (third_party/openbao/sdk/physical/inmem/inmem_test.go)
- `file:third_party/openbao/sdk/physical/inmem/physical_view_test.go` file physical_view_test.go (third_party/openbao/sdk/physical/inmem/physical_view_test.go)
- `function:67470801f4aada872caf1408df246d21` function OpName (third_party/openbao/sdk/physical/inmem/inmem.go)
- `function:92955b55e1abdc8afbaa395116e4e364` function NewDirectInmem (third_party/openbao/sdk/physical/inmem/inmem.go)
- `function:b323d9f5d39c7f416fbfac9dad196fc3` function NewInmemHA (third_party/openbao/sdk/physical/inmem/inmem_ha.go)
- `function:c019f4a22f383dc72eccdef8d9c0f0f2` function NewInmem (third_party/openbao/sdk/physical/inmem/inmem.go)
- `method:20e1a4431c687b6f461a6a95a9941088` method InmemBackend.ListInternal (third_party/openbao/sdk/physical/inmem/inmem.go)
- `method:25879ce9bfd59a5bcd1affedc70dc4af` method InmemBackend.List (third_party/openbao/sdk/physical/inmem/inmem.go)
- `method:304c80ffef2cd2f743ea3bdc7f6a8784` method InmemBackendTransaction.Commit (third_party/openbao/sdk/physical/inmem/inmem.go)
- `method:393c7df9a35883ea59c0adec45409a7c` method InmemBackend.FailGet (third_party/openbao/sdk/physical/inmem/inmem.go)
- `method:39d6aaeb07abb8bb3686f001a8d57d5c` method InmemHABackend.LockWith (third_party/openbao/sdk/physical/inmem/inmem_ha.go)
- `method:3e0f1595c88e7a20ae01bea792ec8df5` method InmemBackendTransaction.Put (third_party/openbao/sdk/physical/inmem/inmem.go)
- `method:3f8fb42701c6fbbab889e38d19785fd5` method InmemBackend.ListPaginatedInternal (third_party/openbao/sdk/physical/inmem/inmem.go)
- `method:4bee182a484f430f1c6c3a51381d5441` method InmemLock.Unlock (third_party/openbao/sdk/physical/inmem/inmem_ha.go)
- `method:531fc17acb8394310e09753f2e8a6c9d` method InmemBackend.PutInternal (third_party/openbao/sdk/physical/inmem/inmem.go)
- `method:5e7184e26097a7ac26054b5656d8ab53` method InmemBackend.ListPage (third_party/openbao/sdk/physical/inmem/inmem.go)
- `method:616da0007e46a4628fdb7f765fb27c67` method InmemHABackend.Delete (third_party/openbao/sdk/physical/inmem/inmem_ha.go)
- `method:6e622dd27a1a2f30cd44d967957d94f9` method InmemBackend.GetInternal (third_party/openbao/sdk/physical/inmem/inmem.go)
- `method:705d52ff7b4f4df84dc5294474090947` method TransactionalInmemBackend.BeginTx (third_party/openbao/sdk/physical/inmem/inmem.go)
- `method:7253cc2049f88538d67b5ad10141893d` method InmemHABackend.HAEnabled (third_party/openbao/sdk/physical/inmem/inmem_ha.go)
- `method:74e406f96705c0d0e72d5501915b441c` method InmemBackend.FailDelete (third_party/openbao/sdk/physical/inmem/inmem.go)
- `method:800402a0b3c8d2c671bce53ead64e1cd` method InmemBackend.FailPut (third_party/openbao/sdk/physical/inmem/inmem.go)
- `method:8153482cc71bfa19cbfe74e22a7f9b6d` method InmemBackendTransaction.Delete (third_party/openbao/sdk/physical/inmem/inmem.go)
- `method:83e66da284c9013a6b103a26f187c911` method InmemHABackend.LockMapSize (third_party/openbao/sdk/physical/inmem/inmem_ha.go)
- `method:8429c18c50dd55f046d1bda3badc60ed` method InmemBackend.Put (third_party/openbao/sdk/physical/inmem/inmem.go)
- `method:94bb327c33212189635d340fa6746144` method InmemHABackend.HookInvalidate (third_party/openbao/sdk/physical/inmem/inmem_ha.go)
- `method:96fcde07ad2ea1cf9ae5ee6ec522f37a` method InmemBackendTransaction.ListPage (third_party/openbao/sdk/physical/inmem/inmem.go)
- `method:9ec8aef4898dfb331ce15077f40a1c71` method InmemBackend.Get (third_party/openbao/sdk/physical/inmem/inmem.go)
- `method:bc30b838af03d4362af5ce8b9b79a4c5` method InmemLock.Value (third_party/openbao/sdk/physical/inmem/inmem_ha.go)
- `method:d195bf63851ddf91db7d6336fb640822` method InmemBackend.FailList (third_party/openbao/sdk/physical/inmem/inmem.go)
- `method:d21e06b62fb07aa815fd38f8e8d9291a` method TransactionalInmemBackend.BeginReadOnlyTx (third_party/openbao/sdk/physical/inmem/inmem.go)
- `method:d5e0cabb4753f261dcbcad8dd0676c07` method InmemHABackend.Put (third_party/openbao/sdk/physical/inmem/inmem_ha.go)
- `method:da23dda1d9aaee72a6f3dfa2566046a7` method InmemBackendTransaction.List (third_party/openbao/sdk/physical/inmem/inmem.go)
- `method:eaa3ba9fbe82faa210aeb03c2f6307c5` method InmemBackendTransaction.Rollback (third_party/openbao/sdk/physical/inmem/inmem.go)
- `method:f53097ef61ea8e68a22cc816f1aa5044` method InmemBackendTransaction.Get (third_party/openbao/sdk/physical/inmem/inmem.go)
- `method:f728bdd01cbe77de2f9240c26d3edf38` method InmemBackend.Delete (third_party/openbao/sdk/physical/inmem/inmem.go)
- `method:fa6471032402e180cc0e53d51382c058` method InmemBackend.DeleteInternal (third_party/openbao/sdk/physical/inmem/inmem.go)
- `method:fb8dd39628f33fdfc2bbbeff7dcdfac6` method InmemLock.Lock (third_party/openbao/sdk/physical/inmem/inmem_ha.go)
- `struct:433127d50c193842a0b1f3ca0ba2d6bd` struct InmemBackend (third_party/openbao/sdk/physical/inmem/inmem.go)
- `struct:605223dc185e0eeb8f8537f0bf596ad0` struct InmemLock (third_party/openbao/sdk/physical/inmem/inmem_ha.go)
- `struct:70bd01e4484635d5c2e3ccf8049945b9` struct InmemHABackend (third_party/openbao/sdk/physical/inmem/inmem_ha.go)
- `struct:ebb7d2f72be01a983dbdded0ecbb4f62` struct InmemBackendTransaction (third_party/openbao/sdk/physical/inmem/inmem.go)

_2 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
