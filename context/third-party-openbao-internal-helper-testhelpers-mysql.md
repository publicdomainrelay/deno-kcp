# Context: third-party-openbao-internal-helper-testhelpers-mysql

Repository: `deno-kcp`

The context exists to give the OpenBao test suite a single, reusable way to stand up a disposable MySQL server and to verify dynamically generated database credentials against it. Tests for the MySQL database secrets engine need a real server, and duplicating container startup logic in every test would be slow to maintain. This package centralizes the image selection, the readiness probe, and the connection string format, and it allows CI environments that already provide a MySQL server to short-circuit container startup through the MYSQL_URL environment variable. TestCredsExist exists so a test can assert that credentials minted by the secrets engine actually authenticate, which is the core behavior those tests exercise.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/helper/testhelpers/mysql/mysqlhelper.go` file mysqlhelper.go (third_party/openbao/internal/helper/testhelpers/mysql/mysqlhelper.go)
- `function:49b703949fe78718321a963bd7dc8e5f` function TestCredsExist (third_party/openbao/internal/helper/testhelpers/mysql/mysqlhelper.go)
- `function:5bb34b89c4a7b9aafbb8201734a768a5` function PrepareTestContainer (third_party/openbao/internal/helper/testhelpers/mysql/mysqlhelper.go)
- `struct:f5374581f30f9f80a49e719a95f6d25f` struct Config (third_party/openbao/internal/helper/testhelpers/mysql/mysqlhelper.go)
<!-- SPECD_MANAGED_END -->
