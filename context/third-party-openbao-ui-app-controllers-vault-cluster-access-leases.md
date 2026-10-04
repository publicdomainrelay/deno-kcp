# Context: third-party-openbao-ui-app-controllers-vault-cluster-access-leases

Repository: `deno-kcp`

This context exists so the leases UI controllers can be described and changed as a unit: they share the list-root alias, the cluster breadcrumb, the lease adapter calls, and the safe-transition helper, and a change to one of them (for example the revoke flow or the filter behavior) usually has to stay consistent with the others. It exists to pin down what the list and detail screens must do, without restating the templates or routes that consume them.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/controllers/vault/cluster/access/leases/index.js` file index.js (third_party/openbao/ui/app/controllers/vault/cluster/access/leases/index.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/access/leases/list-root.js` file list-root.js (third_party/openbao/ui/app/controllers/vault/cluster/access/leases/list-root.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/access/leases/list.js` file list.js (third_party/openbao/ui/app/controllers/vault/cluster/access/leases/list.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/access/leases/show.js` file show.js (third_party/openbao/ui/app/controllers/vault/cluster/access/leases/show.js)
<!-- SPECD_MANAGED_END -->
