# Context: third-party-openbao-internal-builtin-logical-pki-cmd-pki

Repository: `deno-kcp`

This context exists so the PKI secrets engine can run as an external, out-of-process OpenBao plugin binary rather than being linked into the server. The entrypoint wires three things together: the plugin API client metadata that carries the TLS material the server hands the child process, the PKI backend factory that produces the backend instance, and the multiplexing plugin server that speaks the plugin protocol. The explicit TLSProviderFunc is kept so the plugin remains compatible with OpenBao/Vault versions that do not support plugin AutoMTLS.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/logical/pki/cmd/pki/main.go` file main.go (third_party/openbao/internal/builtin/logical/pki/cmd/pki/main.go)
<!-- SPECD_MANAGED_END -->
