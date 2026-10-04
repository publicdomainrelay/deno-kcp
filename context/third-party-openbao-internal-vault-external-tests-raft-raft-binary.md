# Context: third-party-openbao-internal-vault-external-tests-raft-raft-binary

Repository: `deno-kcp`

This context exists so the raft configuration behaviour exercised by the shared external raft test suite is also covered against real docker-hosted vault nodes driven by a locally built binary, rather than only in-process nodes. It guards the join and reconfiguration path: the cluster must behave correctly both before and after a node is added, and the test only runs where a binary path is supplied, so developers without docker or a built binary get a skip instead of a failure.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/raft/raft_binary/raft_test.go` file raft_test.go (third_party/openbao/internal/vault/external_tests/raft/raft_binary/raft_test.go)
<!-- SPECD_MANAGED_END -->
