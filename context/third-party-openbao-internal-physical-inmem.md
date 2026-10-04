# Context: third-party-openbao-internal-physical-inmem

Repository: `deno-kcp`

_(empty: write what this context is for)_

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/physical/inmem/inmem.go` file inmem.go (third_party/openbao/internal/physical/inmem/inmem.go)
- `file:third_party/openbao/internal/physical/inmem/inmem_ha.go` file inmem_ha.go (third_party/openbao/internal/physical/inmem/inmem_ha.go)
- `file:third_party/openbao/internal/physical/inmem/inmem_ha_test.go` file inmem_ha_test.go (third_party/openbao/internal/physical/inmem/inmem_ha_test.go)
- `file:third_party/openbao/internal/physical/inmem/inmem_test.go` file inmem_test.go (third_party/openbao/internal/physical/inmem/inmem_test.go)
- `file:third_party/openbao/internal/physical/inmem/physical_view_test.go` file physical_view_test.go (third_party/openbao/internal/physical/inmem/physical_view_test.go)
- `function:01e86591f7c08850e492d37a5e08dd52` function NewDirectInmem (third_party/openbao/internal/physical/inmem/inmem.go)
- `function:3d2e06bf2d872877c88d4efd08239508` function OpName (third_party/openbao/internal/physical/inmem/inmem.go)
- `function:4c046da44025634cd7e25283ce278dcc` function NewInmem (third_party/openbao/internal/physical/inmem/inmem.go)
- `function:b235eded961c4abe0863e2855edea225` function NewInmemHA (third_party/openbao/internal/physical/inmem/inmem_ha.go)
- `method:09f4611c045b886c99193978e5fffc60` method TransactionalInmemBackend.BeginReadOnlyTx (third_party/openbao/internal/physical/inmem/inmem.go)
- `method:187ff6f6b3a871a5185e2aa1b6cd94b8` method InmemLock.Value (third_party/openbao/internal/physical/inmem/inmem_ha.go)
- `method:1e31f66440b30209f4f5a9e6726329ce` method InmemBackend.Put (third_party/openbao/internal/physical/inmem/inmem.go)
- `method:305ccbdfd456a4b1edc8fab49f0be2ec` method InmemHABackend.LockWith (third_party/openbao/internal/physical/inmem/inmem_ha.go)
- `method:3c04295126306cdfd876bc07e3908a2e` method InmemBackend.Get (third_party/openbao/internal/physical/inmem/inmem.go)
- `method:43c21050c4a345d827af6367dc7a44cf` method InmemBackend.List (third_party/openbao/internal/physical/inmem/inmem.go)
- `method:499e07b68ff4edbe764e64d9fcb1f28b` method InmemLock.Lock (third_party/openbao/internal/physical/inmem/inmem_ha.go)
- `method:4ead8adefd1962fb73444884ef8bc234` method InmemBackend.FailGet (third_party/openbao/internal/physical/inmem/inmem.go)
- `method:5038c7c5d7c5db20d739315dc4cd59f1` method InmemBackend.ListPage (third_party/openbao/internal/physical/inmem/inmem.go)
- `method:599cf2c9ab84549195412caf4c4bb3a8` method InmemBackendTransaction.Rollback (third_party/openbao/internal/physical/inmem/inmem.go)
- `method:620d69cb359873a4adafa368fcd4ab69` method InmemBackend.FailPut (third_party/openbao/internal/physical/inmem/inmem.go)
- `method:72fb45d6d398553c65fc86ed64c4007c` method InmemHABackend.HookInvalidate (third_party/openbao/internal/physical/inmem/inmem_ha.go)
- `method:7b7b36e795b1775fa162674183f074b1` method InmemHABackend.Delete (third_party/openbao/internal/physical/inmem/inmem_ha.go)
- `method:7c18f4d6c4f9da42655ac6302f0f3e75` method InmemLock.Unlock (third_party/openbao/internal/physical/inmem/inmem_ha.go)
- `method:8d276904195680b59b907b4fad500fcc` method InmemHABackend.HAEnabled (third_party/openbao/internal/physical/inmem/inmem_ha.go)
- `method:aebafecb8fd45638f9e01ac42bcb48e6` method InmemBackend.FailDelete (third_party/openbao/internal/physical/inmem/inmem.go)
- `method:ba9e633c846c0ed09e884c1d09bb6648` method InmemBackend.Delete (third_party/openbao/internal/physical/inmem/inmem.go)
- `method:bdd3cf66911c67d4a387fc651363cbf5` method InmemBackend.FailList (third_party/openbao/internal/physical/inmem/inmem.go)
- `method:ccae56ea1b2267afd14f3f6b8e9882d0` method InmemHABackend.LockMapSize (third_party/openbao/internal/physical/inmem/inmem_ha.go)
- `method:d85856c01a2035e79927288ebd527cd5` method TransactionalInmemBackend.BeginTx (third_party/openbao/internal/physical/inmem/inmem.go)
- `method:e0db7897f317070fb2c3a4b7c30828e5` method InmemHABackend.Put (third_party/openbao/internal/physical/inmem/inmem_ha.go)
- `method:e411a886bada2ea8e9ea5fa106f9bc23` method InmemBackendTransaction.Commit (third_party/openbao/internal/physical/inmem/inmem.go)
- `struct:1d80bbbee5698efde6ed532fa3090786` struct InmemOp (third_party/openbao/internal/physical/inmem/inmem.go)
- `struct:2d6b4ee3aec00b51abb859f5c1e03bed` struct InmemBackend (third_party/openbao/internal/physical/inmem/inmem.go)
- `struct:4347fdb9d9109c660bbfc2ea4ab407f0` struct InmemBackendTransaction (third_party/openbao/internal/physical/inmem/inmem.go)
- `struct:5d362beb6e121438856c6710c4b52f89` struct InmemLock (third_party/openbao/internal/physical/inmem/inmem_ha.go)
- `struct:679b872bd8d4cddf89e45879d844de42` struct InmemHABackend (third_party/openbao/internal/physical/inmem/inmem_ha.go)
- `struct:df217a5c171aa38af804e782d2d8a41a` struct TransactionalInmemBackend (third_party/openbao/internal/physical/inmem/inmem.go)
<!-- SPECD_MANAGED_END -->
