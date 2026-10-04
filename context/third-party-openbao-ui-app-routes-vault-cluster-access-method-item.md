# Context: third-party-openbao-ui-app-routes-vault-cluster-access-method-item

Repository: `deno-kcp`

This context exists so the vault cluster access UI can present create, list, show, and edit pages for the items that belong to a given auth method (users, groups, roles of that method, for example) without writing a separate route per item type. Because the item type arrives as a route parameter, one set of routes serves every generated model: the model name is composed from the singularized item type and the auth method type, and the auth method path is passed through as adapter context. The model-name derivation, the singularize step, the data.keys response path, and the transition guards form the contract the item templates and controllers depend on.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/routes/vault/cluster/access/method/item/create.js` file create.js (third_party/openbao/ui/app/routes/vault/cluster/access/method/item/create.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/method/item/edit.js` file edit.js (third_party/openbao/ui/app/routes/vault/cluster/access/method/item/edit.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/method/item/list.js` file list.js (third_party/openbao/ui/app/routes/vault/cluster/access/method/item/list.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/method/item/show.js` file show.js (third_party/openbao/ui/app/routes/vault/cluster/access/method/item/show.js)
<!-- SPECD_MANAGED_END -->
