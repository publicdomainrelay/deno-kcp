# Context: third-party-openbao-ui-app-controllers-vault-cluster-access-oidc-scopes-scope

Repository: `deno-kcp`

This context exists to describe the delete behavior of the OIDC scope details page. The controller is the UI action layer for removing an OIDC scope from the cluster access section: it is the only place that couples the scope model's destroyRecord to user feedback and to navigation back to the scope list, and it owns the rollback path that keeps the UI consistent when the server refuses the delete.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:ceedea0da2474d9eb16e36ffbddf3019` class OidcScopeDetailsController (third_party/openbao/ui/app/controllers/vault/cluster/access/oidc/scopes/scope/details.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/access/oidc/scopes/scope/details.js` file details.js (third_party/openbao/ui/app/controllers/vault/cluster/access/oidc/scopes/scope/details.js)
<!-- SPECD_MANAGED_END -->
