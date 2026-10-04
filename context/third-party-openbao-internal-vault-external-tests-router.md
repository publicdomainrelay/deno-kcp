# Context: third-party-openbao-internal-vault-external-tests-router

Repository: `deno-kcp`

The context exists to pin down router behavior that only shows up end to end: how mounts at nested subpaths resolve regardless of the order they are created, how they survive a seal/unseal cycle, and that a mount whose rollback function returns an error can still be reloaded and remounted. It is an external test package, so it is written against the api/v2 client and the HTTP handler, which keeps it decoupled from internal router types and guards the wiring between HTTP routing, core mount bookkeeping, and backend lifecycle.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/router/router_ext_test.go` file router_ext_test.go (third_party/openbao/internal/vault/external_tests/router/router_ext_test.go)
<!-- SPECD_MANAGED_END -->
