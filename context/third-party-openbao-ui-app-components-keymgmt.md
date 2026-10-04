# Context: third-party-openbao-ui-app-components-keymgmt

Repository: `deno-kcp`

The context exists to pin down the behaviour of the keymgmt provider and key administration surface of the vendored OpenBao UI so changes to it can be checked against a written contract. It matters because these components carry the non-obvious domain rules: which key types each KMS provider accepts, which operations each provider and key-type pairing exposes, when the distribute form must be blocked, and how the store adapters (distribute, removeFromProvider, rotateKey) and route transitions are expected to sequence. It is a third-party subtree, so the spec describes the code as observed rather than prescribing a preferred design.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:c3fc7c3dd4ec847d66cb46c8395558b3` class KeymgmtDistribute (third_party/openbao/ui/app/components/keymgmt/distribute.js)
- `class:d539ad26851c107dd667ccacbad500a1` class KeymgmtProviderEdit (third_party/openbao/ui/app/components/keymgmt/provider-edit.js)
- `class:f91c7ad1845695dc8fa2f8638afd6710` class KeymgmtKeyEdit (third_party/openbao/ui/app/components/keymgmt/key-edit.js)
- `file:third_party/openbao/ui/app/components/keymgmt/distribute.js` file distribute.js (third_party/openbao/ui/app/components/keymgmt/distribute.js)
- `file:third_party/openbao/ui/app/components/keymgmt/key-edit.js` file key-edit.js (third_party/openbao/ui/app/components/keymgmt/key-edit.js)
- `file:third_party/openbao/ui/app/components/keymgmt/provider-edit.js` file provider-edit.js (third_party/openbao/ui/app/components/keymgmt/provider-edit.js)
<!-- SPECD_MANAGED_END -->
