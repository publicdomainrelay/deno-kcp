# Context: third-party-openbao-ui-app-adapters-database

Repository: `deno-kcp`

These adapters exist so the OpenBao UI can present and edit database secrets engine state (connections, roles and generated credentials) through the standard Ember Data store API instead of raw fetch calls. They exist as a separate context because each adapter encodes a distinct piece of the database engine's URL and error semantics: the connection adapter owns the /config endpoint plus the rotate-root and reset sub-resources, the credential adapter owns /creds and /static-creds and has to reconcile the ambiguity between dynamic and static credential roles, and the role adapter owns /roles and /static-roles and must keep the allowed_roles back-reference on the owning connection consistent on create and delete. The context is the boundary where Ember Data conventions meet the database engine's HTTP API.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/adapters/database/connection.js` file connection.js (third_party/openbao/ui/app/adapters/database/connection.js)
- `file:third_party/openbao/ui/app/adapters/database/credential.js` file credential.js (third_party/openbao/ui/app/adapters/database/credential.js)
- `file:third_party/openbao/ui/app/adapters/database/role.js` file role.js (third_party/openbao/ui/app/adapters/database/role.js)
<!-- SPECD_MANAGED_END -->
