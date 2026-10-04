# Context: third-party-openbao-sdk-helper-shamir

Repository: `deno-kcp`

This context exists so the deno-kcp repository can use OpenBao's Shamir Secret Sharing helper for key splitting and reconstruction without depending on an external module. It is vendor code: the spec records the contract the two exported functions must honor so that callers upstream in this repo, and the accompanying tests, keep the same behavior across vendoring updates. The context draws the boundary at the exported surface plus the observable error conditions, since the internal arithmetic helpers (`add`, `mult`, `div`, `makePolynomial`, `evaluate`, `interpolatePolynomial`, `shuffledXCoordinates`) are implementation detail that only matters through the results `Split` and `Combine` produce.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/helper/shamir/shamir.go` file shamir.go (third_party/openbao/sdk/helper/shamir/shamir.go)
- `file:third_party/openbao/sdk/helper/shamir/shamir_test.go` file shamir_test.go (third_party/openbao/sdk/helper/shamir/shamir_test.go)
- `function:7c7f7568411dd04ccd3451e8d8c9cff3` function Combine (third_party/openbao/sdk/helper/shamir/shamir.go)
- `function:dceeb09d33aec206c77220dcb7ad614f` function Split (third_party/openbao/sdk/helper/shamir/shamir.go)
<!-- SPECD_MANAGED_END -->
