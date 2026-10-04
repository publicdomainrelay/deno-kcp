# Context: third-party-openbao-internal-builtin-database-cassandra-test-fixtures-with-tls

Repository: `deno-kcp`

The fixture exists so the Cassandra database backend tests can run against a Cassandra instance whose CQL native transport speaks TLS. The test helpers start Cassandra with this file mounted in place of the default cassandra.yaml, so the client-side connection producer exercises its TLS configuration path (CA certificate, client certificate and key, or insecure skip-verify) against a server that presents a real PEM certificate from /etc/cassandra/server.pem and rejects plaintext clients because optional is false. Keeping the fixture as a checked-in YAML rather than generated content makes the TLS assumptions explicit and reproducible for anyone running the acceptance tests.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/database/cassandra/test-fixtures/with_tls/cassandra.yaml` file cassandra.yaml (third_party/openbao/internal/builtin/database/cassandra/test-fixtures/with_tls/cassandra.yaml)
<!-- SPECD_MANAGED_END -->
