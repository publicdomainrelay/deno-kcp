# Context: third-party-openbao-ui-app-models-keymgmt

Repository: `deno-kcp`

The context exists so the key-management screens of the OpenBao UI have a described data layer: one model that represents an individual key together with its version history and permission-gated actions, and one model that represents a key provider (Azure Key Vault, AWS KMS, Google Cloud KMS) together with its credentials and the keys it holds. Both models exist to give templates a uniform source for form fields, path construction and capability checks instead of hard-coding those details in routes and components.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:1ba43a2c63c7bda832babbbb2347a2b7` class KeymgmtKeyModel (third_party/openbao/ui/app/models/keymgmt/key.js)
- `class:4d48baaa68ed5eee3e223da214246bb9` class KeymgmtProviderModel (third_party/openbao/ui/app/models/keymgmt/provider.js)
- `file:third_party/openbao/ui/app/models/keymgmt/key.js` file key.js (third_party/openbao/ui/app/models/keymgmt/key.js)
- `file:third_party/openbao/ui/app/models/keymgmt/provider.js` file provider.js (third_party/openbao/ui/app/models/keymgmt/provider.js)
<!-- SPECD_MANAGED_END -->
