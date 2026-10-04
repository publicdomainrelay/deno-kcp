# Context: third-party-openbao-ui-lib-pki-addon-routes-roles-role

Repository: `deno-kcp`

These files exist so the OpenBao PKI secrets engine UI can render and drive the per-role screens: view a role, edit a role, generate a certificate from a role, and sign a certificate with a role. They form the routing layer that turns URL params plus the selected secrets mount into the Ember Data records the controllers and templates render, and they own the breadcrumb and unsaved-change-confirmation behavior for those screens.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:13f77d36ece7f79c59949a18346dfd23` class PkiRoleGenerateRoute (third_party/openbao/ui/lib/pki/addon/routes/roles/role/generate.js)
- `class:90b2455314cd905b3305d9d965346074` class RolesRoleDetailsRoute (third_party/openbao/ui/lib/pki/addon/routes/roles/role/details.js)
- `class:a2c23f3b2610327a5496643e076dd636` class PkiRoleSignRoute (third_party/openbao/ui/lib/pki/addon/routes/roles/role/sign.js)
- `class:b5067a024e68d3288237ecaabc776b56` class PkiRoleEditRoute (third_party/openbao/ui/lib/pki/addon/routes/roles/role/edit.js)
- `file:third_party/openbao/ui/lib/pki/addon/routes/roles/role/details.js` file details.js (third_party/openbao/ui/lib/pki/addon/routes/roles/role/details.js)
- `file:third_party/openbao/ui/lib/pki/addon/routes/roles/role/edit.js` file edit.js (third_party/openbao/ui/lib/pki/addon/routes/roles/role/edit.js)
- `file:third_party/openbao/ui/lib/pki/addon/routes/roles/role/generate.js` file generate.js (third_party/openbao/ui/lib/pki/addon/routes/roles/role/generate.js)
- `file:third_party/openbao/ui/lib/pki/addon/routes/roles/role/sign.js` file sign.js (third_party/openbao/ui/lib/pki/addon/routes/roles/role/sign.js)
<!-- SPECD_MANAGED_END -->
