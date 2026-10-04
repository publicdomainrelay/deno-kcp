# Context: third-party-openbao-internal-builtin-logical-totp

Repository: `deno-kcp`

The context exists so that the TOTP logical backend can be described and reasoned about independently of the rest of OpenBao. It pins down the plugin boundary (Factory and Backend), the storage contract for key entries (backend.Key), and the path surface split between key management and code generation. It is a spec slice of vendored third-party code, so it records the code as written rather than proposing changes.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/logical/totp/backend.go` file backend.go (third_party/openbao/internal/builtin/logical/totp/backend.go)
- `file:third_party/openbao/internal/builtin/logical/totp/backend_test.go` file backend_test.go (third_party/openbao/internal/builtin/logical/totp/backend_test.go)
- `file:third_party/openbao/internal/builtin/logical/totp/path_code.go` file path_code.go (third_party/openbao/internal/builtin/logical/totp/path_code.go)
- `file:third_party/openbao/internal/builtin/logical/totp/path_keys.go` file path_keys.go (third_party/openbao/internal/builtin/logical/totp/path_keys.go)
- `function:2659f24939f08b8a6a28ecd0c1a9ad16` function Factory (third_party/openbao/internal/builtin/logical/totp/backend.go)
- `function:93c53f32f8e8d0b9cf6d2596526daf2b` function Backend (third_party/openbao/internal/builtin/logical/totp/backend.go)
- `method:6dc117858b8c671f708f40ddf3aad3b4` method backend.Key (third_party/openbao/internal/builtin/logical/totp/path_keys.go)
<!-- SPECD_MANAGED_END -->
