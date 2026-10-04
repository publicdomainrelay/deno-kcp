# Context: third-party-openbao-internal-builtin-database-mysql

Repository: `deno-kcp`

This context exists to specify the MySQL database secrets engine backend: the code that turns plugin configuration into a live, pooled MySQL connection and that issues, rotates and revokes database credentials for roles. It is the boundary where OpenBao's generic database plugin contracts (dbplugin and connutil) meet the go-sql-driver/mysql driver, so the spec must pin the configuration contract, the connection and failover behavior, the secret redaction rule, and the credential lifecycle entry points that the rest of the engine calls.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/database/mysql/connection_producer.go` file connection_producer.go (third_party/openbao/internal/builtin/database/mysql/connection_producer.go)
- `file:third_party/openbao/internal/builtin/database/mysql/connection_producer_test.go` file connection_producer_test.go (third_party/openbao/internal/builtin/database/mysql/connection_producer_test.go)
- `file:third_party/openbao/internal/builtin/database/mysql/mysql.go` file mysql.go (third_party/openbao/internal/builtin/database/mysql/mysql.go)
- `file:third_party/openbao/internal/builtin/database/mysql/mysql_test.go` file mysql_test.go (third_party/openbao/internal/builtin/database/mysql/mysql_test.go)
- `function:ab7a97517afe8744ec208e49efaa382c` function New (third_party/openbao/internal/builtin/database/mysql/mysql.go)
- `method:0b8132995d14bfa7b27f7f8395282f08` method MySQL.DeleteUser (third_party/openbao/internal/builtin/database/mysql/mysql.go)
- `method:0d811a165342ca2e1598b6fcbf4cd993` method MySQL.Initialize (third_party/openbao/internal/builtin/database/mysql/mysql.go)
- `method:1dcf4d26b3f813c8c805c7be795ed38d` method mySQLConnectionProducer.Connection (third_party/openbao/internal/builtin/database/mysql/connection_producer.go)
- `method:3dec55da06dfc4b9ab79d175e9c5f669` method mySQLConnectionProducer.SecretValues (third_party/openbao/internal/builtin/database/mysql/connection_producer.go)
- `method:428289802a4f07b84a7410d39be9bcd0` method MySQL.Type (third_party/openbao/internal/builtin/database/mysql/mysql.go)
- `method:442bc4e61ba09f7de989ce75450cf291` method mySQLConnectionProducer.Init (third_party/openbao/internal/builtin/database/mysql/connection_producer.go)
- `method:a5bc8db241ea4458270d9852cb464d37` method MySQL.UpdateUser (third_party/openbao/internal/builtin/database/mysql/mysql.go)
- `method:c3614388cef34b7f1d861709b81d21f1` method MySQL.NewUser (third_party/openbao/internal/builtin/database/mysql/mysql.go)
- `method:ccc37717bb59483c31e56f15b56eb65a` method mySQLConnectionProducer.Close (third_party/openbao/internal/builtin/database/mysql/connection_producer.go)
- `method:e50b9f1a12554552068bc1ef044fe986` method mySQLConnectionProducer.Initialize (third_party/openbao/internal/builtin/database/mysql/connection_producer.go)
- `struct:76f64e78002f3990882f31fc4fa973cd` struct MySQL (third_party/openbao/internal/builtin/database/mysql/mysql.go)
<!-- SPECD_MANAGED_END -->
