# Context: third-party-openbao-sdk-helper-xor

Repository: `deno-kcp`

This context exists so that callers needing a simple, dependency-free XOR primitive -- typically for splitting or recombining a secret into two shares -- can do so without reimplementing length checking, base64 decoding, and error wrapping. The package is vendored third-party code from the OpenBao SDK, so its behavior is fixed: unequal lengths, malformed base64, and empty decoded inputs are all hard errors rather than silently truncated or padded results.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/helper/xor/xor.go` file xor.go (third_party/openbao/sdk/helper/xor/xor.go)
- `file:third_party/openbao/sdk/helper/xor/xor_test.go` file xor_test.go (third_party/openbao/sdk/helper/xor/xor_test.go)
- `function:3a5b1b307f6da1e8d7cfd677e6a37901` function XORBase64 (third_party/openbao/sdk/helper/xor/xor.go)
- `function:9c0ecf693088b895977e7459db29c29e` function XORBytes (third_party/openbao/sdk/helper/xor/xor.go)
<!-- SPECD_MANAGED_END -->
