# Context: third-party-openbao-internal-builtin-database-postgresql-scram

Repository: `deno-kcp`

Provide the PostgreSQL database engine with correct SCRAM verifier generation so generated role passwords are stored by the server in the salted-challenge form PostgreSQL validates. It exists as a small, self-contained third-party package under internal/builtin/database/postgresql/scram/, keeping the hashing primitive separate from the engine's connection and role management logic and testable in isolation through scram_test.go.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/database/postgresql/scram/scram.go` file scram.go (third_party/openbao/internal/builtin/database/postgresql/scram/scram.go)
- `file:third_party/openbao/internal/builtin/database/postgresql/scram/scram_test.go` file scram_test.go (third_party/openbao/internal/builtin/database/postgresql/scram/scram_test.go)
- `function:53aa3d2f85a8cd7297a7bbf1a8fbf621` function Hash (third_party/openbao/internal/builtin/database/postgresql/scram/scram.go)
<!-- SPECD_MANAGED_END -->
