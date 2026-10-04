# Context: third-party-openbao-ui-app-components-basic-dropdown

Repository: `deno-kcp`

The context exists to record the local customization the application applies on top of the third-party `ember-basic-dropdown` addon. The addon's trigger component normally renders without a `type` attribute, which is a problem when the trigger element is a button, because the HTML default for a button inside a form is `type="submit"` and the trigger would submit the surrounding form. By extending the addon component and adding `attributeBindings: ['type']`, the app lets callers set the trigger element's `type` explicitly, so a dropdown trigger inside a form can be rendered as `type="button"` and behave as a plain toggle instead of submitting. It is a vendored, minimal override, kept in the third_party tree, and is expected only to widen the addon's attribute surface, not to change its dropdown behavior.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/components/basic-dropdown/trigger.js` file trigger.js (third_party/openbao/ui/app/components/basic-dropdown/trigger.js)
<!-- SPECD_MANAGED_END -->
