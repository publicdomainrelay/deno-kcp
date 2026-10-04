# Context: third-party-openbao-ui

Repository: `deno-kcp`

The context exists to pin the upstream OpenBao UI's local build, formatting, linting, and test configuration as it is vendored into the deno-kcp repository, so that anyone touching the vendored UI knows which toolchain rules are in force and which files must be kept consistent with upstream HashiCorp sources. It documents that these files are configuration surfaces rather than product logic: formatting style, lint rule severities and ignore globs, the Ember app options and asset imports, the pnpm workspace globs and dependency overrides, and the Testem test page, browser arguments and backend proxy targets.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/.prettierrc.js` file .prettierrc.js (third_party/openbao/ui/.prettierrc.js)
- `file:third_party/openbao/ui/.template-lintrc.js` file .template-lintrc.js (third_party/openbao/ui/.template-lintrc.js)
- `file:third_party/openbao/ui/ember-cli-build.js` file ember-cli-build.js (third_party/openbao/ui/ember-cli-build.js)
- `file:third_party/openbao/ui/eslint.config.mjs` file eslint.config.mjs (third_party/openbao/ui/eslint.config.mjs)
- `file:third_party/openbao/ui/pnpm-lock.yaml` file pnpm-lock.yaml (third_party/openbao/ui/pnpm-lock.yaml)
- `file:third_party/openbao/ui/pnpm-workspace.yaml` file pnpm-workspace.yaml (third_party/openbao/ui/pnpm-workspace.yaml)
- `file:third_party/openbao/ui/testem.enos.js` file testem.enos.js (third_party/openbao/ui/testem.enos.js)
- `file:third_party/openbao/ui/testem.js` file testem.js (third_party/openbao/ui/testem.js)
<!-- SPECD_MANAGED_END -->
