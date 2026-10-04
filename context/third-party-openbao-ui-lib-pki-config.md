# Context: third-party-openbao-ui-lib-pki-config

Repository: `deno-kcp`

The context exists to pin down the build-time environment configuration seam for the vendored OpenBao PKI UI addon, so that downstream tooling can rely on the module's exported shape without reading the whole third-party tree. It records that this file is the addon's identity and environment declaration point, that the module prefix is fixed at `pki`, and that no build flags, API hosts, or feature toggles are declared here.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/lib/pki/config/environment.js` file environment.js (third_party/openbao/ui/lib/pki/config/environment.js)
<!-- SPECD_MANAGED_END -->
