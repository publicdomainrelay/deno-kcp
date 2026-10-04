# Context: third-party-openbao-ui-lib-core-app-components-confirm

Repository: `deno-kcp`

This context exists so the confirm/message component is resolvable from the host application's app tree without duplicating its source. Ember resolves application-realm components from app/components, while reusable code lives in the addon realm under lib/core/addon; this file bridges the two by re-exporting the addon module as the app-tree default. It is a generated-style passthrough, so any consumer importing the component at the app path gets the same module instance as a consumer importing the addon path.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/lib/core/app/components/confirm/message.js` file message.js (third_party/openbao/ui/lib/core/app/components/confirm/message.js)
<!-- SPECD_MANAGED_END -->
