# Context: third-party-openbao-internal-command-server

Repository: `deno-kcp`

_(empty: write what this context is for)_

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/command/server/config.go` file config.go (third_party/openbao/internal/command/server/config.go)
- `file:third_party/openbao/internal/command/server/config_custom_response_headers_test.go` file config_custom_response_headers_test.go (third_party/openbao/internal/command/server/config_custom_response_headers_test.go)
- `file:third_party/openbao/internal/command/server/config_plugin_test.go` file config_plugin_test.go (third_party/openbao/internal/command/server/config_plugin_test.go)
- `file:third_party/openbao/internal/command/server/config_telemetry_test.go` file config_telemetry_test.go (third_party/openbao/internal/command/server/config_telemetry_test.go)
- `file:third_party/openbao/internal/command/server/config_test.go` file config_test.go (third_party/openbao/internal/command/server/config_test.go)
- `file:third_party/openbao/internal/command/server/config_test_helpers.go` file config_test_helpers.go (third_party/openbao/internal/command/server/config_test_helpers.go)
- `file:third_party/openbao/internal/command/server/config_test_helpers_util.go` file config_test_helpers_util.go (third_party/openbao/internal/command/server/config_test_helpers_util.go)
- `file:third_party/openbao/internal/command/server/listener.go` file listener.go (third_party/openbao/internal/command/server/listener.go)
- `file:third_party/openbao/internal/command/server/listener_tcp.go` file listener_tcp.go (third_party/openbao/internal/command/server/listener_tcp.go)
- `file:third_party/openbao/internal/command/server/listener_tcp_test.go` file listener_tcp_test.go (third_party/openbao/internal/command/server/listener_tcp_test.go)
- `file:third_party/openbao/internal/command/server/listener_test.go` file listener_test.go (third_party/openbao/internal/command/server/listener_test.go)
- `file:third_party/openbao/internal/command/server/listener_unix.go` file listener_unix.go (third_party/openbao/internal/command/server/listener_unix.go)
- `file:third_party/openbao/internal/command/server/listener_unix_test.go` file listener_unix_test.go (third_party/openbao/internal/command/server/listener_unix_test.go)
- `file:third_party/openbao/internal/command/server/tls_util.go` file tls_util.go (third_party/openbao/internal/command/server/tls_util.go)
- `function:03144b89852a78296c71206dadc98175` function ParseStorage (third_party/openbao/internal/command/server/config.go)
- `function:0b87c92a006924445170e92eb9fd3ac6` function NewConfig (third_party/openbao/internal/command/server/config.go)
- `function:25d191a1c582b2afff5c117b0c98d892` function DevConfig (third_party/openbao/internal/command/server/config.go)
- `function:336c55c9040b22b705deb645348aeae1` function GenerateCA (third_party/openbao/internal/command/server/tls_util.go)
- `function:6dedc4a5dc32fe052d06d52b24fcd566` function GenerateCert (third_party/openbao/internal/command/server/tls_util.go)
- `function:958c77c54e3d19f60e8370d4eec48511` function ParseConfig (third_party/openbao/internal/command/server/config.go)
- `function:a93f3eab7b0c4eb35407fb4473459e82` function LoadConfigFile (third_party/openbao/internal/command/server/config.go)
- `function:b56dd38ccbd2881d4021840d20796e60` function CheckConfig (third_party/openbao/internal/command/server/config.go)
- `function:ce54ba88db8a7cc2d9fb83b3c0ad91b5` function LoadConfig (third_party/openbao/internal/command/server/config.go)
- `function:d449e3c77a6f2ae4ca4924a6528f57ae` function NewListener (third_party/openbao/internal/command/server/listener.go)
- `function:dc9cec84675661684ef50f71f836876c` function DevTLSConfig (third_party/openbao/internal/command/server/config.go)
- `function:ebac0163d349adaca8243e545103be78` function LoadConfigDir (third_party/openbao/internal/command/server/config.go)
- `method:04a00522ec09e8828a14449e51257aca` method PluginConfig.FullName (third_party/openbao/internal/command/server/config.go)
- `method:1e2b78057ea3261cec98c003011000b3` method Config.Merge (third_party/openbao/internal/command/server/config.go)
- `method:2aeb95c290196a8338bee818f2f2da9d` method ServiceRegistration.GoString (third_party/openbao/internal/command/server/config.go)
- `method:46291d598e445725edf9c16649397f06` method Config.Sanitized (third_party/openbao/internal/command/server/config.go)
- `method:5237a00d60222596780babd141d0b54f` method PluginConfig.Validate (third_party/openbao/internal/command/server/config.go)
- `method:64c3ada9252b647581c194fc64cdcdb2` method PluginConfig.Slug (third_party/openbao/internal/command/server/config.go)
- `method:6aba0f8d267b7079b058de03a6dc991c` method AuditDevice.Validate (third_party/openbao/internal/command/server/config.go)
- `method:6b0b29f1cc7f42aab557545e3d264c92` method Config.ToVaultNodeConfig (third_party/openbao/internal/command/server/config.go)
- `method:7bdac16f01c5ea155ebcbf4784ec6468` method Config.Validate (third_party/openbao/internal/command/server/config.go)
- `method:9e072e25d8c94deae7afc680407f1016` method Storage.GoString (third_party/openbao/internal/command/server/config.go)
- `method:b2e8befe16960a229617e8a4339cae16` method TCPKeepAliveListener.Accept (third_party/openbao/internal/command/server/listener_tcp.go)
- `method:d8c26748252a06f94eeb67a95ef4bde3` method ServiceRegistration.Validate (third_party/openbao/internal/command/server/config.go)
- `method:dd879843d58ee64591c50ee959a6590c` method Config.Prune (third_party/openbao/internal/command/server/config.go)
- `method:f0f2e32b6c83cb5abd5d5e3309e05218` method AuditDevice.GoString (third_party/openbao/internal/command/server/config.go)
- `method:f8cf98197bc0197fa6d91b935722c904` method PluginConfig.CommandPath (third_party/openbao/internal/command/server/config.go)
- `struct:3017d05b44fddeef00f6df7ce311ab72` struct PluginConfig (third_party/openbao/internal/command/server/config.go)
- `struct:463f6d147378f09cf4090ac0289e86ca` struct AuditDevice (third_party/openbao/internal/command/server/config.go)

_6 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
