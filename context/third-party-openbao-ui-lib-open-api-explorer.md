# Context: third-party-openbao-ui-lib-open-api-explorer

Repository: `deno-kcp`

The context exists so the vendored OpenBao API documentation UI can be built and lazy-loaded as an Ember engine inside the host application. It declares the engine's identity, its build-time Babel transform via ember-auto-import, and the CSS dependency needed by the Swagger UI page, while deliberately deferring JavaScript dependencies to a dynamic `import()` inside the swagger-ui.js component so they are not pulled into vendor.js. The file carries the original HashiCorp MPL-2.0 header and an eslint-disable for leaking state in Ember objects, marking it as third-party code imported into this repository rather than code authored here.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/lib/open-api-explorer/index.js` file index.js (third_party/openbao/ui/lib/open-api-explorer/index.js)
<!-- SPECD_MANAGED_END -->
