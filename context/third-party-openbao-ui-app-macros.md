# Context: third-party-openbao-ui-app-macros

Repository: `deno-kcp`

These macros exist so models and components can declare a capability lookup as a computed property and let the framework re-query it whenever the interpolated path inputs or the store change, without each caller hand-writing the query, the PromiseProxy wrapper, or the guard against firing a request while path parameters are still missing. apiPath exists as a local, assertion-free variant of the shared utils/api-path helper so the macro can build paths from a plain data object. identity-capabilities exists to give the identity model one canonical capabilities macro over its two-parameter path.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/macros/identity-capabilities.js` file identity-capabilities.js (third_party/openbao/ui/app/macros/identity-capabilities.js)
- `file:third_party/openbao/ui/app/macros/lazy-capabilities.js` file lazy-capabilities.js (third_party/openbao/ui/app/macros/lazy-capabilities.js)
- `file:third_party/openbao/ui/app/macros/maybe-query-record.js` file maybe-query-record.js (third_party/openbao/ui/app/macros/maybe-query-record.js)
- `function:4a20b2d73189d0f97c759bc82588b607` function maybeQueryRecord (third_party/openbao/ui/app/macros/maybe-query-record.js)
- `function:b2de2dd4797e6ac7df2a41ae6cb405c4` function apiPath (third_party/openbao/ui/app/macros/lazy-capabilities.js)
<!-- SPECD_MANAGED_END -->
