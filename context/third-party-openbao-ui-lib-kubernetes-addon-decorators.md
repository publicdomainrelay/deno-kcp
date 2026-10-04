# Context: third-party-openbao-ui-lib-kubernetes-addon-decorators

Repository: `deno-kcp`

The context exists to specify the Kubernetes engine's configuration-fetch decorator for the OpenBao web UI. Routes that need the Kubernetes secrets engine config to be loaded before they render — configuration, configure, overview, and roles index — mix this decorator in rather than repeating the lookup. It exists so a single implementation owns the cache-first read of the 'kubernetes/config' record, the distinction between 'no config yet' (an expected 404 that should prompt the user) and a real failure (which is retained for display), and the safe degradation of the route when the backend is unreachable or unauthorized. The RRoute prototype check is part of its contract: applying it to a non-Route class must warn and be a no-op, never a runtime crash.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/lib/kubernetes/addon/decorators/fetch-config.js` file fetch-config.js (third_party/openbao/ui/lib/kubernetes/addon/decorators/fetch-config.js)
- `function:d90c137b6b5934dba9fdb7039bd644df` function withConfig (third_party/openbao/ui/lib/kubernetes/addon/decorators/fetch-config.js)
- `function:f77d15cc82e182359a209a7b5b1bb19c` function decorator (third_party/openbao/ui/lib/kubernetes/addon/decorators/fetch-config.js)
<!-- SPECD_MANAGED_END -->
