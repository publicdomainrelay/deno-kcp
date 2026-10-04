# Context: third-party-openbao-ui-app-controllers-vault-cluster-access-oidc-providers

Repository: `deno-kcp`

This context exists to pin down the behavior of the OIDC provider route controller inside the OpenBao UI so that the edit-route detection and header-visibility contract are specified rather than inferred. It records that route state is derived from the router's routeDidChange event by substring match on the route name, and that the header is shown only outside the edit route. Anyone porting, refactoring, or testing the OIDC providers UI needs this contract: the controller holds no other state and computes no other derived value.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:fb0235e29ebf4a2474c3616b1c9d07cd` class OidcProviderController (third_party/openbao/ui/app/controllers/vault/cluster/access/oidc/providers/provider.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/access/oidc/providers/provider.js` file provider.js (third_party/openbao/ui/app/controllers/vault/cluster/access/oidc/providers/provider.js)
<!-- SPECD_MANAGED_END -->
