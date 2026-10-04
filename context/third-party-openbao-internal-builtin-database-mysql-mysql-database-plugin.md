# Context: third-party-openbao-internal-builtin-database-mysql-mysql-database-plugin

Repository: `deno-kcp`

This context exists so the MySQL database backend can be shipped and executed as a separate process that OpenBao talks to over the dbplugin RPC protocol. The main.go entrypoint isolates only the composition step: construct the MySQL plugin with the standard (non-legacy) username template and register it with ServeMultiplex. Keeping this as its own binary lets the MySQL engine be built, versioned, and mounted independently of the OpenBao server binary, with the legacy username template variant living in a sibling plugin directory.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/database/mysql/mysql-database-plugin/main.go` file main.go (third_party/openbao/internal/builtin/database/mysql/mysql-database-plugin/main.go)
- `function:be112b15322625e038097c496588868a` function Run (third_party/openbao/internal/builtin/database/mysql/mysql-database-plugin/main.go)
<!-- SPECD_MANAGED_END -->
