# Context: third-party-openbao-ui-app-adapters-pki-certificate

Repository: `deno-kcp`

This context exists so the PKI certificate adapters have a written contract: a shared base adapter that owns URL construction, listing/reading by query, and revocation, plus two thin create-time subclasses that differ only in which role endpoint, issue or sign, a new certificate record is posted to. It records that no other update path exists for a certificate and that a create URL is only formed when both `role` and `backend` are present.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:0a74eb3a2bcc8883c6e4a6928c1f544c` class PkiCertificateGenerateAdapter (third_party/openbao/ui/app/adapters/pki/certificate/generate.js)
- `class:2bfaf79806670863ee4b74a049a1cd30` class PkiCertificateBaseAdapter (third_party/openbao/ui/app/adapters/pki/certificate/base.js)
- `class:bc59b85eeb3a0cdd2b321f852a6a10f0` class PkiCertificateSignAdapter (third_party/openbao/ui/app/adapters/pki/certificate/sign.js)
- `file:third_party/openbao/ui/app/adapters/pki/certificate/base.js` file base.js (third_party/openbao/ui/app/adapters/pki/certificate/base.js)
- `file:third_party/openbao/ui/app/adapters/pki/certificate/generate.js` file generate.js (third_party/openbao/ui/app/adapters/pki/certificate/generate.js)
- `file:third_party/openbao/ui/app/adapters/pki/certificate/sign.js` file sign.js (third_party/openbao/ui/app/adapters/pki/certificate/sign.js)
<!-- SPECD_MANAGED_END -->
