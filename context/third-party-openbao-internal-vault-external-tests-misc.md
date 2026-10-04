# Context: third-party-openbao-internal-vault-external-tests-misc

Repository: `deno-kcp`

This context exists to specify the recovery-mode and panic-recovery external tests of the OpenBao `misc` test package, which exercise the server-level behavior of raw storage access under a recovery operation token and the ability of the cluster to seal cleanly after a logical backend panics. It pins the observable contract those tests assert: what a recovery-mode cluster must reject, what a recovery token must grant, what survives a seal/unseal round trip, and that a panicking backend must not deadlock core shutdown. It is a specification of existing test code, not of new code.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/misc/recover_from_panic_test.go` file recover_from_panic_test.go (third_party/openbao/internal/vault/external_tests/misc/recover_from_panic_test.go)
- `file:third_party/openbao/internal/vault/external_tests/misc/recovery_test.go` file recovery_test.go (third_party/openbao/internal/vault/external_tests/misc/recovery_test.go)
<!-- SPECD_MANAGED_END -->
