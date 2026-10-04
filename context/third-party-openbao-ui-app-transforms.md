# Context: third-party-openbao-ui-app-transforms

Repository: `deno-kcp`

These transforms exist so models can declare `DS.attr('array')` and `DS.attr('object')` attributes and get a guaranteed container back from the API payload rather than `null`, a scalar, or a missing value. They normalize untrusted or absent server data into the shape the UI templates expect, on both the read path (`deserialize`) and the write path (`serialize`), so downstream code never has to null-check the attribute. The context exists as the specification for these two normalization rules.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/transforms/array.js` file array.js (third_party/openbao/ui/app/transforms/array.js)
- `file:third_party/openbao/ui/app/transforms/object.js` file object.js (third_party/openbao/ui/app/transforms/object.js)
<!-- SPECD_MANAGED_END -->
