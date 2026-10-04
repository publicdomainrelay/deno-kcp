# Context: third-party-openbao-internal-builtin-database-postgresql-postgresql-database-plugin

Repository: `deno-kcp`

This context exists to pin down the executable entrypoint that registers the PostgreSQL database plugin with OpenBao's dbplugin RPC layer. It is a packaging and wiring artifact, not behavior: its whole job is to hand a constructor, postgresql.New, to dbplugin.ServeMultiplex so the plugin binary can be spawned as a separate process and satisfy the dbplugin.Database interface (Initialize, NewUser, UpdateUser, DeleteUser, Type, Close). Anyone asking where the PostgreSQL database plugin process starts, or which constructor a build must link, gets that answer here.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/database/postgresql/postgresql-database-plugin/main.go` file main.go (third_party/openbao/internal/builtin/database/postgresql/postgresql-database-plugin/main.go)
- `function:272db5b46bd8b16153d2b40a43c9e229` function Run (third_party/openbao/internal/builtin/database/postgresql/postgresql-database-plugin/main.go)
<!-- SPECD_MANAGED_END -->
