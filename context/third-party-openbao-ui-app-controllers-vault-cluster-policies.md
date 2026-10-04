# Context: third-party-openbao-ui-app-controllers-vault-cluster-policies

Repository: `deno-kcp`

This context exists so the policies list screen retains its filtering, pagination binding, focus state, loading state, and delete-with-flash-feedback behavior in one place, while the route supplies the policy model and toggles the loading flag. The controller decouples the template's filter input from the model, lets the user type a partial policy id and jump to the first match, and centralizes the destructive delete flow so that both success and error paths produce consistent uppercase-typed flash messages.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/controllers/vault/cluster/policies/index.js` file index.js (third_party/openbao/ui/app/controllers/vault/cluster/policies/index.js)
<!-- SPECD_MANAGED_END -->
