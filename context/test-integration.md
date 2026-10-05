# Context: test-integration

Repository: `deno-kcp`

This context exists to hold the end-to-end contract of deno-kcp: that the shipped example manifests are loadable, complete, mutually wired and schema-valid without any cluster, and that the same manifests actually reconcile on a real kcp against a real deno runtime and a real OpenBao. It is where the repository proves its published examples are not merely plausible files but working inputs, where the live fixture encodes the cluster topology (kine, kcp, provider workspaces, typed reads with bounded polling) that makes a live run reproducible, and where the certificate hierarchy a deno pod depends on is demonstrated rather than assumed. Everything here is a test, so its outputs are pass/fail facts about the product surface: no production code depends on it, but a change to the examples, the schemas, the CRD types or the OpenBao integration is meant to break here first.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:test/integration/bao_test.go` file bao_test.go (test/integration/bao_test.go)
- `file:test/integration/examples.go` file examples.go (test/integration/examples.go)
- `file:test/integration/fixture_test.go` file fixture_test.go (test/integration/fixture_test.go)
- `file:test/integration/live_test.go` file live_test.go (test/integration/live_test.go)
- `file:test/integration/offline_test.go` file offline_test.go (test/integration/offline_test.go)
- `file:test/integration/openbao_live_test.go` file openbao_live_test.go (test/integration/openbao_live_test.go)
<!-- SPECD_MANAGED_END -->
