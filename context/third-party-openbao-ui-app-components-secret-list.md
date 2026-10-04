# Context: third-party-openbao-ui-app-components-secret-list

Repository: `deno-kcp`

This context exists so the database secret list can render per-row type information and offer per-row connection and credential operations without owning backend logic. The component delegates all mutation to Ember Data adapters and reports outcomes through the flash message service, keeping the template thin. The specification records which path values map to which key type and which adapter each action must talk to, so the list item's contract with the adapters and the user-visible flash strings stay stable.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:bc88e2dbcf655ddde7b5f9a44d105440` class DatabaseListItem (third_party/openbao/ui/app/components/secret-list/database-list-item.js)
- `file:third_party/openbao/ui/app/components/secret-list/database-list-item.js` file database-list-item.js (third_party/openbao/ui/app/components/secret-list/database-list-item.js)
<!-- SPECD_MANAGED_END -->
