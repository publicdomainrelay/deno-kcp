# Context: third-party-openbao-internal-builtin-credential-userpass

Repository: `deno-kcp`

The context exists to describe how the vendored userpass credential backend is structured and what it must do: mount a credential backend that authenticates users by username and password, expose user administration paths, and provide the CLI-facing auth and help surface. It is a third-party subtree of deno-kcp, so the spec records the code as it stands rather than proposing changes, and gives a stable anchor set for the backend, its paths, and its exported CLI handler.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/credential/userpass/backend.go` file backend.go (third_party/openbao/internal/builtin/credential/userpass/backend.go)
- `file:third_party/openbao/internal/builtin/credential/userpass/backend_test.go` file backend_test.go (third_party/openbao/internal/builtin/credential/userpass/backend_test.go)
- `file:third_party/openbao/internal/builtin/credential/userpass/cli.go` file cli.go (third_party/openbao/internal/builtin/credential/userpass/cli.go)
- `file:third_party/openbao/internal/builtin/credential/userpass/password_validation_test.go` file password_validation_test.go (third_party/openbao/internal/builtin/credential/userpass/password_validation_test.go)
- `file:third_party/openbao/internal/builtin/credential/userpass/path_login.go` file path_login.go (third_party/openbao/internal/builtin/credential/userpass/path_login.go)
- `file:third_party/openbao/internal/builtin/credential/userpass/path_login_test.go` file path_login_test.go (third_party/openbao/internal/builtin/credential/userpass/path_login_test.go)
- `file:third_party/openbao/internal/builtin/credential/userpass/path_user_password.go` file path_user_password.go (third_party/openbao/internal/builtin/credential/userpass/path_user_password.go)
- `file:third_party/openbao/internal/builtin/credential/userpass/path_user_policies.go` file path_user_policies.go (third_party/openbao/internal/builtin/credential/userpass/path_user_policies.go)
- `file:third_party/openbao/internal/builtin/credential/userpass/path_users.go` file path_users.go (third_party/openbao/internal/builtin/credential/userpass/path_users.go)
- `file:third_party/openbao/internal/builtin/credential/userpass/stepwise_test.go` file stepwise_test.go (third_party/openbao/internal/builtin/credential/userpass/stepwise_test.go)
- `function:1f63899e28851cb40d189549fcae73bf` function Factory (third_party/openbao/internal/builtin/credential/userpass/backend.go)
- `function:af5528190992c8c19e6b1b81246f4adf` function Backend (third_party/openbao/internal/builtin/credential/userpass/backend.go)
- `method:b9610c512ba58f5978c0aa99848c9a1f` method CLIHandler.Help (third_party/openbao/internal/builtin/credential/userpass/cli.go)
- `method:df2d95b804f77dc4c897690b1c3f2283` method CLIHandler.Auth (third_party/openbao/internal/builtin/credential/userpass/cli.go)
- `struct:99e29d6eb2738f7ffef084a591393fc4` struct CLIHandler (third_party/openbao/internal/builtin/credential/userpass/cli.go)
- `struct:b805e145b9027141c9ba92289c3cc667` struct UserEntry (third_party/openbao/internal/builtin/credential/userpass/path_users.go)
<!-- SPECD_MANAGED_END -->
