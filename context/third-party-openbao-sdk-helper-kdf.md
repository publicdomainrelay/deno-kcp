# Context: third-party-openbao-sdk-helper-kdf

Repository: `deno-kcp`

This context exists to record the contract of the vendored OpenBao kdf helper so that callers deriving key material from a key plus context can rely on its alignment rules, counter layout, overflow guard, and output length, and so that the two entry points stay byte-for-byte compatible with the upstream vectors that kdf_test.go encodes.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/helper/kdf/kdf.go` file kdf.go (third_party/openbao/sdk/helper/kdf/kdf.go)
- `file:third_party/openbao/sdk/helper/kdf/kdf_test.go` file kdf_test.go (third_party/openbao/sdk/helper/kdf/kdf_test.go)
- `function:57ef1c334238af3ef1acf9a5cfc81c66` function CounterMode (third_party/openbao/sdk/helper/kdf/kdf.go)
- `function:8b0939bcb7f14c09092be37897617ef5` function HMACSHA256PRF (third_party/openbao/sdk/helper/kdf/kdf.go)
- `type_alias:5e2017560087551f07a878e239569078` type_alias PRF (third_party/openbao/sdk/helper/kdf/kdf.go)
<!-- SPECD_MANAGED_END -->
