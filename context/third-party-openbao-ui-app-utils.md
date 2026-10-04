# Context: third-party-openbao-ui-app-utils

Repository: `deno-kcp`

This context exists to describe the shared helpers that the OpenBao UI depends on, so that their contracts are pinned independently of the components that call them. It matters because these helpers define cross-cutting behavior — how API paths are built from tagged templates, how server snake_case keys become camelCase, which database fields are valid for a role type, how PKI certificates are parsed and chain-verified, and what counts as a valid form value — and any change here ripples into many screens. The spec records the observed signatures and the concrete behavior each helper guarantees.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/utils/api-path.js` file api-path.js (third_party/openbao/ui/app/utils/api-path.js)
- `file:third_party/openbao/ui/app/utils/camelize-object-keys.js` file camelize-object-keys.js (third_party/openbao/ui/app/utils/camelize-object-keys.js)
- `file:third_party/openbao/ui/app/utils/clamp.js` file clamp.js (third_party/openbao/ui/app/utils/clamp.js)
- `file:third_party/openbao/ui/app/utils/database-helpers.js` file database-helpers.js (third_party/openbao/ui/app/utils/database-helpers.js)
- `file:third_party/openbao/ui/app/utils/error-message.js` file error-message.js (third_party/openbao/ui/app/utils/error-message.js)
- `file:third_party/openbao/ui/app/utils/field-to-attrs.js` file field-to-attrs.js (third_party/openbao/ui/app/utils/field-to-attrs.js)
- `file:third_party/openbao/ui/app/utils/identity-manager.js` file identity-manager.js (third_party/openbao/ui/app/utils/identity-manager.js)
- `file:third_party/openbao/ui/app/utils/openapi-to-attrs.js` file openapi-to-attrs.js (third_party/openbao/ui/app/utils/openapi-to-attrs.js)
- `file:third_party/openbao/ui/app/utils/parse-pki-cert-oids.js` file parse-pki-cert-oids.js (third_party/openbao/ui/app/utils/parse-pki-cert-oids.js)
- `file:third_party/openbao/ui/app/utils/parse-pki-cert.js` file parse-pki-cert.js (third_party/openbao/ui/app/utils/parse-pki-cert.js)
- `file:third_party/openbao/ui/app/utils/path-encoding-helpers.js` file path-encoding-helpers.js (third_party/openbao/ui/app/utils/path-encoding-helpers.js)
- `file:third_party/openbao/ui/app/utils/remove-record.js` file remove-record.js (third_party/openbao/ui/app/utils/remove-record.js)
- `file:third_party/openbao/ui/app/utils/sort-objects.js` file sort-objects.js (third_party/openbao/ui/app/utils/sort-objects.js)
- `file:third_party/openbao/ui/app/utils/transition-to-safe.js` file transition-to-safe.js (third_party/openbao/ui/app/utils/transition-to-safe.js)
- `file:third_party/openbao/ui/app/utils/trim-right.js` file trim-right.js (third_party/openbao/ui/app/utils/trim-right.js)
- `file:third_party/openbao/ui/app/utils/validators.js` file validators.js (third_party/openbao/ui/app/utils/validators.js)
- `function:04f293c49707860280893034cfdcd21e` function fetch (third_party/openbao/ui/app/utils/identity-manager.js)
- `function:08b85d12e27e0cd527a6b2d602744466` function verifySignature (third_party/openbao/ui/app/utils/parse-pki-cert.js)
- `function:0eca6522c784d158b377a6e4bc8bc8d0` function length (third_party/openbao/ui/app/utils/validators.js)
- `function:15b1a43020beb3f7390db80d3a4061a8` function verifyCertificates (third_party/openbao/ui/app/utils/parse-pki-cert.js)
- `function:30601f42ea8c56d1c6bf4285b95edf0a` function combineFieldGroups (third_party/openbao/ui/app/utils/openapi-to-attrs.js)
- `function:32f082cb51e6ea89da173b21d432ea1f` function combineAttributes (third_party/openbao/ui/app/utils/openapi-to-attrs.js)
- `function:349c825a055c66a24286e8ab31e4a17f` function parseSubject (third_party/openbao/ui/app/utils/parse-pki-cert.js)
- `function:3f97fdca9b7bf66311776a7c97ee9549` function parsePkiCert (third_party/openbao/ui/app/utils/parse-pki-cert.js)
- `function:45f7d6491a0f3af04540c8cc86c9bf72` function expandAttributeMeta (third_party/openbao/ui/app/utils/field-to-attrs.js)
- `function:494cd295d11f9ce4ef8dfd5ee83f3f5f` function removeRecord (third_party/openbao/ui/app/utils/remove-record.js)
- `function:4fa67a6818963040d872ce5eced51a19` function parseExtensions (third_party/openbao/ui/app/utils/parse-pki-cert.js)
- `function:5ac34804edca019cd501d3ebfe6aeae1` function getRoleFields (third_party/openbao/ui/app/utils/database-helpers.js)
- `function:5f71d2bfce38727b37bb9a8148f57fb7` function reset (third_party/openbao/ui/app/utils/identity-manager.js)
- `function:6fe0e41ce28211d1bdd82a0e40a02f21` function containsWhiteSpace (third_party/openbao/ui/app/utils/validators.js)
- `function:72c2304960e573edc027e1c1696eaf2f` function sortObjects (third_party/openbao/ui/app/utils/sort-objects.js)
- `function:73666475181da1980aa531f1d36f3309` function presence (third_party/openbao/ui/app/utils/validators.js)
- `function:7ce16f3cf708b3787d6227b2a6aae881` function formatValues (third_party/openbao/ui/app/utils/parse-pki-cert.js)
- `function:7d2d955782cd48e8ade24ed208f72589` function apiPath (third_party/openbao/ui/app/utils/api-path.js)
- `function:7f437a930c1dea4d6b312f402241387a` function jsonToCertObject (third_party/openbao/ui/app/utils/parse-pki-cert.js)
- `function:884b35553d676a5f79ae63820af76a2a` function constructor (third_party/openbao/ui/app/utils/identity-manager.js)
- `function:bcdbb6f463754d5d2ff94ccbbe4be833` function getStatementFields (third_party/openbao/ui/app/utils/database-helpers.js)
- `function:c32be011d4fd7e47d263d7452435fb9e` function transitionToSafe (third_party/openbao/ui/app/utils/transition-to-safe.js)
- `function:c37c36edd74a2a2dc59a53b59a08e17a` function camelizeKeys (third_party/openbao/ui/app/utils/camelize-object-keys.js)
- `function:cd4cf3eb7b66424157a4ce68a854e309` function number (third_party/openbao/ui/app/utils/validators.js)
- `function:dc1c1c5726d78a78748181ad6fab9cd7` function parseCertificate (third_party/openbao/ui/app/utils/parse-pki-cert.js)
- `function:e0f44690a9983db13bccb7fde78fe7a3` function combineFields (third_party/openbao/ui/app/utils/openapi-to-attrs.js)
- `function:f2759c60c203d141e518b99207d822fb` function set (third_party/openbao/ui/app/utils/identity-manager.js)
- `function:f2f0e75971b05d26ed7cf9cfcca934bb` function expandOpenApiProps (third_party/openbao/ui/app/utils/openapi-to-attrs.js)
<!-- SPECD_MANAGED_END -->
