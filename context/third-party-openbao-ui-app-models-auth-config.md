# Context: third-party-openbao-ui-app-models-auth-config

Repository: `deno-kcp`

This context exists because the OpenBao web UI must present a configuration form per auth method, and each form's shape is data-driven rather than hardcoded in templates. These nine modules are the client-side description of the approle, azure, cert, jwt/oidc, kubernetes, ldap, radius and userpass auth-method configs: they bind each method's backend fields to Ember Data attributes, group them into the sections the user sees, decorate them with labels, help text and edit types, and let fields the UI does not know about statically arrive at runtime from the server's OpenAPI schema through useOpenAPI and combineFieldGroups. The context is the per-method extension layer that sits on top of the shared auth-config base model; anything about ordering, sectioning, or control type of one method's settings is decided here.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/models/auth-config/approle.js` file approle.js (third_party/openbao/ui/app/models/auth-config/approle.js)
- `file:third_party/openbao/ui/app/models/auth-config/azure.js` file azure.js (third_party/openbao/ui/app/models/auth-config/azure.js)
- `file:third_party/openbao/ui/app/models/auth-config/cert.js` file cert.js (third_party/openbao/ui/app/models/auth-config/cert.js)
- `file:third_party/openbao/ui/app/models/auth-config/jwt.js` file jwt.js (third_party/openbao/ui/app/models/auth-config/jwt.js)
- `file:third_party/openbao/ui/app/models/auth-config/kubernetes.js` file kubernetes.js (third_party/openbao/ui/app/models/auth-config/kubernetes.js)
- `file:third_party/openbao/ui/app/models/auth-config/ldap.js` file ldap.js (third_party/openbao/ui/app/models/auth-config/ldap.js)
- `file:third_party/openbao/ui/app/models/auth-config/oidc.js` file oidc.js (third_party/openbao/ui/app/models/auth-config/oidc.js)
- `file:third_party/openbao/ui/app/models/auth-config/radius.js` file radius.js (third_party/openbao/ui/app/models/auth-config/radius.js)
- `file:third_party/openbao/ui/app/models/auth-config/userpass.js` file userpass.js (third_party/openbao/ui/app/models/auth-config/userpass.js)
<!-- SPECD_MANAGED_END -->
