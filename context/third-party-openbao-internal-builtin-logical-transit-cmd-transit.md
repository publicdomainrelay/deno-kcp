# Context: third-party-openbao-internal-builtin-logical-transit-cmd-transit

Repository: `deno-kcp`

The context exists so the transit logical backend can be built and run as a standalone multiplexed plugin process rather than being linked into a server. It separates process wiring, argument and TLS handling from the backend logic in the transit package, and it deliberately sets TLSProviderFunc so the plugin keeps backwards compatibility with Vault versions that do not support plugin AutoMTLS.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/logical/transit/cmd/transit/main.go` file main.go (third_party/openbao/internal/builtin/logical/transit/cmd/transit/main.go)
<!-- SPECD_MANAGED_END -->
