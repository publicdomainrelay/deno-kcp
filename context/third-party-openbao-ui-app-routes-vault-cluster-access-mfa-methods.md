# Context: third-party-openbao-ui-app-routes-vault-cluster-access-mfa-methods

Repository: `deno-kcp`

This context exists to specify the routing behavior that backs the MFA methods list, detail, and creation pages of the OpenBao UI. It documents what each route fetches from the Ember Data store, how each handles missing or failing data, when the router redirects away, how the detail view correlates login enforcements with a method, and how the create route synchronizes the type query parameter with the form's model objects. The spec is the contract the controllers and templates of those pages depend on.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:0129648ecf0331d7c7a9ba3e6bcb1cff` class MfaMethodsRoute (third_party/openbao/ui/app/routes/vault/cluster/access/mfa/methods/index.js)
- `class:2a3554ca939b5f822ca112217a178343` class MfaMethodRoute (third_party/openbao/ui/app/routes/vault/cluster/access/mfa/methods/method.js)
- `class:6454548d1b147ac2baaed64eaadef437` class MfaLoginEnforcementCreateRoute (third_party/openbao/ui/app/routes/vault/cluster/access/mfa/methods/create.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/mfa/methods/create.js` file create.js (third_party/openbao/ui/app/routes/vault/cluster/access/mfa/methods/create.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/mfa/methods/index.js` file index.js (third_party/openbao/ui/app/routes/vault/cluster/access/mfa/methods/index.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/mfa/methods/method.js` file method.js (third_party/openbao/ui/app/routes/vault/cluster/access/mfa/methods/method.js)
<!-- SPECD_MANAGED_END -->
