# Context: third-party-openbao-api-auth-ldap

Repository: `deno-kcp`

This context documents the vendored OpenBao LDAP authentication helper so its contract stays pinned to the code that ships in-tree. It exists because the file is third-party code copied into the repository rather than imported: the surrounding project depends on the exact behavior of NewLDAPAuth, LDAPAuth.Login, Password, LoginOption, and WithMountPath, and any local patch or upgrade must preserve the validation errors, the password-source precedence, the default mount path, and the write path that the rest of the tree relies on. The spec records those obligations, plus the compile-time api.AuthMethod assertion and the test file, so drift is visible.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/api/auth/ldap/ldap.go` file ldap.go (third_party/openbao/api/auth/ldap/ldap.go)
- `file:third_party/openbao/api/auth/ldap/ldap_test.go` file ldap_test.go (third_party/openbao/api/auth/ldap/ldap_test.go)
- `function:6b97c5af51e2fcc7c021f01f76b860fa` function NewLDAPAuth (third_party/openbao/api/auth/ldap/ldap.go)
- `function:cfc4c249d2f4e73eba4e8982bcbf4692` function WithMountPath (third_party/openbao/api/auth/ldap/ldap.go)
- `method:7883bf85aa412b42f30a2fd6ccb9e0d3` method LDAPAuth.Login (third_party/openbao/api/auth/ldap/ldap.go)
- `struct:07bf6c0373565c007ccb05ed56ccb1c3` struct LDAPAuth (third_party/openbao/api/auth/ldap/ldap.go)
- `struct:d967b30d769c5a955fb2372261c1950e` struct Password (third_party/openbao/api/auth/ldap/ldap.go)
- `type_alias:17d8d2b686c300dfc2d55d97cb878aec` type_alias LoginOption (third_party/openbao/api/auth/ldap/ldap.go)
<!-- SPECD_MANAGED_END -->
