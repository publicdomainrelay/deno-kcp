# Context: third-party-openbao-ui-app-adapters-identity

Repository: `deno-kcp`

This context documents the identity adapter layer of the vendored OpenBao web UI, the boundary that maps Ember Data model operations for entities, entity aliases, groups, group aliases and entity merges onto the identity secrets engine HTTP API. It exists so the URL construction, list/query handling, lookup endpoints and merge response rewriting can be specified and checked without reading the Ember source, and so downstream work that touches identity models knows exactly which request shapes the adapters emit.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/adapters/identity/base.js` file base.js (third_party/openbao/ui/app/adapters/identity/base.js)
- `file:third_party/openbao/ui/app/adapters/identity/entity-alias.js` file entity-alias.js (third_party/openbao/ui/app/adapters/identity/entity-alias.js)
- `file:third_party/openbao/ui/app/adapters/identity/entity-merge.js` file entity-merge.js (third_party/openbao/ui/app/adapters/identity/entity-merge.js)
- `file:third_party/openbao/ui/app/adapters/identity/entity.js` file entity.js (third_party/openbao/ui/app/adapters/identity/entity.js)
- `file:third_party/openbao/ui/app/adapters/identity/group-alias.js` file group-alias.js (third_party/openbao/ui/app/adapters/identity/group-alias.js)
- `file:third_party/openbao/ui/app/adapters/identity/group.js` file group.js (third_party/openbao/ui/app/adapters/identity/group.js)
<!-- SPECD_MANAGED_END -->
