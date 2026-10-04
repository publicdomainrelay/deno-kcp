# Context: third-party-openbao-internal-builtin-logical-pki-dnstest

Repository: `deno-kcp`

This context exists to specify the contract of the DNS test harness the PKI backend relies on: what the constructors guarantee about container startup and configuration, how domain and record state is mutated and synchronized, how the running resolver's addresses are exposed to tests, and how resources are released. It gives an implementer or reviewer the invariants the helper must hold so that PKI tests can depend on a deterministic in-container DNS server without re-reading the whole file.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/logical/pki/dnstest/server.go` file server.go (third_party/openbao/internal/builtin/logical/pki/dnstest/server.go)
- `function:769bf9a407752d46c66e4c62f29a9e3d` function SetupResolverOnNetwork (third_party/openbao/internal/builtin/logical/pki/dnstest/server.go)
- `function:88f0f0268853a2055eba1644ceea6e4e` function SetupResolver (third_party/openbao/internal/builtin/logical/pki/dnstest/server.go)
- `method:158ff4a89391b2d07b470a73e9d63382` method TestServer.AddDomain (third_party/openbao/internal/builtin/logical/pki/dnstest/server.go)
- `method:55f9f3a2853673bbf964a50d65a1f2de` method TestServer.RemoveRecordsOfTypeForDomain (third_party/openbao/internal/builtin/logical/pki/dnstest/server.go)
- `method:586406dafe979d86dc8d3b4e0a83cc13` method TestServer.Cleanup (third_party/openbao/internal/builtin/logical/pki/dnstest/server.go)
- `method:6248feb08d12f960753200d1bb8ac089` method TestServer.RemoveAllRecords (third_party/openbao/internal/builtin/logical/pki/dnstest/server.go)
- `method:6ca5f3cf3a0af374c79ca10e46735d56` method TestServer.PushConfig (third_party/openbao/internal/builtin/logical/pki/dnstest/server.go)
- `method:93395f6ee0e52bc88dfc8d77ada5bec8` method TestServer.GetLocalAddr (third_party/openbao/internal/builtin/logical/pki/dnstest/server.go)
- `method:a01ec1c6398f282d07519771cffce0b8` method TestServer.GetRemoteAddr (third_party/openbao/internal/builtin/logical/pki/dnstest/server.go)
- `method:aa35f509411a5732c3b92dfd0c96be1d` method TestServer.RemoveRecordsForDomain (third_party/openbao/internal/builtin/logical/pki/dnstest/server.go)
- `method:ba1201102a00df0a994c03e5aeaed589` method TestServer.RemoveRecord (third_party/openbao/internal/builtin/logical/pki/dnstest/server.go)
- `method:ebfaea9507c84692de195294c309b464` method TestServer.AddRecord (third_party/openbao/internal/builtin/logical/pki/dnstest/server.go)
- `struct:a90e3c5d2d24007c86c24ef772e6cf58` struct TestServer (third_party/openbao/internal/builtin/logical/pki/dnstest/server.go)
<!-- SPECD_MANAGED_END -->
