# Context: third-party-openbao-internal-builtin-database-postgresql-scram

Repository: `deno-kcp`

Provide the PostgreSQL database engine with correct SCRAM verifier generation so generated role passwords are stored by the server in the salted-challenge form PostgreSQL validates. It exists as a small, self-contained third-party package under internal/builtin/database/postgresql/scram/, keeping the hashing primitive separate from the engine's connection and role management logic and testable in isolation through scram_test.go.

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
interfaces:
- file: third_party/openbao/internal/builtin/database/postgresql/scram/scram.go
  kind: function
  name: Hash
  signature: func Hash(password string) (string, error)
requirements:
- codeRefs:
  - file:third_party/openbao/internal/builtin/database/postgresql/scram/scram_test.go
  id: r.covered-by-packagetest
  level: SHOULD
  text: Hash should stay covered by the package test TestScram in scram_test.go.
- codeRefs:
  - file:third_party/openbao/internal/builtin/database/postgresql/scram/scram.go
  - function:53aa3d2f85a8cd7297a7bbf1a8fbf621
  id: r.derive-with-fixed-parameters
  level: MUST
  text: Hash must derive the password with hashPassword using the package constants
    iterationCnt and digestLen, matching the salting parameters PostgreSQL expects.
- codeRefs:
  - file:third_party/openbao/internal/builtin/database/postgresql/scram/scram.go
  - function:53aa3d2f85a8cd7297a7bbf1a8fbf621
  id: r.hash-returns-scram-verifier
  level: MUST
  text: Hash must accept a plaintext password and return the SCRAM verifier string
    for it, or an error if salt generation fails.
- codeRefs:
  - function:53aa3d2f85a8cd7297a7bbf1a8fbf621
  id: r.salt-failure-propagates
  level: MUST
  text: When genSalt fails, Hash must return the empty string together with the underlying
    error rather than a partial hash.
- codeRefs:
  - file:third_party/openbao/internal/builtin/database/postgresql/scram/scram.go
  - function:53aa3d2f85a8cd7297a7bbf1a8fbf621
  id: r.salt-generated-per-call
  level: MUST
  text: Hash must generate a fresh random salt of saltSize bytes on every call via
    genSalt, so the same password hashes differently each time.
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/database/postgresql/scram/scram.go` file scram.go (third_party/openbao/internal/builtin/database/postgresql/scram/scram.go)
- `file:third_party/openbao/internal/builtin/database/postgresql/scram/scram_test.go` file scram_test.go (third_party/openbao/internal/builtin/database/postgresql/scram/scram_test.go)
- `function:53aa3d2f85a8cd7297a7bbf1a8fbf621` function Hash (third_party/openbao/internal/builtin/database/postgresql/scram/scram.go)
<!-- SPECD_MANAGED_END -->
