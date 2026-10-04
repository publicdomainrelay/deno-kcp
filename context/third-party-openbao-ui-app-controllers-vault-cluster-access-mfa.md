# Context: third-party-openbao-ui-app-controllers-vault-cluster-access-mfa

Repository: `deno-kcp`

The context exists to record the interface and behavior of MfaMethodsListController, the Ember controller backing the MFA methods list route in the OpenBao UI. It is needed so that the pagination contract of the MFA methods list screen is described in the specification: the controller exposes queryParams so Ember serializes the page into the URL, and it seeds page to 1 so a fresh visit to the list starts on the first page rather than an undefined or empty page value.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:440062a628c6eae4794a86ba8179be4e` class MfaMethodsListController (third_party/openbao/ui/app/controllers/vault/cluster/access/mfa/methods.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/access/mfa/methods.js` file methods.js (third_party/openbao/ui/app/controllers/vault/cluster/access/mfa/methods.js)
<!-- SPECD_MANAGED_END -->
