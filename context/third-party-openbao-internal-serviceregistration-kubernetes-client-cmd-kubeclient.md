# Context: third-party-openbao-internal-serviceregistration-kubernetes-client-cmd-kubeclient

Repository: `deno-kcp`

It exists to give operators and developers a throwaway, dependency-light binary for manual testing of the Kubernetes service-registration client against a live cluster. It is meant to be built and copied into a running container so that real `GetPod` and `PatchPod` requests can be issued from inside the cluster, which is why it ships as a `main` package under a `cmd/` directory rather than as a library.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/serviceregistration/kubernetes/client/cmd/kubeclient/main.go` file main.go (third_party/openbao/internal/serviceregistration/kubernetes/client/cmd/kubeclient/main.go)
<!-- SPECD_MANAGED_END -->
