# Context: third-party-openbao-internal-vault-external-tests-misc-misc-binary

Repository: `deno-kcp`

This context exists to pin down the behavior of the OpenBao recovery-mode external test so that the surrounding specification knows what that file guarantees: that recovery mode gates nearly every API path behind a recovery token, that sys/raw can be used under a recovery token to mutate persisted data directly, and that such mutations survive a return to normal mode. It is an acceptance test that only runs when a real OpenBao binary is supplied, so its requirements describe conditional, environment-gated behavior rather than production code paths.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/misc/misc_binary/recovery_test.go` file recovery_test.go (third_party/openbao/internal/vault/external_tests/misc/misc_binary/recovery_test.go)
<!-- SPECD_MANAGED_END -->
