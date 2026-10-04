# Context: third-party-openbao-sdk-database-dbplugin

Repository: `deno-kcp`

The package exists so that a database secrets engine plugin, whether compiled into the host as a builtin or run as a separate go-plugin process, exposes one uniform Database contract to the caller. It carries that contract across the gRPC boundary in both directions (server-side gRPCServer adapter, client-side gRPCClient adapter), converts the JSON-encoded config bytes to and from map[string]any, normalizes shutdown and unimplemented-static-account failures into sentinel errors, and instruments every call so the host can report per-database-type metrics and trace logs.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/database/dbplugin/client.go` file client.go (third_party/openbao/sdk/database/dbplugin/client.go)
- `file:third_party/openbao/sdk/database/dbplugin/database.pb.go` file database.pb.go (third_party/openbao/sdk/database/dbplugin/database.pb.go)
- `file:third_party/openbao/sdk/database/dbplugin/database_grpc.pb.go` file database_grpc.pb.go (third_party/openbao/sdk/database/dbplugin/database_grpc.pb.go)
- `file:third_party/openbao/sdk/database/dbplugin/databasemiddleware.go` file databasemiddleware.go (third_party/openbao/sdk/database/dbplugin/databasemiddleware.go)
- `file:third_party/openbao/sdk/database/dbplugin/grpc_transport.go` file grpc_transport.go (third_party/openbao/sdk/database/dbplugin/grpc_transport.go)
- `file:third_party/openbao/sdk/database/dbplugin/plugin.go` file plugin.go (third_party/openbao/sdk/database/dbplugin/plugin.go)
- `file:third_party/openbao/sdk/database/dbplugin/server.go` file server.go (third_party/openbao/sdk/database/dbplugin/server.go)
- `function:367d7c005038ee0b286efbce7c301dfc` function RegisterDatabaseServer (third_party/openbao/sdk/database/dbplugin/database_grpc.pb.go)
- `function:5538fbfef2fa7a5bee63edeef718db1e` function PluginFactoryVersion (third_party/openbao/sdk/database/dbplugin/plugin.go)
- `function:569800375c1f0c1bceac6e6d92eb01c6` function Serve (third_party/openbao/sdk/database/dbplugin/server.go)
- `function:95ad517bf38c38608ba63dac99b36f52` function PluginFactory (third_party/openbao/sdk/database/dbplugin/plugin.go)
- `function:aae24a7ae09470196e76e7a619b2aab7` function NewPluginClient (third_party/openbao/sdk/database/dbplugin/client.go)
- `function:c37077d1ebc4514fc538caceceeeae09` function NewDatabaseClient (third_party/openbao/sdk/database/dbplugin/database_grpc.pb.go)
- `function:d36ff173d0b7cb0fadfc7c44e8e5733d` function ServeConfig (third_party/openbao/sdk/database/dbplugin/server.go)
- `function:e5b4989ee62011d67318b2da9f8f5214` function NewDatabaseErrorSanitizerMiddleware (third_party/openbao/sdk/database/dbplugin/databasemiddleware.go)
- `interface:897912d1e6d82bba93ea31d5cdbdbac9` interface DatabaseServer (third_party/openbao/sdk/database/dbplugin/database_grpc.pb.go)
- `interface:96708e350e69a92427f97ac71da1cc45` interface DatabaseClient (third_party/openbao/sdk/database/dbplugin/database_grpc.pb.go)
- `interface:b8b2e8166dbe54f74280d9310ea769af` interface UnsafeDatabaseServer (third_party/openbao/sdk/database/dbplugin/database_grpc.pb.go)
- `interface:dd78a1312c43389d929171ce9fb39a7b` interface Database (third_party/openbao/sdk/database/dbplugin/plugin.go)
- `method:01932b9c19362fab72d1ae7de54c94e1` method SetCredentialsRequest.GetStatements (third_party/openbao/sdk/database/dbplugin/database.pb.go)
- `method:02eec63104cd3d50b62481078bba5816` method RotateRootCredentialsRequest.GetStatements (third_party/openbao/sdk/database/dbplugin/database.pb.go)
- `method:036e648f044bf2474721691c07bfff31` method databaseMetricsMiddleware.RevokeUser (third_party/openbao/sdk/database/dbplugin/databasemiddleware.go)
- `method:03f83cfe3a549bce6661bf9b2396c6da` method databaseTracingMiddleware.Init (third_party/openbao/sdk/database/dbplugin/databasemiddleware.go)
- `method:049857250e11062a471066cd7e55df53` method databaseMetricsMiddleware.Init (third_party/openbao/sdk/database/dbplugin/databasemiddleware.go)
- `method:071fa3d39a8b476e05725126a9181131` method RenewUserRequest.Reset (third_party/openbao/sdk/database/dbplugin/database.pb.go)
- `method:083e05ef07cb469490478d288939aa36` method RenewUserRequest.ProtoMessage (third_party/openbao/sdk/database/dbplugin/database.pb.go)
- `method:093c846f11c7e68ee2bf2f0b386b3479` method Empty.ProtoReflect (third_party/openbao/sdk/database/dbplugin/database.pb.go)
- `method:09dca2a4cfba14dce5e97c5fbbdb9869` method SetCredentialsRequest.ProtoMessage (third_party/openbao/sdk/database/dbplugin/database.pb.go)
- `method:0a517d9d3fbf4b321b1edae063b5b09e` method SetCredentialsRequest.GetStaticUserConfig (third_party/openbao/sdk/database/dbplugin/database.pb.go)
- `method:0ab07f301b3331370941499ea6540ff6` method DatabaseClient.RotateRootCredentials (third_party/openbao/sdk/database/dbplugin/database_grpc.pb.go)
- `method:0af6c8c9018c97cb51ad0a7fb1a04615` method DatabaseErrorSanitizerMiddleware.Type (third_party/openbao/sdk/database/dbplugin/databasemiddleware.go)
- `method:0ddf3480f381f0121feb2c735ae59a75` method StaticUserConfig.GetUsername (third_party/openbao/sdk/database/dbplugin/database.pb.go)
- `method:0df7a47fe3b4e8ceca427fdec1c64bd5` method RotateRootCredentialsRequest.Descriptor (third_party/openbao/sdk/database/dbplugin/database.pb.go)
- `method:118a9cdc56be5adb02d27c07e8e4da64` method TypeResponse.ProtoMessage (third_party/openbao/sdk/database/dbplugin/database.pb.go)
- `method:13d65244d17bba6e05a946b0f8180538` method StaticUserConfig.GetPassword (third_party/openbao/sdk/database/dbplugin/database.pb.go)
- `method:147c3f78b4cafb1556b9b3a6ef2081e9` method SetCredentialsResponse.String (third_party/openbao/sdk/database/dbplugin/database.pb.go)
- `method:158f5e42a62dfb8f2cbf3906c30955a9` method TypeResponse.GetType (third_party/openbao/sdk/database/dbplugin/database.pb.go)
- `method:15a4fa5e5106d7e89d04b5ff2a16b992` method DatabaseClient.RevokeUser (third_party/openbao/sdk/database/dbplugin/database_grpc.pb.go)
- `method:1793101cb59e2036ff92aac5edc18ea8` method CreateUserResponse.ProtoReflect (third_party/openbao/sdk/database/dbplugin/database.pb.go)
- `method:18c4a0e57515b0304053c2e451e73b80` method DatabaseClient.Initialize (third_party/openbao/sdk/database/dbplugin/database_grpc.pb.go)
- `method:1a06f659bdb741a0f57f8a313982185e` method DatabaseServer.RenewUser (third_party/openbao/sdk/database/dbplugin/database_grpc.pb.go)
- `method:1b366e19201a4b757054f94dd59264ef` method DatabaseServer.GenerateCredentials (third_party/openbao/sdk/database/dbplugin/database_grpc.pb.go)

_218 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
