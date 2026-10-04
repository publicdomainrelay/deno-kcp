# Context: third-party-openbao-ui-app-models-oidc

Repository: `deno-kcp`

This context exists to pin down the contract of the vendored OpenBao OIDC UI models that the rest of the OpenBao front end builds on. Routes, components and serializers in the same application read attributes, form field lists, capability getters and API path properties off these five classes, so their names and semantics must stay stable when the vendored tree is updated or when another part of the repository consumes it. The spec states which attributes each model carries, which getters derive presentation and permission data from them, and which path properties the capability getters read, so a change to any of those is visible as a change to this contract rather than as a silent break in the OIDC screens.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:13025483db13a0a8d234a0b5977da762` class OidcProviderModel (third_party/openbao/ui/app/models/oidc/provider.js)
- `class:261dca2bb7f66ffcfbb9bbf5f9b2ed47` class OidcClientModel (third_party/openbao/ui/app/models/oidc/client.js)
- `class:47bd6620e0b1468753ab65f2174824ff` class OidcAssignmentModel (third_party/openbao/ui/app/models/oidc/assignment.js)
- `class:ace1f2a8ef976995b7f07739033b4c7c` class OidcKeyModel (third_party/openbao/ui/app/models/oidc/key.js)
- `class:c75f9d2624e93ca2e45bf2838a3e1775` class OidcScopeModel (third_party/openbao/ui/app/models/oidc/scope.js)
- `file:third_party/openbao/ui/app/models/oidc/assignment.js` file assignment.js (third_party/openbao/ui/app/models/oidc/assignment.js)
- `file:third_party/openbao/ui/app/models/oidc/client.js` file client.js (third_party/openbao/ui/app/models/oidc/client.js)
- `file:third_party/openbao/ui/app/models/oidc/key.js` file key.js (third_party/openbao/ui/app/models/oidc/key.js)
- `file:third_party/openbao/ui/app/models/oidc/provider.js` file provider.js (third_party/openbao/ui/app/models/oidc/provider.js)
- `file:third_party/openbao/ui/app/models/oidc/scope.js` file scope.js (third_party/openbao/ui/app/models/oidc/scope.js)
<!-- SPECD_MANAGED_END -->
