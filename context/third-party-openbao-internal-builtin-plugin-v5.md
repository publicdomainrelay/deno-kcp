# Context: third-party-openbao-internal-builtin-plugin-v5

Repository: `deno-kcp`

This context exists so the plugin v5 backend shim can be specified independently of the rest of OpenBao: it is the adapter that turns a plugin's RPC-backed logical.Backend into one that survives plugin restarts. It matters because request handling, existence checks and invalidation are the paths that cross the plugin boundary, and the reload-and-retry contract on those paths is the behaviour other code depends on.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/plugin/v5/backend.go` file backend.go (third_party/openbao/internal/builtin/plugin/v5/backend.go)
- `function:134f6df1002aaf8b0c8827e0d5ddeab5` function Backend (third_party/openbao/internal/builtin/plugin/v5/backend.go)
- `method:08637e5ce9fcaf096f490e178acb78c6` method backend.HandleExistenceCheck (third_party/openbao/internal/builtin/plugin/v5/backend.go)
- `method:26aae3c4cbf2510b0890ce91ad9b8fcb` method backend.InvalidateKey (third_party/openbao/internal/builtin/plugin/v5/backend.go)
- `method:721bcb8809f4a8a04bdabcce26020083` method backend.IsExternal (third_party/openbao/internal/builtin/plugin/v5/backend.go)
- `method:90c4b0c62a3d2594ac9c7bbbcb9710c2` method backend.HandleRequest (third_party/openbao/internal/builtin/plugin/v5/backend.go)
<!-- SPECD_MANAGED_END -->
