# Context: third-party-openbao-internal-command-agent-internal-ctmanager

Repository: `deno-kcp`

This context exists to record the configuration surface of the consul-template runner inside the OpenBao agent: which agent-level settings map onto which ctconfig.Config fields, which values are forced rather than inherited from the environment, what the defaults are, and the one condition under which construction fails. The file is vendored third-party code under third_party/openbao, carried in this repository unchanged, so the spec describes the upstream behavior as observed rather than any local design choice.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/command/agent/internal/ctmanager/runner_config.go` file runner_config.go (third_party/openbao/internal/command/agent/internal/ctmanager/runner_config.go)
- `function:1b37cd3c984608ba4dcf87320814df1c` function NewConfig (third_party/openbao/internal/command/agent/internal/ctmanager/runner_config.go)
- `struct:4c8cbdd73f6d08a26c1eabfb4a993eec` struct ManagerConfig (third_party/openbao/internal/command/agent/internal/ctmanager/runner_config.go)
<!-- SPECD_MANAGED_END -->
