# Context: third-party-openbao-ui-app-adapters-pki

Repository: `deno-kcp`

This context exists to pin down the client-side HTTP contract that the OpenBao web UI uses to talk to the PKI secrets engine. Each adapter owns one PKI model family and is responsible for translating Ember Data operations (create, update, query, queryRecord, findRecord, deleteRecord) into the correct PKI mount URLs and payloads. The spec records which endpoint each operation must hit, which adapterOptions drive URL selection, and which invalid state combinations must be rejected, so that the UI behaves correctly against either the legacy PKI endpoints (root/generate, intermediate/generate, config/ca) or the newer issuer endpoints (issuers/generate/..., issuers/import/bundle).

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:35ae48da17ffe424cf063c5fbab11046` class PkiSignIntermediateAdapter (third_party/openbao/ui/app/adapters/pki/sign-intermediate.js)
- `class:3c0112d28f50400745990510767759a0` class PkiKeyAdapter (third_party/openbao/ui/app/adapters/pki/key.js)
- `class:5f748f52e8ff0c08e3cfa27b072fddea` class PkiRoleAdapter (third_party/openbao/ui/app/adapters/pki/role.js)
- `class:8bcf804472eb5da0200699200b48d780` class PkiActionAdapter (third_party/openbao/ui/app/adapters/pki/action.js)
- `class:93f6fcfe084a87fdc87df1a1e76109fe` class PkiIssuerAdapter (third_party/openbao/ui/app/adapters/pki/issuer.js)
- `class:cc61e15fb8e344ac63c02f60b7085f42` class PkiTidyAdapter (third_party/openbao/ui/app/adapters/pki/tidy.js)
- `file:third_party/openbao/ui/app/adapters/pki/action.js` file action.js (third_party/openbao/ui/app/adapters/pki/action.js)
- `file:third_party/openbao/ui/app/adapters/pki/cert.js` file cert.js (third_party/openbao/ui/app/adapters/pki/cert.js)
- `file:third_party/openbao/ui/app/adapters/pki/issuer.js` file issuer.js (third_party/openbao/ui/app/adapters/pki/issuer.js)
- `file:third_party/openbao/ui/app/adapters/pki/key.js` file key.js (third_party/openbao/ui/app/adapters/pki/key.js)
- `file:third_party/openbao/ui/app/adapters/pki/role.js` file role.js (third_party/openbao/ui/app/adapters/pki/role.js)
- `file:third_party/openbao/ui/app/adapters/pki/sign-intermediate.js` file sign-intermediate.js (third_party/openbao/ui/app/adapters/pki/sign-intermediate.js)
- `file:third_party/openbao/ui/app/adapters/pki/tidy.js` file tidy.js (third_party/openbao/ui/app/adapters/pki/tidy.js)
<!-- SPECD_MANAGED_END -->
