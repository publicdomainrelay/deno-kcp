# Context: third-party-openbao-ui-app-serializers-policy

Repository: `deno-kcp`

This context exists so the UI can resolve a distinct serializer module per policy type while keeping one implementation. The Ember resolver maps each policy type's model and serializer by module path, so acl, egp and rgp each need their own file even though the wire format is the same. Declaring these as empty extensions of the base PolicySerializer means any later per-type normalization step can be added in one file without touching the other two or the shared base.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/serializers/policy/acl.js` file acl.js (third_party/openbao/ui/app/serializers/policy/acl.js)
- `file:third_party/openbao/ui/app/serializers/policy/egp.js` file egp.js (third_party/openbao/ui/app/serializers/policy/egp.js)
- `file:third_party/openbao/ui/app/serializers/policy/rgp.js` file rgp.js (third_party/openbao/ui/app/serializers/policy/rgp.js)
<!-- SPECD_MANAGED_END -->
