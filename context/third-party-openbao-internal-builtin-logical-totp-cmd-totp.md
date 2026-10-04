# Context: third-party-openbao-internal-builtin-logical-totp-cmd-totp

Repository: `deno-kcp`

This context exists so the TOTP logical backend can be built and run as an out-of-process OpenBao plugin binary. The main function adapts the TOTP secrets engine (totp.Factory) to the OpenBao plugin host protocol, and wires the standard plugin TLS handshake so the backend works both with host-driven AutoMTLS and with older hosts that require the plugin to fetch its own wrapped TLS certificate.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/logical/totp/cmd/totp/main.go` file main.go (third_party/openbao/internal/builtin/logical/totp/cmd/totp/main.go)
<!-- SPECD_MANAGED_END -->
