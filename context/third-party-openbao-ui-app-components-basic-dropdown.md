# Context: third-party-openbao-ui-app-components-basic-dropdown

Repository: `deno-kcp`

The context records the local customization the application applies on top of the third-party `ember-basic-dropdown` addon. The addon trigger renders no `type` attribute, and a button inside a form defaults to `type="submit"`, so a dropdown trigger placed in a form would submit that form. Extending the addon trigger and declaring `attributeBindings: ['type']` lets a caller pass `type="button"` and get a plain toggle. The file stays a minimal vendored passthrough so addon upgrades remain cheap.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/components/basic-dropdown/trigger.js` file trigger.js (third_party/openbao/ui/app/components/basic-dropdown/trigger.js)
<!-- SPECD_MANAGED_END -->
