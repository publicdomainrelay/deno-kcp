# Context: third-party-openbao-internal-builtin-database-mysql-mysql-legacy-database-plugin

Repository: `deno-kcp`

This context exists to pin down the behaviour of the legacy MySQL database plugin binary inside the vendored third-party OpenBao code, so that the plugin's construction path, username template choice, and RPC serving contract are described rather than inferred. It anchors one file and one function, and it records that the legacy plugin deliberately uses DefaultLegacyUserNameTemplate and dbplugin.Serve, which distinguishes it from the non-legacy MySQL plugin that uses DefaultUserNameTemplate and dbplugin.ServeMultiplex. It is a description of third-party code that is depended on, not code owned by this repository.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/database/mysql/mysql-legacy-database-plugin/main.go` file main.go (third_party/openbao/internal/builtin/database/mysql/mysql-legacy-database-plugin/main.go)
- `function:351b9cf78c3672814bcb525f1d453382` function Run (third_party/openbao/internal/builtin/database/mysql/mysql-legacy-database-plugin/main.go)
<!-- SPECD_MANAGED_END -->
