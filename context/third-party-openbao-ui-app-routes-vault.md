# Context: third-party-openbao-ui-app-routes-vault

Repository: `deno-kcp`

Exists so the Vault/OpenBao UI sends a user to the correct screen (init, unseal, auth, OIDC flows, or the cluster itself) before any cluster route renders, and so cluster-scoped state (current namespace, current cluster, permissions, polled model) is established once per visit and torn down on leave. getManagedNamespace exists as the single place that turns a user-supplied namespace query parameter into a fully qualified namespace path rooted at the user's root namespace.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/routes/vault/cluster-base.js` file cluster-base.js (third_party/openbao/ui/app/routes/vault/cluster-base.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster.js` file cluster.js (third_party/openbao/ui/app/routes/vault/cluster.js)
- `function:7dff5fec12a74a84209530d6104c89e0` function getManagedNamespace (third_party/openbao/ui/app/routes/vault/cluster.js)
<!-- SPECD_MANAGED_END -->
