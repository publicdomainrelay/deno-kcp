# Context: third-party-openbao-ui-lib-pki-addon

Repository: `deno-kcp`

This context exists so the PKI addon can be mounted as a lazy, isolated Ember engine inside the wider OpenBao UI host application. Separating the engine class in engine.js from the route map in routes.js lets the host mount the whole PKI surface under one prefix, hand the engine only the services it is allowed to inject through the explicit dependencies list, and keep its external route references declared rather than discovered at runtime. The engine fixes exactly three things at load time: the module namespace it resolves from, the Resolver for that namespace, and what it needs from the host.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:c54f0a4df0f27bc8cff3a755b9e76744` class PkiEngine (third_party/openbao/ui/lib/pki/addon/engine.js)
- `file:third_party/openbao/ui/lib/pki/addon/engine.js` file engine.js (third_party/openbao/ui/lib/pki/addon/engine.js)
- `file:third_party/openbao/ui/lib/pki/addon/routes.js` file routes.js (third_party/openbao/ui/lib/pki/addon/routes.js)
<!-- SPECD_MANAGED_END -->
