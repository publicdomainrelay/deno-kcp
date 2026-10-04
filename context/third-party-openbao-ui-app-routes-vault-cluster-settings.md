# Context: third-party-openbao-ui-app-routes-vault-cluster-settings

Repository: `deno-kcp`

This context exists so the cluster settings area of the OpenBao UI has well-defined route entry points: mounting a new secrets engine, configuring an existing aws or ssh engine, and viewing the seal state. The redirecting index route keeps the bare settings URL from rendering an empty page, the mount route clears stale secret-engine records before an engine is mounted, and the configure route gates access so only backend types the UI can actually configure are reachable.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:807977493cffaddb7054934fbc73f2f4` class VaultClusterSettingsMountSecretBackendRoute (third_party/openbao/ui/app/routes/vault/cluster/settings/mount-secret-backend.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/settings/configure-secret-backend.js` file configure-secret-backend.js (third_party/openbao/ui/app/routes/vault/cluster/settings/configure-secret-backend.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/settings/index.js` file index.js (third_party/openbao/ui/app/routes/vault/cluster/settings/index.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/settings/mount-secret-backend.js` file mount-secret-backend.js (third_party/openbao/ui/app/routes/vault/cluster/settings/mount-secret-backend.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/settings/seal.js` file seal.js (third_party/openbao/ui/app/routes/vault/cluster/settings/seal.js)
<!-- SPECD_MANAGED_END -->
