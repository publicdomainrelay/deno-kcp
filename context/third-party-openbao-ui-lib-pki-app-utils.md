# Context: third-party-openbao-ui-lib-pki-app-utils

Repository: `deno-kcp`

The context exists to pin down the app-level utility directory of the vendored OpenBao PKI UI as a thin compatibility shim rather than a place with real behavior. Any consumer or test that imports keyParamsByType from the app utils path depends on this file forwarding to the library utils module; the context records that dependency so a refactor of the re-export is known to break pki-generate-root component tests.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/lib/pki/app/utils/action-params.js` file action-params.js (third_party/openbao/ui/lib/pki/app/utils/action-params.js)
<!-- SPECD_MANAGED_END -->
