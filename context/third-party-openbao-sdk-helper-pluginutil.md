# Context: third-party-openbao-sdk-helper-pluginutil

Repository: `deno-kcp`

_(empty: write what this context is for)_

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/helper/pluginutil/env.go` file env.go (third_party/openbao/sdk/helper/pluginutil/env.go)
- `file:third_party/openbao/sdk/helper/pluginutil/multiplexing.go` file multiplexing.go (third_party/openbao/sdk/helper/pluginutil/multiplexing.go)
- `file:third_party/openbao/sdk/helper/pluginutil/multiplexing.pb.go` file multiplexing.pb.go (third_party/openbao/sdk/helper/pluginutil/multiplexing.pb.go)
- `file:third_party/openbao/sdk/helper/pluginutil/multiplexing_grpc.pb.go` file multiplexing_grpc.pb.go (third_party/openbao/sdk/helper/pluginutil/multiplexing_grpc.pb.go)
- `file:third_party/openbao/sdk/helper/pluginutil/multiplexing_test.go` file multiplexing_test.go (third_party/openbao/sdk/helper/pluginutil/multiplexing_test.go)
- `file:third_party/openbao/sdk/helper/pluginutil/run_config.go` file run_config.go (third_party/openbao/sdk/helper/pluginutil/run_config.go)
- `file:third_party/openbao/sdk/helper/pluginutil/run_config_test.go` file run_config_test.go (third_party/openbao/sdk/helper/pluginutil/run_config_test.go)
- `file:third_party/openbao/sdk/helper/pluginutil/runner.go` file runner.go (third_party/openbao/sdk/helper/pluginutil/runner.go)
- `file:third_party/openbao/sdk/helper/pluginutil/tls.go` file tls.go (third_party/openbao/sdk/helper/pluginutil/tls.go)
- `function:116a783b6b861d4bd625df8e0334a94d` function MLock (third_party/openbao/sdk/helper/pluginutil/run_config.go)
- `function:1d28340916bd885f2bd904029a7bd930` function InMetadataMode (third_party/openbao/sdk/helper/pluginutil/env.go)
- `function:4865f54d34162b4eca80a8e2631e4167` function Runner (third_party/openbao/sdk/helper/pluginutil/run_config.go)
- `function:48c88e80e6fb0d2b6f42b45a18b0614a` function MultiplexingSupported (third_party/openbao/sdk/helper/pluginutil/multiplexing.go)
- `function:570753949cd6d5e387e7a564f98be5d6` function CtxCancelIfCanceled (third_party/openbao/sdk/helper/pluginutil/runner.go)
- `function:5aa4380bca3b1928c1b116b21d4bfdf4` function Logger (third_party/openbao/sdk/helper/pluginutil/run_config.go)
- `function:614468a9e8c6f55bdcdbca753fe26d0e` function GetMultiplexIDFromContext (third_party/openbao/sdk/helper/pluginutil/multiplexing.go)
- `function:6f5bc79892dd4f74f85dfcbbca6f62c7` function MetadataMode (third_party/openbao/sdk/helper/pluginutil/run_config.go)
- `function:82f5b8a574d5603675f1d6b78f5b9506` function OptionallyEnableMlock (third_party/openbao/sdk/helper/pluginutil/env.go)
- `function:97e626f0ec471ddba7eea78743c78d31` function AutoMTLS (third_party/openbao/sdk/helper/pluginutil/run_config.go)
- `function:98a41c2983fb971a8c90ccb2db9757c3` function NewPluginMultiplexingClient (third_party/openbao/sdk/helper/pluginutil/multiplexing_grpc.pb.go)
- `function:9e11ba299d75d1cfa994fd23fd4ca10c` function PluginSets (third_party/openbao/sdk/helper/pluginutil/run_config.go)
- `function:9fd220a7179b845fe2608c8684c73aca` function Env (third_party/openbao/sdk/helper/pluginutil/run_config.go)
- `function:d3eeb60152564378665bccceb0b98323` function RegisterPluginMultiplexingServer (third_party/openbao/sdk/helper/pluginutil/multiplexing_grpc.pb.go)
- `function:e24349af21ae65ddae4c8f90ee2cd46d` function HandshakeConfig (third_party/openbao/sdk/helper/pluginutil/run_config.go)
- `interface:2663b27c152935bcf4cd53bc0ceee9fc` interface UnsafePluginMultiplexingServer (third_party/openbao/sdk/helper/pluginutil/multiplexing_grpc.pb.go)
- `interface:55de85a873de3136870fc6ca335af6ce` interface PluginMultiplexingClient (third_party/openbao/sdk/helper/pluginutil/multiplexing_grpc.pb.go)
- `interface:60c33804b73da593042fa3570f136023` interface PluginMultiplexingServer (third_party/openbao/sdk/helper/pluginutil/multiplexing_grpc.pb.go)
- `interface:78ed783a494ecc5b382ce9e517b15538` interface RunnerUtil (third_party/openbao/sdk/helper/pluginutil/runner.go)
- `interface:b5c78d1a3643602257c44aba69db60ef` interface Looker (third_party/openbao/sdk/helper/pluginutil/runner.go)
- `interface:cbb69c7b9c94c7db8a5792145ca6aa26` interface PluginClient (third_party/openbao/sdk/helper/pluginutil/runner.go)
- `interface:f9cc8171d1cffc85a4a61a0c963fd2ac` interface LookRunnerUtil (third_party/openbao/sdk/helper/pluginutil/runner.go)
- `method:0117e69146f6720229df4b635e2aa83c` method PluginRunner.RunConfig (third_party/openbao/sdk/helper/pluginutil/run_config.go)
- `method:02fa2407e98e9363b04a7b3ebf023be0` method Looker.LookupPlugin (third_party/openbao/sdk/helper/pluginutil/runner.go)
- `method:0b8d9091019f8917c5df38ca0697bf7f` method MultiplexingSupportResponse.ProtoReflect (third_party/openbao/sdk/helper/pluginutil/multiplexing.pb.go)
- `method:1e59d39b4632029e10a4d2ba09c3cc9f` method PluginMultiplexingClient.MultiplexingSupport (third_party/openbao/sdk/helper/pluginutil/multiplexing_grpc.pb.go)
- `method:2e98f1de279766b21b10c81f1be8b497` method PluginClient.Reload (third_party/openbao/sdk/helper/pluginutil/runner.go)
- `method:2fadc1892af1cd8c869a9ed2460491a8` method PluginRunner.Run (third_party/openbao/sdk/helper/pluginutil/runner.go)
- `method:339b47d8cf6a84c4855efe9614e53afc` method MultiplexingSupportResponse.Reset (third_party/openbao/sdk/helper/pluginutil/multiplexing.pb.go)
- `method:39b582c07098d61df0a499ffaf9395f1` method MultiplexingSupportResponse.String (third_party/openbao/sdk/helper/pluginutil/multiplexing.pb.go)
- `method:4b35c36f0d40317a160a7260e04786de` method PluginRunner.RunMetadataMode (third_party/openbao/sdk/helper/pluginutil/runner.go)
- `method:50ec0d5e98c00024fd79c6dce6fbfa91` method PluginMultiplexingServer.MultiplexingSupport (third_party/openbao/sdk/helper/pluginutil/multiplexing_grpc.pb.go)
- `method:56a84b6a5e369922debbf43b0e6c0af5` method UnimplementedPluginMultiplexingServer.MultiplexingSupport (third_party/openbao/sdk/helper/pluginutil/multiplexing_grpc.pb.go)

_24 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
