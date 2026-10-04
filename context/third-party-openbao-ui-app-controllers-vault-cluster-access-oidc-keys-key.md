# Context: third-party-openbao-ui-app-controllers-vault-cluster-access-oidc-keys-key

Repository: `deno-kcp`

This context exists to describe the behaviour of the OIDC key detail controller in the vendored OpenBao UI, so that the rotate and delete flows for a single OIDC key are specified in one place. It matters because these two actions mutate key material and delete it: rotation must pass both the key name and the verification TTL to the adapter, and deletion must leave the record consistent (rollback on failure) and navigate away only after a successful destroy. The context gives the controller's service dependencies and its success/error reporting contract, which is what any change to the OIDC key detail screen has to preserve.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:602b9abb5aa9578164145a739b5d6722` class OidcKeyDetailsController (third_party/openbao/ui/app/controllers/vault/cluster/access/oidc/keys/key/details.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/access/oidc/keys/key/details.js` file details.js (third_party/openbao/ui/app/controllers/vault/cluster/access/oidc/keys/key/details.js)
<!-- SPECD_MANAGED_END -->
