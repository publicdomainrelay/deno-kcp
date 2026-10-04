# Context: third-party-openbao-ui-lib-kubernetes-addon-routes-roles

Repository: `deno-kcp`

This context exists to specify the routing and data-loading behaviour of the Kubernetes roles section of the OpenBao UI addon: how the roles index route discovers and filters roles for a mounted secrets backend, how the create route prepares a new empty role record, and how each route sets up the controller with the right breadcrumbs. It gives a downstream reader or generator the contract each route must satisfy without needing to read the whole UI addon.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:0c231d92d2ed3d2fb91e19247e23cb12` class KubernetesRolesRoute (third_party/openbao/ui/lib/kubernetes/addon/routes/roles/index.js)
- `class:42e8a3960e1f95ab7d2b43366f5be9de` class KubernetesRolesCreateRoute (third_party/openbao/ui/lib/kubernetes/addon/routes/roles/create.js)
- `file:third_party/openbao/ui/lib/kubernetes/addon/routes/roles/create.js` file create.js (third_party/openbao/ui/lib/kubernetes/addon/routes/roles/create.js)
- `file:third_party/openbao/ui/lib/kubernetes/addon/routes/roles/index.js` file index.js (third_party/openbao/ui/lib/kubernetes/addon/routes/roles/index.js)
<!-- SPECD_MANAGED_END -->
