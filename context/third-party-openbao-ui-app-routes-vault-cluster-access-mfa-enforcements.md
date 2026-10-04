# Context: third-party-openbao-ui-app-routes-vault-cluster-access-mfa-enforcements

Repository: `deno-kcp`

This context exists so the login MFA enforcement routes are described as they are written: which record type each route reads or builds, what route parameter the detail route consumes, and how the list route treats a missing enforcement collection. It anchors downstream work on the enforcement list, create, and detail screens to the route classes that supply their models, and records the one non-obvious behavior in the group, the 404-to-empty-array fallback in the index query.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:75cf9590dfb1bbc040d1b61410ea6455` class MfaLoginEnforcementRoute (third_party/openbao/ui/app/routes/vault/cluster/access/mfa/enforcements/enforcement.js)
- `class:bfba4f6e717fca795d4881a93d8b0436` class MfaEnforcementsRoute (third_party/openbao/ui/app/routes/vault/cluster/access/mfa/enforcements/index.js)
- `class:d1209001e9ce4a6fa69925e696609aef` class MfaLoginEnforcementCreateRoute (third_party/openbao/ui/app/routes/vault/cluster/access/mfa/enforcements/create.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/mfa/enforcements/create.js` file create.js (third_party/openbao/ui/app/routes/vault/cluster/access/mfa/enforcements/create.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/mfa/enforcements/enforcement.js` file enforcement.js (third_party/openbao/ui/app/routes/vault/cluster/access/mfa/enforcements/enforcement.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/access/mfa/enforcements/index.js` file index.js (third_party/openbao/ui/app/routes/vault/cluster/access/mfa/enforcements/index.js)
<!-- SPECD_MANAGED_END -->
