# Context: third-party-openbao-ui-app-routes-vault-cluster

Repository: `deno-kcp`

This context exists to describe the routing contract of the OpenBao UI cluster subtree as vendored into this repository. It is the boundary between the URL space under a cluster and the controllers, services and templates behind it, so anyone changing cluster entry points, the OIDC login handshake, or the logout flow needs to know which route owns which transition. It is documented from the code as it is, including the pre-login versus post-login split, the accepted policy types, and the query-parameter conventions (authMethod, redirect_to, o, prompt, namespace) the routes read and write.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:73d2d4131d52fe4cc4310d970fc51dc6` class VaultClusterRedirectRoute (third_party/openbao/ui/app/routes/vault/cluster/redirect.js)
- `class:7911c3068799e0312fcedaec5b1f6009` class InitRoute (third_party/openbao/ui/app/routes/vault/cluster/init.js)
- `class:bed77d511f7bd7322650b4bc89bd75e3` class VaultClusterOidcProviderNsRoute (third_party/openbao/ui/app/routes/vault/cluster/oidc-provider-ns.js)
- `class:c2968a558da6ed2976992f89e6227f03` class MfaSetupRoute (third_party/openbao/ui/app/routes/vault/cluster/mfa-setup.js)
- `class:cdf9f334beaf9b12bcdbd47e5bc8cb03` class VaultClusterOidcProviderRoute (third_party/openbao/ui/app/routes/vault/cluster/oidc-provider.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access.js` file access.js (third_party/openbao/ui/app/routes/vault/cluster/access.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/auth.js` file auth.js (third_party/openbao/ui/app/routes/vault/cluster/auth.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/cluster-route-base.js` file cluster-route-base.js (third_party/openbao/ui/app/routes/vault/cluster/cluster-route-base.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/index.js` file index.js (third_party/openbao/ui/app/routes/vault/cluster/index.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/init.js` file init.js (third_party/openbao/ui/app/routes/vault/cluster/init.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/logout.js` file logout.js (third_party/openbao/ui/app/routes/vault/cluster/logout.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/mfa-setup.js` file mfa-setup.js (third_party/openbao/ui/app/routes/vault/cluster/mfa-setup.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/oidc-callback.js` file oidc-callback.js (third_party/openbao/ui/app/routes/vault/cluster/oidc-callback.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/oidc-provider-ns.js` file oidc-provider-ns.js (third_party/openbao/ui/app/routes/vault/cluster/oidc-provider-ns.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/oidc-provider.js` file oidc-provider.js (third_party/openbao/ui/app/routes/vault/cluster/oidc-provider.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/policies.js` file policies.js (third_party/openbao/ui/app/routes/vault/cluster/policies.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/policy.js` file policy.js (third_party/openbao/ui/app/routes/vault/cluster/policy.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/redirect.js` file redirect.js (third_party/openbao/ui/app/routes/vault/cluster/redirect.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/secrets.js` file secrets.js (third_party/openbao/ui/app/routes/vault/cluster/secrets.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/settings.js` file settings.js (third_party/openbao/ui/app/routes/vault/cluster/settings.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/storage.js` file storage.js (third_party/openbao/ui/app/routes/vault/cluster/storage.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/tools.js` file tools.js (third_party/openbao/ui/app/routes/vault/cluster/tools.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/unseal.js` file unseal.js (third_party/openbao/ui/app/routes/vault/cluster/unseal.js)
- `function:2dd792848591de1362c9a840acbadcf7` function getParamsForCallback (third_party/openbao/ui/app/routes/vault/cluster/oidc-callback.js)
<!-- SPECD_MANAGED_END -->
