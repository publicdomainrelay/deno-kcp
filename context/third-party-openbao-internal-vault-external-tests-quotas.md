# Context: third-party-openbao-internal-vault-external-tests-quotas

Repository: `deno-kcp`

The context exists to pin down the externally observable contract of the OpenBao rate-limit quota subsystem as demanded by its external_tests/quotas package: how quota rules are named and deduplicated, how they bind to paths, mounts and namespaces, how child namespaces inherit them when the inheritable flag is set, how configured and default exempt paths bypass them, how enforcement tracks the token-bucket refill rate, how violations are written to the audit log, and how a mount-scoped rule takes precedence over a root-scoped one. Because the package is test-only and exports nothing but test entrypoints, the specification is expressed as invariants the tests require of the vault core and quota engine rather than as callable production API.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/quotas/quotas_test.go` file quotas_test.go (third_party/openbao/internal/vault/external_tests/quotas/quotas_test.go)
<!-- SPECD_MANAGED_END -->
