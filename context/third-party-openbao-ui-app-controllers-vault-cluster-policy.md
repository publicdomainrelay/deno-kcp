# Context: third-party-openbao-ui-app-controllers-vault-cluster-policy

Repository: `deno-kcp`

This context is the policy-editing surface of the OpenBao web UI. It exists to give the edit route a working delete action with success and failure feedback, and to give the create and show routes a shared cleanup contract that releases the record a singleton controller would otherwise hold onto after the route is left. The edit controller owns the destructive path for a policy, and the create controller owns the lifecycle housekeeping that show inherits.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:b6199ded53e7c771c2e355a09af4bba3` class PolicyEditController (third_party/openbao/ui/app/controllers/vault/cluster/policy/edit.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/policy/create.js` file create.js (third_party/openbao/ui/app/controllers/vault/cluster/policy/create.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/policy/edit.js` file edit.js (third_party/openbao/ui/app/controllers/vault/cluster/policy/edit.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/policy/show.js` file show.js (third_party/openbao/ui/app/controllers/vault/cluster/policy/show.js)
<!-- SPECD_MANAGED_END -->
