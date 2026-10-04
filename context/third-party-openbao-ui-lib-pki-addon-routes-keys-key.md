# Context: third-party-openbao-ui-lib-pki-addon-routes-keys-key

Repository: `deno-kcp`

This context exists to specify the navigation and breadcrumb behavior of the OpenBao PKI key details and key edit routes, so that the two pages can be reimplemented or verified against a single shared contract: both must reuse the parent keys.key model rather than fetching their own, and both must publish the same four-level breadcrumb trail rooted at the secrets engine, the current mount path, and the keys index, terminated by the key's own id.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:4932e12b5fa3c670ed5f83fe9260caa6` class PkiKeyDetailsRoute (third_party/openbao/ui/lib/pki/addon/routes/keys/key/details.js)
- `class:7eab7a696dab841ab9d925a60df1b7d9` class PkiKeyEditRoute (third_party/openbao/ui/lib/pki/addon/routes/keys/key/edit.js)
- `file:third_party/openbao/ui/lib/pki/addon/routes/keys/key/details.js` file details.js (third_party/openbao/ui/lib/pki/addon/routes/keys/key/details.js)
- `file:third_party/openbao/ui/lib/pki/addon/routes/keys/key/edit.js` file edit.js (third_party/openbao/ui/lib/pki/addon/routes/keys/key/edit.js)
<!-- SPECD_MANAGED_END -->
