# Context: third-party-openbao-internal-builtin-credential-approle

Repository: `deno-kcp`

This context documents the vendored OpenBao AppRole credential backend that lives in the deno-kcp tree, so the plugin factory surface, the role/login/tidy paths, the salt lifecycle and the SecretID storage model stay described as they actually are. It exists to anchor the backend's exported entry points and its behavioural obligations to concrete code references before any change is made to third_party/openbao.

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
interfaces:
- file: third_party/openbao/internal/builtin/credential/approle/backend.go
  kind: function
  name: Backend
  signature: func Backend(conf *logical.BackendConfig) *backend
- file: third_party/openbao/internal/builtin/credential/approle/backend.go
  kind: function
  name: Factory
  signature: func Factory(ctx context.Context, conf *logical.BackendConfig) (logical.Backend,
    error)
- file: third_party/openbao/internal/builtin/credential/approle/backend.go
  kind: method
  name: backend.Initialize
  signature: func (b *backend) Initialize(ctx context.Context, req *logical.InitializationRequest)
    error
- file: third_party/openbao/internal/builtin/credential/approle/backend.go
  kind: method
  name: backend.Salt
  signature: func (b *backend) Salt(ctx context.Context, storage logical.Storage)
    (*salt.Salt, error)
- file: third_party/openbao/internal/builtin/credential/approle/path_role.go
  kind: method
  name: secretIDStorageEntry.ToResponseData
  signature: func (entry *secretIDStorageEntry) ToResponseData() map[string]any
requirements:
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/approle/backend.go
  - function:f60007e9359b1fe56e6c46688c61f16a
  id: r.backend-construction
  level: MUST
  text: Backend must allocate lock sets for roles, RoleIDs, SecretIDs and SecretID
    accessors, and must attach a framework.Backend of type credential that registers
    rolePaths, pathLogin and pathTidySecretID, sets AuthRenew to pathLoginRenew, PeriodicFunc
    to periodicFunc, InitializeFunc to Initialize, exposes login as unauthenticated
    and marks the SecretID and SecretID accessor prefixes as local storage.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/approle/backend.go
  - function:778c275d5c4171a937db430a31fc675f
  id: r.factory-setup
  level: MUST
  text: Factory must build the approle backend with Backend and call Setup on it,
    returning the backend on success or the setup error.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/approle/backend.go
  - method:c762feff70986a13c11a628f4b3d5cf1
  id: r.initialize-salt
  level: MUST
  text: Initialize must return without creating a salt when the replication state
    is DR secondary or performance standby, or when the mount is not local and the
    state is performance secondary; otherwise it must create the initial salt via
    Salt and wrap any failure as "error creating initial salt".
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/approle/path_login.go
  id: r.login-path
  level: MUST
  text: The login path must authenticate a RoleID and SecretID pair and issue a token,
    and must supply the auth renew handler.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/approle/path_role.go
  id: r.role-paths
  level: MUST
  text: The role paths must create, read, list, delete and configure AppRole roles,
    including their RoleID and SecretID material.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/approle/backend.go
  - method:acd763567a46862e1615f9caf42a28ec
  id: r.salt-provisioning
  level: MUST
  text: backend.Salt must return the salt backed by the given logical storage, creating
    it on first use.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/approle/path_role.go
  - method:0f65fa95a5748d658f4e8e617e0d8092
  id: r.secret-id-response
  level: MUST
  text: secretIDStorageEntry.ToResponseData must project a stored SecretID entry into
    a map[string]any suitable for an API response, reporting secret_id_accessor, secret_id_num_uses,
    secret_id_ttl in seconds, creation_time, expiration_time, last_updated_time, metadata,
    cidr_list and token_bound_cidrs, and substituting an empty string slice when TokenBoundCIDRs
    is empty.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/approle/validation.go
  id: r.secret-id-validation
  level: MUST
  text: SecretID and RoleID validation must reject entries that are expired or bound
    to a different role.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/approle/backend_test.go
  - file:third_party/openbao/internal/builtin/credential/approle/path_login_test.go
  - file:third_party/openbao/internal/builtin/credential/approle/path_role_test.go
  - file:third_party/openbao/internal/builtin/credential/approle/path_tidy_user_id_test.go
  - file:third_party/openbao/internal/builtin/credential/approle/validation_test.go
  id: r.test-coverage
  level: SHOULD
  text: The backend, login, role, tidy and validation behaviour should be covered
    by the package's Go tests.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/approle/path_tidy_user_id.go
  id: r.tidy-secret-id
  level: MUST
  text: The tidy secret ID path must remove expired and orphaned SecretID entries.
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/credential/approle/backend.go` file backend.go (third_party/openbao/internal/builtin/credential/approle/backend.go)
- `file:third_party/openbao/internal/builtin/credential/approle/backend_test.go` file backend_test.go (third_party/openbao/internal/builtin/credential/approle/backend_test.go)
- `file:third_party/openbao/internal/builtin/credential/approle/path_login.go` file path_login.go (third_party/openbao/internal/builtin/credential/approle/path_login.go)
- `file:third_party/openbao/internal/builtin/credential/approle/path_login_test.go` file path_login_test.go (third_party/openbao/internal/builtin/credential/approle/path_login_test.go)
- `file:third_party/openbao/internal/builtin/credential/approle/path_role.go` file path_role.go (third_party/openbao/internal/builtin/credential/approle/path_role.go)
- `file:third_party/openbao/internal/builtin/credential/approle/path_role_test.go` file path_role_test.go (third_party/openbao/internal/builtin/credential/approle/path_role_test.go)
- `file:third_party/openbao/internal/builtin/credential/approle/path_tidy_user_id.go` file path_tidy_user_id.go (third_party/openbao/internal/builtin/credential/approle/path_tidy_user_id.go)
- `file:third_party/openbao/internal/builtin/credential/approle/path_tidy_user_id_test.go` file path_tidy_user_id_test.go (third_party/openbao/internal/builtin/credential/approle/path_tidy_user_id_test.go)
- `file:third_party/openbao/internal/builtin/credential/approle/validation.go` file validation.go (third_party/openbao/internal/builtin/credential/approle/validation.go)
- `file:third_party/openbao/internal/builtin/credential/approle/validation_test.go` file validation_test.go (third_party/openbao/internal/builtin/credential/approle/validation_test.go)
- `function:778c275d5c4171a937db430a31fc675f` function Factory (third_party/openbao/internal/builtin/credential/approle/backend.go)
- `function:f60007e9359b1fe56e6c46688c61f16a` function Backend (third_party/openbao/internal/builtin/credential/approle/backend.go)
- `method:0f65fa95a5748d658f4e8e617e0d8092` method secretIDStorageEntry.ToResponseData (third_party/openbao/internal/builtin/credential/approle/path_role.go)
- `method:acd763567a46862e1615f9caf42a28ec` method backend.Salt (third_party/openbao/internal/builtin/credential/approle/backend.go)
- `method:c762feff70986a13c11a628f4b3d5cf1` method backend.Initialize (third_party/openbao/internal/builtin/credential/approle/backend.go)
<!-- SPECD_MANAGED_END -->
