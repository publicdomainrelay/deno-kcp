# Context: third-party-openbao-ui-lib-pki-addon-helpers

Repository: `deno-kcp`

These helpers exist so PKI templates can read the active mount path and build transition links without touching services directly. The mount path helper gives templates one stable accessor for the current secret mount. The transition-to helper wraps router.transitionTo so a link click is intercepted, its default browser action suppressed, and the query params of the target route are resolved before navigation. The context documents these two adapters as the PKI addon's helper surface.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:3ca659cc61d957c68100411551638231` class CurrentMountPathHelper (third_party/openbao/ui/lib/pki/addon/helpers/current-mount-path.js)
- `class:94cb4eb7e90eef645c5b81681e8fffa0` class TransitionToHelper (third_party/openbao/ui/lib/pki/addon/helpers/transition-to.js)
- `file:third_party/openbao/ui/lib/pki/addon/helpers/current-mount-path.js` file current-mount-path.js (third_party/openbao/ui/lib/pki/addon/helpers/current-mount-path.js)
- `file:third_party/openbao/ui/lib/pki/addon/helpers/transition-to.js` file transition-to.js (third_party/openbao/ui/lib/pki/addon/helpers/transition-to.js)
<!-- SPECD_MANAGED_END -->
