# Context: third-party-openbao-ui-app-components-transit-key-action

Repository: `deno-kcp`

This context exists to pin down the public shape of the transit key export action component so downstream work — templates that bind to it, route or controller code that invokes it, and any refactor or port of the OpenBao UI — has a stable, machine-checkable description of what the file exposes. It records that the component is state-only: two tracked fields and no behaviour, which is the assumption a consumer must make. The surface is deliberately narrow because the observed facts show nothing beyond the class declaration and its two properties.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:8e8a75e4ad7a4ab6edf02c3155b3f164` class ExportComponent (third_party/openbao/ui/app/components/transit-key-action/export.js)
- `file:third_party/openbao/ui/app/components/transit-key-action/export.js` file export.js (third_party/openbao/ui/app/components/transit-key-action/export.js)
<!-- SPECD_MANAGED_END -->
