# Context: third-party-openbao-ui-app-config

Repository: `deno-kcp`

It exists so the OpenBao web UI can import its build-time environment configuration through `import config from 'my-app/config/environment'` with full type checking under TypeScript. Without this declaration the Ember resolver's virtual module would be untyped, so every read of environment metadata would be implicit any. The context therefore pins the configuration surface the UI code is allowed to rely on.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/config/environment.d.ts` file environment.d.ts (third_party/openbao/ui/app/config/environment.d.ts)
<!-- SPECD_MANAGED_END -->
