# Context: third-party-openbao-ui-app-routes-vault-cluster-policies

Repository: `deno-kcp`

The context exists so the policy list and policy create routes of the OpenBao UI can be described and reasoned about as one unit: both routes derive their behavior from a single `policyType()` lookup on the `vault.cluster.policies` params, both treat only the `acl` type as a first-class supported type, and both share controller-facing setup and reset semantics. Documenting them together keeps the type dispatch, pagination, transition guards, and cleanup contract visible as a whole rather than split across two files.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/routes/vault/cluster/policies/create.js` file create.js (third_party/openbao/ui/app/routes/vault/cluster/policies/create.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/policies/index.js` file index.js (third_party/openbao/ui/app/routes/vault/cluster/policies/index.js)
<!-- SPECD_MANAGED_END -->
