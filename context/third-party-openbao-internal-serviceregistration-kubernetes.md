# Context: third-party-openbao-internal-serviceregistration-kubernetes

Repository: `deno-kcp`

This context exists to describe the Kubernetes service registration implementation that OpenBao uses to publish pod state as labels on its own pod, and the retry layer that keeps those label patches applied when the Kubernetes API is transiently unavailable. It is documented so the construction path, the state notification surface and the retry semantics are explicit rather than inferred from the surrounding command code that calls them.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/serviceregistration/kubernetes/retry_handler.go` file retry_handler.go (third_party/openbao/internal/serviceregistration/kubernetes/retry_handler.go)
- `file:third_party/openbao/internal/serviceregistration/kubernetes/retry_handler_test.go` file retry_handler_test.go (third_party/openbao/internal/serviceregistration/kubernetes/retry_handler_test.go)
- `file:third_party/openbao/internal/serviceregistration/kubernetes/service_registration.go` file service_registration.go (third_party/openbao/internal/serviceregistration/kubernetes/service_registration.go)
- `file:third_party/openbao/internal/serviceregistration/kubernetes/service_registration_test.go` file service_registration_test.go (third_party/openbao/internal/serviceregistration/kubernetes/service_registration_test.go)
- `function:bbf84ead9ca06f06cda8b7776cb9e562` function NewServiceRegistration (third_party/openbao/internal/serviceregistration/kubernetes/service_registration.go)
- `method:4b1f23f2f0887d041e13b22b0cfac769` method retryHandler.Notify (third_party/openbao/internal/serviceregistration/kubernetes/retry_handler.go)
- `method:7fe76a8fed667f4ffc812b5ca6792954` method serviceRegistration.NotifyActiveStateChange (third_party/openbao/internal/serviceregistration/kubernetes/service_registration.go)
- `method:841ce99015784c3428e7be159afd9294` method serviceRegistration.NotifySealedStateChange (third_party/openbao/internal/serviceregistration/kubernetes/service_registration.go)
- `method:928d3c98917dab34063c719eb0159110` method retryHandler.Run (third_party/openbao/internal/serviceregistration/kubernetes/retry_handler.go)
- `method:cb7fe2225119b3b317fac64c8ba6b0f4` method serviceRegistration.NotifyPerformanceStandbyStateChange (third_party/openbao/internal/serviceregistration/kubernetes/service_registration.go)
- `method:db3e2c22d822aa06c246592130d719e7` method serviceRegistration.Run (third_party/openbao/internal/serviceregistration/kubernetes/service_registration.go)
- `method:ff4cffb6239d0aa5d138c0f9bd505b32` method serviceRegistration.NotifyInitializedStateChange (third_party/openbao/internal/serviceregistration/kubernetes/service_registration.go)
<!-- SPECD_MANAGED_END -->
