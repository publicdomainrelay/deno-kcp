# Context: third-party-openbao-ui-app-serializers-database

Repository: `deno-kcp`

These serializers exist so the OpenBao UI can present database connections, roles and generated credentials as Ember Data models while the underlying API keeps its own wire shape. They absorb the API's asymmetries: list endpoints return only a key array while detail endpoints return full objects, write endpoints return nothing useful, and some fields are named differently on the way out than on the way in. The context is the database-specific part of the UI serializer layer and is meant to be read together with the database models, adapters and utils/database-helpers.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/serializers/database/connection.js` file connection.js (third_party/openbao/ui/app/serializers/database/connection.js)
- `file:third_party/openbao/ui/app/serializers/database/credential.js` file credential.js (third_party/openbao/ui/app/serializers/database/credential.js)
- `file:third_party/openbao/ui/app/serializers/database/role.js` file role.js (third_party/openbao/ui/app/serializers/database/role.js)
<!-- SPECD_MANAGED_END -->
