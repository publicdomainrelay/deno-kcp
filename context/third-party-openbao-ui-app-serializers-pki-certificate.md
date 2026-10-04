# Context: third-party-openbao-ui-app-serializers-pki-certificate

Repository: `deno-kcp`

The context exists so the PKI certificate response shape is described in one place: how a raw OpenBao PKI API response is turned into an Ember Data model, why the serial number is the primary key, why `role` is stripped on write, and why the parsed certificate and its common name are lifted to the top level of the payload. It is documentation for the certificate generate and sign routes of the OpenBao UI, which share one base serializer and differ only by subclass identity.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:6768f8a77ef44e47f4b276581b9678a2` class PkiCertificateGenerateSerializer (third_party/openbao/ui/app/serializers/pki/certificate/generate.js)
- `class:f911826941e024f780359dc88ceefb1f` class PkiCertificateBaseSerializer (third_party/openbao/ui/app/serializers/pki/certificate/base.js)
- `file:third_party/openbao/ui/app/serializers/pki/certificate/base.js` file base.js (third_party/openbao/ui/app/serializers/pki/certificate/base.js)
- `file:third_party/openbao/ui/app/serializers/pki/certificate/generate.js` file generate.js (third_party/openbao/ui/app/serializers/pki/certificate/generate.js)
- `file:third_party/openbao/ui/app/serializers/pki/certificate/sign.js` file sign.js (third_party/openbao/ui/app/serializers/pki/certificate/sign.js)
<!-- SPECD_MANAGED_END -->
