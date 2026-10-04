# Context: third-party-openbao-internal-vault-external-tests-standby

Repository: `deno-kcp`

This context exists to pin down, as executable tests, the contract that a standby node in an OpenBao/Vault-style cluster remains readable: it serves read requests for data written on the primary, it must not accept a token that the primary has revoked, and write or wrapping operations it cannot serve locally must be refused with a forwarding error rather than handled. It lives under third_party/openbao as upstream external tests, so it exercises the public-ish surface (vault.NewTestCluster, Core.Standby, Core.HAState, Core.HandleRequest, logical.ShouldForward, teststorage.RaftBackendSetup, testhelpers.WaitForActiveNodeAndStandbys) rather than internals, and is kept so the deno-kcp repository inherits upstream regression coverage for standby semantics.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/standby/read_only_standby_test.go` file read_only_standby_test.go (third_party/openbao/internal/vault/external_tests/standby/read_only_standby_test.go)
<!-- SPECD_MANAGED_END -->
