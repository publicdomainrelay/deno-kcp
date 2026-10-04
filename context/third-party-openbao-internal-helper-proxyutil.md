# Context: third-party-openbao-internal-helper-proxyutil

Repository: `deno-kcp`

This context exists to describe the vendored OpenBao PROXY protocol listener helper that this repository carries under third_party. It is the seam between a raw listener and a listener that understands the PROXY protocol line sent by a load balancer, and it decides trust for that line from a configurable behavior mode plus an authorized address list. The spec pins the parsing contract, the three accepted behavior values, the trust decision made per connection, and the failure modes, so downstream wiring that configures proxy_protocol_behavior and authorized_addrs can be reasoned about without reading the vendored file.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/helper/proxyutil/proxyutil.go` file proxyutil.go (third_party/openbao/internal/helper/proxyutil/proxyutil.go)
- `function:bc8a41e1f897c27f5611df7fa195c96f` function WrapInProxyProto (third_party/openbao/internal/helper/proxyutil/proxyutil.go)
- `method:16304eba8afdeca2dfd5b2edf506aedf` method ProxyProtoConfig.SetAuthorizedAddrs (third_party/openbao/internal/helper/proxyutil/proxyutil.go)
- `struct:5d637bf772e385dfacc87f0d9ea70390` struct ProxyProtoConfig (third_party/openbao/internal/helper/proxyutil/proxyutil.go)
<!-- SPECD_MANAGED_END -->
