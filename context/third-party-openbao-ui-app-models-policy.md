# Context: third-party-openbao-ui-app-models-policy

Repository: `deno-kcp`

This context exists to pin down the shape of the OpenBao UI policy models. The policy screens need to know which attributes each policy type carries, which values an enforcement level may take, which default applies when the user sets nothing, and which attributes get rendered as form fields. The three files keep that knowledge in one place: a base policy model extended per policy type, with ACL adding no fields, RGP adding the enforcement level, and EGP adding the path list on top of RGP. Recording this as a spec lets a reader or a refactorer see the inheritance chain and the exact field metadata without reading the Ember app.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/models/policy/acl.js` file acl.js (third_party/openbao/ui/app/models/policy/acl.js)
- `file:third_party/openbao/ui/app/models/policy/egp.js` file egp.js (third_party/openbao/ui/app/models/policy/egp.js)
- `file:third_party/openbao/ui/app/models/policy/rgp.js` file rgp.js (third_party/openbao/ui/app/models/policy/rgp.js)
<!-- SPECD_MANAGED_END -->
