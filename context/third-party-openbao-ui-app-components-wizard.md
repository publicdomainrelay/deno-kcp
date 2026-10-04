# Context: third-party-openbao-ui-app-components-wizard

Repository: `deno-kcp`

The context exists to describe the wizard UI layer that walks a user through enabling secrets key management in OpenBao. WizardSecretsKeymgmtComponent turns the current wizard step, carried on this.args.featureState, into the three pieces of copy the template needs: a short header, a paragraph of body text explaining what the step does, and a line of instruction telling the user which action to take next. Keeping these strings in three parallel getters means a step's presentation is data-driven from a single state value rather than being branched over in the template, and it gives a single place to change wording for the provider, displayProvider and distribute steps.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:656df5a359affa07968d6ed808e4c3f9` class WizardSecretsKeymgmtComponent (third_party/openbao/ui/app/components/wizard/secrets-keymgmt.js)
- `file:third_party/openbao/ui/app/components/wizard/features-selection.js` file features-selection.js (third_party/openbao/ui/app/components/wizard/features-selection.js)
- `file:third_party/openbao/ui/app/components/wizard/mounts-wizard.js` file mounts-wizard.js (third_party/openbao/ui/app/components/wizard/mounts-wizard.js)
- `file:third_party/openbao/ui/app/components/wizard/secrets-keymgmt.js` file secrets-keymgmt.js (third_party/openbao/ui/app/components/wizard/secrets-keymgmt.js)
<!-- SPECD_MANAGED_END -->
