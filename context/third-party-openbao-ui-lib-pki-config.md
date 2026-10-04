# Context: third-party-openbao-ui-lib-pki-config

Repository: `deno-kcp`

This context exists to pin down the build-time environment configuration seam of the vendored OpenBao PKI UI addon, so downstream tooling can rely on the module's exported shape without reading the surrounding third-party tree. It records that this file is the addon's identity and environment declaration point, that the Ember module namespace is fixed at `pki`, that the caller-supplied build target is echoed back verbatim, and that no build flags, API hosts, or feature toggles are declared here. It also records the file-level conventions that must survive any vendoring or patch operation: the Node scoping directives and the upstream license header.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/lib/pki/config/environment.js` file environment.js (third_party/openbao/ui/lib/pki/config/environment.js)
<!-- SPECD_MANAGED_END -->
