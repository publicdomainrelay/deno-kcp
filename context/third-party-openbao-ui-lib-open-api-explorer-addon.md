# Context: third-party-openbao-ui-lib-open-api-explorer-addon

Repository: `deno-kcp`

This context exists so the OpenBao web UI can mount the OpenAPI explorer as an isolated Ember Engine without pulling its code into the host application's own route or resolver space. The three files are the minimum a mountable engine needs: a class that names its module prefix and tells Ember which host services it may inject, a resolver so the engine's own modules are found under that prefix, and a route map so the engine can grow routes later. A reader of this context learns how the explorer is wired into OpenBao and which host services it depends on, which is what matters when changing the UI or reasoning about vendored upstream code.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/lib/open-api-explorer/addon/engine.js` file engine.js (third_party/openbao/ui/lib/open-api-explorer/addon/engine.js)
- `file:third_party/openbao/ui/lib/open-api-explorer/addon/resolver.js` file resolver.js (third_party/openbao/ui/lib/open-api-explorer/addon/resolver.js)
- `file:third_party/openbao/ui/lib/open-api-explorer/addon/routes.js` file routes.js (third_party/openbao/ui/lib/open-api-explorer/addon/routes.js)
<!-- SPECD_MANAGED_END -->
