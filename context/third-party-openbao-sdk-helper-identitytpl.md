# Context: third-party-openbao-sdk-helper-identitytpl

Repository: `deno-kcp`

This context exists so that identity-aware strings in OpenBao policies and JSON payloads can be expanded from an entity, its aliases, its group memberships and metadata, without each caller reimplementing template parsing. It is a vendored third-party helper inside the deno-kcp repository, kept in third_party so the surrounding Go code can reference OpenBao templating semantics with a stable local copy. The spec pins the observable contract of PopulateString and the shape of its input struct so that changes to the vendored copy stay visible and callers can rely on specific return values and error conditions.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/helper/identitytpl/templating.go` file templating.go (third_party/openbao/sdk/helper/identitytpl/templating.go)
- `file:third_party/openbao/sdk/helper/identitytpl/templating_test.go` file templating_test.go (third_party/openbao/sdk/helper/identitytpl/templating_test.go)
- `function:8a7ad43cd54daad745ecbf63b34f1b0b` function PopulateString (third_party/openbao/sdk/helper/identitytpl/templating.go)
- `struct:dd4409fc828faf633e005ced43289975` struct PopulateStringInput (third_party/openbao/sdk/helper/identitytpl/templating.go)
<!-- SPECD_MANAGED_END -->
