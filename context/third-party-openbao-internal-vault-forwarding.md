# Context: third-party-openbao-internal-vault-forwarding

Repository: `deno-kcp`

The context exists so the request-forwarding wire protocol, the HA gating rules, the certificate lookups, and the client heartbeat/namespace-key/invalidation loops can be reasoned about and changed as one unit. It is the seam between a standby node and the active node: a standby must forward HTTP requests, ship and fetch namespace seal keys, and stay current on invalidations, while the active node must answer those RPCs and push invalidations. The proto service is named `RequestForwarding` for legacy reasons but carries health, forwarding, key sharing and invalidation RPCs, so the specification must record all of them together.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/forwarding/request_forwarding.go` file request_forwarding.go (third_party/openbao/internal/vault/forwarding/request_forwarding.go)
- `file:third_party/openbao/internal/vault/forwarding/request_forwarding_rpc.go` file request_forwarding_rpc.go (third_party/openbao/internal/vault/forwarding/request_forwarding_rpc.go)
- `file:third_party/openbao/internal/vault/forwarding/request_forwarding_service.pb.go` file request_forwarding_service.pb.go (third_party/openbao/internal/vault/forwarding/request_forwarding_service.pb.go)
- `file:third_party/openbao/internal/vault/forwarding/request_forwarding_service_grpc.pb.go` file request_forwarding_service_grpc.pb.go (third_party/openbao/internal/vault/forwarding/request_forwarding_service_grpc.pb.go)
- `function:026de1a79700fc1f78d3fd8fe04f7fcd` function NewRequestForwardingHandler (third_party/openbao/internal/vault/forwarding/request_forwarding.go)
- `function:0cb099a795e1619529e0e06329fa7eeb` function NewClient (third_party/openbao/internal/vault/forwarding/request_forwarding_rpc.go)
- `function:5746c17f5551e7b23f705b7db65f052f` function NewRequestForwardingClient (third_party/openbao/internal/vault/forwarding/request_forwarding_service_grpc.pb.go)
- `function:684d05cae83340677266163547b53c6d` function LegacyPackageFallback (third_party/openbao/internal/vault/forwarding/request_forwarding_rpc.go)
- `function:bd3a8abb826163c4b4f23aad6e6a746d` function NewRequestForwardingClusterClient (third_party/openbao/internal/vault/forwarding/request_forwarding.go)
- `function:fc4a929af8ea5f97ae855ee4d8ffcb5c` function RegisterRequestForwardingServer (third_party/openbao/internal/vault/forwarding/request_forwarding_service_grpc.pb.go)
- `interface:2128d72b4abc9f78512a85f62f357df1` interface UnsafeRequestForwardingServer (third_party/openbao/internal/vault/forwarding/request_forwarding_service_grpc.pb.go)
- `interface:4e11799c5ea2b292ced25f57a07d324b` interface RequestForwardingServer (third_party/openbao/internal/vault/forwarding/request_forwarding_service_grpc.pb.go)
- `interface:b38b7cf9fd528e74ae80012ff2edcdd3` interface RequestForwardingClient (third_party/openbao/internal/vault/forwarding/request_forwarding_service_grpc.pb.go)
- `method:0151be407af0ced102224aa819e22cc8` method SendNamespaceKeysRequest.ProtoMessage (third_party/openbao/internal/vault/forwarding/request_forwarding_service.pb.go)
- `method:03e2a9a2e5a3b5a6329aab6802ae61bb` method EchoRequest.GetClusterAddrs (third_party/openbao/internal/vault/forwarding/request_forwarding_service.pb.go)
- `method:06aa5826c1078100e79e0283ad3e52ac` method EchoRequest.GetClusterAddr (third_party/openbao/internal/vault/forwarding/request_forwarding_service.pb.go)
- `method:091a527a3194e17aefc5a2ec54e68c54` method EchoRequest.GetMessage (third_party/openbao/internal/vault/forwarding/request_forwarding_service.pb.go)
- `method:09c5a2e7025d9f0bc7d82bf7e8fb0649` method CheckInvalidationResponse.ProtoMessage (third_party/openbao/internal/vault/forwarding/request_forwarding_service.pb.go)
- `method:0b609dd7909c96a51010eecaa6aab977` method GetNamespaceKeysRequest.Descriptor (third_party/openbao/internal/vault/forwarding/request_forwarding_service.pb.go)
- `method:0cf2dce6314aca91a940d85d2b7b9cc9` method NodeInformation.GetClusterAddr (third_party/openbao/internal/vault/forwarding/request_forwarding_service.pb.go)
- `method:0e7521b6ea6a6126f16c0d1abb723121` method StartInvalidationResponse.GetIndex (third_party/openbao/internal/vault/forwarding/request_forwarding_service.pb.go)
- `method:1073716db4ab2ffe3fb2c130985eddc9` method StartInvalidationResponse.ProtoMessage (third_party/openbao/internal/vault/forwarding/request_forwarding_service.pb.go)
- `method:1803b44005543fb410369fc6775894fa` method RequestForwardingClient.AdvertiseNamespaceKeys (third_party/openbao/internal/vault/forwarding/request_forwarding_service_grpc.pb.go)
- `method:1b067542b829f0468655cbb5452cc6f2` method Client.CheckReplicationIndex (third_party/openbao/internal/vault/forwarding/request_forwarding_rpc.go)
- `method:1c4479bf1a1523c08050547f1ef627b1` method core.NamespacesMissingKeys (third_party/openbao/internal/vault/forwarding/request_forwarding.go)
- `method:1e333481fc2110d54b886be33ddedc65` method NodeInformation.GetReplicationState (third_party/openbao/internal/vault/forwarding/request_forwarding_service.pb.go)
- `method:1f477a439a87cfa5ea1493d325cdd435` method NodeInformation.GetMode (third_party/openbao/internal/vault/forwarding/request_forwarding_service.pb.go)
- `method:2120efe97af332232eced1438f204ef5` method SendNamespaceKeysRequest.String (third_party/openbao/internal/vault/forwarding/request_forwarding_service.pb.go)
- `method:21a3d21ce5f56a0fb9ed507a60cc2f7f` method requestForwardingClient.CheckInvalidations (third_party/openbao/internal/vault/forwarding/request_forwarding_service_grpc.pb.go)
- `method:21c4a06eaaf7c82ccac213af0d90e45f` method AdvertiseNamespaceKeysReply.GetNamespaces (third_party/openbao/internal/vault/forwarding/request_forwarding_service.pb.go)
- `method:22d3c45d6cdc208c87438b3f573d01dd` method RequestForwardingClient.CheckInvalidations (third_party/openbao/internal/vault/forwarding/request_forwarding_service_grpc.pb.go)
- `method:232f35566b0311fdb6286c9cff6b4835` method EchoRequest.GetNodeInfo (third_party/openbao/internal/vault/forwarding/request_forwarding_service.pb.go)
- `method:247989895b4739874b94fa41cbeed1e4` method forwardedRequestRPCServer.SendNamespaceKeys (third_party/openbao/internal/vault/forwarding/request_forwarding_rpc.go)
- `method:2558fa0d26e0bfc6c9b8c29cc50e257b` method ClientKey.Descriptor (third_party/openbao/internal/vault/forwarding/request_forwarding_service.pb.go)
- `method:277a6faf27aaf10fd63ed66e87991dbc` method NodeInformation.GetHostname (third_party/openbao/internal/vault/forwarding/request_forwarding_service.pb.go)

_182 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
