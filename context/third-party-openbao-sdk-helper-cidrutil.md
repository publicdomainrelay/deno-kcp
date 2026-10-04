# Context: third-party-openbao-sdk-helper-cidrutil

Repository: `deno-kcp`

The context exists so the host project can reuse OpenBao's reviewed CIDR-whitelisting logic instead of reimplementing address containment and canonical-form checks. It centralizes the policy decisions that matter for access control: an empty whitelist means allow, an unparseable remote address means deny, and a CIDR that is not in canonical form is rejected rather than silently widened. Recording these functions as a spec makes their exact error strings, boundary conditions, and subset semantics visible to callers elsewhere in the repository.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/helper/cidrutil/cidr.go` file cidr.go (third_party/openbao/sdk/helper/cidrutil/cidr.go)
- `file:third_party/openbao/sdk/helper/cidrutil/cidr_test.go` file cidr_test.go (third_party/openbao/sdk/helper/cidrutil/cidr_test.go)
- `function:357ae319a33e6e9a2fd0984bfe837712` function IPBelongsToCIDRBlocksSlice (third_party/openbao/sdk/helper/cidrutil/cidr.go)
- `function:3a6bc9d19a63e95e73e639bd3289094b` function Subset (third_party/openbao/sdk/helper/cidrutil/cidr.go)
- `function:945af157aa61736f4e38b7868aedba90` function ValidateCIDRListString (third_party/openbao/sdk/helper/cidrutil/cidr.go)
- `function:ba2624e1c8f91fe295d81a0f05ff20ea` function RemoteAddrIsOk (third_party/openbao/sdk/helper/cidrutil/cidr.go)
- `function:e8374bafdac2a1b932fad1971e866422` function ValidateCIDRListSlice (third_party/openbao/sdk/helper/cidrutil/cidr.go)
- `function:f5c6c9fd9c53539248a91a63f53e512c` function IPBelongsToCIDR (third_party/openbao/sdk/helper/cidrutil/cidr.go)
- `function:fd151dfd0382f7f91302bb3dd916ece3` function SubsetBlocks (third_party/openbao/sdk/helper/cidrutil/cidr.go)
<!-- SPECD_MANAGED_END -->
