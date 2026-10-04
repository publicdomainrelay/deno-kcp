# Context: third-party-openbao-ui-app-models-identity

Repository: `deno-kcp`

This context exists so the OpenBao UI can present and edit Vault identity data — entities, their aliases, entity merges, groups and group aliases — on top of Ember Data. The models exist to give the identity screens typed attributes with the right form editor metadata (`editType`, labels, `readOnly`, section headers), the relationships that join aliases to their parent entity or group, and capability-derived permission flags so the UI only offers actions (delete, edit, read, add alias, create policies) that the current token is allowed to perform.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:71e521bb7cde0980024910cb7866c4f8` class Model (third_party/openbao/ui/app/models/identity/entity.js)
- `file:third_party/openbao/ui/app/models/identity/_base.js` file _base.js (third_party/openbao/ui/app/models/identity/_base.js)
- `file:third_party/openbao/ui/app/models/identity/entity-alias.js` file entity-alias.js (third_party/openbao/ui/app/models/identity/entity-alias.js)
- `file:third_party/openbao/ui/app/models/identity/entity-merge.js` file entity-merge.js (third_party/openbao/ui/app/models/identity/entity-merge.js)
- `file:third_party/openbao/ui/app/models/identity/entity.js` file entity.js (third_party/openbao/ui/app/models/identity/entity.js)
- `file:third_party/openbao/ui/app/models/identity/group-alias.js` file group-alias.js (third_party/openbao/ui/app/models/identity/group-alias.js)
- `file:third_party/openbao/ui/app/models/identity/group.js` file group.js (third_party/openbao/ui/app/models/identity/group.js)
<!-- SPECD_MANAGED_END -->
