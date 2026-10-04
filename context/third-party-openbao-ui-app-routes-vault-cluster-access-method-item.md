# Context: third-party-openbao-ui-app-routes-vault-cluster-access-method-item

Repository: `deno-kcp`

This context exists so the vault cluster access UI can present create, list, show, and edit pages for the items that belong to a given auth method (for example users, groups, or roles of that method) without writing a route per item type. The item type arrives as a route parameter, so one set of routes serves every generated model by composing the Ember Data model name from the singularized item type and the auth method type, and by passing the auth method path as adapter context. The context matters because the model-name derivation, the singularize step, the response path data.keys, and the transition guards are the contract the item templates and controllers depend on.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/routes/vault/cluster/access/method/item/create.js` file create.js (third_party/openbao/ui/app/routes/vault/cluster/access/method/item/create.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/method/item/edit.js` file edit.js (third_party/openbao/ui/app/routes/vault/cluster/access/method/item/edit.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/method/item/list.js` file list.js (third_party/openbao/ui/app/routes/vault/cluster/access/method/item/list.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/method/item/show.js` file show.js (third_party/openbao/ui/app/routes/vault/cluster/access/method/item/show.js)
<!-- SPECD_MANAGED_END -->
