# Context: third-party-openbao-ui-app-models-pki

Repository: `deno-kcp`

The context marks out the vendored PKI model layer of the OpenBao web UI so that the specifications around it have a stable, exact description of what these six models are and do. It exists because the surrounding deno-kcp work depends on knowing the field names, capability predicates, and help/path routing these models expose, without having to re-read the vendored JavaScript each time. The spec is descriptive: it records the attributes, the OpenAPI/help hooks, the capability gates, and the mount scoping that the code already implements, and it names the models the type declarations and PKI components bind to.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:2bc734ca8db65c0e3725743bd1a43272` class PkiSignIntermediateModel (third_party/openbao/ui/app/models/pki/sign-intermediate.js)
- `class:94060da0bdffa022432d3ad39befd9fd` class PkiRoleModel (third_party/openbao/ui/app/models/pki/role.js)
- `class:c41f2189781777365f01d63f6f5ce5e1` class PkiActionModel (third_party/openbao/ui/app/models/pki/action.js)
- `class:dcf1fb5555c3db5ee172a816792e9ea1` class PkiKeyModel (third_party/openbao/ui/app/models/pki/key.js)
- `class:ed97b0eda21ce3413f482a312ce2b03a` class PkiIssuerModel (third_party/openbao/ui/app/models/pki/issuer.js)
- `class:f3b616b5f2ee31a0617e1c0429a929e0` class PkiTidyModel (third_party/openbao/ui/app/models/pki/tidy.js)
- `file:third_party/openbao/ui/app/models/pki/action.js` file action.js (third_party/openbao/ui/app/models/pki/action.js)
- `file:third_party/openbao/ui/app/models/pki/issuer.js` file issuer.js (third_party/openbao/ui/app/models/pki/issuer.js)
- `file:third_party/openbao/ui/app/models/pki/key.js` file key.js (third_party/openbao/ui/app/models/pki/key.js)
- `file:third_party/openbao/ui/app/models/pki/role.js` file role.js (third_party/openbao/ui/app/models/pki/role.js)
- `file:third_party/openbao/ui/app/models/pki/sign-intermediate.js` file sign-intermediate.js (third_party/openbao/ui/app/models/pki/sign-intermediate.js)
- `file:third_party/openbao/ui/app/models/pki/tidy.js` file tidy.js (third_party/openbao/ui/app/models/pki/tidy.js)
<!-- SPECD_MANAGED_END -->
