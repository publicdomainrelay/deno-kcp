# Context: third-party-openbao-ui-app-serializers-pki

Repository: `deno-kcp`

This context exists to describe the client-side serialization layer that translates between the PKI API's request/response shapes and the UI's models: which attributes are client-only and never sent, how per-action payload parameters are filtered, how certificate strings are parsed back into structured objects, how list responses are rehydrated into full model attributes, and how the role and tidy serializers special-case empty arrays and manual tidy requests.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:17afa5a16f974f99e67ef3e6f7205fff` class PkiIssuerSerializer (third_party/openbao/ui/app/serializers/pki/issuer.js)
- `class:6abebc6c0d0a1d473794f1e8a538ae94` class PkiRoleSerializer (third_party/openbao/ui/app/serializers/pki/role.js)
- `class:c130369168208db034158640fa9be8a1` class PkiKeySerializer (third_party/openbao/ui/app/serializers/pki/key.js)
- `class:d596e6b4964c7c32cc019abe6e3c012d` class PkiCertificateSerializer (third_party/openbao/ui/app/serializers/pki/certificate.js)
- `class:dc330f2a39a80f717515bc5b71a9b192` class PkiActionSerializer (third_party/openbao/ui/app/serializers/pki/action.js)
- `class:e1779c6c64f378b370bd456fcdeabae7` class PkiTidySerializer (third_party/openbao/ui/app/serializers/pki/tidy.js)
- `file:third_party/openbao/ui/app/serializers/pki/action.js` file action.js (third_party/openbao/ui/app/serializers/pki/action.js)
- `file:third_party/openbao/ui/app/serializers/pki/certificate.js` file certificate.js (third_party/openbao/ui/app/serializers/pki/certificate.js)
- `file:third_party/openbao/ui/app/serializers/pki/issuer.js` file issuer.js (third_party/openbao/ui/app/serializers/pki/issuer.js)
- `file:third_party/openbao/ui/app/serializers/pki/key.js` file key.js (third_party/openbao/ui/app/serializers/pki/key.js)
- `file:third_party/openbao/ui/app/serializers/pki/role.js` file role.js (third_party/openbao/ui/app/serializers/pki/role.js)
- `file:third_party/openbao/ui/app/serializers/pki/tidy.js` file tidy.js (third_party/openbao/ui/app/serializers/pki/tidy.js)
<!-- SPECD_MANAGED_END -->
