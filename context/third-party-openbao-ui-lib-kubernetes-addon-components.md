# Context: third-party-openbao-ui-lib-kubernetes-addon-components

Repository: `deno-kcp`

This context exists to fix the contract of the tab page header component for the Kubernetes secrets engine in the vendored OpenBao UI. Consumers of the component, and anything that replaces or regenerates this vendored file, need to know that the component contributes exactly one URL mapping and that the list route it points at is the Kubernetes roles list route. It is recorded as a spec so that a future change to this file, or a port of the OpenBao UI into this repository, can be checked against the same single observable behavior instead of being re-derived from the vendored source.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:93c349010e8be9f7f1b9baab11fdffc4` class TabPageHeaderComponent (third_party/openbao/ui/lib/kubernetes/addon/components/tab-page-header.js)
- `file:third_party/openbao/ui/lib/kubernetes/addon/components/tab-page-header.js` file tab-page-header.js (third_party/openbao/ui/lib/kubernetes/addon/components/tab-page-header.js)
<!-- SPECD_MANAGED_END -->
