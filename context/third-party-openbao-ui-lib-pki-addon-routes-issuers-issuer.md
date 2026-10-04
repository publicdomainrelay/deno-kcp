# Context: third-party-openbao-ui-lib-pki-addon-routes-issuers-issuer

Repository: `deno-kcp`

This context exists to document the routing layer for a single issuer inside the PKI secrets engine UI: how each issuer sub-screen loads its model, which store records or raw endpoints it touches, and what breadcrumb trail it renders. It gives a reader the contract each route must satisfy — model shape, controller setup, mount-path awareness and confirm-leave behavior — without restating the templates or components that consume it.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:0e431584883ac1d65f2b411946d203a2` class PkiIssuerCrossSignRoute (third_party/openbao/ui/lib/pki/addon/routes/issuers/issuer/cross-sign.js)
- `class:39d78ac404991312dcac6b1516416251` class PkiIssuerDetailsRoute (third_party/openbao/ui/lib/pki/addon/routes/issuers/issuer/details.js)
- `class:6ea813b535460b9ce9338711a5e87b54` class PkiIssuerRotateRootRoute (third_party/openbao/ui/lib/pki/addon/routes/issuers/issuer/rotate-root.js)
- `class:b3deadcbb72d007d3d0c835b0d109355` class PkiIssuerEditRoute (third_party/openbao/ui/lib/pki/addon/routes/issuers/issuer/edit.js)
- `class:fccd8c46422fab159c157923ce406406` class PkiIssuerSignRoute (third_party/openbao/ui/lib/pki/addon/routes/issuers/issuer/sign.js)
- `file:third_party/openbao/ui/lib/pki/addon/routes/issuers/issuer/cross-sign.js` file cross-sign.js (third_party/openbao/ui/lib/pki/addon/routes/issuers/issuer/cross-sign.js)
- `file:third_party/openbao/ui/lib/pki/addon/routes/issuers/issuer/details.js` file details.js (third_party/openbao/ui/lib/pki/addon/routes/issuers/issuer/details.js)
- `file:third_party/openbao/ui/lib/pki/addon/routes/issuers/issuer/edit.js` file edit.js (third_party/openbao/ui/lib/pki/addon/routes/issuers/issuer/edit.js)
- `file:third_party/openbao/ui/lib/pki/addon/routes/issuers/issuer/rotate-root.js` file rotate-root.js (third_party/openbao/ui/lib/pki/addon/routes/issuers/issuer/rotate-root.js)
- `file:third_party/openbao/ui/lib/pki/addon/routes/issuers/issuer/sign.js` file sign.js (third_party/openbao/ui/lib/pki/addon/routes/issuers/issuer/sign.js)
<!-- SPECD_MANAGED_END -->
