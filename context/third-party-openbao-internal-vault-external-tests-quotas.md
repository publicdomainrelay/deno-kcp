# Context: third-party-openbao-internal-vault-external-tests-quotas

Repository: `deno-kcp`

This context exists to specify the externally observable behaviour of the OpenBao rate-limit quota subsystem as asserted by its external_tests/quotas package: how quota rules are named, deduplicated, scoped to paths and namespaces, inherited by child namespaces, exempted by path, enforced against the token-bucket refill rate, audited on violation, and how mount-level rules take precedence over root-level rules. It is a test-only package, so it exports nothing but test entrypoints; the specification captures the invariants those tests demand of the vault core and quota engine.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/quotas/quotas_test.go` file quotas_test.go (third_party/openbao/internal/vault/external_tests/quotas/quotas_test.go)
<!-- SPECD_MANAGED_END -->
