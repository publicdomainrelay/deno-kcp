# Context: third-party-openbao-internal-builtin-credential-jwt-cmd-jwt

Repository: `deno-kcp`

This context exists to capture the process-level bootstrap that turns the JWT/OIDC credential backend into a runnable OpenBao/Vault plugin binary. It is deliberately thin: it owns flag parsing, TLS config derivation, and the `plugin.ServeMultiplex` wiring, while all backend behavior lives in the jwtauth package imported as `jwtauth`. It must stay correct because it is the only path by which the JWT backend is mounted as an external plugin, and the explicit `TLSProviderFunc` exists purely to keep older Vault versions without AutoMTLS working.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/credential/jwt/cmd/jwt/main.go` file main.go (third_party/openbao/internal/builtin/credential/jwt/cmd/jwt/main.go)
<!-- SPECD_MANAGED_END -->
