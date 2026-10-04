# Context: third-party-openbao-internal-helper-parseip

Repository: `deno-kcp`

This context exists to document the small text-normalization helper OpenBao uses before parsing addresses, kept as vendored third-party code inside the deno-kcp repository. Its purpose is to make address strings with leading zeroes in octets (for example 010.010.20.5 or ::192.00.002.33) comparable and parseable by canonicalizing them, since Go's net.ParseIPSloppy rejects or mishandles such forms. The spec pins down the contract that callers depend on: CIDR input has only its address portion rewritten and its prefix length preserved verbatim, while anything that is not a well-formed CIDR string passes through untouched.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/helper/parseip/parseip.go` file parseip.go (third_party/openbao/internal/helper/parseip/parseip.go)
- `file:third_party/openbao/internal/helper/parseip/parseip_test.go` file parseip_test.go (third_party/openbao/internal/helper/parseip/parseip_test.go)
- `function:1461006423d5a06241fef7e963c65dcd` function TrimLeadingZeroesCIDR (third_party/openbao/internal/helper/parseip/parseip.go)
<!-- SPECD_MANAGED_END -->
