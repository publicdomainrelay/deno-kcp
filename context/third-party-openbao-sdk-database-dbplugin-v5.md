# Context: third-party-openbao-sdk-database-dbplugin-v5

Repository: `deno-kcp`

_(empty: write what this context is for)_

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/database/dbplugin/v5/conversions_test.go` file conversions_test.go (third_party/openbao/sdk/database/dbplugin/v5/conversions_test.go)
- `file:third_party/openbao/sdk/database/dbplugin/v5/database.go` file database.go (third_party/openbao/sdk/database/dbplugin/v5/database.go)
- `file:third_party/openbao/sdk/database/dbplugin/v5/grpc_client.go` file grpc_client.go (third_party/openbao/sdk/database/dbplugin/v5/grpc_client.go)
- `file:third_party/openbao/sdk/database/dbplugin/v5/grpc_client_test.go` file grpc_client_test.go (third_party/openbao/sdk/database/dbplugin/v5/grpc_client_test.go)
- `file:third_party/openbao/sdk/database/dbplugin/v5/grpc_database_plugin.go` file grpc_database_plugin.go (third_party/openbao/sdk/database/dbplugin/v5/grpc_database_plugin.go)
- `file:third_party/openbao/sdk/database/dbplugin/v5/grpc_server.go` file grpc_server.go (third_party/openbao/sdk/database/dbplugin/v5/grpc_server.go)
- `file:third_party/openbao/sdk/database/dbplugin/v5/grpc_server_test.go` file grpc_server_test.go (third_party/openbao/sdk/database/dbplugin/v5/grpc_server_test.go)
- `file:third_party/openbao/sdk/database/dbplugin/v5/marshalling.go` file marshalling.go (third_party/openbao/sdk/database/dbplugin/v5/marshalling.go)
- `file:third_party/openbao/sdk/database/dbplugin/v5/middleware.go` file middleware.go (third_party/openbao/sdk/database/dbplugin/v5/middleware.go)
- `file:third_party/openbao/sdk/database/dbplugin/v5/middleware_test.go` file middleware_test.go (third_party/openbao/sdk/database/dbplugin/v5/middleware_test.go)
- `file:third_party/openbao/sdk/database/dbplugin/v5/plugin_client.go` file plugin_client.go (third_party/openbao/sdk/database/dbplugin/v5/plugin_client.go)
- `file:third_party/openbao/sdk/database/dbplugin/v5/plugin_client_test.go` file plugin_client_test.go (third_party/openbao/sdk/database/dbplugin/v5/plugin_client_test.go)
- `file:third_party/openbao/sdk/database/dbplugin/v5/plugin_factory.go` file plugin_factory.go (third_party/openbao/sdk/database/dbplugin/v5/plugin_factory.go)
- `file:third_party/openbao/sdk/database/dbplugin/v5/plugin_server.go` file plugin_server.go (third_party/openbao/sdk/database/dbplugin/v5/plugin_server.go)
- `function:0ea0e9540b869dbb740e92f2dc6eae57` function PluginFactoryVersion (third_party/openbao/sdk/database/dbplugin/v5/plugin_factory.go)
- `function:123278cbb41914b67ceb7b3a24f4daac` function PluginFactory (third_party/openbao/sdk/database/dbplugin/v5/plugin_factory.go)
- `function:827ee20f2d5744320b9f6b4552c1e670` function Serve (third_party/openbao/sdk/database/dbplugin/v5/plugin_server.go)
- `function:8ae30dd6f4be34337f254700db9c1b9b` function ServeMultiplex (third_party/openbao/sdk/database/dbplugin/v5/plugin_server.go)
- `function:8d6e3831f3d7ee1998fb5a6ab9164f99` function NewDatabaseErrorSanitizerMiddleware (third_party/openbao/sdk/database/dbplugin/v5/middleware.go)
- `function:93fd0f4a016bb850e754bf3eda1e0f0f` function NewPluginClient (third_party/openbao/sdk/database/dbplugin/v5/plugin_client.go)
- `function:d09bd1c9f934e87fa5e8267aa3cb949c` function ServeConfig (third_party/openbao/sdk/database/dbplugin/v5/plugin_server.go)
- `function:ee852639587bb277541cbf6f7d713f2b` function ServeConfigMultiplex (third_party/openbao/sdk/database/dbplugin/v5/plugin_server.go)
- `interface:efbc3f1b701c6ee3e0f150aae2141211` interface Database (third_party/openbao/sdk/database/dbplugin/v5/database.go)
- `method:03b748812c19b75e31685c89c722e5cb` method gRPCClient.Initialize (third_party/openbao/sdk/database/dbplugin/v5/grpc_client.go)
- `method:090857ff02747adba9703ad2ed1d624f` method Database.DeleteUser (third_party/openbao/sdk/database/dbplugin/v5/database.go)
- `method:0b8db0064d802cad866cc9e4f6899d45` method gRPCClient.DeleteUser (third_party/openbao/sdk/database/dbplugin/v5/grpc_client.go)
- `method:0f421aecba90fc5d6e968ffe0ebf57b7` method gRPCServer.Initialize (third_party/openbao/sdk/database/dbplugin/v5/grpc_server.go)
- `method:0fc1f235c5f599ef8e5a13c2cce16895` method databaseMetricsMiddleware.DeleteUser (third_party/openbao/sdk/database/dbplugin/v5/middleware.go)
- `method:159c0bfda3e5a83073270c9f1ed5ade9` method DatabasePluginClient.PluginVersion (third_party/openbao/sdk/database/dbplugin/v5/plugin_client.go)
- `method:1cc76569cd71d97fae9a89436318b1c7` method databaseTracingMiddleware.DeleteUser (third_party/openbao/sdk/database/dbplugin/v5/middleware.go)
- `method:1e21573bd85fec53109b52cd10870e77` method databaseMetricsMiddleware.Type (third_party/openbao/sdk/database/dbplugin/v5/middleware.go)
- `method:342ec63ddc0800e914093f848817edfb` method Database.Close (third_party/openbao/sdk/database/dbplugin/v5/database.go)
- `method:34b2402045ce1f72b8e342d027e9566c` method Database.Initialize (third_party/openbao/sdk/database/dbplugin/v5/database.go)
- `method:3652d403a0817da8bea1972c1ee15ff0` method gRPCServer.UpdateUser (third_party/openbao/sdk/database/dbplugin/v5/grpc_server.go)
- `method:388c39c3ffaa27f5d918ae384e84ab9e` method gRPCClient.NewUser (third_party/openbao/sdk/database/dbplugin/v5/grpc_client.go)
- `method:3cc79446bac189c77017610324615de7` method DatabaseErrorSanitizerMiddleware.Initialize (third_party/openbao/sdk/database/dbplugin/v5/middleware.go)
- `method:43e637e7ee9e2fd2fc94b77db9bfa94d` method InitializeResponse.SetSupportedCredentialTypes (third_party/openbao/sdk/database/dbplugin/v5/database.go)
- `method:47e8d425c2251f4225dfba4beca88ab9` method gRPCClient.UpdateUser (third_party/openbao/sdk/database/dbplugin/v5/grpc_client.go)
- `method:4958de484cd5bdc5ca67354597ef14ef` method DatabaseErrorSanitizerMiddleware.Type (third_party/openbao/sdk/database/dbplugin/v5/middleware.go)
- `method:5cf4c7a61cbb8490afcb90978b005df8` method gRPCClient.PluginVersion (third_party/openbao/sdk/database/dbplugin/v5/grpc_client.go)

_48 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
