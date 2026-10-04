# Context: third-party-openbao-ui-app-adapters-pki-config

Repository: `deno-kcp`

This context exists so that the PKI configuration HTTP surface of the OpenBao UI stays described in one place: a single generic adapter holds all request logic (GET for findRecord, POST for updateRecord) while thin subclasses supply only the URL for each of the four PKI config endpoints. It documents that contract so future refactors of the adapters preserve the v1 namespace, the mount-path encoding through encodePath, and the unwrapping of resp.data on find.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:0ae4baeedbb44b011a1bb8b77ebcd63d` class PkiConfigCrlAdapter (third_party/openbao/ui/app/adapters/pki/config/crl.js)
- `class:7013746357be30dc3099a721f1e46d65` class PkiConfigBaseAdapter (third_party/openbao/ui/app/adapters/pki/config/base.js)
- `class:b07ea4beb4f13b0976ed4043f7e6deca` class PkiConfigClusterAdapter (third_party/openbao/ui/app/adapters/pki/config/cluster.js)
- `class:e7161dbfd2de9d32ca59cd636e4daa5f` class PkiConfigUrlsAdapter (third_party/openbao/ui/app/adapters/pki/config/urls.js)
- `class:f085aea2fe7d8234f29b97c5b51d4929` class PkiConfigAcmeAdapter (third_party/openbao/ui/app/adapters/pki/config/acme.js)
- `file:third_party/openbao/ui/app/adapters/pki/config/acme.js` file acme.js (third_party/openbao/ui/app/adapters/pki/config/acme.js)
- `file:third_party/openbao/ui/app/adapters/pki/config/base.js` file base.js (third_party/openbao/ui/app/adapters/pki/config/base.js)
- `file:third_party/openbao/ui/app/adapters/pki/config/cluster.js` file cluster.js (third_party/openbao/ui/app/adapters/pki/config/cluster.js)
- `file:third_party/openbao/ui/app/adapters/pki/config/crl.js` file crl.js (third_party/openbao/ui/app/adapters/pki/config/crl.js)
- `file:third_party/openbao/ui/app/adapters/pki/config/urls.js` file urls.js (third_party/openbao/ui/app/adapters/pki/config/urls.js)
<!-- SPECD_MANAGED_END -->
