# Context: third-party-openbao-ui-app-serializers-keymgmt

Repository: `deno-kcp`

The context exists so the key-management serializers can be described and reasoned about as one unit: how raw keymgmt API payloads become Ember Data records and how records become create/update request bodies. It matters because the key endpoint returns versions as a number-keyed object rather than an array and omits backend context from list entries, and because provider credentials live on the record rather than in the serialized attributes, so neither quirk can be handled by the default ApplicationSerializer behaviour that both classes extend.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:88cba2da41a41350ecfad514d4118378` class KeymgmtProviderSerializer (third_party/openbao/ui/app/serializers/keymgmt/provider.js)
- `class:d2f1cce48f9d3fc208c3a35c8df4e55a` class KeymgmtKeySerializer (third_party/openbao/ui/app/serializers/keymgmt/key.js)
- `file:third_party/openbao/ui/app/serializers/keymgmt/key.js` file key.js (third_party/openbao/ui/app/serializers/keymgmt/key.js)
- `file:third_party/openbao/ui/app/serializers/keymgmt/provider.js` file provider.js (third_party/openbao/ui/app/serializers/keymgmt/provider.js)
<!-- SPECD_MANAGED_END -->
