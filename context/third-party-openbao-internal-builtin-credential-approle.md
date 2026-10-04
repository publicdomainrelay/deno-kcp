# Context: third-party-openbao-internal-builtin-credential-approle

Repository: `deno-kcp`

This context documents the vendored OpenBao AppRole credential backend that lives in the deno-kcp tree, so the plugin factory surface, the role/login/tidy paths, the salt lifecycle and the SecretID storage model stay described as they actually are. It exists to anchor the backend's exported entry points and its behavioural obligations to concrete code references before any change is made to third_party/openbao.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

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
