# Context: third-party-openbao-ui-lib-core-app-decorators

Repository: `deno-kcp`

This context exists so the app-side decorator entry point for confirm-leave navigation guarding is specifiable independently of the addon that implements it. The app file is a pure re-export shim: it owns no logic, but it fixes the import path `core/decorators/confirm-leave` that application and test code use, so changing or removing the re-export would silently break every consumer that imports withConfirmLeave from the app decorators directory rather than from the addon. It is described here so the route-decorator contract it exposes, and the unsaved-change behavior behind it, are recorded as the observable facts show them.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/lib/core/app/decorators/confirm-leave.js` file confirm-leave.js (third_party/openbao/ui/lib/core/app/decorators/confirm-leave.js)
<!-- SPECD_MANAGED_END -->
