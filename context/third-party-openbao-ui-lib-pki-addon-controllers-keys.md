# Context: third-party-openbao-ui-lib-pki-addon-controllers-keys

Repository: `deno-kcp`

This context exists so the PKI keys index page has a controller that exposes the engine mount point to its route's templates. Rather than threading the mount path down from the route or recomputing it at each use site, the controller resolves it once from the Ember owner and publishes it as a property, keeping the keys index UI decoupled from how the PKI engine was mounted.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:1f11b4591f598557944a357118cd17b7` class PkiKeysIndexController (third_party/openbao/ui/lib/pki/addon/controllers/keys/index.js)
- `file:third_party/openbao/ui/lib/pki/addon/controllers/keys/index.js` file index.js (third_party/openbao/ui/lib/pki/addon/controllers/keys/index.js)
<!-- SPECD_MANAGED_END -->
