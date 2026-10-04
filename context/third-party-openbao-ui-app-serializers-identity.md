# Context: third-party-openbao-ui-app-serializers-identity

Repository: `deno-kcp`

This context exists so the identity serializer layer of the bundled OpenBao UI can be described and reasoned about as one unit: how list, lazy-paginated and single-record responses for identity entities, entity aliases, groups and group aliases are normalized into Ember Data records, and how embedded alias relationships are declared, serialized and stripped. It captures the shared base behavior that the concrete serializers inherit or override, so changes to identity payload handling can be checked against the contract those four serializers depend on.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/serializers/identity/_base.js` file _base.js (third_party/openbao/ui/app/serializers/identity/_base.js)
- `file:third_party/openbao/ui/app/serializers/identity/entity-alias.js` file entity-alias.js (third_party/openbao/ui/app/serializers/identity/entity-alias.js)
- `file:third_party/openbao/ui/app/serializers/identity/entity.js` file entity.js (third_party/openbao/ui/app/serializers/identity/entity.js)
- `file:third_party/openbao/ui/app/serializers/identity/group-alias.js` file group-alias.js (third_party/openbao/ui/app/serializers/identity/group-alias.js)
- `file:third_party/openbao/ui/app/serializers/identity/group.js` file group.js (third_party/openbao/ui/app/serializers/identity/group.js)
<!-- SPECD_MANAGED_END -->
