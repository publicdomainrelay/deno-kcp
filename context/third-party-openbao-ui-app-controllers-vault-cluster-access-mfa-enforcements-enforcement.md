# Context: third-party-openbao-ui-app-controllers-vault-cluster-access-mfa-enforcements-enforcement

Repository: `deno-kcp`

This context exists to specify the behavior of the MFA login enforcement detail/index controller in Openbao's UI: how it tracks the selected tab, how it renders and dismisses the delete confirmation, and what the delete action must do on success and on failure. The spec pins the deletion flow, the fallback error state, and the post-delete navigation target so the controller can be read, reimplemented, or refactored without re-deriving its contract from the Ember source.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:2b291d0b6786c867cac27571154f533f` class MfaLoginEnforcementIndexController (third_party/openbao/ui/app/controllers/vault/cluster/access/mfa/enforcements/enforcement/index.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/access/mfa/enforcements/enforcement/index.js` file index.js (third_party/openbao/ui/app/controllers/vault/cluster/access/mfa/enforcements/enforcement/index.js)
<!-- SPECD_MANAGED_END -->
