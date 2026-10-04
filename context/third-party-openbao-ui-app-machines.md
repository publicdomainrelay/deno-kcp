# Context: third-party-openbao-ui-app-machines

Repository: `deno-kcp`

These modules exist to declare, as data rather than as code, the step graph of every OpenBao UI setup wizard flow. Keeping the transitions in plain configuration objects lets one generic wizard engine walk any flow, render the right component at each level, and drive route changes, so a new wizard step is added by editing a config rather than by writing new control logic. This context is the declarative half of that engine; the effect handlers and renderers it names are supplied elsewhere.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/machines/auth-machine.js` file auth-machine.js (third_party/openbao/ui/app/machines/auth-machine.js)
- `file:third_party/openbao/ui/app/machines/policies-machine.js` file policies-machine.js (third_party/openbao/ui/app/machines/policies-machine.js)
- `file:third_party/openbao/ui/app/machines/secrets-machine.js` file secrets-machine.js (third_party/openbao/ui/app/machines/secrets-machine.js)
- `file:third_party/openbao/ui/app/machines/tools-machine.js` file tools-machine.js (third_party/openbao/ui/app/machines/tools-machine.js)
- `file:third_party/openbao/ui/app/machines/tutorial-machine.js` file tutorial-machine.js (third_party/openbao/ui/app/machines/tutorial-machine.js)
<!-- SPECD_MANAGED_END -->
