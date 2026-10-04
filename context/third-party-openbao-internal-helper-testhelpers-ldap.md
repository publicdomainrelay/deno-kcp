# Context: third-party-openbao-internal-helper-testhelpers-ldap

Repository: `deno-kcp`

This context exists so test suites that exercise OpenBao's LDAP authentication and secrets-engine paths have a real directory server to talk to without an external fixture. The helper hides container lifecycle, port mapping, and readiness polling behind one call, and hands back a ready-to-use ldaputil.ConfigEntry plus a cleanup func so each test can bind, search, and tear down deterministically. It is a third-party (openbao) internal helper vendored into this repository, not application code.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/helper/testhelpers/ldap/ldaphelper.go` file ldaphelper.go (third_party/openbao/internal/helper/testhelpers/ldap/ldaphelper.go)
- `function:39dc4dc3575e0e09a7e68e2f222352c0` function PrepareTestContainer (third_party/openbao/internal/helper/testhelpers/ldap/ldaphelper.go)
<!-- SPECD_MANAGED_END -->
