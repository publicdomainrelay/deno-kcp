# Context: third-party-openbao-ui-app-controllers

Repository: `deno-kcp`

This context exists to fix the contract of the UI's base and cluster controllers: which query parameters the cluster route accepts and under what names, which properties default to empty, and which services each controller may rely on being injected. It is the anchor for anything that reads or mutates controller state from templates and routes, and it records the deliberate asymmetry that `currentCluster` is available on the application controller but not on the vault controller.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/controllers/application.js` file application.js (third_party/openbao/ui/app/controllers/application.js)
- `file:third_party/openbao/ui/app/controllers/vault.js` file vault.js (third_party/openbao/ui/app/controllers/vault.js)
<!-- SPECD_MANAGED_END -->
