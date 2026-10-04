# Context: third-party-openbao-internal-builtin-database-postgresql

Repository: `deno-kcp`

The context exists so the PostgreSQL database secrets engine can be read as a self-contained specification: what the plugin is constructed from, which dbplugin v5 methods it must satisfy, and which configuration keys (username_template, password_authentication) it accepts. It anchors the third-party vendored OpenBao code inside the deno-kcp repository so that the plugin's contract, and any local modifications to it, stay describable and traceable.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/database/postgresql/passwordauthentication.go` file passwordauthentication.go (third_party/openbao/internal/builtin/database/postgresql/passwordauthentication.go)
- `file:third_party/openbao/internal/builtin/database/postgresql/postgresql.go` file postgresql.go (third_party/openbao/internal/builtin/database/postgresql/postgresql.go)
- `file:third_party/openbao/internal/builtin/database/postgresql/postgresql_test.go` file postgresql_test.go (third_party/openbao/internal/builtin/database/postgresql/postgresql_test.go)
- `function:a2a5d9dc98ae361cc50affb0d7d7c011` function New (third_party/openbao/internal/builtin/database/postgresql/postgresql.go)
- `method:104c6501594ab33e3be68a4b13902493` method PostgreSQL.Initialize (third_party/openbao/internal/builtin/database/postgresql/postgresql.go)
- `method:48ca6109fb985aad531f4872bc2dd8aa` method PostgreSQL.DeleteUser (third_party/openbao/internal/builtin/database/postgresql/postgresql.go)
- `method:6ab2c58e15ee2bf7219365719071ae5b` method PostgreSQL.PluginVersion (third_party/openbao/internal/builtin/database/postgresql/postgresql.go)
- `method:816e944b2d4f0ba8b0c57ddc24124a85` method PostgreSQL.Type (third_party/openbao/internal/builtin/database/postgresql/postgresql.go)
- `method:e94446bf68d072b3dca3e5d40854d882` method PostgreSQL.NewUser (third_party/openbao/internal/builtin/database/postgresql/postgresql.go)
- `method:fee9a15454325c0f80242ad693eab42a` method PostgreSQL.UpdateUser (third_party/openbao/internal/builtin/database/postgresql/postgresql.go)
- `struct:28e857d7ee88863c8395d0194dcedc5e` struct PostgreSQL (third_party/openbao/internal/builtin/database/postgresql/postgresql.go)
<!-- SPECD_MANAGED_END -->
