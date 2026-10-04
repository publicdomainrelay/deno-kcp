# Context: third-party-openbao-ui-lib-kubernetes-addon-helpers

Repository: `deno-kcp`

This context exists so the Kubernetes addon portion of the OpenBao UI can expose the currently viewed secret mount path to its templates without each template reaching into the secretMountPath service directly. The helper is a thin template-facing wrapper: it depends on the secretMountPath service for state and exposes that state as a helper value. It exists because the addon lives in its own Ember engine with its own helper namespace, so it needs a local copy of the helper rather than a cross-engine import from the app or the pki addon.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:d0f222f7db6aa4f4d2ad9e72f0099d51` class CurrentMountPathHelper (third_party/openbao/ui/lib/kubernetes/addon/helpers/current-mount-path.js)
- `file:third_party/openbao/ui/lib/kubernetes/addon/helpers/current-mount-path.js` file current-mount-path.js (third_party/openbao/ui/lib/kubernetes/addon/helpers/current-mount-path.js)
<!-- SPECD_MANAGED_END -->
