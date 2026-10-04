# Context: third-party-openbao-sdk-helper-template

Repository: `deno-kcp`

The context exists so callers in this repository can build and render Go text/templates through a validated, option-driven constructor instead of calling text/template directly. Callers pass a raw template string and any extra template functions as Opt values; the constructor validates the input once, merges a built-in function library, and returns a StringTemplate whose Generate method renders the parsed template against caller data.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/helper/template/funcs.go` file funcs.go (third_party/openbao/sdk/helper/template/funcs.go)
- `file:third_party/openbao/sdk/helper/template/funcs_test.go` file funcs_test.go (third_party/openbao/sdk/helper/template/funcs_test.go)
- `file:third_party/openbao/sdk/helper/template/template.go` file template.go (third_party/openbao/sdk/helper/template/template.go)
- `file:third_party/openbao/sdk/helper/template/template_test.go` file template_test.go (third_party/openbao/sdk/helper/template/template_test.go)
- `function:0863ca8e4e59382dff1e3569dfa86150` function NewTemplate (third_party/openbao/sdk/helper/template/template.go)
- `function:2d65743c2acb10f109a598b1adb2a8aa` function Function (third_party/openbao/sdk/helper/template/template.go)
- `function:633fb385f6c7e3a185e7d7f585882bd4` function Option (third_party/openbao/sdk/helper/template/template.go)
- `function:e916dee7d7c65ed558f6b04bd9fdd93d` function Template (third_party/openbao/sdk/helper/template/template.go)
- `method:5cec2f37ce542ffbd6260b060201b027` method StringTemplate.Generate (third_party/openbao/sdk/helper/template/template.go)
- `struct:4578ac9a6509fdb2557a98f75f115a7e` struct StringTemplate (third_party/openbao/sdk/helper/template/template.go)
- `type_alias:961b4139fc2c076a3339627c31869405` type_alias Opt (third_party/openbao/sdk/helper/template/template.go)
<!-- SPECD_MANAGED_END -->
