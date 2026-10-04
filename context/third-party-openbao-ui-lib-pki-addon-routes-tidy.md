# Context: third-party-openbao-ui-lib-pki-addon-routes-tidy

Repository: `deno-kcp`

This context exists to pin down the routing and controller-wiring behaviour of the PKI tidy feature in the vendored OpenBao UI, so that changes to the tidy status polling, the auto-tidy view model, or the manual tidy form's record creation and breadcrumbs can be made without breaking the rest of the addon. It is a slice of third_party code rather than first-party code, so the spec records what these three route modules actually do — the endpoints they call, the services they inject, the model keys they expose and the lifecycle hooks they implement — as the contract other route, controller and template modules in the same addon depend on.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:0c6fa2442378e648a8384f41475dcbf5` class PkiTidyManualRoute (third_party/openbao/ui/lib/pki/addon/routes/tidy/manual.js)
- `class:31be8b2e00256012008212b057cecbb0` class PkiTidyIndexRoute (third_party/openbao/ui/lib/pki/addon/routes/tidy/index.js)
- `class:678ce8c2848108638f633bf218a253cb` class PkiTidyAutoRoute (third_party/openbao/ui/lib/pki/addon/routes/tidy/auto.js)
- `file:third_party/openbao/ui/lib/pki/addon/routes/tidy/auto.js` file auto.js (third_party/openbao/ui/lib/pki/addon/routes/tidy/auto.js)
- `file:third_party/openbao/ui/lib/pki/addon/routes/tidy/index.js` file index.js (third_party/openbao/ui/lib/pki/addon/routes/tidy/index.js)
- `file:third_party/openbao/ui/lib/pki/addon/routes/tidy/manual.js` file manual.js (third_party/openbao/ui/lib/pki/addon/routes/tidy/manual.js)
<!-- SPECD_MANAGED_END -->
