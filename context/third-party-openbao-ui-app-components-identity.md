# Context: third-party-openbao-ui-app-components-identity

Repository: `deno-kcp`

This context exists so the vendored OpenBao identity UI components are described as a coherent unit rather than nine unrelated files. It pins down the shared contract that the popup subclasses inherit, the modes and routes the entity/group edit form supports, and the parameters the lookup component sends to the identity adapter, so that any future change to the vendored tree, or any replacement of it, can be checked against the behavior the code actually has today.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/components/identity/_popup-base.js` file _popup-base.js (third_party/openbao/ui/app/components/identity/_popup-base.js)
- `file:third_party/openbao/ui/app/components/identity/edit-form.js` file edit-form.js (third_party/openbao/ui/app/components/identity/edit-form.js)
- `file:third_party/openbao/ui/app/components/identity/entity-nav.js` file entity-nav.js (third_party/openbao/ui/app/components/identity/entity-nav.js)
- `file:third_party/openbao/ui/app/components/identity/item-details.js` file item-details.js (third_party/openbao/ui/app/components/identity/item-details.js)
- `file:third_party/openbao/ui/app/components/identity/lookup-input.js` file lookup-input.js (third_party/openbao/ui/app/components/identity/lookup-input.js)
- `file:third_party/openbao/ui/app/components/identity/popup-alias.js` file popup-alias.js (third_party/openbao/ui/app/components/identity/popup-alias.js)
- `file:third_party/openbao/ui/app/components/identity/popup-members.js` file popup-members.js (third_party/openbao/ui/app/components/identity/popup-members.js)
- `file:third_party/openbao/ui/app/components/identity/popup-metadata.js` file popup-metadata.js (third_party/openbao/ui/app/components/identity/popup-metadata.js)
- `file:third_party/openbao/ui/app/components/identity/popup-policy.js` file popup-policy.js (third_party/openbao/ui/app/components/identity/popup-policy.js)
<!-- SPECD_MANAGED_END -->
