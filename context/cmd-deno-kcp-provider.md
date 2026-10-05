# Context: cmd-deno-kcp-provider

Repository: `deno-kcp`

This context exists to pin down the provider's process boundary: the single main that turns operator input (flags and environment) into the registry, engine runner, pod runner and provider the controller needs, and the failure and shutdown behaviour around them. Everything else in the repository assumes a configured provider already exists; this context is what makes one.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:cmd/deno-kcp-provider/main.go` file main.go (cmd/deno-kcp-provider/main.go)
<!-- SPECD_MANAGED_END -->
