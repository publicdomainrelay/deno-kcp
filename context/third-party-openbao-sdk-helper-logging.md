# Context: third-party-openbao-sdk-helper-logging

Repository: `deno-kcp`

This context exists so that SDK consumers and OpenBao components share one definition of log format and one place to construct a logger, rather than each caller re-implementing format parsing or logger wiring. The LogFormat type carries the three accepted states so callers can compare results by value, the parsers centralise the accepted spellings of each format (including the trimmed, lower-cased, and vault-prefixed aliases), and the constructors fix the logger options — level, independent levels, output writer, and JSON formatting decided from the environment — so that a logger created through this package behaves consistently no matter which entry point is used.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/helper/logging/logging.go` file logging.go (third_party/openbao/sdk/helper/logging/logging.go)
- `file:third_party/openbao/sdk/helper/logging/logging_test.go` file logging_test.go (third_party/openbao/sdk/helper/logging/logging_test.go)
- `function:14579d465d86403647209873e941c97d` function NewVaultLogger (third_party/openbao/sdk/helper/logging/logging.go)
- `function:9ba0bab216e904df7cc422f1ce26c15d` function NewVaultLoggerWithWriter (third_party/openbao/sdk/helper/logging/logging.go)
- `function:c93ea2090c966df5cc25488e76155619` function ParseLogFormat (third_party/openbao/sdk/helper/logging/logging.go)
- `function:f429f14084efc1889a39feef98b72677` function ParseEnvLogFormat (third_party/openbao/sdk/helper/logging/logging.go)
- `method:e8e74a2a6c5eaf339e3198cee0b346de` method LogFormat.String (third_party/openbao/sdk/helper/logging/logging.go)
- `type_alias:190b85ecd7b82dddf7e2d027143cac81` type_alias LogFormat (third_party/openbao/sdk/helper/logging/logging.go)
<!-- SPECD_MANAGED_END -->
