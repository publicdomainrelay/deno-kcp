# Context: third-party-openbao-ui-lib-core-app-modifiers

Repository: `deno-kcp`

This context exists so that the app-layer modifier namespace in the OpenBao UI has an entry for `code-mirror` without duplicating the implementation. Ember classic layout resolves modifiers from both the core and app trees; the app tree file is a thin alias that re-points the app path at the core path. Keeping it as a pure re-export means there is exactly one definition of the modifier, and any change to the modifier lands in the core module only.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/lib/core/app/modifiers/code-mirror.js` file code-mirror.js (third_party/openbao/ui/lib/core/app/modifiers/code-mirror.js)
<!-- SPECD_MANAGED_END -->
