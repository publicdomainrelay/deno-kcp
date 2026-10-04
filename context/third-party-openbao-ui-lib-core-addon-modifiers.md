# Context: third-party-openbao-ui-lib-core-addon-modifiers

Repository: `deno-kcp`

This context exists so the OpenBao UI has one reusable way to attach a CodeMirror editor to any template element and drive it declaratively from named modifier arguments instead of imperative component code. It exists because the UI needs JSON/YAML/Ruby editing surfaces with linting, bracket matching, active-line highlighting, and theming, plus a controlled-value contract: the caller owns `content` and receives edits back through `onUpdate`, with focus events surfaced through `onFocus`. Keeping this behavior in a modifier lets templates declare an editor inline and lets the modifier own setup, teardown-free reuse, and the guard that prevents echoing a programmatic setValue back to the caller as a user edit.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:86a8b2048dc6a1a9f9a7ea9494b1c105` class CodeMirrorModifier (third_party/openbao/ui/lib/core/addon/modifiers/code-mirror.js)
- `file:third_party/openbao/ui/lib/core/addon/modifiers/code-mirror.js` file code-mirror.js (third_party/openbao/ui/lib/core/addon/modifiers/code-mirror.js)
<!-- SPECD_MANAGED_END -->
