# Context: third-party-openbao-internal-builtin-database-cassandra-test-fixtures-no-tls

Repository: `deno-kcp`

The context exists so the Cassandra database plugin can be exercised against a real server that speaks plain, unencrypted CQL. Acceptance tests for the plugin need a deterministic local node, so this fixture pins a fixed cluster name, a fixed seed address, and disabled client encryption, removing TLS certificate setup from the test path. Keeping the fixture under a directory named no_tls makes the encrypted and unencrypted test topologies separate and self-describing, and isolating it from Go source keeps the configuration editable as data rather than code.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/database/cassandra/test-fixtures/no_tls/cassandra.yaml` file cassandra.yaml (third_party/openbao/internal/builtin/database/cassandra/test-fixtures/no_tls/cassandra.yaml)
<!-- SPECD_MANAGED_END -->
