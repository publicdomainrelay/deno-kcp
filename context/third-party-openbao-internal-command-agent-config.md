# Context: third-party-openbao-internal-command-agent-config

Repository: `deno-kcp`

This context exists so the OpenBao agent can be configured from files: it owns the schema of the agent configuration, the parsing of HCL config files and directories, the merge of several sources into one effective Config, validation of the result, and cleanup of parse bookkeeping before the config is used or printed. It is the config layer of third_party/openbao that the agent command depends on, and its behaviour is pinned by config_test.go.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/command/agent/config/config.go` file config.go (third_party/openbao/internal/command/agent/config/config.go)
- `file:third_party/openbao/internal/command/agent/config/config_test.go` file config_test.go (third_party/openbao/internal/command/agent/config/config_test.go)
- `function:294cb86e42204c2b1e779df712442e7c` function NewConfig (third_party/openbao/internal/command/agent/config/config.go)
- `function:7d03046ef74c3b4828473c26ca07b14e` function LoadConfig (third_party/openbao/internal/command/agent/config/config.go)
- `function:7de4097c49ecd17b3154c91c54c4bc66` function LoadConfigFile (third_party/openbao/internal/command/agent/config/config.go)
- `function:cdf4d68dbad872e3cc019b30335916e8` function LoadConfigDir (third_party/openbao/internal/command/agent/config/config.go)
- `method:14758788adb7aaacf8bc499df1e36609` method Config.Merge (third_party/openbao/internal/command/agent/config/config.go)
- `method:159bd10ec29b623bd2509959fbb3378d` method Config.IsDefaultListerDefined (third_party/openbao/internal/command/agent/config/config.go)
- `method:2de5b2addd58dfa33ca845032bbc3fda` method Config.Prune (third_party/openbao/internal/command/agent/config/config.go)
- `method:33819d9eb533c481516c0e9f498b0efe` method transportDialer.DialContext (third_party/openbao/internal/command/agent/config/config.go)
- `method:8fb9e5ef63e7856d62d727089b7b3173` method Config.ValidateConfig (third_party/openbao/internal/command/agent/config/config.go)
- `method:d51536a7e952ec0386af644c07169ec3` method transportDialer.Dial (third_party/openbao/internal/command/agent/config/config.go)
- `struct:1e61102ed4280e90915a3b0faa7abaef` struct Method (third_party/openbao/internal/command/agent/config/config.go)
- `struct:395626fce95617b4e4ef8719da52ce58` struct APIProxy (third_party/openbao/internal/command/agent/config/config.go)
- `struct:44449fb715c31140e1e50908dc3e93ff` struct ExecConfig (third_party/openbao/internal/command/agent/config/config.go)
- `struct:5c371d991b82ea353ada34a8c5bd550f` struct Sink (third_party/openbao/internal/command/agent/config/config.go)
- `struct:5dcd267d8757551adf2d2b5e65efb7ad` struct TemplateConfig (third_party/openbao/internal/command/agent/config/config.go)
- `struct:ac66f17e5f4fabf2cf84d94fb54cb5ec` struct Config (third_party/openbao/internal/command/agent/config/config.go)
- `struct:b2749db8a09b8055c3236fd3f45afbfa` struct Vault (third_party/openbao/internal/command/agent/config/config.go)
- `struct:d94331f190c4482eddf512fb13aa508e` struct AutoAuth (third_party/openbao/internal/command/agent/config/config.go)
- `struct:ddbfb0c13f698324033d443acb021af5` struct Retry (third_party/openbao/internal/command/agent/config/config.go)
- `struct:e690bcb76158075ce108dc746d196ce1` struct Cache (third_party/openbao/internal/command/agent/config/config.go)
<!-- SPECD_MANAGED_END -->
