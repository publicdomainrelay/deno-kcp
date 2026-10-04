# Context: third-party-openbao-ui-app-controllers-vault-cluster-settings-auth

Repository: `deno-kcp`

This context exists to pin down the lifecycle behavior of the OpenBao UI auth-settings controllers around mounting an auth method and configuring it. The configure-section controller must release its Ember Data record from the store and clear its own model when the section is torn down, because controllers are singletons and a retained model would leak between route visits; the guards ensure records still in flight are never unloaded. The enable controller must forward a successful auth-method mount to the configuration route using the safe transition helper with the injected router, so an unauthorized or inaccessible route is not entered.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/controllers/vault/cluster/settings/auth/configure-section.js` file configure-section.js (third_party/openbao/ui/app/controllers/vault/cluster/settings/auth/configure-section.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/settings/auth/enable.js` file enable.js (third_party/openbao/ui/app/controllers/vault/cluster/settings/auth/enable.js)
<!-- SPECD_MANAGED_END -->
