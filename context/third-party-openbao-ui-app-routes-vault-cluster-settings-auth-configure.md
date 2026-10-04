# Context: third-party-openbao-ui-app-routes-vault-cluster-settings-auth-configure

Repository: `deno-kcp`

This context exists so the auth-method settings screens can reuse one route for every supported auth backend instead of one route per backend. index.js always lands on the first available tab, and section.js interprets the tab name to pick the right auth-config model (aws, azure, github, gcp, jwt, oidc, kubernetes, ldap, okta, radius), fetch it from the API, and tolerate the API 404 that means no configuration has been saved yet. The reset hook keeps the shared controller clean when the user leaves a section.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/routes/vault/cluster/settings/auth/configure/index.js` file index.js (third_party/openbao/ui/app/routes/vault/cluster/settings/auth/configure/index.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/settings/auth/configure/section.js` file section.js (third_party/openbao/ui/app/routes/vault/cluster/settings/auth/configure/section.js)
<!-- SPECD_MANAGED_END -->
