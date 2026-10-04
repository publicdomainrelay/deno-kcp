# Context: third-party-openbao-ui-app-controllers-vault-cluster-access-oidc-keys

Repository: `deno-kcp`

The context exists to capture the small amount of presentation state that the OIDC key route needs: whether the user is on the edit sub-route. It is recorded as a spec so the controller's observable contract is stable — the router-event subscription in the constructor, the isEditRoute tracked property it drives, and the showHeader getter derived from it — giving a reference for what the template can rely on without re-reading the controller source.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:15b4ca10ba703e0bbe511a57f87c7c64` class OidcKeyController (third_party/openbao/ui/app/controllers/vault/cluster/access/oidc/keys/key.js)
- `file:third_party/openbao/ui/app/controllers/vault/cluster/access/oidc/keys/key.js` file key.js (third_party/openbao/ui/app/controllers/vault/cluster/access/oidc/keys/key.js)
<!-- SPECD_MANAGED_END -->
