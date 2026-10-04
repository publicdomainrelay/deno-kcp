# Context: third-party-openbao-internal-command-agentproxyshared-winsvc

Repository: `deno-kcp`

This context exists so the agent proxy can run as a native Windows service. The Windows service manager drives the process through a handler interface, but the rest of the agent only needs one portable signal: a channel that fires when the service controller asks the process to stop. ShutdownChannel is that portable surface, and serviceWindows.Execute is the adapter that translates Windows service control requests into it. The init hook keeps normal interactive invocations unaffected, registering the handler only in a real service session.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/command/agentproxyshared/winsvc/service.go` file service.go (third_party/openbao/internal/command/agentproxyshared/winsvc/service.go)
- `file:third_party/openbao/internal/command/agentproxyshared/winsvc/service_windows.go` file service_windows.go (third_party/openbao/internal/command/agentproxyshared/winsvc/service_windows.go)
- `function:10e62384985d4e46bd75edda25ec0c6f` function ShutdownChannel (third_party/openbao/internal/command/agentproxyshared/winsvc/service.go)
- `method:37a50972e1aea1705742d82736abad05` method serviceWindows.Execute (third_party/openbao/internal/command/agentproxyshared/winsvc/service_windows.go)
<!-- SPECD_MANAGED_END -->
