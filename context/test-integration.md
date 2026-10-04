# Context: test-integration

Repository: `deno-kcp`

This context exists to hold the one test package that proves deno-kcp works against real infrastructure and against the checked-in examples. It separates what can be verified from the repository alone (offline_test.go, examples.go) from what needs a running kcp, kine, deno and policy-engine (live_test.go, fixture_test.go) from what additionally needs the pinned OpenBao (bao_test.go, openbao_live_test.go), so the cheap checks run everywhere and the expensive ones are gated behind explicit opt-in. The fixture layer exists so that every live test describes intent in terms of typed Kubernetes objects and named expectations rather than raw HTTP, and so the OpenBao version certificates are issued by is the one the repository pins, never whatever binary happens to be on PATH. The example registry covers every kcp-kind manifest the repository ships, including the atproto market manifests under deploy/examples/atproto/market, so the offline tier decodes and schema-fits them with no cluster.

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
