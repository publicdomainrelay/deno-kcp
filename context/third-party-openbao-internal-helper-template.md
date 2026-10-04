# Context: third-party-openbao-internal-helper-template

Repository: `deno-kcp`

The context exists to pin down the contract of the two exported helpers in third_party/openbao/internal/helper/template/template.go, which is the only place in the tree that fixes the variable names a path-filtering template may reference. It exists because the filtering templates are authored as strings elsewhere (from configuration or request input) and must be compiled and evaluated with a stable, agreed-upon data shape; anyone changing that data shape, the constructor used for compilation, or the error propagation would break every caller that writes a filter template.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/helper/template/template.go` file template.go (third_party/openbao/internal/helper/template/template.go)
- `function:0fbc5b16cbaec183b3fb1ca03f6c4ebc` function CompileTemplatePathForFiltering (third_party/openbao/internal/helper/template/template.go)
- `function:be8659e87c09dc6b583391ba45c8042c` function UseTemplateForFiltering (third_party/openbao/internal/helper/template/template.go)
<!-- SPECD_MANAGED_END -->
