# Context: third-party-openbao-ui-lib-pki-addon-routes-roles

Repository: `deno-kcp`

These routes exist to feed the PKI roles list and role creation screens with data taken from the secret engine mount that the user is browsing. Both classes inject the `store` and `secretMountPath` services so that every query is scoped to `secretMountPath.currentPath` rather than a fixed backend, which is what lets the same route serve any PKI mount in the UI. The 404 handling keeps a freshly mounted engine, whose role or issuer endpoints do not exist yet, from surfacing an error instead of an empty screen.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:238b6e12742a458a3bce1ac75810a4a6` class PkiRolesCreateRoute (third_party/openbao/ui/lib/pki/addon/routes/roles/create.js)
- `class:23a6de23f5f18e3cec44322f7d779e76` class PkiRolesIndexRoute (third_party/openbao/ui/lib/pki/addon/routes/roles/index.js)
- `file:third_party/openbao/ui/lib/pki/addon/routes/roles/create.js` file create.js (third_party/openbao/ui/lib/pki/addon/routes/roles/create.js)
- `file:third_party/openbao/ui/lib/pki/addon/routes/roles/index.js` file index.js (third_party/openbao/ui/lib/pki/addon/routes/roles/index.js)
<!-- SPECD_MANAGED_END -->
