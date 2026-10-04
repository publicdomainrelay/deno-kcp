# Context: third-party-openbao-sdk-helper-policyutil

Repository: `deno-kcp`

This context exists to pin down the policy-name handling contract for the vendored OpenBao SDK helper: how raw policy input (nil, CSV string, or slice) becomes a canonical, deduplicated list, how root and default are treated, and how two policy lists are judged equivalent. It is the reference for any caller in deno-kcp that reads, stores, or diffs policy names and needs the same normalization rules the upstream SDK applies.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/helper/policyutil/policyutil.go` file policyutil.go (third_party/openbao/sdk/helper/policyutil/policyutil.go)
- `file:third_party/openbao/sdk/helper/policyutil/policyutil_test.go` file policyutil_test.go (third_party/openbao/sdk/helper/policyutil/policyutil_test.go)
- `function:38c4740a14b1ae37b69d0d742456f60c` function SanitizePolicies (third_party/openbao/sdk/helper/policyutil/policyutil.go)
- `function:765caaac54c0a91136b95db0ac0d222d` function EquivalentPolicies (third_party/openbao/sdk/helper/policyutil/policyutil.go)
- `function:978afd9f8cd63f6ea1115b7782561314` function ParsePolicies (third_party/openbao/sdk/helper/policyutil/policyutil.go)
<!-- SPECD_MANAGED_END -->
