# Context: third-party-openbao-ui-app-routes-vault-cluster-secrets

Repository: `deno-kcp`

This context exists so the secrets-engine list and single-engine URLs of the OpenBao/Vault UI resolve to real model data and to a sensible default child route. backends.js gives the secrets overview a model of all secret engines; backend.js resolves one engine by path, records that path in the shared secretMountPath service so descendants and components know the active mount, and forwards the intermediate route to the engine's list-root child when no child route claimed the transition. Together they are the routing seam between URL parameters and the secret-engine ember-data records that every secrets screen reads.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/routes/vault/cluster/secrets/backend.js` file backend.js (third_party/openbao/ui/app/routes/vault/cluster/secrets/backend.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/secrets/backends.js` file backends.js (third_party/openbao/ui/app/routes/vault/cluster/secrets/backends.js)
<!-- SPECD_MANAGED_END -->
