# Context: third-party-openbao-internal-builtin-database-postgresql

Repository: `deno-kcp`

The context exists so the PostgreSQL database secrets engine can be read as a self-contained specification: what the plugin is constructed from, which dbplugin v5 methods it must satisfy, and which configuration keys (username_template, password_authentication) it accepts. It anchors the third-party vendored OpenBao code inside the deno-kcp repository so that the plugin's contract, and any local modifications to it, stay describable and traceable.

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
interfaces:
- file: third_party/openbao/internal/builtin/database/postgresql/postgresql.go
  kind: function
  name: New
  signature: func New() (any, error)
- file: third_party/openbao/internal/builtin/database/postgresql/postgresql.go
  kind: struct
  name: PostgreSQL
  signature: type PostgreSQL struct
- file: third_party/openbao/internal/builtin/database/postgresql/postgresql.go
  kind: method
  name: PostgreSQL.DeleteUser
  signature: func (p *PostgreSQL) DeleteUser(ctx context.Context, req dbplugin.DeleteUserRequest)
    (dbplugin.DeleteUserResponse, error)
- file: third_party/openbao/internal/builtin/database/postgresql/postgresql.go
  kind: method
  name: PostgreSQL.Initialize
  signature: func (p *PostgreSQL) Initialize(ctx context.Context, req dbplugin.InitializeRequest)
    (dbplugin.InitializeResponse, error)
- file: third_party/openbao/internal/builtin/database/postgresql/postgresql.go
  kind: method
  name: PostgreSQL.NewUser
  signature: func (p *PostgreSQL) NewUser(ctx context.Context, req dbplugin.NewUserRequest)
    (dbplugin.NewUserResponse, error)
- file: third_party/openbao/internal/builtin/database/postgresql/postgresql.go
  kind: method
  name: PostgreSQL.PluginVersion
  signature: func (p *PostgreSQL) PluginVersion() logical.PluginVersion
- file: third_party/openbao/internal/builtin/database/postgresql/postgresql.go
  kind: method
  name: PostgreSQL.Type
  signature: func (p *PostgreSQL) Type() (string, error)
- file: third_party/openbao/internal/builtin/database/postgresql/postgresql.go
  kind: method
  name: PostgreSQL.UpdateUser
  signature: func (p *PostgreSQL) UpdateUser(ctx context.Context, req dbplugin.UpdateUserRequest)
    (dbplugin.UpdateUserResponse, error)
requirements:
- codeRefs:
  - file:third_party/openbao/internal/builtin/database/postgresql/postgresql_test.go
  id: r.behaviour-covered-by-tests
  level: SHOULD
  text: The plugin's connection, user creation, expiration and repmgr container behaviour
    should stay covered by the package test file so the dbplugin v5 contract keeps
    holding.
- codeRefs:
  - file:third_party/openbao/internal/builtin/database/postgresql/postgresql.go
  - function:a2a5d9dc98ae361cc50affb0d7d7c011
  id: r.constructs-sanitized-plugin
  level: MUST
  text: New must construct a PostgreSQL instance via new() and return it wrapped in
    the database error sanitizer middleware, with the secret values accessor supplied
    as the redaction source, returning the wrapped value and a nil error.
- codeRefs:
  - file:third_party/openbao/internal/builtin/database/postgresql/postgresql.go
  - struct:28e857d7ee88863c8395d0194dcedc5e
  id: r.default-password-authentication-mode
  level: MUST
  text: A newly constructed PostgreSQL instance must default its password authentication
    mode to password, so role creation works without an explicit password_authentication
    config value.
- codeRefs:
  - file:third_party/openbao/internal/builtin/database/postgresql/postgresql.go
  - method:48ca6109fb985aad531f4872bc2dd8aa
  id: r.delete-user-revocation
  level: MUST
  text: PostgreSQL.DeleteUser must revoke the role using the request's revocation
    statements when they are supplied (customDeleteUser) and fall back to defaultDeleteUser
    otherwise, dropping the role's privileges and the role itself.
- codeRefs:
  - file:third_party/openbao/internal/builtin/database/postgresql/postgresql.go
  - method:104c6501594ab33e3be68a4b13902493
  id: r.initialize-config-and-template
  level: MUST
  text: PostgreSQL.Initialize must pass the request config and verify-connection flag
    to the embedded connection producer's Init, read username_template from the config,
    fall back to defaultUserNameTemplate when it is empty, build the username template
    producer, and generate one username from empty metadata to reject an invalid template
    before returning the new config.
- codeRefs:
  - file:third_party/openbao/internal/builtin/database/postgresql/passwordauthentication.go
  - method:104c6501594ab33e3be68a4b13902493
  id: r.initialize-password-authentication
  level: MUST
  text: When the config carries a non-empty password_authentication value, Initialize
    must parse it with parsePasswordAuthentication and store the result on the instance;
    a parse failure must fail initialization.
- codeRefs:
  - file:third_party/openbao/internal/builtin/database/postgresql/postgresql.go
  - method:e94446bf68d072b3dca3e5d40854d882
  id: r.new-user-creates-role
  level: MUST
  text: PostgreSQL.NewUser must open a connection for the request context, create
    the database role for the generated username, apply the request's password and
    expiration settings, and return the created username in the response.
- codeRefs:
  - file:third_party/openbao/internal/builtin/database/postgresql/postgresql.go
  - method:6ab2c58e15ee2bf7219365719071ae5b
  id: r.plugin-version-reported
  level: MUST
  text: PostgreSQL.PluginVersion must return the plugin version metadata of this build
    so the database engine can report and negotiate the plugin's version.
- codeRefs:
  - file:third_party/openbao/internal/builtin/database/postgresql/postgresql.go
  - struct:28e857d7ee88863c8395d0194dcedc5e
  id: r.secret-values-redacted
  level: SHOULD
  text: The instance should expose its sensitive config values through secretValues
    so the sanitizer middleware can redact them from error messages returned to callers.
- codeRefs:
  - file:third_party/openbao/internal/builtin/database/postgresql/postgresql.go
  - method:816e944b2d4f0ba8b0c57ddc24124a85
  id: r.type-name-postgresql
  level: MUST
  text: PostgreSQL.Type must report the plugin type name as postgresql so the database
    secrets engine can dispatch to this plugin.
- codeRefs:
  - file:third_party/openbao/internal/builtin/database/postgresql/postgresql.go
  - method:fee9a15454325c0f80242ad693eab42a
  id: r.update-user-password-and-expiration
  level: MUST
  text: PostgreSQL.UpdateUser must apply a requested password change through changeUserPassword
    and a requested expiration change through changeUserExpiration, returning an error
    when either change fails.
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/database/postgresql/passwordauthentication.go` file passwordauthentication.go (third_party/openbao/internal/builtin/database/postgresql/passwordauthentication.go)
- `file:third_party/openbao/internal/builtin/database/postgresql/postgresql.go` file postgresql.go (third_party/openbao/internal/builtin/database/postgresql/postgresql.go)
- `file:third_party/openbao/internal/builtin/database/postgresql/postgresql_test.go` file postgresql_test.go (third_party/openbao/internal/builtin/database/postgresql/postgresql_test.go)
- `function:a2a5d9dc98ae361cc50affb0d7d7c011` function New (third_party/openbao/internal/builtin/database/postgresql/postgresql.go)
- `method:104c6501594ab33e3be68a4b13902493` method PostgreSQL.Initialize (third_party/openbao/internal/builtin/database/postgresql/postgresql.go)
- `method:48ca6109fb985aad531f4872bc2dd8aa` method PostgreSQL.DeleteUser (third_party/openbao/internal/builtin/database/postgresql/postgresql.go)
- `method:6ab2c58e15ee2bf7219365719071ae5b` method PostgreSQL.PluginVersion (third_party/openbao/internal/builtin/database/postgresql/postgresql.go)
- `method:816e944b2d4f0ba8b0c57ddc24124a85` method PostgreSQL.Type (third_party/openbao/internal/builtin/database/postgresql/postgresql.go)
- `method:e94446bf68d072b3dca3e5d40854d882` method PostgreSQL.NewUser (third_party/openbao/internal/builtin/database/postgresql/postgresql.go)
- `method:fee9a15454325c0f80242ad693eab42a` method PostgreSQL.UpdateUser (third_party/openbao/internal/builtin/database/postgresql/postgresql.go)
- `struct:28e857d7ee88863c8395d0194dcedc5e` struct PostgreSQL (third_party/openbao/internal/builtin/database/postgresql/postgresql.go)
<!-- SPECD_MANAGED_END -->
