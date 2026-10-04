# Context: third-party-openbao-ui-app-controllers-vault-cluster-access-mfa-enforcements

Repository: `deno-kcp`

This context exists to pin down the page-state contract of the MFA enforcement list route in the OpenBao UI: which query parameter the route accepts, how it is named, and what the default page value is when the URL carries no page query parameter. It is deliberately narrow, covering only the controller and not the matching route, template, adapter, or model. Recording it makes the URL/pagination contract of that page explicit and stable, so changes to page sizing, parameter naming, or the default page number can be checked against it.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:23a3872c16d0d338fabe3c587cda66e7` class MfaEnforcementListController (third_party/openbao/ui/app/controllers/vault/cluster/access/mfa/enforcements/index.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/access/mfa/enforcements/index.js` file index.js (third_party/openbao/ui/app/controllers/vault/cluster/access/mfa/enforcements/index.js)
<!-- SPECD_MANAGED_END -->
