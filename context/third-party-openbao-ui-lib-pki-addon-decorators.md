# Context: third-party-openbao-ui-lib-pki-addon-decorators

Repository: `deno-kcp`

This context exists so the PKI engine routes can detect whether a secrets engine has been configured before rendering. The withConfig decorator wraps a route and, during beforeModel, probes the unauthenticated pki/issuer endpoint for the current mount path. Routes apply the decorator to gain a shouldPromptConfig flag that the view layer can use to prompt the user for configuration. The guard keeps the decorator safe to apply only to Ember Route subclasses, degrading to a console error and the original class instead of throwing.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/lib/pki/addon/decorators/check-config.js` file check-config.js (third_party/openbao/ui/lib/pki/addon/decorators/check-config.js)
- `function:0c525784d07e38e0a048415378b52427` function decorator (third_party/openbao/ui/lib/pki/addon/decorators/check-config.js)
- `function:77c6c1fd50a76c505b38f9b6d4154d75` function withConfig (third_party/openbao/ui/lib/pki/addon/decorators/check-config.js)
<!-- SPECD_MANAGED_END -->
