# Context: third-party-openbao-internal-command-agentproxyshared-auth-kubernetes

Repository: `deno-kcp`

The context exists so that an OpenBao agent can authenticate to an OpenBao server with a Kubernetes service account token. It is the Kubernetes implementation of the shared auth.AuthMethod interface the agentproxyshared auth package declares: the constructor turns agent configuration into a method object, and the method object supplies the login request the agent sends. Because the plugin is vendored third-party code inside deno-kcp, the specification records the observed contract of that plugin rather than any locally authored behavior.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/command/agentproxyshared/auth/kubernetes/kubernetes.go` file kubernetes.go (third_party/openbao/internal/command/agentproxyshared/auth/kubernetes/kubernetes.go)
- `file:third_party/openbao/internal/command/agentproxyshared/auth/kubernetes/kubernetes_test.go` file kubernetes_test.go (third_party/openbao/internal/command/agentproxyshared/auth/kubernetes/kubernetes_test.go)
- `function:662cee05789c54192c8afe7da9a01545` function NewKubernetesAuthMethod (third_party/openbao/internal/command/agentproxyshared/auth/kubernetes/kubernetes.go)
- `method:803ebafa8f0153e48e3b463bf0a8d692` method kubernetesMethod.CredSuccess (third_party/openbao/internal/command/agentproxyshared/auth/kubernetes/kubernetes.go)
- `method:f25ad26825ee628d87faab8aef7dfac3` method kubernetesMethod.NewCreds (third_party/openbao/internal/command/agentproxyshared/auth/kubernetes/kubernetes.go)
- `method:f80a23c01970f9ec5b0b63d5aadc409f` method kubernetesMethod.Authenticate (third_party/openbao/internal/command/agentproxyshared/auth/kubernetes/kubernetes.go)
- `method:f92c67aafe17516364b2ccda9028bc4f` method kubernetesMethod.Shutdown (third_party/openbao/internal/command/agentproxyshared/auth/kubernetes/kubernetes.go)
<!-- SPECD_MANAGED_END -->
