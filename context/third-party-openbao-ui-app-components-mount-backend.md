# Context: third-party-openbao-ui-app-components-mount-backend

Repository: `deno-kcp`

This context exists to fix the contract of the mount-backend type selector: it is the component that decides, from a caller-supplied `mountType` argument, whether the user is offered auth-method types or secret-engine types, and it exposes that decision as a single `mountTypes` list plus a `selection` field for the form's chosen value. It exists inside the vendored OpenBao UI app, so its behaviour must match that of upstream Vault rather than any local redesign.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:ba74c0022e26efc577417b374cc60e75` class MountBackendTypeForm (third_party/openbao/ui/app/components/mount-backend/type-form.js)
- `file:third_party/openbao/ui/app/components/mount-backend/type-form.js` file type-form.js (third_party/openbao/ui/app/components/mount-backend/type-form.js)
<!-- SPECD_MANAGED_END -->
