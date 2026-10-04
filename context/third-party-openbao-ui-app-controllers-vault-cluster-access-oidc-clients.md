# Context: third-party-openbao-ui-app-controllers-vault-cluster-access-oidc-clients

Repository: `deno-kcp`

This context exists to pin down the observable contract of the OIDC client detail controller in the vendored OpenBao UI, so the route-observation behavior and the header-visibility rule cannot drift. It exists because the page header must disappear on the edit route, which requires the controller to track route transitions rather than assume a fixed route name. It depends on Ember's Controller base class for instantiation by the router, on the injected router service as the source of route-change events, and on the @tracked decorator so isEditRoute changes invalidate templates.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:655bb55c9ae5c9a164f5fc0c955e7c08` class OidcClientController (third_party/openbao/ui/app/controllers/vault/cluster/access/oidc/clients/client.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/access/oidc/clients/client.js` file client.js (third_party/openbao/ui/app/controllers/vault/cluster/access/oidc/clients/client.js)
<!-- SPECD_MANAGED_END -->
