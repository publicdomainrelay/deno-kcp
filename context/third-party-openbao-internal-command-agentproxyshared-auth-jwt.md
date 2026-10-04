# Context: third-party-openbao-internal-command-agentproxyshared-auth-jwt

Repository: `deno-kcp`

The context exists so that the agent proxy can authenticate to OpenBao with a JWT read from a file on disk and kept fresh by a polling watcher, instead of a static token. NewJWTAuthMethod is the construction and configuration surface, defining which config keys are required and which are optional and what the read cadence defaults to; Authenticate is the point where a current JWT is turned into a login request; NewCreds and CredSuccess are the handshake through which the method tells the agent that new credentials were found and that a credential cycle succeeded. Together they pin down the observable contract of the JWT auth method for the tests in jwt_test.go, which drive the delete-after-reading and symlink-following paths.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/command/agentproxyshared/auth/jwt/jwt.go` file jwt.go (third_party/openbao/internal/command/agentproxyshared/auth/jwt/jwt.go)
- `file:third_party/openbao/internal/command/agentproxyshared/auth/jwt/jwt_test.go` file jwt_test.go (third_party/openbao/internal/command/agentproxyshared/auth/jwt/jwt_test.go)
- `function:5309b89ba07996090ade8f15667301c7` function NewJWTAuthMethod (third_party/openbao/internal/command/agentproxyshared/auth/jwt/jwt.go)
- `method:448def8af0745a4758db8c0228a618b1` method jwtMethod.NewCreds (third_party/openbao/internal/command/agentproxyshared/auth/jwt/jwt.go)
- `method:564d5539ce5d0b556518bc2a4bac0ead` method jwtMethod.CredSuccess (third_party/openbao/internal/command/agentproxyshared/auth/jwt/jwt.go)
- `method:80be1d87e70084dc2be8fac52ffd9036` method jwtMethod.Authenticate (third_party/openbao/internal/command/agentproxyshared/auth/jwt/jwt.go)
- `method:efcbcd483e832be4936a32b3df90e691` method jwtMethod.Shutdown (third_party/openbao/internal/command/agentproxyshared/auth/jwt/jwt.go)
<!-- SPECD_MANAGED_END -->
