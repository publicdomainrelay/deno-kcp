# Context: third-party-openbao-ui-lib-pki-addon-controllers-roles

Repository: `deno-kcp`

The context exists to capture the contract of the PKI roles index controller: a route-scoped Ember controller whose only responsibility is to hand templates the mount point of the PKI engine the roles list belongs to. It is a small, single-purpose read-only surface — the list itself, filtering, and role data come from the route and model, while this controller only answers "which mount is this?" so links and API paths can be built relative to the correct engine.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:fc70b09ee2eb2abdc09304e862957362` class PkiRolesIndexController (third_party/openbao/ui/lib/pki/addon/controllers/roles/index.js)
- `file:third_party/openbao/ui/lib/pki/addon/controllers/roles/index.js` file index.js (third_party/openbao/ui/lib/pki/addon/controllers/roles/index.js)
<!-- SPECD_MANAGED_END -->
