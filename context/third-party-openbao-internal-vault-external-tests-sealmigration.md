# Context: third-party-openbao-internal-vault-external-tests-sealmigration

Repository: `deno-kcp`

The package exists so OpenBao's seal-migration behavior can be exercised end to end against real test clusters. Each ParamTest* function is a scenario that a caller's test file invokes, parameterized by logger, reusable storage and a base port, so the same migration logic runs over different storage backends. The pre-1.4 and post-1.4 variants exist because the migration protocol changed at that version, and the transit-to-transit variant covers moving between two transit seals.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/sealmigration/seal_migration_pre14_test.go` file seal_migration_pre14_test.go (third_party/openbao/internal/vault/external_tests/sealmigration/seal_migration_pre14_test.go)
- `file:third_party/openbao/internal/vault/external_tests/sealmigration/seal_migration_test.go` file seal_migration_test.go (third_party/openbao/internal/vault/external_tests/sealmigration/seal_migration_test.go)
- `file:third_party/openbao/internal/vault/external_tests/sealmigration/testshared.go` file testshared.go (third_party/openbao/internal/vault/external_tests/sealmigration/testshared.go)
- `function:17afc0249ee3900e0b5c59e5cf2c9eaa` function ParamTestSealMigration_TransitToTransit (third_party/openbao/internal/vault/external_tests/sealmigration/testshared.go)
- `function:40d8d4cf39f7e9a7ce033ff593e61364` function ParamTestSealMigrationTransitToShamir_Pre14 (third_party/openbao/internal/vault/external_tests/sealmigration/testshared.go)
- `function:be29784e5299a43e0e6bb142b3f5f08c` function InitializeTransit (third_party/openbao/internal/vault/external_tests/sealmigration/testshared.go)
- `function:c87742ce772f5a00a62c340c7ab92ca5` function ParamTestSealMigrationTransitToShamir_Post14 (third_party/openbao/internal/vault/external_tests/sealmigration/testshared.go)
- `function:ede151c6274be7b37402e591a9c49599` function ParamTestSealMigrationShamirToTransit_Pre14 (third_party/openbao/internal/vault/external_tests/sealmigration/testshared.go)
- `function:f93a5441445832900846fd2657ebe10a` function ParamTestSealMigrationShamirToTransit_Post14 (third_party/openbao/internal/vault/external_tests/sealmigration/testshared.go)
<!-- SPECD_MANAGED_END -->
