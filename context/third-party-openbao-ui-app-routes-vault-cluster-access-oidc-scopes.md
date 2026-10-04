# Context: third-party-openbao-ui-app-routes-vault-cluster-access-oidc-scopes

Repository: `deno-kcp`

The context exists to pin down the routing surface for OIDC scope management in the OpenBao web UI: which route classes exist for the list, create, and detail screens, how each obtains its Ember Data model from the injected store, and what parameters the detail route receives. It gives a specification of the observed router hooks so that changes to the OIDC scope screens keep the same store-backed model contract, and so anyone porting or reimplementing these screens knows that the create route hands out a client-side new `oidc/scope` record rather than a fetched one.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:271c3c6841cd1868b8eab40c1a455c38` class OidcScopeRoute (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/scopes/scope.js)
- `class:71b1fd9421b5a5c4c1980994eef2a999` class OidcScopesCreateRoute (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/scopes/create.js)
- `class:de9f6d7acd51217b2ef9cb3fa176a5b0` class OidcScopesRoute (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/scopes/index.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/oidc/scopes/create.js` file create.js (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/scopes/create.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/oidc/scopes/index.js` file index.js (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/scopes/index.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/oidc/scopes/scope.js` file scope.js (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/scopes/scope.js)
<!-- SPECD_MANAGED_END -->
