# Context: third-party-openbao-internal-vault-external-tests-raft

Repository: `deno-kcp`

This context exists so that the raft external tests have a reusable, cluster-agnostic assertion for Raft configuration state instead of each test spelling out the sys/storage/raft/configuration parse and leader checks itself. The helper parameterizes the cluster as a testcluster.VaultCluster, so any cluster implementation the test suite builds can be handed to it, and it derives the expected membership from cluster.Nodes() rather than from a literal list, which keeps the expectation correct as the node count changes. The two test files exist to invoke that helper (TestRaft_Configuration) and to exercise autopilot behavior against the same cluster shape; the context is defined by the shared assertion, not by the individual test names.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/raft/raft.go` file raft.go (third_party/openbao/internal/vault/external_tests/raft/raft.go)
- `file:third_party/openbao/internal/vault/external_tests/raft/raft_autopilot_test.go` file raft_autopilot_test.go (third_party/openbao/internal/vault/external_tests/raft/raft_autopilot_test.go)
- `file:third_party/openbao/internal/vault/external_tests/raft/raft_test.go` file raft_test.go (third_party/openbao/internal/vault/external_tests/raft/raft_test.go)
- `function:3a883b33c1bea1968582334abdc0aae3` function Raft_Configuration_Test (third_party/openbao/internal/vault/external_tests/raft/raft.go)
<!-- SPECD_MANAGED_END -->
