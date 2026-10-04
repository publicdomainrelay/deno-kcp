# Context: third-party-openbao-internal-vault-external-tests-kv

Repository: `deno-kcp`

This context exists to specify the black-box acceptance tests that guard the KVv2 secret engine's PATCH, subkeys and upgrade-handling behaviour. The tests are deliberately end-to-end: they build a cluster from a CoreConfig that registers logicalKv.Factory or logicalKv.VersionedKVFactory as the "kv" logical backend, mount kv-v2 over the sys API, and then assert on raw HTTP status codes and parsed secret bodies. The package pins three externally visible contracts, namely that PATCH requires a merge-patch content type and produces exactly one audit request and response record, that the subkeys endpoint reports nil subkeys with deletion or destruction metadata instead of leaking data, and that reopening a KVv2 mount whose policy and archive views were wiped does not emit a "cannot write to storage during setup" error. The retry helper exists because a freshly mounted KVv2 backend may still be performing its non-versioned-to-versioned upgrade when the first request arrives, so the tests must tolerate that transient failure rather than reporting it.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/kv/kv_patch_test.go` file kv_patch_test.go (third_party/openbao/internal/vault/external_tests/kv/kv_patch_test.go)
- `file:third_party/openbao/internal/vault/external_tests/kv/kv_subkeys_test.go` file kv_subkeys_test.go (third_party/openbao/internal/vault/external_tests/kv/kv_subkeys_test.go)
- `file:third_party/openbao/internal/vault/external_tests/kv/kvv2_upgrade_test.go` file kvv2_upgrade_test.go (third_party/openbao/internal/vault/external_tests/kv/kvv2_upgrade_test.go)
<!-- SPECD_MANAGED_END -->
