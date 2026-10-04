# Context: third-party-openbao-ui-app-routes-vault-cluster-access-oidc-keys-key

Repository: `deno-kcp`

This context exists to describe the per-key sub-routes of the OIDC keys section: the clients tab, which needs a real model hook to fetch only the clients allowed to use the key, and the details and edit tabs, which are declared only so Ember's router can resolve the leaf routes and let the shared parent key route plus their templates supply the data. The three files are grouped because they are siblings under the same parent resource and together define the navigable surface of one OIDC key.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:309b087d4c9c4a1f0fd91dc8477e7e4a` class OidcKeyDetailsRoute (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/keys/key/details.js)
- `class:f183f877c86c4b5ad32e290027c24aa4` class OidcKeyEditRoute (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/keys/key/edit.js)
- `class:f4b4ab88db913431c8b5d03cabb44e13` class OidcKeyClientsRoute (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/keys/key/clients.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/oidc/keys/key/clients.js` file clients.js (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/keys/key/clients.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/oidc/keys/key/details.js` file details.js (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/keys/key/details.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/oidc/keys/key/edit.js` file edit.js (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/keys/key/edit.js)
<!-- SPECD_MANAGED_END -->
