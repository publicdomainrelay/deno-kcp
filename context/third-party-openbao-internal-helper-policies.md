# Context: third-party-openbao-internal-helper-policies

Repository: `deno-kcp`

The context exists so the internal policy helper has its own pinned, described equivalence rule separate from the sdk copy, which has drifted. It records exactly what the internal implementation guarantees (nil handling, default filtering, duplicate collapsing, order independence) so a later change to either copy can be checked against a stated contract rather than against the other file. The test in policies_test.go is the executable form of that contract and is the only caller recorded for this function.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/helper/policies/policies.go` file policies.go (third_party/openbao/internal/helper/policies/policies.go)
- `file:third_party/openbao/internal/helper/policies/policies_test.go` file policies_test.go (third_party/openbao/internal/helper/policies/policies_test.go)
- `function:379ad7dcf8d0a770034c5155490d07a1` function EquivalentPolicies (third_party/openbao/internal/helper/policies/policies.go)
<!-- SPECD_MANAGED_END -->
