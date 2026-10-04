# Context: third-party-openbao-ui-app-routes-vault-cluster-access-oidc-clients

Repository: `deno-kcp`

These routes exist to give the OIDC clients section of the Vault/OpenBao cluster UI its data-loading layer, separating list, create and single-record views. The index route decides whether the clients feature is usable at all by treating a missing endpoint as an empty list and bouncing the user back to the parent OIDC overview when nothing is configured; the create route supplies an empty record so the form can be submitted without a prior fetch; the detail route resolves one client by name from the URL so its page can render and later save that record. The context is documentation of that routing contract: what each hook returns, which errors are absorbed, and when navigation happens.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:2d968cb3f138f4f31ab2e3967a250731` class OidcClientsCreateRoute (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/clients/create.js)
- `class:3ce6a1eed54513f2c5b2a3bfe2248ddb` class OidcClientsRoute (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/clients/index.js)
- `class:91d9f27e0daca8c8005f1d15f2c4cce0` class OidcClientRoute (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/clients/client.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/oidc/clients/client.js` file client.js (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/clients/client.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/oidc/clients/create.js` file create.js (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/clients/create.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/oidc/clients/index.js` file index.js (third_party/openbao/ui/app/routes/vault/cluster/access/oidc/clients/index.js)
<!-- SPECD_MANAGED_END -->
