# Context: third-party-openbao-internal-builtin-audit-file

Repository: `deno-kcp`

This context exists so that the file audit device can be reasoned about and changed without reading the whole vendored OpenBao tree. It records the contract Factory must honor when it turns operator configuration into a running backend, the file-mode and format validation rules that guard audit log creation, and the audit.Backend methods Backend exposes. The companion test file pins the observable behavior of the file-mode handling, so the spec must describe that validation as it is actually implemented rather than as a cleaner design.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/audit/file/backend.go` file backend.go (third_party/openbao/internal/builtin/audit/file/backend.go)
- `file:third_party/openbao/internal/builtin/audit/file/backend_test.go` file backend_test.go (third_party/openbao/internal/builtin/audit/file/backend_test.go)
- `function:3085f49aa218cfa27d80e9c0431694b3` function Factory (third_party/openbao/internal/builtin/audit/file/backend.go)
- `method:30d039106baf5b0a2b030a69c7c29738` method Backend.Salt (third_party/openbao/internal/builtin/audit/file/backend.go)
- `method:438657ef874a844cf73f07789ad57d46` method Backend.Invalidate (third_party/openbao/internal/builtin/audit/file/backend.go)
- `method:50b06add913bdcb63f4528e9cc84aedf` method Backend.LogResponse (third_party/openbao/internal/builtin/audit/file/backend.go)
- `method:56c35816515d1fa3d4063f64ffbf2452` method Backend.Reload (third_party/openbao/internal/builtin/audit/file/backend.go)
- `method:733a08994d5c610fb8b4dfb7ded80a9d` method Backend.LogTestMessage (third_party/openbao/internal/builtin/audit/file/backend.go)
- `method:98bc68d8572bdd0a3f936e204dc1e9c1` method Backend.LogRequest (third_party/openbao/internal/builtin/audit/file/backend.go)
- `method:ff1ccf33ac4896d41b106ed0196442c9` method Backend.GetHash (third_party/openbao/internal/builtin/audit/file/backend.go)
- `struct:42847894a256e32dfab52f2167e89a54` struct Backend (third_party/openbao/internal/builtin/audit/file/backend.go)
<!-- SPECD_MANAGED_END -->
