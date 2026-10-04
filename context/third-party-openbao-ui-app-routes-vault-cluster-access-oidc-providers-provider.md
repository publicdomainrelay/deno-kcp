# Context: third-party-openbao-ui-app-routes-vault-cluster-access-oidc-providers-provider

Repository: `deno-kcp`

The context exists so the OIDC provider detail page can resolve and display the clients that the provider is allowed to serve, and so its details and edit sub-pages are routable. The clients route bridges the parent provider route's allowedClientIds to the oidc/client store query, which is what populates the clients list in the UI, while the details and edit routes declare the two other tabs of the same provider page without adding behavior of their own.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:02a0be079c8f4ccb8d0be061596b9389` class OidcProviderEditRoute (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/providers/provider/edit.js)
- `class:116536b2b31847055cf83f89f3855b39` class OidcProviderClientsRoute (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/providers/provider/clients.js)
- `class:fad001fea8f402e1ac986c7ce606393b` class OidcProviderDetailsRoute (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/providers/provider/details.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/oidc/providers/provider/clients.js` file clients.js (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/providers/provider/clients.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/oidc/providers/provider/details.js` file details.js (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/providers/provider/details.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/oidc/providers/provider/edit.js` file edit.js (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/providers/provider/edit.js)
<!-- SPECD_MANAGED_END -->
