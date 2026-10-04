# Context: third-party-openbao-internal-builtin-credential-cert-cmd-cert

Repository: `deno-kcp`

This context exists to pin down the contract of the cert plugin's binary entry point: the sequence of flag parsing, TLS material derivation from the plugin API client meta, and the multiplexed serve call that registers `cert.Factory` as the backend factory. It matters because the entry point is the boundary between the plugin process and the OpenBao/Vault plugin protocol, and because the explicit `TLSProviderFunc` is what keeps the plugin loadable by older Vault versions without AutoMTLS. It also fixes the failure behavior — log and exit non-zero — so a failed serve is never silently ignored. The context deliberately holds no business logic: everything about certificate auth lives in the cert package, and this file must stay a thin bootstrapper.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/credential/cert/cmd/cert/main.go` file main.go (third_party/openbao/internal/builtin/credential/cert/cmd/cert/main.go)
<!-- SPECD_MANAGED_END -->
