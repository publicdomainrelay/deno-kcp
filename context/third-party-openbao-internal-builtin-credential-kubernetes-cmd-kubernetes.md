# Context: third-party-openbao-internal-builtin-credential-kubernetes-cmd-kubernetes

Repository: `deno-kcp`

This context exists to pin down the contract of the Kubernetes credential backend's plugin binary: which SDK entry point it serves through, how it obtains its TLS provider, and how it fails. It gives reviewers and downstream tooling a stable statement of the entry point's obligations, because the file itself is a few statements of wiring whose correctness is entirely about calling the OpenBao plugin SDK in the right order with the right arguments.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/credential/kubernetes/cmd/kubernetes/main.go` file main.go (third_party/openbao/internal/builtin/credential/kubernetes/cmd/kubernetes/main.go)
<!-- SPECD_MANAGED_END -->
