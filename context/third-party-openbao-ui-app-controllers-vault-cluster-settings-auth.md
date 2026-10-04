# Context: third-party-openbao-ui-app-controllers-vault-cluster-settings-auth

Repository: `deno-kcp`

This context covers the OpenBao UI auth-settings controllers that manage lifecycle around mounting an auth method and configuring it. configure-section exists to prevent a stale model from leaking across singleton controller instances and to release the Ember Data record from the store once the section is torn down; enable exists to forward a successful auth-method mount to the configuration route using the safe transition helper, so navigation honors permissions and route accessibility.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/controllers/vault/cluster/settings/auth/configure-section.js` file configure-section.js (third_party/openbao/ui/app/controllers/vault/cluster/settings/auth/configure-section.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/settings/auth/enable.js` file enable.js (third_party/openbao/ui/app/controllers/vault/cluster/settings/auth/enable.js)
<!-- SPECD_MANAGED_END -->
