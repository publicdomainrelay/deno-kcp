# Context: third-party-openbao-internal-command-agent-exec

Repository: `deno-kcp`

The context exists so the agent exec server's contract is described independently of the surrounding OpenBao agent: which configuration the server accepts, how it derives runner state from environment templates, under what conditions it restarts or stops the child process, what it returns on cancellation, template error and child exit, and how restart-on-secret-changes values are interpreted. It documents the boundary between the template-render path (incoming token and rendered events) and the process-supervision path so a reader can reason about restart, debounce and shutdown behavior without reading the whole agent command tree.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/command/agent/exec/exec.go` file exec.go (third_party/openbao/internal/command/agent/exec/exec.go)
- `file:third_party/openbao/internal/command/agent/exec/exec_test.go` file exec_test.go (third_party/openbao/internal/command/agent/exec/exec_test.go)
- `function:e33e1ebed1f36c917fef8deab4475932` function NewServer (third_party/openbao/internal/command/agent/exec/exec.go)
- `method:6e442a147416a14cb234be2ec46b6ebe` method ProcessExitError.Error (third_party/openbao/internal/command/agent/exec/exec.go)
- `method:db69fdf5be5c51d15f8e995d1175c4a5` method Server.Run (third_party/openbao/internal/command/agent/exec/exec.go)
- `struct:021265e04d39a5bf274b9d3278a1e0aa` struct Server (third_party/openbao/internal/command/agent/exec/exec.go)
- `struct:1c43932d16944fc9cc3f63f66ca570d9` struct ProcessExitError (third_party/openbao/internal/command/agent/exec/exec.go)
- `struct:aba0f8b75a0682a2aedeae8345a175fc` struct ServerConfig (third_party/openbao/internal/command/agent/exec/exec.go)
<!-- SPECD_MANAGED_END -->
