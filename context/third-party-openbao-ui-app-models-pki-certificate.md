# Context: third-party-openbao-ui-app-models-pki-certificate

Repository: `deno-kcp`

This context exists to describe the data models that back the OpenBao PKI engine's certificate generate and sign workflows in the bundled UI. The three classes are the request/response shape the UI sends to and reads from the PKI mount: the base model defines every field an issued certificate and its request share, while the generate and sign subclasses specialize that shape for the issue endpoint and the sign endpoint respectively. Consumers use these models to render forms, build help links against the active backend mount, and decide whether a displayed certificate offers revocation.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:73d79690266dec4d2b8c7d767ecc39fd` class PkiCertificateBaseModel (third_party/openbao/ui/app/models/pki/certificate/base.js)
- `class:d9bf28875adf418b55f62af0f1482ec2` class PkiCertificateSignModel (third_party/openbao/ui/app/models/pki/certificate/sign.js)
- `class:faa9db3f9cbc0e1a9048f3325f7e5526` class PkiCertificateGenerateModel (third_party/openbao/ui/app/models/pki/certificate/generate.js)
- `file:third_party/openbao/ui/app/models/pki/certificate/base.js` file base.js (third_party/openbao/ui/app/models/pki/certificate/base.js)
- `file:third_party/openbao/ui/app/models/pki/certificate/generate.js` file generate.js (third_party/openbao/ui/app/models/pki/certificate/generate.js)
- `file:third_party/openbao/ui/app/models/pki/certificate/sign.js` file sign.js (third_party/openbao/ui/app/models/pki/certificate/sign.js)
<!-- SPECD_MANAGED_END -->
