# Context: third-party-openbao-ui-lib-pki

Repository: `deno-kcp`

The context exists to pin down the entrypoint that registers the PKI feature area of the OpenBao web UI as an Ember engine addon, so consumers of this repository know how the PKI UI is packaged, under what name it is mounted, and that it is loaded eagerly rather than lazily. It is part of the vendored third_party/openbao subtree, kept as-is from upstream rather than reimplemented, and it sits upstream of the component and model code that the PKI engine renders.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/lib/pki/index.js` file index.js (third_party/openbao/ui/lib/pki/index.js)
<!-- SPECD_MANAGED_END -->
