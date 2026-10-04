# Context: third-party-openbao-ui-app-controllers-vault-cluster

Repository: `deno-kcp`

The context exists to specify the behavior of the OpenBao UI's vault/cluster controllers so that the cluster-level user flows (init, unseal, authenticate with optional MFA and OIDC, namespace selection, cluster settings) stay described independently of the templates and routes that consume them. It records which state each controller tracks, which query parameters it binds, and which transitions or adapter calls it performs, so that changes to these controllers can be checked against the documented contract.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:65db596087c8cd3083db7d9a79e6210a` class VaultClusterOidcProviderNsController (third_party/openbao/ui/app/controllers/vault/cluster/oidc-provider-ns.js)
- `class:6f341448bd8e5078e740d7692f1d79fa` class VaultClusterOidcProviderController (third_party/openbao/ui/app/controllers/vault/cluster/oidc-provider.js)
- `class:6fa21011585db592c4ced9808a05fc38` class InitController (third_party/openbao/ui/app/controllers/vault/cluster/init.js)
- `class:790ce691d60cbf30223e9aaf406544a6` class VaultClusterMfaSetupController (third_party/openbao/ui/app/controllers/vault/cluster/mfa-setup.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/auth.js` file auth.js (third_party/openbao/ui/app/controllers/vault/cluster/auth.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/init.js` file init.js (third_party/openbao/ui/app/controllers/vault/cluster/init.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/mfa-setup.js` file mfa-setup.js (third_party/openbao/ui/app/controllers/vault/cluster/mfa-setup.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/oidc-callback.js` file oidc-callback.js (third_party/openbao/ui/app/controllers/vault/cluster/oidc-callback.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/oidc-provider-ns.js` file oidc-provider-ns.js (third_party/openbao/ui/app/controllers/vault/cluster/oidc-provider-ns.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/oidc-provider.js` file oidc-provider.js (third_party/openbao/ui/app/controllers/vault/cluster/oidc-provider.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/settings.js` file settings.js (third_party/openbao/ui/app/controllers/vault/cluster/settings.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/unseal.js` file unseal.js (third_party/openbao/ui/app/controllers/vault/cluster/unseal.js)
<!-- SPECD_MANAGED_END -->
