# Context: third-party-openbao-internal-helper-testhelpers-ldap

Repository: `deno-kcp`

The helper exists so every test that exercises OpenBao's LDAP auth method or LDAP-backed secrets engine can obtain a working directory server without an external fixture or manual container setup. One call hides image selection, port mapping, and readiness polling behind a single function, and hands back both a ready-to-use ldaputil.ConfigEntry and a cleanup func, so a test binds, searches, and tears down deterministically. It is vendored third-party OpenBao internal test code in this repository, not application logic, and is compiled only into test binaries.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/helper/testhelpers/ldap/ldaphelper.go` file ldaphelper.go (third_party/openbao/internal/helper/testhelpers/ldap/ldaphelper.go)
- `function:39dc4dc3575e0e09a7e68e2f222352c0` function PrepareTestContainer (third_party/openbao/internal/helper/testhelpers/ldap/ldaphelper.go)
<!-- SPECD_MANAGED_END -->
