# Context: third-party-openbao-sdk-helper-tokenutil

Repository: `deno-kcp`

The package exists so that every OpenBao auth and secrets backend describes token issuance parameters in one place instead of repeating the field schema, parsing, and response marshalling for each role. TokenFields supplies the canonical field set, AddTokenFields installs it into a role's field map, ParseTokenFields turns a request's field data into a TokenParams, and PopulateTokenData plus PopulateTokenAuth push those parameters back out to API responses and issued tokens. DeprecationText and UpgradeValue exist so older renamed token fields keep working while callers move to the current key names.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/helper/tokenutil/tokenutil.go` file tokenutil.go (third_party/openbao/sdk/helper/tokenutil/tokenutil.go)
- `function:1b40e1a36a07cf64c5f3dbdeb3f856de` function AddTokenFields (third_party/openbao/sdk/helper/tokenutil/tokenutil.go)
- `function:61f5a7fa8bc8c46425642e61e90091b8` function DeprecationText (third_party/openbao/sdk/helper/tokenutil/tokenutil.go)
- `function:acfa7994320318ddae640f74d7b476f5` function AddTokenFieldsWithAllowList (third_party/openbao/sdk/helper/tokenutil/tokenutil.go)
- `function:e67f3eba917ac1e12eddf119f0f044b4` function UpgradeValue (third_party/openbao/sdk/helper/tokenutil/tokenutil.go)
- `function:f80007a81d4998ff0ed84126ab931633` function TokenFields (third_party/openbao/sdk/helper/tokenutil/tokenutil.go)
- `method:5979538a3f71abbacbfdba613ca6df38` method TokenParams.ParseTokenFields (third_party/openbao/sdk/helper/tokenutil/tokenutil.go)
- `method:779a064d3b7059f2933f94733f478e1e` method TokenParams.PopulateTokenAuth (third_party/openbao/sdk/helper/tokenutil/tokenutil.go)
- `method:8f535ceaabc0ca5ca2d1bcf7aab4f0d0` method TokenParams.PopulateTokenData (third_party/openbao/sdk/helper/tokenutil/tokenutil.go)
- `struct:49538ef1c2da53f5510e63c5a6268a83` struct TokenParams (third_party/openbao/sdk/helper/tokenutil/tokenutil.go)
<!-- SPECD_MANAGED_END -->
