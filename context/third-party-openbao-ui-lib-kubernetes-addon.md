# Context: third-party-openbao-ui-lib-kubernetes-addon

Repository: `deno-kcp`

The context exists to record the structure and wiring of the vendored OpenBao Kubernetes UI addon so that changes to it, or dependencies on its engine name, routes and injected services, are grounded in what the code actually declares. It matters because the addon is loaded as an Ember engine with a fixed module prefix and a fixed set of service and external-route dependencies, and any host application integration depends on those exact names.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:be97ad9bca27f8aa6c2b71e7e60c37a7` class KubernetesEngine (third_party/openbao/ui/lib/kubernetes/addon/engine.js)
- `file:third_party/openbao/ui/lib/kubernetes/addon/engine.js` file engine.js (third_party/openbao/ui/lib/kubernetes/addon/engine.js)
- `file:third_party/openbao/ui/lib/kubernetes/addon/routes.js` file routes.js (third_party/openbao/ui/lib/kubernetes/addon/routes.js)
<!-- SPECD_MANAGED_END -->
