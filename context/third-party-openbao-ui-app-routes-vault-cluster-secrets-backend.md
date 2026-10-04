# Context: third-party-openbao-ui-app-routes-vault-cluster-secrets-backend

Repository: `deno-kcp`

This context exists so that the secrets-backend route subtree of the OpenBao UI is described as a unit: which route modules exist, which of them export a class the graph can see, and what those classes do to the Ember store and controller. It gives the spec an anchor for the navigation and data-loading contract of secret engines (parameter extraction from the parent backend route, secret-v2 record lookup, controller priming for tabs) without restating the UI's controllers, templates, or adapters. It marks the boundary between routes that only exist to define a nested path and the two routes whose hook bodies are actually known.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:806b1b72918850a9776256f86ac9a879` class diff (third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/diff.js)
- `class:e040711efe37f148df075441136a6961` class MetadataShow (third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/metadata.js)
- `class:ea242026a9cf956a82d48e6262ee9cd8` class EditMetadataRoute (third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/edit-metadata.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/actions.js` file actions.js (third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/actions.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/configuration.js` file configuration.js (third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/configuration.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/create-root.js` file create-root.js (third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/create-root.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/create.js` file create.js (third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/create.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/credentials-root.js` file credentials-root.js (third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/credentials-root.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/credentials.js` file credentials.js (third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/credentials.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/diff.js` file diff.js (third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/diff.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/edit-metadata.js` file edit-metadata.js (third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/edit-metadata.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/edit-root.js` file edit-root.js (third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/edit-root.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/edit.js` file edit.js (third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/edit.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/index.js` file index.js (third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/index.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/list-root.js` file list-root.js (third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/list-root.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/list.js` file list.js (third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/list.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/metadata.js` file metadata.js (third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/metadata.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/overview.js` file overview.js (third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/overview.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/secret-edit.js` file secret-edit.js (third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/secret-edit.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/show-root.js` file show-root.js (third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/show-root.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/show.js` file show.js (third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/show.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/sign-root.js` file sign-root.js (third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/sign-root.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/sign.js` file sign.js (third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/sign.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/versions-root.js` file versions-root.js (third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/versions-root.js)
- `file:third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/versions.js` file versions.js (third_party/openbao/ui/app/routes/vault/cluster/secrets/backend/versions.js)
<!-- SPECD_MANAGED_END -->
