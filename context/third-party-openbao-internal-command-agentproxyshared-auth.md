# Context: third-party-openbao-internal-command-agentproxyshared-auth

Repository: `deno-kcp`

This context exists because agent and proxy auto-auth needs one place that owns the token lifecycle: it defines the contract credential methods implement, decides when to re-authenticate or renew, fans the token out to file/template/exec sinks, and keeps retry behavior uniform across all auth methods. It is the shared dependency of the approle, cert, jwt, kubernetes and token-file method packages, so its interfaces and configuration structs are the seam those packages and the agent/sink code compile against.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/command/agentproxyshared/auth/auth.go` file auth.go (third_party/openbao/internal/command/agentproxyshared/auth/auth.go)
- `file:third_party/openbao/internal/command/agentproxyshared/auth/auth_test.go` file auth_test.go (third_party/openbao/internal/command/agentproxyshared/auth/auth_test.go)
- `function:dce3dfc9a119cb3f8d51a85e7cc0c4c1` function NewAuthHandler (third_party/openbao/internal/command/agentproxyshared/auth/auth.go)
- `interface:0d74489ab0d559a9769b26c729cee007` interface AuthMethod (third_party/openbao/internal/command/agentproxyshared/auth/auth.go)
- `interface:d197ccafdc0a79f7b5f34693af3e4723` interface AuthMethodWithClient (third_party/openbao/internal/command/agentproxyshared/auth/auth.go)
- `method:05b8dcd27eda904ebd0f01667b26547e` method AuthMethod.NewCreds (third_party/openbao/internal/command/agentproxyshared/auth/auth.go)
- `method:0e8ea0d941e22ea58ef3a88d096fefb4` method AuthMethodWithClient.AuthClient (third_party/openbao/internal/command/agentproxyshared/auth/auth.go)
- `method:3031eb440e4b09b483f86a106036de8b` method AuthMethod.Authenticate (third_party/openbao/internal/command/agentproxyshared/auth/auth.go)
- `method:356a9104cf38f50d20bdd8b28b005400` method autoAuthBackoff.String (third_party/openbao/internal/command/agentproxyshared/auth/auth.go)
- `method:600796333fc443a1fcce1cf63eae033e` method AuthMethod.Shutdown (third_party/openbao/internal/command/agentproxyshared/auth/auth.go)
- `method:ad8dc37f5a35b58de42ae1227cece785` method AuthHandler.Run (third_party/openbao/internal/command/agentproxyshared/auth/auth.go)
- `method:dd14a787df21b4dd31349d380e916be1` method AuthMethod.CredSuccess (third_party/openbao/internal/command/agentproxyshared/auth/auth.go)
- `struct:283295d326d630f31d67353ca011a1f7` struct AuthHandlerConfig (third_party/openbao/internal/command/agentproxyshared/auth/auth.go)
- `struct:aca458a585521ce17b4a96b9a546b1af` struct AuthHandler (third_party/openbao/internal/command/agentproxyshared/auth/auth.go)
- `struct:f1af97701d51ef4e9dbcff6f27be7097` struct AuthConfig (third_party/openbao/internal/command/agentproxyshared/auth/auth.go)
<!-- SPECD_MANAGED_END -->
