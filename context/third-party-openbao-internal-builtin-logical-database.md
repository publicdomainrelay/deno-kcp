# Context: third-party-openbao-internal-builtin-logical-database

Repository: `deno-kcp`

The context exists so the database secrets engine can be described and regenerated as one unit: it is the part of the vendored OpenBao tree responsible for configuring database connections, issuing dynamic and static credentials through database plugins, rotating root and static credentials, and revoking leases. It also carries the plugin-version abstraction that lets a single backend speak to both the legacy v4 database plugin interface and the v5 request/response interface, plus the mock plugins the test suite relies on.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/logical/database/backend.go` file backend.go (third_party/openbao/internal/builtin/logical/database/backend.go)
- `file:third_party/openbao/internal/builtin/logical/database/backend_test.go` file backend_test.go (third_party/openbao/internal/builtin/logical/database/backend_test.go)
- `file:third_party/openbao/internal/builtin/logical/database/credentials.go` file credentials.go (third_party/openbao/internal/builtin/logical/database/credentials.go)
- `file:third_party/openbao/internal/builtin/logical/database/credentials_test.go` file credentials_test.go (third_party/openbao/internal/builtin/logical/database/credentials_test.go)
- `file:third_party/openbao/internal/builtin/logical/database/mocks_test.go` file mocks_test.go (third_party/openbao/internal/builtin/logical/database/mocks_test.go)
- `file:third_party/openbao/internal/builtin/logical/database/mockv4.go` file mockv4.go (third_party/openbao/internal/builtin/logical/database/mockv4.go)
- `file:third_party/openbao/internal/builtin/logical/database/mockv5.go` file mockv5.go (third_party/openbao/internal/builtin/logical/database/mockv5.go)
- `file:third_party/openbao/internal/builtin/logical/database/path_config_connection.go` file path_config_connection.go (third_party/openbao/internal/builtin/logical/database/path_config_connection.go)
- `file:third_party/openbao/internal/builtin/logical/database/path_config_connection_test.go` file path_config_connection_test.go (third_party/openbao/internal/builtin/logical/database/path_config_connection_test.go)
- `file:third_party/openbao/internal/builtin/logical/database/path_creds_create.go` file path_creds_create.go (third_party/openbao/internal/builtin/logical/database/path_creds_create.go)
- `file:third_party/openbao/internal/builtin/logical/database/path_roles.go` file path_roles.go (third_party/openbao/internal/builtin/logical/database/path_roles.go)
- `file:third_party/openbao/internal/builtin/logical/database/path_roles_test.go` file path_roles_test.go (third_party/openbao/internal/builtin/logical/database/path_roles_test.go)
- `file:third_party/openbao/internal/builtin/logical/database/path_rotate_credentials.go` file path_rotate_credentials.go (third_party/openbao/internal/builtin/logical/database/path_rotate_credentials.go)
- `file:third_party/openbao/internal/builtin/logical/database/rollback.go` file rollback.go (third_party/openbao/internal/builtin/logical/database/rollback.go)
- `file:third_party/openbao/internal/builtin/logical/database/rollback_test.go` file rollback_test.go (third_party/openbao/internal/builtin/logical/database/rollback_test.go)
- `file:third_party/openbao/internal/builtin/logical/database/rotation.go` file rotation.go (third_party/openbao/internal/builtin/logical/database/rotation.go)
- `file:third_party/openbao/internal/builtin/logical/database/rotation_test.go` file rotation_test.go (third_party/openbao/internal/builtin/logical/database/rotation_test.go)
- `file:third_party/openbao/internal/builtin/logical/database/secret_creds.go` file secret_creds.go (third_party/openbao/internal/builtin/logical/database/secret_creds.go)
- `file:third_party/openbao/internal/builtin/logical/database/version_wrapper.go` file version_wrapper.go (third_party/openbao/internal/builtin/logical/database/version_wrapper.go)
- `file:third_party/openbao/internal/builtin/logical/database/version_wrapper_test.go` file version_wrapper_test.go (third_party/openbao/internal/builtin/logical/database/version_wrapper_test.go)
- `file:third_party/openbao/internal/builtin/logical/database/versioning_large_test.go` file versioning_large_test.go (third_party/openbao/internal/builtin/logical/database/versioning_large_test.go)
- `function:46b03c6a5071694623273c1859a79474` function Factory (third_party/openbao/internal/builtin/logical/database/backend.go)
- `function:602120409f1d3c280ad783306bdf1723` function RunV4 (third_party/openbao/internal/builtin/logical/database/mockv4.go)
- `function:625945c626d767c4238ce3a4d0ef9e59` function NewV4 (third_party/openbao/internal/builtin/logical/database/mockv4.go)
- `function:69f986706c3bf46fe5958edbeabb4471` function Backend (third_party/openbao/internal/builtin/logical/database/backend.go)
- `function:6a3315a2298212e20d7fe65e6b33d0df` function RunV5 (third_party/openbao/internal/builtin/logical/database/mockv5.go)
- `function:9590727b1790d44883ac5e32446d9815` function New (third_party/openbao/internal/builtin/logical/database/mockv5.go)
- `function:e0e35ed3467a27074242ec85380b5890` function RunV6Multiplexed (third_party/openbao/internal/builtin/logical/database/mockv5.go)
- `method:06211080d95cd2246ec3ae8f2539325d` method MockDatabaseV5.UpdateUser (third_party/openbao/internal/builtin/logical/database/mockv5.go)
- `method:0c3d1048e3c9ef9e668c347b6704756b` method staticAccount.CredentialTTL (third_party/openbao/internal/builtin/logical/database/path_roles.go)
- `method:0ef6e016c964d2998368213081a1fe62` method DatabaseConfig.SupportsCredentialType (third_party/openbao/internal/builtin/logical/database/path_config_connection.go)
- `method:102323d53aba8f635a3085ddef98327f` method databaseBackend.StaticRole (third_party/openbao/internal/builtin/logical/database/backend.go)
- `method:171b816c74e0728d13ec042f10e27f4f` method MockDatabaseV5.Type (third_party/openbao/internal/builtin/logical/database/mockv5.go)
- `method:21045c51cbf5612d8ff03b9967a11589` method databaseBackend.DatabaseConfig (third_party/openbao/internal/builtin/logical/database/backend.go)
- `method:3409ee4597651f3731a33c632acfe7f8` method MockDatabaseV4.Type (third_party/openbao/internal/builtin/logical/database/mockv4.go)
- `method:3602402a0da7635c4715341b96e7c0f7` method databaseVersionWrapper.Initialize (third_party/openbao/internal/builtin/logical/database/version_wrapper.go)

_31 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
