# Context: third-party-openbao-internal-builtin-logical-kubernetes-cmd-kubernetes

Repository: `deno-kcp`

This context exists so the Kubernetes secrets engine can run as an external OpenBao plugin process: a host launches the binary, passes TLS material and the unwrap token through the plugin handshake, and the binary serves the kubernetes logical backend over the plugin multiplex protocol. The context pins down the entrypoint's flag surface and its shutdown behavior, which are the only things this file decides; all backend behavior lives in the imported kubernetes package.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/logical/kubernetes/cmd/kubernetes/main.go` file main.go (third_party/openbao/internal/builtin/logical/kubernetes/cmd/kubernetes/main.go)
<!-- SPECD_MANAGED_END -->
