# Context: third-party-openbao-internal-builtin-logical-kv-cmd-kv

Repository: `deno-kcp`

This context exists because the KV secrets engine must be runnable as an out-of-process OpenBao plugin, not only as an in-tree backend. Its purpose is to adapt the kv backend's factory to the plugin serving protocol: it collects the TLS material the plugin needs to talk back to the OpenBao server, converts it into the provider function the plugin SDK expects, and starts the plugin server with the KV factory registered as the backend. It is deliberately thin, holding no KV logic and no policy of its own; all storage behavior lives in the kv package it references.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/logical/kv/cmd/kv/main.go` file main.go (third_party/openbao/internal/builtin/logical/kv/cmd/kv/main.go)
<!-- SPECD_MANAGED_END -->
