# Context: third-party-openbao-ui-app-adapters-auth-config

Repository: `deno-kcp`

The context exists to describe the auth-method configuration adapter layer of the vendored OpenBao UI: one shared base adapter that owns URL construction, path derivation and backend-id bookkeeping, plus per-auth-method subclasses that exist only so Ember can resolve a distinct adapter per model type. It is documented here so that changes to auth-config request routing or to any individual auth method's adapter can be reasoned about against the shared contract rather than file by file.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/adapters/auth-config/_base.js` file _base.js (third_party/openbao/ui/app/adapters/auth-config/_base.js)
- `file:third_party/openbao/ui/app/adapters/auth-config/azure.js` file azure.js (third_party/openbao/ui/app/adapters/auth-config/azure.js)
- `file:third_party/openbao/ui/app/adapters/auth-config/jwt.js` file jwt.js (third_party/openbao/ui/app/adapters/auth-config/jwt.js)
- `file:third_party/openbao/ui/app/adapters/auth-config/kubernetes.js` file kubernetes.js (third_party/openbao/ui/app/adapters/auth-config/kubernetes.js)
- `file:third_party/openbao/ui/app/adapters/auth-config/ldap.js` file ldap.js (third_party/openbao/ui/app/adapters/auth-config/ldap.js)
- `file:third_party/openbao/ui/app/adapters/auth-config/oidc.js` file oidc.js (third_party/openbao/ui/app/adapters/auth-config/oidc.js)
- `file:third_party/openbao/ui/app/adapters/auth-config/radius.js` file radius.js (third_party/openbao/ui/app/adapters/auth-config/radius.js)
<!-- SPECD_MANAGED_END -->
