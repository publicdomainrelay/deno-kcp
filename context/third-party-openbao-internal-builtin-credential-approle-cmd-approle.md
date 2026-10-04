# Context: third-party-openbao-internal-builtin-credential-approle-cmd-approle

Repository: `deno-kcp`

This context exists so the AppRole credential backend can run as an out-of-process OpenBao plugin binary. It isolates the harness boilerplate — flag parsing, TLS provider derivation, and multiplexed serving — from the backend implementation, which lives in the parent `approle` package and is reached only through the `approle.Factory` symbol. Keeping this file thin means the backend stays testable and buildable without the plugin harness, while the binary itself remains compileable against host versions that predate plugin AutoMTLS.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/credential/approle/cmd/approle/main.go` file main.go (third_party/openbao/internal/builtin/credential/approle/cmd/approle/main.go)
<!-- SPECD_MANAGED_END -->
