# Context: third-party-openbao-ui-app-serializers-keymgmt

Repository: `deno-kcp`

The context exists so the key-management Ember serializers can be described and reasoned about as a unit: how raw keymgmt API payloads are normalized into Ember Data records and how records are serialized back for create/update requests. It matters because the key endpoint returns versions as a number-keyed object and omits backend context, and because provider credentials live on the record rather than in the serialized attributes, so both quirks must be handled outside the default ApplicationSerializer behaviour that both classes extend.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:88cba2da41a41350ecfad514d4118378` class KeymgmtProviderSerializer (third_party/openbao/ui/app/serializers/keymgmt/provider.js)
- `class:d2f1cce48f9d3fc208c3a35c8df4e55a` class KeymgmtKeySerializer (third_party/openbao/ui/app/serializers/keymgmt/key.js)
- `file:third_party/openbao/ui/app/serializers/keymgmt/key.js` file key.js (third_party/openbao/ui/app/serializers/keymgmt/key.js)
- `file:third_party/openbao/ui/app/serializers/keymgmt/provider.js` file provider.js (third_party/openbao/ui/app/serializers/keymgmt/provider.js)
<!-- SPECD_MANAGED_END -->
