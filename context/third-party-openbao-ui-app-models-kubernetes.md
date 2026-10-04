# Context: third-party-openbao-ui-app-models-kubernetes

Repository: `deno-kcp`

The context exists so the OpenBao UI can read, edit and validate Kubernetes secrets-engine configuration and roles without hand-rolled form code. KubernetesConfigModel declares which backend fields the config screen exposes, and KubernetesRoleModel declares the role fields plus the generation-preference state machine that decides whether OpenBao generates a basic service account, an expanded role binding, or uses fully user-supplied role rules, and that computes the capability flags the UI uses to show or hide actions.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:282a6a22ad22b2423f7af3f320e5ec45` class KubernetesRoleModel (third_party/openbao/ui/app/models/kubernetes/role.js)
- `class:b832b4e691efebc11e0e5a20e3c638bd` class KubernetesConfigModel (third_party/openbao/ui/app/models/kubernetes/config.js)
- `file:third_party/openbao/ui/app/models/kubernetes/config.js` file config.js (third_party/openbao/ui/app/models/kubernetes/config.js)
- `file:third_party/openbao/ui/app/models/kubernetes/role.js` file role.js (third_party/openbao/ui/app/models/kubernetes/role.js)
<!-- SPECD_MANAGED_END -->
