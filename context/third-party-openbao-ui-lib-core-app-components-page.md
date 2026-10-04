# Context: third-party-openbao-ui-lib-core-app-components-page

Repository: `deno-kcp`

The Ember build merges the app/ and addon/ trees, so a component owned by the addon must also have a module at the app-tree path for the resolver to find it. These two files exist to satisfy that requirement for the page breadcrumbs and page error components without forking or duplicating the addon code, keeping the addon implementation as the single source of truth while making the components resolvable from the app tree. The context documents only that shim contract: which addon module each file forwards to, and the license header both must retain.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/lib/core/app/components/page/breadcrumbs.js` file breadcrumbs.js (third_party/openbao/ui/lib/core/app/components/page/breadcrumbs.js)
- `file:third_party/openbao/ui/lib/core/app/components/page/error.js` file error.js (third_party/openbao/ui/lib/core/app/components/page/error.js)
<!-- SPECD_MANAGED_END -->
