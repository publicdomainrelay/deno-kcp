# Context: third-party-openbao-internal-vault-external-tests-approle

Repository: `deno-kcp`

This context exists to pin down the externally observable behavior of the AppRole credential backend when mounted in a real OpenBao server: that malformed login payloads fail cleanly instead of triggering an internal error, and that response-wrapped secret-id reads expose the same accessor as the unwrapped secret. It is a regression surface for the AppRole auth method's login decoding and for secret-id wrapping metadata, exercised end to end through the HTTP API rather than through unit-level handler calls.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/approle/alias_name_panic_test.go` file alias_name_panic_test.go (third_party/openbao/internal/vault/external_tests/approle/alias_name_panic_test.go)
- `file:third_party/openbao/internal/vault/external_tests/approle/wrapped_secretid_test.go` file wrapped_secretid_test.go (third_party/openbao/internal/vault/external_tests/approle/wrapped_secretid_test.go)
<!-- SPECD_MANAGED_END -->
