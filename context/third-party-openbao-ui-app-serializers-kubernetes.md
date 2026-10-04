# Context: third-party-openbao-ui-app-serializers-kubernetes

Repository: `deno-kcp`

The context exists to pin down the payload-shaping behaviour of the OpenBao UI Kubernetes serializers, which is easy to get wrong because the model identity key and the wire payload disagree: the model is keyed by backend, yet backend must never reach the API body. It also records the asymmetric cleanup rule, found only in config.js, that discards stale manual-CA fields when disable_local_ca_jwt is false, a condition the role serializer does not share. Recording both files together keeps the pair that looks identical in outline but differs in one branch explicit.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:8676fa2c6e4d5a795d361476a4483ad5` class KubernetesConfigSerializer (third_party/openbao/ui/app/serializers/kubernetes/config.js)
- `file:third_party/openbao/ui/app/serializers/kubernetes/config.js` file config.js (third_party/openbao/ui/app/serializers/kubernetes/config.js)
- `file:third_party/openbao/ui/app/serializers/kubernetes/role.js` file role.js (third_party/openbao/ui/app/serializers/kubernetes/role.js)
<!-- SPECD_MANAGED_END -->
