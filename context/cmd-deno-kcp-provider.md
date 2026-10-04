# Context: cmd-deno-kcp-provider

Repository: `deno-kcp`

This context exists to be the process entrypoint for the deno-kcp provider controller. Everything it does is wiring: turn command line flags and environment variables into a config, refuse to start without a kubeconfig, build the registry, engine runner, pod runner and provider in the order their dependencies require, and then run the provider until a termination signal arrives. The two non-obvious behaviours it encodes are the KUBE_FEATURE_WatchListClient opt-out, which stops a streaming list from hanging when kcp's APIExport virtual workspace sends no bookmark, and the deferred TrustBundle closure, which exists because the OpenBao root CA does not exist until a namespace has requested a certificate and the provider that generates it is built from the runner being constructed. It is deliberately thin, holding no reconcile logic of its own.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:cmd/deno-kcp-provider/main.go` file main.go (cmd/deno-kcp-provider/main.go)
<!-- SPECD_MANAGED_END -->
