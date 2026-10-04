# Context: third-party-openbao-ui-app-controllers-vault-cluster-access

Repository: `deno-kcp`

This context exists to record the observable contract of the two vendored OpenBao UI controllers in the vault/cluster/access folder, so that the auth-methods list filtering behavior and the OIDC header state machine can be referenced, tested or modified without re-reading the Ember source. It names the state each controller owns, the derived values it computes from the route model, and the route-name conditions that drive the OIDC header.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:808950ebb775d7e1cc279bd796289cf6` class VaultClusterAccessMethodsController (third_party/openbao/ui/app/controllers/vault/cluster/access/methods.js)
- `class:d01e2b33e4201cbf01aa4907d05d3f85` class OidcConfigureController (third_party/openbao/ui/app/controllers/vault/cluster/access/oidc.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/access/methods.js` file methods.js (third_party/openbao/ui/app/controllers/vault/cluster/access/methods.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/access/oidc.js` file oidc.js (third_party/openbao/ui/app/controllers/vault/cluster/access/oidc.js)
<!-- SPECD_MANAGED_END -->
