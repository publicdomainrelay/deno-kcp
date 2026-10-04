# Context: third-party-openbao-ui-lib-service-worker-authenticated-download

Repository: `deno-kcp`

The context records the contract of the service-worker-authenticated-download addon so the dev-server header behavior it provides can be relied on without re-reading the addon. The addon exists only to add `Service-Worker-Allowed: /` to every dev-server response; the Ember wiring around that header matters less than the header itself, because other parts of the UI depend on a root-scoped service worker being permitted to handle authenticated downloads. The addon's identity is deliberately read from its own package manifest rather than hard-coded, so the context documents that too.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/lib/service-worker-authenticated-download/index.js` file index.js (third_party/openbao/ui/lib/service-worker-authenticated-download/index.js)
<!-- SPECD_MANAGED_END -->
