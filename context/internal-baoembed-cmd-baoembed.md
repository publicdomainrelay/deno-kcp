# Context: internal-baoembed-cmd-baoembed

Repository: `deno-kcp`

This context exists so the repository can run a real OpenBao server from a single Go command with no external install, driven entirely by flags and environment variables. Integration tests and developers build and launch this binary, parse its readiness line to learn the URL and, in TLS mode, the generated CA path, then talk to the live server. The flag and environment surface, the root-token export, the TLS certificate directory handling, and the readiness line are therefore a contract that the tests depend on, and this document pins that contract.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:internal/baoembed/cmd/baoembed/main.go` file main.go (internal/baoembed/cmd/baoembed/main.go)
<!-- SPECD_MANAGED_END -->
