# Context: third-party-openbao-ui-app-models-database

Repository: `deno-kcp`

This context exists so the UI database models can be described and regenerated as a unit: the connection form, the role form and the credential read-model that the database secrets engine routes render. It records the attribute surfaces each model must declare, the plugin-name-driven field derivation that makes one connection model serve every supported database plugin, the special-casing that hides revocation statements for elasticsearch, and the capability aliases templates read instead of calling the API directly.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/models/database/connection.js` file connection.js (third_party/openbao/ui/app/models/database/connection.js)
- `file:third_party/openbao/ui/app/models/database/credential.js` file credential.js (third_party/openbao/ui/app/models/database/credential.js)
- `file:third_party/openbao/ui/app/models/database/role.js` file role.js (third_party/openbao/ui/app/models/database/role.js)
<!-- SPECD_MANAGED_END -->
