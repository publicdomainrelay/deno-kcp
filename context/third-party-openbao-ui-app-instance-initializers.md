# Context: third-party-openbao-ui-app-instance-initializers

Repository: `deno-kcp`

The context exists so the CSP event tracking service starts exactly once when the Ember application instance boots. Instance-initializers run after the application instance and its services are available, which is why the lookup of 'service:csp-event' and the attach() call live here rather than in a plain initializer. Separating this file keeps the CSP reporting concern out of the service itself and out of application boot code.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/instance-initializers/track-csp-event.js` file track-csp-event.js (third_party/openbao/ui/app/instance-initializers/track-csp-event.js)
- `function:4b03aad49f16b64f3ea2ec56bbf50525` function initialize (third_party/openbao/ui/app/instance-initializers/track-csp-event.js)
<!-- SPECD_MANAGED_END -->
