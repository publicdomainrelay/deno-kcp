# Context: third-party-openbao-ui-lib-core-app-helpers

Repository: `deno-kcp`

This context exists so the OpenBao UI core addon can expose its helper set to the host app's resolver: the app/helpers directory must re-export, under the app-namespace paths Ember looks up, the helpers that are implemented once in the core addon. The spec records that contract together with the observable behaviour of each re-exported helper, so that a change to a shim (a dropped named export, a renamed module path) or to the underlying formatting, state-mapping, route-matching, sanitizing or flash-message logic is detectable as a spec violation.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/lib/core/app/helpers/changelog-url-for.js` file changelog-url-for.js (third_party/openbao/ui/lib/core/app/helpers/changelog-url-for.js)
- `file:third_party/openbao/ui/lib/core/app/helpers/cluster-states.js` file cluster-states.js (third_party/openbao/ui/lib/core/app/helpers/cluster-states.js)
- `file:third_party/openbao/ui/lib/core/app/helpers/date-format.js` file date-format.js (third_party/openbao/ui/lib/core/app/helpers/date-format.js)
- `file:third_party/openbao/ui/lib/core/app/helpers/format-duration.js` file format-duration.js (third_party/openbao/ui/lib/core/app/helpers/format-duration.js)
- `file:third_party/openbao/ui/lib/core/app/helpers/format-number.js` file format-number.js (third_party/openbao/ui/lib/core/app/helpers/format-number.js)
- `file:third_party/openbao/ui/lib/core/app/helpers/img-path.js` file img-path.js (third_party/openbao/ui/lib/core/app/helpers/img-path.js)
- `file:third_party/openbao/ui/lib/core/app/helpers/is-active-route.js` file is-active-route.js (third_party/openbao/ui/lib/core/app/helpers/is-active-route.js)
- `file:third_party/openbao/ui/lib/core/app/helpers/loose-equal.js` file loose-equal.js (third_party/openbao/ui/lib/core/app/helpers/loose-equal.js)
- `file:third_party/openbao/ui/lib/core/app/helpers/message-types.js` file message-types.js (third_party/openbao/ui/lib/core/app/helpers/message-types.js)
- `file:third_party/openbao/ui/lib/core/app/helpers/options-for-backend.js` file options-for-backend.js (third_party/openbao/ui/lib/core/app/helpers/options-for-backend.js)
- `file:third_party/openbao/ui/lib/core/app/helpers/path-or-array.js` file path-or-array.js (third_party/openbao/ui/lib/core/app/helpers/path-or-array.js)
- `file:third_party/openbao/ui/lib/core/app/helpers/sanitized-html.js` file sanitized-html.js (third_party/openbao/ui/lib/core/app/helpers/sanitized-html.js)
- `file:third_party/openbao/ui/lib/core/app/helpers/set-flash-message.js` file set-flash-message.js (third_party/openbao/ui/lib/core/app/helpers/set-flash-message.js)
<!-- SPECD_MANAGED_END -->
