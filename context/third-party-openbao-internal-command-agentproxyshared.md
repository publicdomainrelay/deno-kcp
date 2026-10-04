# Context: third-party-openbao-internal-command-agentproxyshared

Repository: `deno-kcp`

The context exists so every agent-proxy command can share one implementation of auto-auth method selection and of persistent lease caching, instead of each command re-deriving how a config string becomes an auth method and how a bolt database file on disk is opened, keyed, restored and optionally deleted. It centralizes the required validation (nil config, missing path, unsupported key protection type), the Kubernetes service-account-JWT lookup used as additional authenticated data, and the keep_after_import / exit_on_err policy that decides whether the bolt file survives the import and whether errors are fatal.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/command/agentproxyshared/helpers.go` file helpers.go (third_party/openbao/internal/command/agentproxyshared/helpers.go)
- `file:third_party/openbao/internal/command/agentproxyshared/helpers_test.go` file helpers_test.go (third_party/openbao/internal/command/agentproxyshared/helpers_test.go)
- `function:558242af32f8480a238cc113a963d2c4` function GetAutoAuthMethodFromConfig (third_party/openbao/internal/command/agentproxyshared/helpers.go)
- `function:66faeada19cce16e9efb4b9fcfb6016d` function AddPersistentStorageToLeaseCache (third_party/openbao/internal/command/agentproxyshared/helpers.go)
- `struct:0524d0ccf8fc5e3a4157d968c7521a94` struct PersistConfig (third_party/openbao/internal/command/agentproxyshared/helpers.go)
<!-- SPECD_MANAGED_END -->
