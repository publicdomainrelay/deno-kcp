# Context: third-party-openbao-ui-lib-pki-addon-routes-configuration

Repository: `deno-kcp`

The context exists so the PKI addon has routable screens for viewing, creating and editing a PKI engine's configuration. The index route gathers every piece of configuration state the overview renders, the create route hands the template an empty pki/action record to submit a new configuration, and the edit route hands the template the current configuration values plus a breadcrumb trail. Grouping them describes one navigation unit: the read, create and edit halves of the same configuration resource, each loading its own model and shaping it for its template.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:328bc27d4d4d2e804e5c8d8445052f6e` class PkiConfigurationCreateRoute (third_party/openbao/ui/lib/pki/addon/routes/configuration/create.js)
- `class:3d56cd545182cf74e2eafcc5ca4cac9f` class ConfigurationIndexRoute (third_party/openbao/ui/lib/pki/addon/routes/configuration/index.js)
- `class:687415f6be20c0b7f58519cfc5fad17c` class PkiConfigurationEditRoute (third_party/openbao/ui/lib/pki/addon/routes/configuration/edit.js)
- `file:third_party/openbao/ui/lib/pki/addon/routes/configuration/create.js` file create.js (third_party/openbao/ui/lib/pki/addon/routes/configuration/create.js)
- `file:third_party/openbao/ui/lib/pki/addon/routes/configuration/edit.js` file edit.js (third_party/openbao/ui/lib/pki/addon/routes/configuration/edit.js)
- `file:third_party/openbao/ui/lib/pki/addon/routes/configuration/index.js` file index.js (third_party/openbao/ui/lib/pki/addon/routes/configuration/index.js)
<!-- SPECD_MANAGED_END -->
