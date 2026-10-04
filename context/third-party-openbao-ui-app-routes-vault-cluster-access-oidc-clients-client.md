# Context: third-party-openbao-ui-app-routes-vault-cluster-access-oidc-clients-client

Repository: `deno-kcp`

This context exists so the client details view, the client edit form, and the client-to-provider associations can each be addressed as their own nested route under a single client model. The details and edit routes are deliberately empty: they need no data of their own because the parent route already fetched the client, and the corresponding templates render against that inherited model. Only the providers route owns a fetch, because the set of identity providers permitted to use a given client is not a field on the client record; it is discovered by querying the oidc/provider type with the allowed_client_id filter, and a 404 from that query means no providers are linked rather than an error worth surfacing. The split keeps one client load shared across three tabs instead of refetching per screen.

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
