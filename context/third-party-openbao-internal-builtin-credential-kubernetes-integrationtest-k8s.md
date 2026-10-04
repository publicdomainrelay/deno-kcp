# Context: third-party-openbao-internal-builtin-credential-kubernetes-integrationtest-k8s

Repository: `deno-kcp`

This context exists to give integration tests of the Kubernetes auth backend a way to talk to a Vault/OpenBao instance that runs inside a Kubernetes pod. Because the container is not reachable directly from the test host, the package provides the two primitives the tests need: an authenticated clientset built from a caller-named kubeconfig context, and a port-forward that exposes the pod's Vault port 8200 on a free local port, together with a close function so the tunnel can be torn down. Both helpers share the same kubeconfig resolution path, and every failure is returned as a wrapped error naming the step that failed, so a broken test setup reports where it broke.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/credential/kubernetes/integrationtest/k8s/client.go` file client.go (third_party/openbao/internal/builtin/credential/kubernetes/integrationtest/k8s/client.go)
- `file:third_party/openbao/internal/builtin/credential/kubernetes/integrationtest/k8s/portforward.go` file portforward.go (third_party/openbao/internal/builtin/credential/kubernetes/integrationtest/k8s/portforward.go)
- `function:d25c5f13b828e6338775ee8d7712b2a2` function SetupPortForwarding (third_party/openbao/internal/builtin/credential/kubernetes/integrationtest/k8s/portforward.go)
- `function:fe4918691279e6a1d0666d8cef18d89f` function ClientFromKubeConfig (third_party/openbao/internal/builtin/credential/kubernetes/integrationtest/k8s/client.go)
<!-- SPECD_MANAGED_END -->
