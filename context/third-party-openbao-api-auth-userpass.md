# Context: third-party-openbao-api-auth-userpass

Repository: `deno-kcp`

This context exists to pin the behaviour of the vendored OpenBao userpass auth method as this repository consumes it: the constructor contract, the mount-path option, the deferred password read, and the validate rules. It captures the code that is there so changes to the vendored copy can be checked against the expected interface and error strings, and so the conformance to api.AuthMethod is recorded.

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
interfaces:
- file: third_party/openbao/api/auth/userpass/userpass.go
  kind: type_alias
  name: LoginOption
  signature: type LoginOption func(a *UserpassAuth) error
- file: third_party/openbao/api/auth/userpass/userpass.go
  kind: function
  name: NewUserpassAuth
  signature: func NewUserpassAuth(username string, password *Password, opts ...LoginOption)
    (*UserpassAuth, error)
- file: third_party/openbao/api/auth/userpass/userpass.go
  kind: struct
  name: Password
  signature: type Password struct
- file: third_party/openbao/api/auth/userpass/userpass.go
  kind: struct
  name: UserpassAuth
  signature: type UserpassAuth struct
- file: third_party/openbao/api/auth/userpass/userpass.go
  kind: method
  name: UserpassAuth.Login
  signature: func (a *UserpassAuth) Login(ctx context.Context, client *api.Client)
    (*api.Secret, error)
- file: third_party/openbao/api/auth/userpass/userpass.go
  kind: function
  name: WithMountPath
  signature: func WithMountPath(mountPath string) LoginOption
requirements:
- codeRefs:
  - file:third_party/openbao/api/auth/userpass/userpass.go
  - struct:a59bb055a5013978de35ac677b4ec239
  id: r.auth-method-conformance
  level: MUST
  text: UserpassAuth satisfies api.AuthMethod, asserted by the package-level var _
    api.AuthMethod = (*UserpassAuth)(nil).
- codeRefs:
  - function:f5e1d9de7472feb4063d8d4b38e6638b
  - function:f736e7e6a1f4575d2650107dd15dd744
  id: r.default-mount-path
  level: MUST
  text: A new UserpassAuth uses the mount path "userpass" and WithMountPath replaces
    it through the LoginOption function value.
- codeRefs:
  - method:9afc106af9cd9785e2aa574c2189b084
  id: r.empty-env-password-error
  level: MUST
  text: When the password comes from an environment variable whose value is empty,
    UserpassAuth.Login fails with "password was specified with an environment variable
    with an empty value".
- codeRefs:
  - file:third_party/openbao/api/auth/userpass/userpass.go
  - method:9afc106af9cd9785e2aa574c2189b084
  id: r.file-password-read-limits
  level: MUST
  text: Reading a password file opens the path, reads at most 1000 bytes through io.LimitReader,
    and trims one trailing newline from the value.
- codeRefs:
  - function:f736e7e6a1f4575d2650107dd15dd744
  - type_alias:d9885a92c719f1e783f19725804a4044
  id: r.login-options-applied
  level: MUST
  text: NewUserpassAuth applies each LoginOption in order against the new UserpassAuth
    and wraps any option error as "error with login option".
- codeRefs:
  - method:9afc106af9cd9785e2aa574c2189b084
  id: r.login-request-path
  level: MUST
  text: UserpassAuth.Login posts the password map to the path auth/<mountPath>/login/<username>
    with client.Logical().WriteWithContext and returns the resulting api.Secret, substituting
    context.Background() when ctx is nil.
- codeRefs:
  - method:9afc106af9cd9785e2aa574c2189b084
  - struct:a59bb055a5013978de35ac677b4ec239
  id: r.password-read-at-login-time
  level: MUST
  text: Password.FromFile and Password.FromEnv are stored as paths or variable names
    only; the secret value is read inside UserpassAuth.Login so a changed file or
    environment value takes effect.
- codeRefs:
  - function:f736e7e6a1f4575d2650107dd15dd744
  - struct:96e3f457b1325f85ffcedcb95a8bb314
  id: r.password-required-and-single-source
  level: MUST
  text: NewUserpassAuth rejects a nil Password with "no password provided for login",
    and Password.validate rejects a Password with no source and a Password with more
    than one of FromFile, FromEnv, FromString set.
- codeRefs:
  - file:third_party/openbao/api/auth/userpass/userpass_test.go
  id: r.test-covers-three-sources
  level: SHOULD
  text: The test file logs in through a local HTTP test server with the password taken
    from a temp file, from an environment variable, and from a plaintext string, asserting
    a non-empty ClientToken each time.
- codeRefs:
  - function:f736e7e6a1f4575d2650107dd15dd744
  id: r.username-required
  level: MUST
  text: NewUserpassAuth returns the error "no user name provided for login" when username
    is empty.
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/api/auth/userpass/userpass.go` file userpass.go (third_party/openbao/api/auth/userpass/userpass.go)
- `file:third_party/openbao/api/auth/userpass/userpass_test.go` file userpass_test.go (third_party/openbao/api/auth/userpass/userpass_test.go)
- `function:f5e1d9de7472feb4063d8d4b38e6638b` function WithMountPath (third_party/openbao/api/auth/userpass/userpass.go)
- `function:f736e7e6a1f4575d2650107dd15dd744` function NewUserpassAuth (third_party/openbao/api/auth/userpass/userpass.go)
- `method:9afc106af9cd9785e2aa574c2189b084` method UserpassAuth.Login (third_party/openbao/api/auth/userpass/userpass.go)
- `struct:96e3f457b1325f85ffcedcb95a8bb314` struct Password (third_party/openbao/api/auth/userpass/userpass.go)
- `struct:a59bb055a5013978de35ac677b4ec239` struct UserpassAuth (third_party/openbao/api/auth/userpass/userpass.go)
- `type_alias:d9885a92c719f1e783f19725804a4044` type_alias LoginOption (third_party/openbao/api/auth/userpass/userpass.go)
<!-- SPECD_MANAGED_END -->
