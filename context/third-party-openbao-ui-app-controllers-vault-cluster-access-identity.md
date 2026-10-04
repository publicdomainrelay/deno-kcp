# Context: third-party-openbao-ui-app-controllers-vault-cluster-access-identity

Repository: `deno-kcp`

This context exists so the identity management routes of the OpenBao UI have describable controller behavior: a single create controller carries the post-save/post-delete navigation and record cleanup contract, the edit and merge controllers reuse it verbatim, and the index controller carries the list screen's filtering, pagination, deletion, and enable/disable toggling contract. It captures the code as written, including that edit and merge add no behavior of their own.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/controllers/vault/cluster/access/identity/create.js` file create.js (third_party/openbao/ui/app/controllers/vault/cluster/access/identity/create.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/access/identity/edit.js` file edit.js (third_party/openbao/ui/app/controllers/vault/cluster/access/identity/edit.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/access/identity/index.js` file index.js (third_party/openbao/ui/app/controllers/vault/cluster/access/identity/index.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/access/identity/merge.js` file merge.js (third_party/openbao/ui/app/controllers/vault/cluster/access/identity/merge.js)
<!-- SPECD_MANAGED_END -->
