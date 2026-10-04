# Context: third-party-openbao-ui-app-initializers

Repository: `deno-kcp`

This context exists to pin down the boot-time behaviour that the vendored OpenBao UI contributes through Ember application initializers, separately from the rest of the Go code base in this repository. It records that the UI depends on Ember's initializer convention (an exported initialize function per file in app/initializers) and on the specific side effects those initializers apply to the application config, Ember Data, and the inspector. It matters because this code is third-party and copied rather than authored here, so the specification is needed to detect drift from upstream and to know which behaviour is intentional when the UI is upgraded.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/initializers/deprecation-filter.js` file deprecation-filter.js (third_party/openbao/ui/app/initializers/deprecation-filter.js)
- `file:third_party/openbao/ui/app/initializers/disable-ember-inspector.js` file disable-ember-inspector.js (third_party/openbao/ui/app/initializers/disable-ember-inspector.js)
- `file:third_party/openbao/ui/app/initializers/ember-data-identifiers.js` file ember-data-identifiers.js (third_party/openbao/ui/app/initializers/ember-data-identifiers.js)
- `file:third_party/openbao/ui/app/initializers/enable-engines.js` file enable-engines.js (third_party/openbao/ui/app/initializers/enable-engines.js)
- `function:87b40e749cff021538fa7e2b0998ba88` function initialize (third_party/openbao/ui/app/initializers/deprecation-filter.js)
<!-- SPECD_MANAGED_END -->
