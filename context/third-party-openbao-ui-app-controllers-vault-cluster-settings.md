# Context: third-party-openbao-ui-app-controllers-vault-cluster-settings

Repository: `deno-kcp`

The context exists so the post-mount redirect logic and the cluster-settings controller actions can be described and depended on without re-reading the JavaScript. It fixes the contract between the secret-engine metadata (SUPPORTED_BACKENDS and allEngines()) and the routes the UI transitions to, plus the side effects the configure and seal actions must produce, so that changes to engine metadata or route names can be checked against these requirements.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:5b643ccbcf3ba0528f60d3055990a81c` class MountSecretBackendController (third_party/openbao/ui/app/controllers/vault/cluster/settings/mount-secret-backend.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/settings/configure-secret-backend.js` file configure-secret-backend.js (third_party/openbao/ui/app/controllers/vault/cluster/settings/configure-secret-backend.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/settings/mount-secret-backend.js` file mount-secret-backend.js (third_party/openbao/ui/app/controllers/vault/cluster/settings/mount-secret-backend.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/settings/seal.js` file seal.js (third_party/openbao/ui/app/controllers/vault/cluster/settings/seal.js)
<!-- SPECD_MANAGED_END -->
