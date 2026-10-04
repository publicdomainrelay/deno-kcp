# Context: third-party-openbao-ui-app-components-splash-page

Repository: `deno-kcp`

This context documents the vendored splash-page component trio in the OpenBao UI that this repository carries as third-party source. It exists so the leaf components can be reasoned about, replaced or re-synced from upstream without rereading the files: the contract here is deliberately minimal, and the value of the spec is in pinning down that minimality (tagless, default-export-only, no injected state, MPL-2.0 header) so that any divergence introduced later is detectable as a real change rather than mistaken for the components' normal form. It also marks the boundary: splash-page.js, which does hold services and a getter, is not part of this context and must not be described from here.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/components/splash-page/splash-content.js` file splash-content.js (third_party/openbao/ui/app/components/splash-page/splash-content.js)
- `file:third_party/openbao/ui/app/components/splash-page/splash-footer.js` file splash-footer.js (third_party/openbao/ui/app/components/splash-page/splash-footer.js)
- `file:third_party/openbao/ui/app/components/splash-page/splash-header.js` file splash-header.js (third_party/openbao/ui/app/components/splash-page/splash-header.js)
<!-- SPECD_MANAGED_END -->
