# Context: third-party-openbao-internal-builtin-database-cassandra-cassandra-database-plugin

Repository: `deno-kcp`

This context exists to pin the contract of the Cassandra database plugin binary: a thin entry point whose only job is to hand a constructor to dbplugin.ServeMultiplex so the OpenBao database secrets engine can serve Cassandra connections out of process. The spec records that Run is the exported surface callers and tests can invoke, and that all Cassandra behavior lives in the referenced cassandra package rather than in this file.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/database/cassandra/cassandra-database-plugin/main.go` file main.go (third_party/openbao/internal/builtin/database/cassandra/cassandra-database-plugin/main.go)
- `function:17b561dc752a0a1fe20a249ae6b8a9bb` function Run (third_party/openbao/internal/builtin/database/cassandra/cassandra-database-plugin/main.go)
<!-- SPECD_MANAGED_END -->
