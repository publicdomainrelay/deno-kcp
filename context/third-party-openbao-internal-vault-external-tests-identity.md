# Context: third-party-openbao-internal-vault-external-tests-identity

Repository: `deno-kcp`

This context exists to verify the identity secrets engine from outside its implementation package, so engine behaviour stays testable across refactors of internal code. Each file targets one slice of identity: entity aliases, entity lifecycle, groups, group aliases, cross-namespace visibility, login MFA by Duo and by TOTP, OIDC provider behaviour, and user lockouts. Because the tests are external, they pin the externally observable contract of the identity engine — request paths, response fields, and error conditions — and must keep passing as the engine internals change.

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
