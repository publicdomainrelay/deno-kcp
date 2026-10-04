# Context: third-party-openbao-internal-helper-random

Repository: `deno-kcp`

_(empty: write what this context is for)_

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/helper/random/parser.go` file parser.go (third_party/openbao/internal/helper/random/parser.go)
- `file:third_party/openbao/internal/helper/random/parser_test.go` file parser_test.go (third_party/openbao/internal/helper/random/parser_test.go)
- `file:third_party/openbao/internal/helper/random/random_api.go` file random_api.go (third_party/openbao/internal/helper/random/random_api.go)
- `file:third_party/openbao/internal/helper/random/registry.go` file registry.go (third_party/openbao/internal/helper/random/registry.go)
- `file:third_party/openbao/internal/helper/random/registry_test.go` file registry_test.go (third_party/openbao/internal/helper/random/registry_test.go)
- `file:third_party/openbao/internal/helper/random/rules.go` file rules.go (third_party/openbao/internal/helper/random/rules.go)
- `file:third_party/openbao/internal/helper/random/rules_test.go` file rules_test.go (third_party/openbao/internal/helper/random/rules_test.go)
- `file:third_party/openbao/internal/helper/random/serializing.go` file serializing.go (third_party/openbao/internal/helper/random/serializing.go)
- `file:third_party/openbao/internal/helper/random/serializing_test.go` file serializing_test.go (third_party/openbao/internal/helper/random/serializing_test.go)
- `file:third_party/openbao/internal/helper/random/string_generator.go` file string_generator.go (third_party/openbao/internal/helper/random/string_generator.go)
- `file:third_party/openbao/internal/helper/random/string_generator_test.go` file string_generator_test.go (third_party/openbao/internal/helper/random/string_generator_test.go)
- `function:3f3e8dbed91b70337191211abb27d48c` function HandleRandomAPI (third_party/openbao/internal/helper/random/random_api.go)
- `function:7689ecd13f7905f0a597e578d1cf4d02` function ParsePolicy (third_party/openbao/internal/helper/random/parser.go)
- `function:82a1a2a5bdf10e6a0f641b84bc861e7e` function ParsePolicyBytes (third_party/openbao/internal/helper/random/parser.go)
- `function:c4b5f5a3889e1ec2e05ff25c971b1b37` function ParseCharset (third_party/openbao/internal/helper/random/rules.go)
- `interface:91060efc84605a1dcc13fac3225ac3cb` interface Rule (third_party/openbao/internal/helper/random/rules.go)
- `method:2341e00b57531841a647bd5422db45e5` method CharsetRule.MinLength (third_party/openbao/internal/helper/random/rules.go)
- `method:3bbceea9fc1070a46f3c6c872071f738` method PolicyParser.ParsePolicy (third_party/openbao/internal/helper/random/parser.go)
- `method:48a355dd1f9413870240d730867f64a5` method CharsetRule.Pass (third_party/openbao/internal/helper/random/rules.go)
- `method:52d709fdbcb3d5abff37bae4d4c491f7` method serializableRules.MarshalJSON (third_party/openbao/internal/helper/random/serializing.go)
- `method:568211382744bcfb5f1135a67e9dfc3e` method runes.Swap (third_party/openbao/internal/helper/random/serializing.go)
- `method:6f856173083ecef6ca7a7f88d331e0a8` method StringGenerator.Generate (third_party/openbao/internal/helper/random/string_generator.go)
- `method:72b586bc845844cdbd3aa5078d60105c` method runes.Len (third_party/openbao/internal/helper/random/serializing.go)
- `method:7791c4f5e9663e368d09393c766799b7` method Rule.Pass (third_party/openbao/internal/helper/random/rules.go)
- `method:9922db73c27392b37ee0544ee75ff10d` method serializableRules.UnmarshalJSON (third_party/openbao/internal/helper/random/serializing.go)
- `method:a4c331df70b129bcf50ccf335af59e5f` method CharsetRule.Chars (third_party/openbao/internal/helper/random/rules.go)
- `method:ad9ab2c14df85914d8d9b69a60885bee` method CharsetRule.Type (third_party/openbao/internal/helper/random/rules.go)
- `method:c465fc94b0e91b28f163f676a57e35a3` method runes.Less (third_party/openbao/internal/helper/random/serializing.go)
- `method:d5223fc9f9ab59cab1707241025106b8` method runes.UnmarshalJSON (third_party/openbao/internal/helper/random/serializing.go)
- `method:d63e6912f0d0b2ec36617d0deca1cb30` method Rule.Type (third_party/openbao/internal/helper/random/rules.go)
- `method:e91ab7a8656012a88fd93a6f6c734e5f` method runes.MarshalJSON (third_party/openbao/internal/helper/random/serializing.go)
- `struct:4f34fce2ae663b6eeabe145d17902950` struct StringGenerator (third_party/openbao/internal/helper/random/string_generator.go)
- `struct:51cf85ee3939be72e2149d2915d4077b` struct PolicyParser (third_party/openbao/internal/helper/random/parser.go)
- `struct:843ef098b5721935b75f4ad9c3d485c5` struct Registry (third_party/openbao/internal/helper/random/registry.go)
- `struct:88ddd19e7a92d20b4baeb08319dd30cf` struct CharsetRule (third_party/openbao/internal/helper/random/rules.go)
<!-- SPECD_MANAGED_END -->
