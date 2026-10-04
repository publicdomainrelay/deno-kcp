# Context: third-party-openbao-ui-lib-service-worker-authenticated-download

Repository: `deno-kcp`

The context exists to record the contract of the service-worker-authenticated-download addon: an Ember CLI addon whose only runtime effect is to add the `Service-Worker-Allowed: /` header to every dev-server response so a service worker scoped at the root can handle authenticated downloads. It is documented here because the header, not the addon wiring, is the behavior other parts of the UI depend on, and because the addon's identity is sourced from its own package manifest rather than hard-coded.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/lib/service-worker-authenticated-download/index.js` file index.js (third_party/openbao/ui/lib/service-worker-authenticated-download/index.js)
<!-- SPECD_MANAGED_END -->
