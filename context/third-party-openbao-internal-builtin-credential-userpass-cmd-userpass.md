# Context: third-party-openbao-internal-builtin-credential-userpass-cmd-userpass

Repository: `deno-kcp`

This context exists so the userpass credential backend can be run as a separate process under OpenBao's plugin multiplexing protocol, which is how a plugin binary is launched and handed a listener and TLS material by the host. It is the process boundary: everything about the backend's behavior is elsewhere, but the backend cannot be loaded at all without this main package parsing the plugin API client flags, constructing the TLS provider function that keeps backwards compatibility with hosts lacking plugin AutoMTLS, and serving userpass.Factory over multiplex. The error path exists so a failure to serve is reported and turned into a nonzero exit rather than a silent hang.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/credential/userpass/cmd/userpass/main.go` file main.go (third_party/openbao/internal/builtin/credential/userpass/cmd/userpass/main.go)
<!-- SPECD_MANAGED_END -->
