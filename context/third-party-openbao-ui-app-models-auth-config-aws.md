# Context: third-party-openbao-ui-app-models-auth-config-aws

Repository: `deno-kcp`

This context exists so the OpenBao UI can edit the AWS auth method's client configuration, periodic tidy behavior, identity access list, and role tag denylist through the same Ember Data models the rest of the UI uses. It is a declarative form-schema layer: the models decide which attributes exist, their labels, defaults, edit types, and how they group into form fields, and the shared AuthConfig base supplies the save/read mechanics against the auth-config API path.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/models/auth-config/aws/client.js` file client.js (third_party/openbao/ui/app/models/auth-config/aws/client.js)
- `file:third_party/openbao/ui/app/models/auth-config/aws/identity-accesslist.js` file identity-accesslist.js (third_party/openbao/ui/app/models/auth-config/aws/identity-accesslist.js)
- `file:third_party/openbao/ui/app/models/auth-config/aws/roletag-denylist.js` file roletag-denylist.js (third_party/openbao/ui/app/models/auth-config/aws/roletag-denylist.js)
- `file:third_party/openbao/ui/app/models/auth-config/aws/tidy.js` file tidy.js (third_party/openbao/ui/app/models/auth-config/aws/tidy.js)
<!-- SPECD_MANAGED_END -->
