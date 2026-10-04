# Context: third-party-openbao-internal-vault-external-tests-raftha

Repository: `deno-kcp`

This context exists to pin down the raft HA external tests of the vendored OpenBao tree: they exercise cluster formation over two physical backends and two TLS client-certificate modes, and they exercise growing an existing non-raft cluster into a raft-HA cluster while preserving barrier keys and the root token. It records what the tests set up and assert so that the join, peer-verification and peer-removal behaviour they depend on stays specified.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/raftha/raft_ha_test.go` file raft_ha_test.go (third_party/openbao/internal/vault/external_tests/raftha/raft_ha_test.go)
<!-- SPECD_MANAGED_END -->
