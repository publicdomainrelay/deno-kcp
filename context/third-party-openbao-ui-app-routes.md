# Context: third-party-openbao-ui-app-routes

Repository: `deno-kcp`

The context documents the routing entry layer of the vendored OpenBao web UI so that its behaviour — global scroll reset, error-transition URL recovery, OIDC callback detection, version fetching, single-cluster bootstrapping and index redirect — is specified rather than only readable in source. It exists to keep the vendored third_party UI's route contract explicit for anyone auditing or porting this UI, especially the hardcoded single-cluster assumption and the '/ui' rootURL trimming in error handling.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/routes/application.js` file application.js (third_party/openbao/ui/app/routes/application.js)
- `file:third_party/openbao/ui/app/routes/loading.js` file loading.js (third_party/openbao/ui/app/routes/loading.js)
- `file:third_party/openbao/ui/app/routes/vault.js` file vault.js (third_party/openbao/ui/app/routes/vault.js)
<!-- SPECD_MANAGED_END -->
