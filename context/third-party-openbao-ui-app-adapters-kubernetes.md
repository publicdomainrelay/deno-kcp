# Context: third-party-openbao-ui-app-adapters-kubernetes

Repository: `deno-kcp`

This context exists to specify the browser-side Kubernetes secrets engine integration of the bundled OpenBao UI: the read and write paths the UI uses against a Kubernetes mount, so the config singleton and the per-mount roles plus credential generation stay addressable and serializable. It records which HTTP verbs and URL shapes the adapters emit, how the backend mount path travels through query, snapshot and response objects, and which fields the models expect back, so the UI layer keeps working unchanged against the Kubernetes secrets engine API.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:4ccde46e2def7df4b8568c996f3e847f` class KubernetesRoleAdapter (third_party/openbao/ui/app/adapters/kubernetes/role.js)
- `class:79c09b75c4ee536ddd9bf3addc6df266` class KubernetesConfigAdapter (third_party/openbao/ui/app/adapters/kubernetes/config.js)
- `file:third_party/openbao/ui/app/adapters/kubernetes/config.js` file config.js (third_party/openbao/ui/app/adapters/kubernetes/config.js)
- `file:third_party/openbao/ui/app/adapters/kubernetes/role.js` file role.js (third_party/openbao/ui/app/adapters/kubernetes/role.js)
<!-- SPECD_MANAGED_END -->
