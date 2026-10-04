# Context: third-party-openbao-internal-builtin-audit-socket

Repository: `deno-kcp`

The context exists so the socket audit device has a specification anchored to its real Go symbols: one exported factory, one exported Backend type, and the eight methods that make the type usable as an audit.Backend. It names the entry points a caller or a sibling audit device (file, http, syslog) would rely on, and records the signatures those callers can depend on without reading the file.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/audit/socket/backend.go` file backend.go (third_party/openbao/internal/builtin/audit/socket/backend.go)
- `function:6a2ce28d7941107c5315180d60d656c8` function Factory (third_party/openbao/internal/builtin/audit/socket/backend.go)
- `method:0dfcd89cec84f44a84b27c82ec48575f` method Backend.Invalidate (third_party/openbao/internal/builtin/audit/socket/backend.go)
- `method:1ec3d615174a0753435662e932df070e` method Backend.LogResponse (third_party/openbao/internal/builtin/audit/socket/backend.go)
- `method:2846f8c3e19e3776184a1b969555c3fa` method Backend.Salt (third_party/openbao/internal/builtin/audit/socket/backend.go)
- `method:2e21d6fb3ce37ab7b6b7283ff6020452` method Backend.Reload (third_party/openbao/internal/builtin/audit/socket/backend.go)
- `method:89d687803ddb57ed9fd8d62eb1c1495b` method Backend.LogRequest (third_party/openbao/internal/builtin/audit/socket/backend.go)
- `method:a27ee23fac47f3d28cc2753042623d74` method Backend.GetHash (third_party/openbao/internal/builtin/audit/socket/backend.go)
- `method:fde4a897fbd4681c9fb6c3298b434091` method Backend.LogTestMessage (third_party/openbao/internal/builtin/audit/socket/backend.go)
- `struct:32c0a542ae36b6f7aaa1f74ad620868c` struct Backend (third_party/openbao/internal/builtin/audit/socket/backend.go)
<!-- SPECD_MANAGED_END -->
