# Context: third-party-openbao-ui-app-adapters-auth-config-aws

Repository: `deno-kcp`

The context exists so that the AWS auth-config sub-resources in the OpenBao UI resolve to separate Ember Data adapter classes while sharing one implementation. Each of client, identity-accesslist, and roletag-denylist needs its own module for the Ember resolver to find it by model name, but the request semantics are identical across the three, so the modules are deliberately empty subclasses of ../_base and the URL and record-id logic lives in one place. The context records that these files are pure aliases, which tells a reader that any change to AWS config request behavior belongs in the base adapter rather than in these three modules.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/adapters/auth-config/aws/client.js` file client.js (third_party/openbao/ui/app/adapters/auth-config/aws/client.js)
- `file:third_party/openbao/ui/app/adapters/auth-config/aws/identity-accesslist.js` file identity-accesslist.js (third_party/openbao/ui/app/adapters/auth-config/aws/identity-accesslist.js)
- `file:third_party/openbao/ui/app/adapters/auth-config/aws/roletag-denylist.js` file roletag-denylist.js (third_party/openbao/ui/app/adapters/auth-config/aws/roletag-denylist.js)
<!-- SPECD_MANAGED_END -->
