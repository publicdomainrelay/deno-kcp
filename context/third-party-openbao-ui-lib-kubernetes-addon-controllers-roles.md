# Context: third-party-openbao-ui-lib-kubernetes-addon-controllers-roles

Repository: `deno-kcp`

This context exists to pin down the URL-state surface of the Kubernetes roles page: the roles route's controller must declare pageFilter as a query parameter so the route can read and update the filter value from the query string, and so the page component that renders the roles list can drive it. It is a thin contract file, and the spec records that contract rather than any behavior, because the class carries no logic of its own.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:141604e723dca54066003e3aac39ce43` class KubernetesRolesController (third_party/openbao/ui/lib/kubernetes/addon/controllers/roles/index.js)
- `file:third_party/openbao/ui/lib/kubernetes/addon/controllers/roles/index.js` file index.js (third_party/openbao/ui/lib/kubernetes/addon/controllers/roles/index.js)
<!-- SPECD_MANAGED_END -->
