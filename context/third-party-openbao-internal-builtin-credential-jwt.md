# Context: third-party-openbao-internal-builtin-credential-jwt

Repository: `deno-kcp`

This context exists because the JWT/OIDC auth plugin is vendored third-party OpenBao code inside deno-kcp, and it needs one spec that states what the package actually provides: the backend factory, the CLI login handler, the QR rendering writer, the CustomProvider contract, the three optional provider extension interfaces, the provider registry and resolution function, and the five concrete provider implementations. Recording these interfaces and requirements makes the vendored plugin's public surface explicit, so that changes to it, or reliance on it from elsewhere in the repository, can be checked against a stated contract instead of re-reading the files.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/credential/jwt/backend.go` file backend.go (third_party/openbao/internal/builtin/credential/jwt/backend.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/claims.go` file claims.go (third_party/openbao/internal/builtin/credential/jwt/claims.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/claims_test.go` file claims_test.go (third_party/openbao/internal/builtin/credential/jwt/claims_test.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/cli.go` file cli.go (third_party/openbao/internal/builtin/credential/jwt/cli.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/cli_auth_no_sigtstp.go` file cli_auth_no_sigtstp.go (third_party/openbao/internal/builtin/credential/jwt/cli_auth_no_sigtstp.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/cli_auth_sigtstp.go` file cli_auth_sigtstp.go (third_party/openbao/internal/builtin/credential/jwt/cli_auth_sigtstp.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/cli_qr.go` file cli_qr.go (third_party/openbao/internal/builtin/credential/jwt/cli_qr.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/cli_qr_test.go` file cli_qr_test.go (third_party/openbao/internal/builtin/credential/jwt/cli_qr_test.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/cli_test.go` file cli_test.go (third_party/openbao/internal/builtin/credential/jwt/cli_test.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/html_responses.go` file html_responses.go (third_party/openbao/internal/builtin/credential/jwt/html_responses.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/path_cel_login.go` file path_cel_login.go (third_party/openbao/internal/builtin/credential/jwt/path_cel_login.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/path_cel_login_test.go` file path_cel_login_test.go (third_party/openbao/internal/builtin/credential/jwt/path_cel_login_test.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/path_cel_role.go` file path_cel_role.go (third_party/openbao/internal/builtin/credential/jwt/path_cel_role.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/path_cel_role_test.go` file path_cel_role_test.go (third_party/openbao/internal/builtin/credential/jwt/path_cel_role_test.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/path_config.go` file path_config.go (third_party/openbao/internal/builtin/credential/jwt/path_config.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/path_config_test.go` file path_config_test.go (third_party/openbao/internal/builtin/credential/jwt/path_config_test.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/path_login.go` file path_login.go (third_party/openbao/internal/builtin/credential/jwt/path_login.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/path_login_test.go` file path_login_test.go (third_party/openbao/internal/builtin/credential/jwt/path_login_test.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/path_oidc.go` file path_oidc.go (third_party/openbao/internal/builtin/credential/jwt/path_oidc.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/path_oidc_test.go` file path_oidc_test.go (third_party/openbao/internal/builtin/credential/jwt/path_oidc_test.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/path_role.go` file path_role.go (third_party/openbao/internal/builtin/credential/jwt/path_role.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/path_role_test.go` file path_role_test.go (third_party/openbao/internal/builtin/credential/jwt/path_role_test.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/provider_azure.go` file provider_azure.go (third_party/openbao/internal/builtin/credential/jwt/provider_azure.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/provider_azure_test.go` file provider_azure_test.go (third_party/openbao/internal/builtin/credential/jwt/provider_azure_test.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/provider_config.go` file provider_config.go (third_party/openbao/internal/builtin/credential/jwt/provider_config.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/provider_config_test.go` file provider_config_test.go (third_party/openbao/internal/builtin/credential/jwt/provider_config_test.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/provider_gsuite.go` file provider_gsuite.go (third_party/openbao/internal/builtin/credential/jwt/provider_gsuite.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/provider_gsuite_test.go` file provider_gsuite_test.go (third_party/openbao/internal/builtin/credential/jwt/provider_gsuite_test.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/provider_ibmisam.go` file provider_ibmisam.go (third_party/openbao/internal/builtin/credential/jwt/provider_ibmisam.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/provider_ibmisam_test.go` file provider_ibmisam_test.go (third_party/openbao/internal/builtin/credential/jwt/provider_ibmisam_test.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/provider_kubernetes.go` file provider_kubernetes.go (third_party/openbao/internal/builtin/credential/jwt/provider_kubernetes.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/provider_kubernetes_test.go` file provider_kubernetes_test.go (third_party/openbao/internal/builtin/credential/jwt/provider_kubernetes_test.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/provider_secureauth.go` file provider_secureauth.go (third_party/openbao/internal/builtin/credential/jwt/provider_secureauth.go)

_44 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
