# Context: third-party-openbao-internal-builtin-audit-http

Repository: `deno-kcp`

This context exists so that the HTTP audit device can be described, tested and reimplemented without reading the vendored source: it fixes the contract the audit subsystem depends on (a Backend that hashes with a salt, encodes log input through a JSON formatter, and POSTs the entry to a configured URI), the exact configuration keys and defaults Factory honours, and the failure modes callers must see at construction time rather than at first log. It also records the test-only handler the package uses to stand in for a remote audit endpoint, so end-to-end behaviour of the HTTP path is observable from tests.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/audit/http/backend.go` file backend.go (third_party/openbao/internal/builtin/audit/http/backend.go)
- `file:third_party/openbao/internal/builtin/audit/http/backend_test.go` file backend_test.go (third_party/openbao/internal/builtin/audit/http/backend_test.go)
- `file:third_party/openbao/internal/builtin/audit/http/testing.go` file testing.go (third_party/openbao/internal/builtin/audit/http/testing.go)
- `function:5420893024c784962ca66998e515722e` function Factory (third_party/openbao/internal/builtin/audit/http/backend.go)
- `function:78289ad6a1c57b0dfc04ef875683bdec` function GetTestAuditHandler (third_party/openbao/internal/builtin/audit/http/testing.go)
- `method:179a3b9c0e58491f354ec4cfc318766a` method Backend.GetHash (third_party/openbao/internal/builtin/audit/http/backend.go)
- `method:1f5a6642d322c7e19b8ec0833dded31d` method Backend.Reload (third_party/openbao/internal/builtin/audit/http/backend.go)
- `method:26a4cfe9cc2bf8924db4c407efff660a` method Backend.LogTestMessage (third_party/openbao/internal/builtin/audit/http/backend.go)
- `method:61b0c443f53626e8f698e0c2cfaf732f` method Backend.LogResponse (third_party/openbao/internal/builtin/audit/http/backend.go)
- `method:b689c9fd3423d00931d4c50b44ed37c6` method Backend.LogRequest (third_party/openbao/internal/builtin/audit/http/backend.go)
- `method:c3d47d9cb7259ae83b32e711619ec500` method Backend.Salt (third_party/openbao/internal/builtin/audit/http/backend.go)
- `method:d517f9951df6496b0847557b06b079ff` method Backend.Invalidate (third_party/openbao/internal/builtin/audit/http/backend.go)
- `struct:20dd53850adf10614f22517a31ba4402` struct Backend (third_party/openbao/internal/builtin/audit/http/backend.go)
<!-- SPECD_MANAGED_END -->
