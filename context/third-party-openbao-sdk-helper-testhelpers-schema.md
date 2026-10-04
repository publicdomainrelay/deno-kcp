# Context: third-party-openbao-sdk-helper-testhelpers-schema

Repository: `deno-kcp`

Backend operations in OpenBao declare response schemas in framework.Path, but nothing at runtime guarantees the handler emits data matching that schema. This package exists so tests can assert the contract: it locates the declared schema for a path and operation, then validates the actual response payload against it, failing the test when they diverge. ResponseValidatingCallback lets a test install this check automatically on every response of a backend instead of writing a per-endpoint assertion.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/helper/testhelpers/schema/response_validation.go` file response_validation.go (third_party/openbao/sdk/helper/testhelpers/schema/response_validation.go)
- `file:third_party/openbao/sdk/helper/testhelpers/schema/response_validation_test.go` file response_validation_test.go (third_party/openbao/sdk/helper/testhelpers/schema/response_validation_test.go)
- `function:0add55e58d3e6d6fd8305ffac07feca6` function ValidateResponseData (third_party/openbao/sdk/helper/testhelpers/schema/response_validation.go)
- `function:38af66172cd797663f08faa6edf77b97` function GetResponseSchema (third_party/openbao/sdk/helper/testhelpers/schema/response_validation.go)
- `function:5a07ba37fe94ef99e1e18ea189337dd5` function ResponseValidatingCallback (third_party/openbao/sdk/helper/testhelpers/schema/response_validation.go)
- `function:73eb67f134dbba510097d7a789c564f9` function ValidateResponse (third_party/openbao/sdk/helper/testhelpers/schema/response_validation.go)
- `function:f01c0a3a57987dfaec3675fe272193a0` function FindResponseSchema (third_party/openbao/sdk/helper/testhelpers/schema/response_validation.go)
<!-- SPECD_MANAGED_END -->
