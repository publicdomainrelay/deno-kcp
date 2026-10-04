# Context: third-party-openbao-sdk-plugin

Repository: `deno-kcp`

_(empty: write what this context is for)_

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/plugin/backend.go` file backend.go (third_party/openbao/sdk/plugin/backend.go)
- `file:third_party/openbao/sdk/plugin/grpc_backend.go` file grpc_backend.go (third_party/openbao/sdk/plugin/grpc_backend.go)
- `file:third_party/openbao/sdk/plugin/grpc_backend_client.go` file grpc_backend_client.go (third_party/openbao/sdk/plugin/grpc_backend_client.go)
- `file:third_party/openbao/sdk/plugin/grpc_backend_server.go` file grpc_backend_server.go (third_party/openbao/sdk/plugin/grpc_backend_server.go)
- `file:third_party/openbao/sdk/plugin/grpc_backend_test.go` file grpc_backend_test.go (third_party/openbao/sdk/plugin/grpc_backend_test.go)
- `file:third_party/openbao/sdk/plugin/grpc_storage.go` file grpc_storage.go (third_party/openbao/sdk/plugin/grpc_storage.go)
- `file:third_party/openbao/sdk/plugin/grpc_system.go` file grpc_system.go (third_party/openbao/sdk/plugin/grpc_system.go)
- `file:third_party/openbao/sdk/plugin/grpc_system_test.go` file grpc_system_test.go (third_party/openbao/sdk/plugin/grpc_system_test.go)
- `file:third_party/openbao/sdk/plugin/logger.go` file logger.go (third_party/openbao/sdk/plugin/logger.go)
- `file:third_party/openbao/sdk/plugin/logger_test.go` file logger_test.go (third_party/openbao/sdk/plugin/logger_test.go)
- `file:third_party/openbao/sdk/plugin/middleware.go` file middleware.go (third_party/openbao/sdk/plugin/middleware.go)
- `file:third_party/openbao/sdk/plugin/plugin.go` file plugin.go (third_party/openbao/sdk/plugin/plugin.go)
- `file:third_party/openbao/sdk/plugin/plugin_v5.go` file plugin_v5.go (third_party/openbao/sdk/plugin/plugin_v5.go)
- `file:third_party/openbao/sdk/plugin/serve.go` file serve.go (third_party/openbao/sdk/plugin/serve.go)
- `file:third_party/openbao/sdk/plugin/storage_test.go` file storage_test.go (third_party/openbao/sdk/plugin/storage_test.go)
- `function:2102a0f2191f4030153f7abf9e3956e3` function NewPluginClient (third_party/openbao/sdk/plugin/plugin.go)
- `function:6e3505f1f4c72782efe70fd3a74447ac` function NewBackend (third_party/openbao/sdk/plugin/plugin.go)
- `function:a6733a8b57e4b20e4fa4378c8674dcf6` function NewBackendV5 (third_party/openbao/sdk/plugin/plugin_v5.go)
- `function:ace0d2c743fe6cb870f3439eaeeef5fc` function Serve (third_party/openbao/sdk/plugin/serve.go)
- `function:b052930f1568525b7416c6a7dd388b99` function ServeMultiplex (third_party/openbao/sdk/plugin/serve.go)
- `function:c7b21232958a5b231b82265ec8ac21a2` function NewBackendWithVersion (third_party/openbao/sdk/plugin/plugin.go)
- `function:c9412851cff57cc07186a931b2d0570f` function Dispense (third_party/openbao/sdk/plugin/plugin_v5.go)
- `function:f10fd7cb843087c77654f7dd89ad9c38` function NewPluginClientV5 (third_party/openbao/sdk/plugin/plugin_v5.go)
- `method:03d239f3a6001ecf6b8baf024b63c2ce` method GRPCStorageClient.Put (third_party/openbao/sdk/plugin/grpc_storage.go)
- `method:0a9c4bf7a631037cad289dd4779bf323` method BackendPluginClient.Cleanup (third_party/openbao/sdk/plugin/plugin.go)
- `method:0b9c4fcf76557462d9601358f6cd6b33` method gRPCSystemViewServer.CachingDisabled (third_party/openbao/sdk/plugin/grpc_system.go)
- `method:0bfc2e84c1c3f42c856a3c8e25811b37` method GRPCStorageClientTransaction.Rollback (third_party/openbao/sdk/plugin/grpc_storage.go)
- `method:0c70f9c91b6db5de7bbec6912b73a289` method gRPCSystemViewClient.VaultVersion (third_party/openbao/sdk/plugin/grpc_system.go)
- `method:0d2b3ec3df7e24317bcaa59cdffacde0` method GRPCBackendPlugin.GRPCServer (third_party/openbao/sdk/plugin/backend.go)
- `method:136decbd6e0368d8a3c88b89f1e20706` method GRPCStorageServer.Delete (third_party/openbao/sdk/plugin/grpc_storage.go)
- `method:174d5d0103acb1b2ed4a07af8ea49a70` method backendGRPCPluginServer.HandleRequest (third_party/openbao/sdk/plugin/grpc_backend_server.go)
- `method:1ae3ba74915527ef6a926ebbb0f3fc6d` method gRPCSystemViewClient.NewPluginClient (third_party/openbao/sdk/plugin/grpc_system.go)
- `method:1ae9e1055c4c547f91bffecf87e3408b` method LoggerServer.Error (third_party/openbao/sdk/plugin/logger.go)
- `method:1b7848a15e29d6ec84624977a059f707` method backendGRPCPluginClient.HandleRequest (third_party/openbao/sdk/plugin/grpc_backend_client.go)
- `method:1c58ea704d1ea3d538ed36c65bd1e213` method backendGRPCPluginServer.Version (third_party/openbao/sdk/plugin/grpc_backend_server.go)
- `method:1d1c41691c3048a667c5cd4d8e0afd1b` method gRPCSystemViewClient.MlockEnabled (third_party/openbao/sdk/plugin/grpc_system.go)
- `method:22236a5bc814d9e48397b652c607d2b5` method backendGRPCPluginClient.PluginVersion (third_party/openbao/sdk/plugin/grpc_backend_client.go)
- `method:2395253bf53d1ca1fa29f1fc054d3ac9` method gRPCSystemViewClient.CachingDisabled (third_party/openbao/sdk/plugin/grpc_system.go)
- `method:2761d214a022b43b525b08cc20bf1f2e` method gRPCSystemViewServer.LocalMount (third_party/openbao/sdk/plugin/grpc_system.go)
- `method:2827ddabfa1ea12b12ff2585eef1c0b5` method gRPCSystemViewServer.Tainted (third_party/openbao/sdk/plugin/grpc_system.go)
- `method:2af708be0578b6d482b348656fbf5525` method GRPCStorageClient.ListPage (third_party/openbao/sdk/plugin/grpc_storage.go)
- `method:2b4b94171d09bc27210585e5a91bcb4e` method backendGRPCPluginClient.Initialize (third_party/openbao/sdk/plugin/grpc_backend_client.go)
- `method:2bdb41cc13742562d20fd0cbb78c90d5` method backendGRPCPluginClient.SpecialPaths (third_party/openbao/sdk/plugin/grpc_backend_client.go)
- `method:32468eb19e567c90f508f68e9638ac96` method backendGRPCPluginClient.System (third_party/openbao/sdk/plugin/grpc_backend_client.go)
- `method:3396e99d36fce725371b2778e424e876` method LoggerServer.SetLevel (third_party/openbao/sdk/plugin/logger.go)
- `method:3653e0f25154a788fd8bf3e5584cf0bb` method NOOPStorage.Get (third_party/openbao/sdk/plugin/grpc_storage.go)

_99 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
