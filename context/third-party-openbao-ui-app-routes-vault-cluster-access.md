# Context: third-party-openbao-ui-app-routes-vault-cluster-access

Repository: `deno-kcp`

This context records the cluster-access routing surface of the vendored OpenBao web UI as a specification before any change to the vendored UI is made: the list route for auth methods, the OIDC configure placeholder route, and the identity, leases and per-method detail routes. It exists so the routes' data loading, param mapping and 404 behaviour stay fixed and reviewable while the UI is patched downstream.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:9373017409ee56837c91b943f45e421f` class VaultClusterAccessMethodsRoute (third_party/openbao/ui/app/routes/vault/cluster/access/methods.js)
- `class:bd9bfe3d7c9bb4073a2764299a2dd55e` class OidcConfigureRoute (third_party/openbao/ui/app/routes/vault/cluster/access/oidc.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/identity.js` file identity.js (third_party/openbao/ui/app/routes/vault/cluster/access/identity.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/leases.js` file leases.js (third_party/openbao/ui/app/routes/vault/cluster/access/leases.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/method.js` file method.js (third_party/openbao/ui/app/routes/vault/cluster/access/method.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/methods.js` file methods.js (third_party/openbao/ui/app/routes/vault/cluster/access/methods.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/oidc.js` file oidc.js (third_party/openbao/ui/app/routes/vault/cluster/access/oidc.js)
<!-- SPECD_MANAGED_END -->
