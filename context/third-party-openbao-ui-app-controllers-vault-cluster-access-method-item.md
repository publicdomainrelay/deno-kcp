# Context: third-party-openbao-ui-app-controllers-vault-cluster-access-method-item

Repository: `deno-kcp`

The context exists to describe how the OpenBao UI item controllers manage route-model lifecycle and list-filter state. create.js exists so a controller singleton can unload a route model safely after the create screen is left, avoiding stale or dirty records leaking into the Ember Data store. edit.js exists so the edit route reuses that exact cleanup contract without duplicating it. list.js exists so the item list screen can paginate, filter by name, and support keyboard-style first-partial-match selection while delegating data refresh to the list route.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/controllers/vault/cluster/access/method/item/create.js` file create.js (third_party/openbao/ui/app/controllers/vault/cluster/access/method/item/create.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/access/method/item/edit.js` file edit.js (third_party/openbao/ui/app/controllers/vault/cluster/access/method/item/edit.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/access/method/item/list.js` file list.js (third_party/openbao/ui/app/controllers/vault/cluster/access/method/item/list.js)
<!-- SPECD_MANAGED_END -->
