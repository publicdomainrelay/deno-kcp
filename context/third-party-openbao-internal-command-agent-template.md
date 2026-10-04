# Context: third-party-openbao-internal-command-agent-template

Repository: `deno-kcp`

This context specifies the template-rendering server that the OpenBao agent uses to run the internal Consul Template runner: it accepts the agent's template configurations and an incoming Vault token channel, restarts the runner when a new token arrives, retries with backoff on runner errors, and terminates early once all templates are rendered when exit-after-auth is configured. The spec records the construction, configuration surface and lifecycle guarantees of that server so the behaviour can be preserved.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/command/agent/template/template.go` file template.go (third_party/openbao/internal/command/agent/template/template.go)
- `file:third_party/openbao/internal/command/agent/template/template_test.go` file template_test.go (third_party/openbao/internal/command/agent/template/template_test.go)
- `function:a8686accea59bb747ec05fed62bd2585` function NewServer (third_party/openbao/internal/command/agent/template/template.go)
- `method:990e84dbe81ed2f87ab34932c0f7bfb0` method Server.Stop (third_party/openbao/internal/command/agent/template/template.go)
- `method:d9dd6f48d0065ecd94dcb0ceec98c148` method Server.Run (third_party/openbao/internal/command/agent/template/template.go)
- `struct:264a18de453074c01711a78e413c9c08` struct ServerConfig (third_party/openbao/internal/command/agent/template/template.go)
- `struct:57207bdcd5ca90e05fed9af466416b7f` struct Server (third_party/openbao/internal/command/agent/template/template.go)
<!-- SPECD_MANAGED_END -->
