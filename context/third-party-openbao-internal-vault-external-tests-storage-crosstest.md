# Context: third-party-openbao-internal-vault-external-tests-storage-crosstest

Repository: `deno-kcp`

This context pins down the behavioural contract that OpenBao's logical.Storage implementations must satisfy collectively. The file is a conformance harness: any backend registered in allLogical or allTransactionalLogical must be indistinguishable from its peers under the same operation stream, so adding a storage backend means adding it to those maps and letting the shared assertions prove parity. It encodes the edge cases the project cares about — storage-root listing, prefix versus exact-key deletion, nil versus empty list results, write ordering, pagination with after and limit, and transactional conflict detection — as executable assertions rather than prose.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/storage/crosstest/cross_test.go` file cross_test.go (third_party/openbao/internal/vault/external_tests/storage/crosstest/cross_test.go)
<!-- SPECD_MANAGED_END -->
