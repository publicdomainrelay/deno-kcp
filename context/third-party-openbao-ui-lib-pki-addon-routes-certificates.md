# Context: third-party-openbao-ui-lib-pki-addon-routes-certificates

Repository: `deno-kcp`

The context exists to describe the data-loading and controller-setup behaviour of the PKI certificates index route. It captures which services the route depends on, how the model is assembled, how a missing mount or unconfigured engine (HTTP 404) is tolerated rather than thrown, and how the not-configured message shown to the user is chosen. Anyone changing the certificates index page needs this context to know the exact backend path, the query shape, and the fallback semantics that the template and controller rely on.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:2ef4d0c984520a9dd1e0f461e7e5617c` class PkiCertificatesIndexRoute (third_party/openbao/ui/lib/pki/addon/routes/certificates/index.js)
- `file:third_party/openbao/ui/lib/pki/addon/routes/certificates/index.js` file index.js (third_party/openbao/ui/lib/pki/addon/routes/certificates/index.js)
<!-- SPECD_MANAGED_END -->
