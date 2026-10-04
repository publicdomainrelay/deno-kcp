# Context: internal-baoembed-cmd-baoembed

Repository: `deno-kcp`

This context exists to give the repository's integration tests and developers a runnable OpenBao server without an external install. The `test/integration` helpers build this package (see `baoembedBinary`, which runs `go build -o bin ./cmd/baoembed` with its working directory at `internal/baoembed`) and start it with `startProcess`, which launches the binary with stdout and stderr redirected into a log file and a new process group. Because the tests need to know when the server is up and, under TLS, which CA to trust, the command's contract is its readiness line: everything here is shaped around emitting `BAOEMBED <url>` (with the CA path when TLS is on) only after the embedded server accepts connections, and around accepting its configuration from flags with environment fallbacks so a test can drive it either way.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:internal/baoembed/cmd/baoembed/main.go` file main.go (internal/baoembed/cmd/baoembed/main.go)
<!-- SPECD_MANAGED_END -->
