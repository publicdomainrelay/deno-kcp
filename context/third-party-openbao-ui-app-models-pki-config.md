# Context: third-party-openbao-ui-app-models-pki-config

Repository: `deno-kcp`

This context exists so the PKI configuration edit surface has a describable contract: which configuration fields each of the four config endpoints (acme, cluster, crl, urls) accepts, how those fields render in the form, and how the UI decides whether the current token may write them. It is a third-party UI model layer (vendored under third_party/openbao), consumed by pki-configuration-edit.ts, and it maps one-to-one onto the PKI engine's config/* API paths.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:0dcaa854434eaefbc976d6883d5ddd47` class PkiConfigCrlModel (third_party/openbao/ui/app/models/pki/config/crl.js)
- `class:11f9538efb972a0a6a640217e161c307` class PkiConfigAcmeModel (third_party/openbao/ui/app/models/pki/config/acme.js)
- `class:811c1c2b377c20e67c49d062851b8405` class PkiConfigClusterModel (third_party/openbao/ui/app/models/pki/config/cluster.js)
- `class:c163acf9c02241811a259c1952b2a508` class PkiConfigUrlsModel (third_party/openbao/ui/app/models/pki/config/urls.js)
- `file:third_party/openbao/ui/app/models/pki/config/acme.js` file acme.js (third_party/openbao/ui/app/models/pki/config/acme.js)
- `file:third_party/openbao/ui/app/models/pki/config/cluster.js` file cluster.js (third_party/openbao/ui/app/models/pki/config/cluster.js)
- `file:third_party/openbao/ui/app/models/pki/config/crl.js` file crl.js (third_party/openbao/ui/app/models/pki/config/crl.js)
- `file:third_party/openbao/ui/app/models/pki/config/urls.js` file urls.js (third_party/openbao/ui/app/models/pki/config/urls.js)
<!-- SPECD_MANAGED_END -->
