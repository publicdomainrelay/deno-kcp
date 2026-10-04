# Context: third-party-openbao-internal-vault-external-tests-pprof

Repository: `deno-kcp`

This context exists to specify the external pprof verification surface of the vendored OpenBao tree, so the pprof endpoints of a running Vault-compatible cluster stay covered by tests that live outside the core packages. It pins down what the two exported entrypoints must do to a live cluster: which pprof paths get exercised, how the requests are configured, which responses count as failures, and that the standby node is probed directly alongside the active node. It is written for readers who need to know the contract of these exported test helpers without reading the vendored source.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/pprof/pprof.go` file pprof.go (third_party/openbao/internal/vault/external_tests/pprof/pprof.go)
- `file:third_party/openbao/internal/vault/external_tests/pprof/pprof_test.go` file pprof_test.go (third_party/openbao/internal/vault/external_tests/pprof/pprof_test.go)
- `function:72ef1ad28d2ed5526bdb4e9b55b31211` function SysPprof_Test (third_party/openbao/internal/vault/external_tests/pprof/pprof.go)
- `function:a8b945b73826f471cf2d88027c833677` function SysPprof_Standby_Test (third_party/openbao/internal/vault/external_tests/pprof/pprof.go)
<!-- SPECD_MANAGED_END -->
