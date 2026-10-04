# Context: third-party-openbao-internal-vault-external-tests-kms

Repository: `deno-kcp`

The context exists to hold the shared external-test exercise code for OpenBao's KMS integration, so that both the builtin-transit and external-transit test entrypoints can drive the same transit and PKI scenarios against a real server. It separates the reusable exercise functions from the thin test functions, letting a KMS implementation be validated by mounting transit or PKI, binding keys through the sys/external-keys config and grant API, and exercising encrypt/decrypt and sign/verify or CA issuance over that external key. Its purpose is coverage of the external key workflow: the negative case where a transit external-key write is rejected before a grant, and the positive cases after the grant is written.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/kms/kms_test.go` file kms_test.go (third_party/openbao/internal/vault/external_tests/kms/kms_test.go)
- `file:third_party/openbao/internal/vault/external_tests/kms/testing.go` file testing.go (third_party/openbao/internal/vault/external_tests/kms/testing.go)
- `function:1017e8ef94de38bb38646b55bdd5cdd2` function ExercisePKIIntermediateCA (third_party/openbao/internal/vault/external_tests/kms/testing.go)
- `function:148d1fe5f4fb2681bed177ae23c84730` function ExercisePKICA (third_party/openbao/internal/vault/external_tests/kms/testing.go)
- `function:17f8e7ee21f0f651bc7f1594fa263d94` function ExercisePKIRootCA (third_party/openbao/internal/vault/external_tests/kms/testing.go)
- `function:190e0c5e008b566007f49bbd64546906` function SetupPKI (third_party/openbao/internal/vault/external_tests/kms/testing.go)
- `function:3046d2a4858afebec6428e34d78eebc0` function ExerciseTransitEncryptDecrypt (third_party/openbao/internal/vault/external_tests/kms/testing.go)
- `function:31b901d631b78a1f1fda76d2be91c7b6` function ExerciseTransitSignVerify (third_party/openbao/internal/vault/external_tests/kms/testing.go)
- `function:6c7d8b4d2c30fc31ec00d6d0d3307cb2` function ExercisePKIForKey (third_party/openbao/internal/vault/external_tests/kms/testing.go)
- `function:7bcc7c8885e937d749320e92a98f01aa` function ExerciseTransitWithTransitKMS (third_party/openbao/internal/vault/external_tests/kms/testing.go)
- `function:7fd87069f7f62de955ee069151b37731` function ExerciseTransitForKey (third_party/openbao/internal/vault/external_tests/kms/testing.go)
- `function:b8b8fc44db4b504bf330ecbdf5acfa78` function ExerciseTransitKMS (third_party/openbao/internal/vault/external_tests/kms/testing.go)
- `function:df15032a6d8494078e7470afa5e09cde` function SetupTransit (third_party/openbao/internal/vault/external_tests/kms/testing.go)
- `function:eb9d41a27c4d208e2a1660caa228c677` function ExercisePKIWithTransitKMS (third_party/openbao/internal/vault/external_tests/kms/testing.go)
<!-- SPECD_MANAGED_END -->
