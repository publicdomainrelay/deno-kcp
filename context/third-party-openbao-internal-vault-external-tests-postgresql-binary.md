# Context: third-party-openbao-internal-vault-external-tests-postgresql-binary

Repository: `deno-kcp`

The context exists to exercise the PostgreSQL storage backend of OpenBao against real containerised server binaries rather than in-memory storage, so that lock fencing, concurrent initialization, initialization failure, rolling upgrades and primary/replica failover are all covered end to end. It is an external, opt-in test suite: it needs Docker plus a compiled binary supplied through BAO_BINARY, and it deliberately skips otherwise so the ordinary unit test run stays fast and dependency-free.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/postgresql_binary/postgresql_test.go` file postgresql_test.go (third_party/openbao/internal/vault/external_tests/postgresql_binary/postgresql_test.go)
<!-- SPECD_MANAGED_END -->
