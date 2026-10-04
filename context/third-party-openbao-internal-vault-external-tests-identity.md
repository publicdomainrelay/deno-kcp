# Context: third-party-openbao-internal-vault-external-tests-identity

Repository: `deno-kcp`

The suite exists to verify the identity secrets engine from outside its implementation package, so engine behaviour stays testable as internal code is refactored. Because the tests are external, they pin the externally observable contract of the engine: request paths, response fields, and error conditions. Each file targets one slice of identity, and together they must keep passing while the engine internals change, which makes the tests the standing specification of the engine's public behaviour rather than a description of any particular implementation.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/identity/aliases_test.go` file aliases_test.go (third_party/openbao/internal/vault/external_tests/identity/aliases_test.go)
- `file:third_party/openbao/internal/vault/external_tests/identity/cross_namespace_test.go` file cross_namespace_test.go (third_party/openbao/internal/vault/external_tests/identity/cross_namespace_test.go)
- `file:third_party/openbao/internal/vault/external_tests/identity/entities_test.go` file entities_test.go (third_party/openbao/internal/vault/external_tests/identity/entities_test.go)
- `file:third_party/openbao/internal/vault/external_tests/identity/group_aliases_test.go` file group_aliases_test.go (third_party/openbao/internal/vault/external_tests/identity/group_aliases_test.go)
- `file:third_party/openbao/internal/vault/external_tests/identity/groups_test.go` file groups_test.go (third_party/openbao/internal/vault/external_tests/identity/groups_test.go)
- `file:third_party/openbao/internal/vault/external_tests/identity/identity_test.go` file identity_test.go (third_party/openbao/internal/vault/external_tests/identity/identity_test.go)
- `file:third_party/openbao/internal/vault/external_tests/identity/login_mfa_duo_test.go` file login_mfa_duo_test.go (third_party/openbao/internal/vault/external_tests/identity/login_mfa_duo_test.go)
- `file:third_party/openbao/internal/vault/external_tests/identity/login_mfa_totp_test.go` file login_mfa_totp_test.go (third_party/openbao/internal/vault/external_tests/identity/login_mfa_totp_test.go)
- `file:third_party/openbao/internal/vault/external_tests/identity/oidc_provider_test.go` file oidc_provider_test.go (third_party/openbao/internal/vault/external_tests/identity/oidc_provider_test.go)
- `file:third_party/openbao/internal/vault/external_tests/identity/userlockouts_test.go` file userlockouts_test.go (third_party/openbao/internal/vault/external_tests/identity/userlockouts_test.go)
<!-- SPECD_MANAGED_END -->
