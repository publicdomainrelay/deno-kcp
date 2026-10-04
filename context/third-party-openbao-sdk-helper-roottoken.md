# Context: third-party-openbao-sdk-helper-roottoken

Repository: `deno-kcp`

The context exists so callers of the OpenBao SDK can split a root token into an encoded blob and a separate one-time password, then reassemble it, without holding the raw token in the API response. It isolates the byte-level XOR, base64 and base62 mechanics behind three functions and keeps backwards compatibility with tokens produced by the earlier zero-otpLength scheme, which used UUID formatting instead of raw string output.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/helper/roottoken/decode.go` file decode.go (third_party/openbao/sdk/helper/roottoken/decode.go)
- `file:third_party/openbao/sdk/helper/roottoken/encode.go` file encode.go (third_party/openbao/sdk/helper/roottoken/encode.go)
- `file:third_party/openbao/sdk/helper/roottoken/encode_test.go` file encode_test.go (third_party/openbao/sdk/helper/roottoken/encode_test.go)
- `file:third_party/openbao/sdk/helper/roottoken/otp.go` file otp.go (third_party/openbao/sdk/helper/roottoken/otp.go)
- `file:third_party/openbao/sdk/helper/roottoken/otp_test.go` file otp_test.go (third_party/openbao/sdk/helper/roottoken/otp_test.go)
- `function:3518a32961e678d229a118dd1bcdc667` function DecodeToken (third_party/openbao/sdk/helper/roottoken/decode.go)
- `function:79af08be4993a48058794aa0eb6cb360` function GenerateOTP (third_party/openbao/sdk/helper/roottoken/otp.go)
- `function:9dc914afacd1073fb8322590bd01f546` function EncodeToken (third_party/openbao/sdk/helper/roottoken/encode.go)
<!-- SPECD_MANAGED_END -->
