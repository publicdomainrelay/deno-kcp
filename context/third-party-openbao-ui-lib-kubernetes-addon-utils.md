# Context: third-party-openbao-ui-lib-kubernetes-addon-utils

Repository: `deno-kcp`

This context exists so the Kubernetes role editor can present a fixed, ordered dropdown of starter rule templates and recover the user's own rules when none of them match. The module is the single source of those templates: it must keep the six ids and labels stable because the component uses the numeric-string ids as the selected template key, and it must return rule values that compare by reference so `initRoleRules` can recognize a template the user picked but did not edit.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/lib/kubernetes/addon/utils/generated-role-rules.js` file generated-role-rules.js (third_party/openbao/ui/lib/kubernetes/addon/utils/generated-role-rules.js)
- `function:1f18191a8684e62b3fa7acaa8801c045` function getRules (third_party/openbao/ui/lib/kubernetes/addon/utils/generated-role-rules.js)
<!-- SPECD_MANAGED_END -->
