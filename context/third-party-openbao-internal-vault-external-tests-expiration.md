# Context: third-party-openbao-internal-vault-external-tests-expiration

Repository: `deno-kcp`

The context exists to verify, from outside the vault core, that the irrevocable-lease reporting surface of the expiration subsystem behaves correctly end to end over HTTP: that sys/leases/count and sys/leases report zero leases on a fresh cluster, report the exact injected count and per-mount breakdown after injection, and that sys/leases applies the default return cap with its warning until the caller passes limit=none. It is the external acceptance layer for the irrevocable lease listing and counting endpoints, so it pins the response shape (lease_count, counts, leases, mount_id, warnings) that API consumers depend on.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/expiration/expiration_test.go` file expiration_test.go (third_party/openbao/internal/vault/external_tests/expiration/expiration_test.go)
<!-- SPECD_MANAGED_END -->
