# Context: third-party-openbao-ui-app-routes-vault-cluster-access-oidc-clients-client

Repository: `deno-kcp`

These files exist to give each OIDC client detail screen its own routable sub-state: a details view, an edit view, and a providers list view reachable at .../clients/client/providers. The empty details and edit routes are deliberate placeholders that rely on the parent route's model and on the corresponding templates; only the providers route needs its own data fetch, because the set of identity providers allowed to use a given client is not part of the client record itself and must be queried separately by allowed_client_id. The nested route structure lets the UI render client details, client edit form, and client-to-provider associations under a single client model without refetching the client for each tab.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:56f63b8c4d657f5b5b97e5a1e90267fe` class OidcClientEditRoute (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/clients/client/edit.js)
- `class:7f1cb0f1c4fee1deecf68d6f592c15b5` class OidcClientDetailsRoute (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/clients/client/details.js)
- `class:d81a601a448cf767deb20b2bd5266e2e` class OidcClientProvidersRoute (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/clients/client/providers.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/oidc/clients/client/details.js` file details.js (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/clients/client/details.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/oidc/clients/client/edit.js` file edit.js (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/clients/client/edit.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/oidc/clients/client/providers.js` file providers.js (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/clients/client/providers.js)
<!-- SPECD_MANAGED_END -->
