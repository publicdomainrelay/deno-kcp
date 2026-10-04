# Context: third-party-openbao-ui-lib-keep-gitkeep

Repository: `deno-kcp`

Provide a durable placeholder mechanism so that the gitignored OpenBao/Vault web UI output directory is still tracked in git as a directory. The addon hooks into the Ember build pipeline and recreates an empty .gitkeep in the build output directory on every build, which matters because git cannot track empty directories and the downstream Go build expects that folder structure to exist.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/lib/keep-gitkeep/index.js` file index.js (third_party/openbao/ui/lib/keep-gitkeep/index.js)
<!-- SPECD_MANAGED_END -->
