# Context: third-party-openbao-ui-app-routes-vault-cluster-access-method

Repository: `deno-kcp`

These routes exist to route the user into the correct sub-view of an authentication method in the OpenBao UI. The index route exists so that visiting an auth method with no further path forwards the user to the first tab of that method, computed from the method type and its navigable paths. The item route exists so that a URL naming an item type (for example a role or a user) builds the corresponding generated model type and populates the controller with the navigable paths belonging to that item type. The section route exists to guard the method's configuration section, so that only the section named 'configuration' resolves and anything else is reported as not found.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/routes/vault/cluster/access/method/index.js` file index.js (third_party/openbao/ui/app/routes/vault/cluster/access/method/index.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/method/item.js` file item.js (third_party/openbao/ui/app/routes/vault/cluster/access/method/item.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/method/section.js` file section.js (third_party/openbao/ui/app/routes/vault/cluster/access/method/section.js)
<!-- SPECD_MANAGED_END -->
