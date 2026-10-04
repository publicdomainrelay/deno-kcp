# Context: third-party-openbao-internal-builtin-database-postgresql-postgresql-database-plugin

Repository: `deno-kcp`

This context exists to pin down the executable entrypoint that registers the PostgreSQL database plugin with OpenBao's dbplugin RPC layer. It is a packaging and wiring artifact, not behavior: its whole job is to hand a constructor, postgresql.New, to dbplugin.ServeMultiplex so the plugin binary can be spawned as a separate process and satisfy the dbplugin.Database interface (Initialize, NewUser, UpdateUser, DeleteUser, Type, Close). Anyone asking where the PostgreSQL database plugin process starts, or which constructor a build must link, gets that answer here.

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
interfaces:
- file: third_party/openbao/internal/builtin/database/postgresql/postgresql-database-plugin/main.go
  kind: function
  name: Run
  signature: func Run() error
requirements:
- codeRefs:
  - file:third_party/openbao/internal/builtin/database/postgresql/postgresql-database-plugin/main.go
  id: r.main-invokes-run
  level: MUST
  text: The package main function must call Run to start the plugin's RPC server.
- codeRefs:
  - file:third_party/openbao/internal/builtin/database/postgresql/postgresql-database-plugin/main.go
  - function:272db5b46bd8b16153d2b40a43c9e229
  id: r.no-database-logic-in-entrypoint
  level: SHOULD
  text: 'The plugin entrypoint should stay a thin shim: PostgreSQL connection and
    credential logic should live in the postgresql package reached through postgresql.New,
    not in this file.'
- codeRefs:
  - file:third_party/openbao/internal/builtin/database/postgresql/postgresql-database-plugin/main.go
  - function:272db5b46bd8b16153d2b40a43c9e229
  id: r.run-serves-postgresql-database-plugin
  level: MUST
  text: Run must instantiate the PostgreSQL database object by passing the postgresql.New
    constructor to dbplugin.ServeMultiplex, and must return nil after serving starts.
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/database/postgresql/postgresql-database-plugin/main.go` file main.go (third_party/openbao/internal/builtin/database/postgresql/postgresql-database-plugin/main.go)
- `function:272db5b46bd8b16153d2b40a43c9e229` function Run (third_party/openbao/internal/builtin/database/postgresql/postgresql-database-plugin/main.go)
<!-- SPECD_MANAGED_END -->
