# Context: third-party-openbao-internal-command-agentproxyshared-auth-cert

Repository: `deno-kcp`

This context exists so the agent proxy can authenticate to OpenBao using TLS client certificates instead of a renewable token. The cert method only supplies the login path and optional certificate-role name; the actual client certificate is presented by the TLS layer, so the method has no credential lifecycle to manage, which is why NewCreds returns nil and CredSuccess and Shutdown do nothing. The constructor exists to validate and default the operator-supplied config map before the agent starts.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/command/agentproxyshared/auth/cert/cert.go` file cert.go (third_party/openbao/internal/command/agentproxyshared/auth/cert/cert.go)
- `file:third_party/openbao/internal/command/agentproxyshared/auth/cert/cert_test.go` file cert_test.go (third_party/openbao/internal/command/agentproxyshared/auth/cert/cert_test.go)
- `function:72c0b4a6fb15e6576d02c8b829aa8eee` function NewCertAuthMethod (third_party/openbao/internal/command/agentproxyshared/auth/cert/cert.go)
- `method:1e8a9476171783802a48d8ae2a820e70` method certMethod.Shutdown (third_party/openbao/internal/command/agentproxyshared/auth/cert/cert.go)
- `method:74691b628a048e5ca411f2fa36bec155` method certMethod.AuthClient (third_party/openbao/internal/command/agentproxyshared/auth/cert/cert.go)
- `method:7751c7f52375b2b2f7cf5af5395cb14d` method certMethod.Authenticate (third_party/openbao/internal/command/agentproxyshared/auth/cert/cert.go)
- `method:f2f59a52905ef7981a48da042ea46b1c` method certMethod.NewCreds (third_party/openbao/internal/command/agentproxyshared/auth/cert/cert.go)
- `method:f4018509912bf7d804f7eb0bb134b395` method certMethod.CredSuccess (third_party/openbao/internal/command/agentproxyshared/auth/cert/cert.go)
<!-- SPECD_MANAGED_END -->
