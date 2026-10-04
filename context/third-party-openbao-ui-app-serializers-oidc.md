# Context: third-party-openbao-ui-app-serializers-oidc

Repository: `deno-kcp`

The context exists to pin down the payload-shaping contract of the OIDC serializers in the vendored OpenBao UI, which sits in this repository as third-party code. It matters because these classes are the single point where the raw OIDC LIST and READ responses from the server are turned into records the Ember models can consume: get primaryKey wrong and every record collides under an undefined key, and get normalizeItems wrong and list views render rows with names but no body. Recording the two normalization branches, the flattened keys/key_info shape, and the fact that only client and provider override it keeps later edits from silently changing what the OIDC list and detail screens receive.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:335ce3d18d9109295d314eec8a9ec48a` class OidcClientSerializer (third_party/openbao/ui/app/serializers/oidc/client.js)
- `class:390ba76e8ca0104a18fa597df8bfaf1c` class OidcKeySerializer (third_party/openbao/ui/app/serializers/oidc/key.js)
- `class:436fd8e63b5de854d1735c297f2e19c9` class OidcAssignmentSerializer (third_party/openbao/ui/app/serializers/oidc/assignment.js)
- `class:a400db6099abad63dbcd66f5f6446c2f` class OidcScopeSerializer (third_party/openbao/ui/app/serializers/oidc/scope.js)
- `class:babc6ff432ad43bc649bc4e09e7193c0` class OidcProviderSerializer (third_party/openbao/ui/app/serializers/oidc/provider.js)
- `file:third_party/openbao/ui/app/serializers/oidc/assignment.js` file assignment.js (third_party/openbao/ui/app/serializers/oidc/assignment.js)
- `file:third_party/openbao/ui/app/serializers/oidc/client.js` file client.js (third_party/openbao/ui/app/serializers/oidc/client.js)
- `file:third_party/openbao/ui/app/serializers/oidc/key.js` file key.js (third_party/openbao/ui/app/serializers/oidc/key.js)
- `file:third_party/openbao/ui/app/serializers/oidc/provider.js` file provider.js (third_party/openbao/ui/app/serializers/oidc/provider.js)
- `file:third_party/openbao/ui/app/serializers/oidc/scope.js` file scope.js (third_party/openbao/ui/app/serializers/oidc/scope.js)
<!-- SPECD_MANAGED_END -->
