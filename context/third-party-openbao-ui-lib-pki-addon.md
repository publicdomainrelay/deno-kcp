# Context: third-party-openbao-ui-lib-pki-addon

Repository: `deno-kcp`

This context exists so the PKI addon can be loaded as a lazy, isolated Ember engine inside the wider OpenBao UI host application. Splitting the addon into an engine class plus a separate route map lets the host mount the whole PKI surface under one prefix, hand it only the services it is allowed to use through the explicit dependencies list, and keep its external route references declared rather than discovered at runtime. The context is described here only at its entrypoint level, because the facts available are the engine class definition and the two entry files, not the components or models the addon resolves internally.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:c54f0a4df0f27bc8cff3a755b9e76744` class PkiEngine (third_party/openbao/ui/lib/pki/addon/engine.js)
- `file:third_party/openbao/ui/lib/pki/addon/engine.js` file engine.js (third_party/openbao/ui/lib/pki/addon/engine.js)
- `file:third_party/openbao/ui/lib/pki/addon/routes.js` file routes.js (third_party/openbao/ui/lib/pki/addon/routes.js)
<!-- SPECD_MANAGED_END -->
