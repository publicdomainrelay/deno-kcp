# Context: third-party-openbao-internal-helper-profiles

Repository: `deno-kcp`

_(empty: write what this context is for)_

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/helper/profiles/cel_source.go` file cel_source.go (third_party/openbao/internal/helper/profiles/cel_source.go)
- `file:third_party/openbao/internal/helper/profiles/cel_source_test.go` file cel_source_test.go (third_party/openbao/internal/helper/profiles/cel_source_test.go)
- `file:third_party/openbao/internal/helper/profiles/config.go` file config.go (third_party/openbao/internal/helper/profiles/config.go)
- `file:third_party/openbao/internal/helper/profiles/config_test.go` file config_test.go (third_party/openbao/internal/helper/profiles/config_test.go)
- `file:third_party/openbao/internal/helper/profiles/env_source.go` file env_source.go (third_party/openbao/internal/helper/profiles/env_source.go)
- `file:third_party/openbao/internal/helper/profiles/env_source_test.go` file env_source_test.go (third_party/openbao/internal/helper/profiles/env_source_test.go)
- `file:third_party/openbao/internal/helper/profiles/file_source.go` file file_source.go (third_party/openbao/internal/helper/profiles/file_source.go)
- `file:third_party/openbao/internal/helper/profiles/file_source_test.go` file file_source_test.go (third_party/openbao/internal/helper/profiles/file_source_test.go)
- `file:third_party/openbao/internal/helper/profiles/history.go` file history.go (third_party/openbao/internal/helper/profiles/history.go)
- `file:third_party/openbao/internal/helper/profiles/history_test.go` file history_test.go (third_party/openbao/internal/helper/profiles/history_test.go)
- `file:third_party/openbao/internal/helper/profiles/input_source.go` file input_source.go (third_party/openbao/internal/helper/profiles/input_source.go)
- `file:third_party/openbao/internal/helper/profiles/profiles.go` file profiles.go (third_party/openbao/internal/helper/profiles/profiles.go)
- `file:third_party/openbao/internal/helper/profiles/profiles_test.go` file profiles_test.go (third_party/openbao/internal/helper/profiles/profiles_test.go)
- `file:third_party/openbao/internal/helper/profiles/request_source.go` file request_source.go (third_party/openbao/internal/helper/profiles/request_source.go)
- `file:third_party/openbao/internal/helper/profiles/request_source_test.go` file request_source_test.go (third_party/openbao/internal/helper/profiles/request_source_test.go)
- `file:third_party/openbao/internal/helper/profiles/response_source.go` file response_source.go (third_party/openbao/internal/helper/profiles/response_source.go)
- `file:third_party/openbao/internal/helper/profiles/response_source_test.go` file response_source_test.go (third_party/openbao/internal/helper/profiles/response_source_test.go)
- `file:third_party/openbao/internal/helper/profiles/template_source.go` file template_source.go (third_party/openbao/internal/helper/profiles/template_source.go)
- `file:third_party/openbao/internal/helper/profiles/template_source_test.go` file template_source_test.go (third_party/openbao/internal/helper/profiles/template_source_test.go)
- `function:155d2435b3754382c8642401ed9d149a` function NewEngine (third_party/openbao/internal/helper/profiles/profiles.go)
- `function:1a0c90b0e69fbddeb3383ea2b3a276ef` function WithSourceBuilder (third_party/openbao/internal/helper/profiles/profiles.go)
- `function:202569d4c2113ce28fb68010ce7a9d84` function HasResponseSource (third_party/openbao/internal/helper/profiles/response_source.go)
- `function:22db8d00156e8649ca124a8b6a112694` function WithCELSource (third_party/openbao/internal/helper/profiles/cel_source.go)
- `function:27fdcc8c70e70193027c5273ecb64882` function TemplateSourceBuilder (third_party/openbao/internal/helper/profiles/template_source.go)
- `function:2b5ce51dd66011a62fca2a66cb5e4674` function ParseOuterConfig (third_party/openbao/internal/helper/profiles/config.go)
- `function:2b9020ed1aad1778274aee067522155d` function FileSourceBuilder (third_party/openbao/internal/helper/profiles/file_source.go)
- `function:34855acf98e57f6167116d27d6a804a1` function EnvSourceBuilder (third_party/openbao/internal/helper/profiles/env_source.go)
- `function:359ea69acfc44b6fc044a6256a377f19` function WithInputSource (third_party/openbao/internal/helper/profiles/input_source.go)
- `function:39f3d1626f87193fde2cb76639343afa` function ParseRequestConfig (third_party/openbao/internal/helper/profiles/config.go)
- `function:3b585a3d10a6f512523323a39ddcb11f` function WithTemplateSource (third_party/openbao/internal/helper/profiles/template_source.go)
- `function:3f9fe99fb6d8427b2e3fe9bdfecd48ed` function WithOuterBlockName (third_party/openbao/internal/helper/profiles/profiles.go)
- `function:449b6e660ac993d089ec2f52cea30801` function ResponseSourceBuilder (third_party/openbao/internal/helper/profiles/response_source.go)
- `function:49a7a08966690cc4a81a852f5a5e8c15` function RequestSourceBuilder (third_party/openbao/internal/helper/profiles/request_source.go)
- `function:543faf615015d36261bf8d0eda0b0e4c` function CreateOuterConfig (third_party/openbao/internal/helper/profiles/config.go)
- `function:58c56653fc17a408d5bdbef4fdecea3b` function CELSourceBuilder (third_party/openbao/internal/helper/profiles/cel_source.go)
- `function:6268fe8d5d14693c2294fb531b923dbe` function WithRequestHandler (third_party/openbao/internal/helper/profiles/profiles.go)
- `function:7440863d3b705c5c7b02d3c7b773d01d` function HasRequestSource (third_party/openbao/internal/helper/profiles/request_source.go)
- `function:7dfb6c1d2bdf0f29fe730a5dc3eca6f0` function WithFileSource (third_party/openbao/internal/helper/profiles/file_source.go)
- `function:87be9e15c14e4388c9147a4c9fd1b95b` function WithResponseSource (third_party/openbao/internal/helper/profiles/response_source.go)
- `function:8f91cf64a50ef678a372b4b3141f3144` function WithProfile (third_party/openbao/internal/helper/profiles/profiles.go)
- `function:9d316051199ccc5ff72bd1b16f009389` function ParseFieldSchemaConfig (third_party/openbao/internal/helper/profiles/config.go)

_67 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
