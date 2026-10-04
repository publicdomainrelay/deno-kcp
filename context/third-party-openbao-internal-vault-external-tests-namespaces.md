# Context: third-party-openbao-internal-vault-external-tests-namespaces

Repository: `deno-kcp`

This context exists to specify the black-box behavior the external namespace tests assert about OpenBao: how namespace deletion must survive an interrupted (cancelled) deletion and leave a tainted namespace that a second delete can finish, and how per-namespace seal/unseal state must propagate across all cores of a cluster, including after seal, step-down, restart and resync. It documents the acceptance rules these integration tests enforce so that changes to namespace deletion, tainting or namespace sealing can be checked against them.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/namespaces/namespace_test.go` file namespace_test.go (third_party/openbao/internal/vault/external_tests/namespaces/namespace_test.go)
- `file:third_party/openbao/internal/vault/external_tests/namespaces/sealing_test.go` file sealing_test.go (third_party/openbao/internal/vault/external_tests/namespaces/sealing_test.go)
<!-- SPECD_MANAGED_END -->
