# Context: third-party-openbao-ui-lib-open-api-explorer

Repository: `deno-kcp`

The context exists so the vendored OpenBao API documentation UI can be built and mounted as a lazy-loaded Ember engine inside the host application. It pins the engine's identity and the build configuration the engine depends on: the ember-auto-import Babel transform that rewrites imports during the engine's build, the Swagger UI stylesheet import that places that CSS into the engine's own lazy-loaded bundle rather than the host application's vendor CSS, and the `lazyLoading.enabled` switch that keeps the engine's assets off the initial payload until a host route enters it. It also records a deliberate omission: Swagger UI JavaScript is not imported in the `included()` hook because doing so would put those dependencies into `vendor.js`; the JavaScript is lazy-loaded instead through a dynamic `import()` in the swagger-ui.js component. Because the file is vendored third-party code rather than code authored in this repository, the context also preserves its HashiCorp MPL-2.0 provenance header and the eslint-disable that exempts Ember object state initialization from the host lint rules.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/lib/open-api-explorer/index.js` file index.js (third_party/openbao/ui/lib/open-api-explorer/index.js)
<!-- SPECD_MANAGED_END -->
