# Context: third-party-openbao-ui-app-routes-vault-cluster-access-oidc-scopes

Repository: `deno-kcp`

This context pins down the routing and model-resolution contract for the OIDC scope list, create, and detail screens in the OpenBao UI so that changes to those screens, or a port of them, keep the same store-backed model contract. It records that the create route hands out a client-side `oidc/scope` record rather than a fetched one, that the index route resolves its model with no parameters, and that the detail route is keyed on a `{ name }` parameter taken from the URL. It exists to make the three route classes, their injected `store` service, and their `model` hook shapes explicitly specified rather than implicit in the source.

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
