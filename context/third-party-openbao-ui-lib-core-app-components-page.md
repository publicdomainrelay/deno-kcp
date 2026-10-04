# Context: third-party-openbao-ui-lib-core-app-components-page

Repository: `deno-kcp`

This context exists so that the app tree of the OpenBao UI exposes the page breadcrumbs and page error components at the module paths the Ember resolver expects. The Ember build merges app/ and addon/ trees; these thin re-export modules make the addon-owned page components resolvable from the app tree without duplicating their code. The context documents the shim contract only: which addon module each file forwards to, and the license header both must keep.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/lib/core/app/components/page/breadcrumbs.js` file breadcrumbs.js (third_party/openbao/ui/lib/core/app/components/page/breadcrumbs.js)
- `file:third_party/openbao/ui/lib/core/app/components/page/error.js` file error.js (third_party/openbao/ui/lib/core/app/components/page/error.js)
<!-- SPECD_MANAGED_END -->
