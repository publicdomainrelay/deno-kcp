# Context: third-party-openbao-ui-app-controllers-vault-cluster-access-oidc-clients-client

Repository: `deno-kcp`

The context exists so the OIDC client details screen has a controller with a single destructive action: deleting the OIDC application being viewed. It is the UI-facing counterpart of the OIDC client read/delete path, kept separate from the list and creation screens so the details route can own deletion, user feedback, and post-delete navigation. Anyone changing how OIDC clients are deleted, how deletion errors are reported, or where the user lands after a delete must look here.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:dcd9216169acc4b1f83f8521996f79fa` class OidcClientDetailsController (third_party/openbao/ui/app/controllers/vault/cluster/access/oidc/clients/client/details.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/access/oidc/clients/client/details.js` file details.js (third_party/openbao/ui/app/controllers/vault/cluster/access/oidc/clients/client/details.js)
<!-- SPECD_MANAGED_END -->
