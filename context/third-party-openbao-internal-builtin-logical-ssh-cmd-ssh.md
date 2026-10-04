# Context: third-party-openbao-internal-builtin-logical-ssh-cmd-ssh

Repository: `deno-kcp`

The file exists so the SSH logical backend can be built and run as a separate OpenBao/Vault plugin process, negotiated over the plugin protocol rather than compiled into the server. Its purpose is to wire the three pieces a plugin binary needs: the SSH backend factory, the TLS material supplied by the host through command-line flags, and the multiplexed plugin server, while keeping the legacy `TLSProviderFunc` path so the plugin still works with host versions that do not support plugin AutoMTLS.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/logical/ssh/cmd/ssh/main.go` file main.go (third_party/openbao/internal/builtin/logical/ssh/cmd/ssh/main.go)
<!-- SPECD_MANAGED_END -->
