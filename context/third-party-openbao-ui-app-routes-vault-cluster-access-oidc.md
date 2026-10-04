# Context: third-party-openbao-ui-app-routes-vault-cluster-access-oidc

Repository: `deno-kcp`

This context exists to record the OIDC access index route of the OpenBao UI: the page a user reaches under a cluster's access section for OIDC. Its purpose is to decide, before the index template renders, whether any OIDC clients already exist; if they do, the user is sent straight to the client list, and if they do not (the adapter raises 404 for an empty collection), the index route stays in place to present the first-time setup call to action. Documenting it makes that redirect contract, the injected services it depends on, and its error-swallowing rule explicit for anyone changing the OIDC routing tree or the oidc/client adapter.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:fa1e6bf6840a2041d782e2d621e3dd2f` class OidcConfigureRoute (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/index.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/oidc/index.js` file index.js (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/index.js)
<!-- SPECD_MANAGED_END -->
