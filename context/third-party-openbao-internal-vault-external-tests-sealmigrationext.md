# Context: third-party-openbao-internal-vault-external-tests-sealmigrationext

Repository: `deno-kcp`

This context exists so the seal-migration scenarios that the shared internal/vault/external_tests/sealmigration package implements can be driven from a thin external test surface without duplicating the scenario bodies. The file supplies the concrete test entrypoints for Shamir-to-Transit, Transit-to-Shamir and Transit-to-Transit migration, split across the pre-1.4 and post-1.4 variants, and it fixes the per-test in-memory storage construction and the base-port offset that keeps the parallel tests from colliding on listening ports.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/sealmigrationext/seal_migration_pre14_test.go` file seal_migration_pre14_test.go (third_party/openbao/internal/vault/external_tests/sealmigrationext/seal_migration_pre14_test.go)
<!-- SPECD_MANAGED_END -->
