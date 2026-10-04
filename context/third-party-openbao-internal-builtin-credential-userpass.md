# Context: third-party-openbao-internal-builtin-credential-userpass

Repository: `deno-kcp`

The context exists to describe how the vendored userpass credential backend is structured and what it must do: mount a credential backend that authenticates users by username and password, expose user administration paths, and provide the CLI-facing auth and help surface. It is a third-party subtree of deno-kcp, so the spec records the code as it stands rather than proposing changes, and gives a stable anchor set for the backend, its paths, and its exported CLI handler.

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
interfaces:
- file: third_party/openbao/internal/builtin/credential/userpass/backend.go
  kind: function
  name: Backend
  signature: func Backend() *backend
- file: third_party/openbao/internal/builtin/credential/userpass/cli.go
  kind: struct
  name: CLIHandler
  signature: type CLIHandler struct
- file: third_party/openbao/internal/builtin/credential/userpass/cli.go
  kind: method
  name: CLIHandler.Auth
  signature: func (c *CLIHandler) Auth(c *api.Client, m map[string]string, nonInteractive
    bool) (*api.Secret, error)
- file: third_party/openbao/internal/builtin/credential/userpass/cli.go
  kind: method
  name: CLIHandler.Help
  signature: func (c *CLIHandler) Help() string
- file: third_party/openbao/internal/builtin/credential/userpass/backend.go
  kind: function
  name: Factory
  signature: func Factory(ctx context.Context, conf *logical.BackendConfig) (logical.Backend,
    error)
- file: third_party/openbao/internal/builtin/credential/userpass/path_users.go
  kind: struct
  name: UserEntry
  signature: type UserEntry struct
requirements:
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/userpass/backend.go
  - function:af5528190992c8c19e6b1b81246f4adf
  id: r.backend-constructor
  level: MUST
  text: Backend must return a *backend whose framework.Backend registers the userpass
    paths and back end type.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/userpass/cli.go
  - method:df2d95b804f77dc4c897690b1c3f2283
  - struct:99e29d6eb2738f7ffef084a591393fc4
  id: r.cli-auth
  level: MUST
  text: CLIHandler.Auth must perform a userpass login through the api.Client given
    method configuration and a non-interactive flag, returning the resulting secret.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/userpass/cli.go
  - method:b9610c512ba58f5978c0aa99848c9a1f
  id: r.cli-help
  level: SHOULD
  text: CLIHandler.Help must return the help text describing the userpass login flags
    for the CLI.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/userpass/backend.go
  - function:1f63899e28851cb40d189549fcae73bf
  id: r.factory-setup
  level: MUST
  text: Factory must construct the userpass backend and call Setup with the supplied
    logical.BackendConfig, returning an error if setup fails.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/userpass/path_login.go
  id: r.login-path
  level: MUST
  text: The login path must be registered as unauthenticated and must authenticate
    a username and password pair, issuing a token with the user's policies and renewing
    it on request.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/userpass/password_validation_test.go
  id: r.password-validation
  level: SHOULD
  text: Password validation must reject passwords that violate the backend's stated
    constraints, as exercised by the password validation tests.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/userpass/stepwise_test.go
  id: r.stepwise-login
  level: MAY
  text: The backend may support a stepwise login flow in addition to single-request
    login, exercised by the stepwise tests.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/userpass/path_user_password.go
  - file:third_party/openbao/internal/builtin/credential/userpass/path_user_policies.go
  - file:third_party/openbao/internal/builtin/credential/userpass/path_users.go
  id: r.user-administration
  level: MUST
  text: The user paths must support creating, reading, listing, and deleting users,
    and updating a user's password and policies through their dedicated paths.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/userpass/path_users.go
  - struct:b805e145b9027141c9ba92289c3cc667
  id: r.user-entry
  level: MUST
  text: UserEntry must carry the stored per-user fields — password hash, policies,
    and related metadata — as the value written to and read from storage by the user
    paths.
upstream: self
```

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
