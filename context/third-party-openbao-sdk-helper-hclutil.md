# Context: third-party-openbao-sdk-helper-hclutil

Repository: `deno-kcp`

This context exists to give the deno-kcp specification a stable description of the vendored OpenBao HCL parsing and key-validation helpers. The package is a dependency boundary: other packages in the vendored tree read configuration through it rather than touching the HCL AST library directly, so its three functions define the contract for how configuration bytes become a parsed AST and how unknown configuration keys are rejected. It is documented here so that consumers of the vendored OpenBao code can rely on the parsing and validation behaviour without depending on the internal layout of the helper file.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/helper/hclutil/hcl.go` file hcl.go (third_party/openbao/sdk/helper/hclutil/hcl.go)
- `function:6111decf716583b7ca8e7c49cdbe479b` function ParseConfig (third_party/openbao/sdk/helper/hclutil/hcl.go)
- `function:630fc7a2c6d7b7c77ac4f6c7b54f855c` function WhenHCLKeyPresent (third_party/openbao/sdk/helper/hclutil/hcl.go)
- `function:7331d1e1fd9fa4af3a0e6b8a4af38118` function CheckHCLKeys (third_party/openbao/sdk/helper/hclutil/hcl.go)
<!-- SPECD_MANAGED_END -->
