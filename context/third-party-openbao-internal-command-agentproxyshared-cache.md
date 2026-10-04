# Context: third-party-openbao-internal-command-agentproxyshared-cache

Repository: `deno-kcp`

_(empty: write what this context is for)_

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/command/agentproxyshared/cache/api_proxy.go` file api_proxy.go (third_party/openbao/internal/command/agentproxyshared/cache/api_proxy.go)
- `file:third_party/openbao/internal/command/agentproxyshared/cache/api_proxy_test.go` file api_proxy_test.go (third_party/openbao/internal/command/agentproxyshared/cache/api_proxy_test.go)
- `file:third_party/openbao/internal/command/agentproxyshared/cache/cache_test.go` file cache_test.go (third_party/openbao/internal/command/agentproxyshared/cache/cache_test.go)
- `file:third_party/openbao/internal/command/agentproxyshared/cache/handler.go` file handler.go (third_party/openbao/internal/command/agentproxyshared/cache/handler.go)
- `file:third_party/openbao/internal/command/agentproxyshared/cache/lease_cache.go` file lease_cache.go (third_party/openbao/internal/command/agentproxyshared/cache/lease_cache.go)
- `file:third_party/openbao/internal/command/agentproxyshared/cache/lease_cache_test.go` file lease_cache_test.go (third_party/openbao/internal/command/agentproxyshared/cache/lease_cache_test.go)
- `file:third_party/openbao/internal/command/agentproxyshared/cache/listener.go` file listener.go (third_party/openbao/internal/command/agentproxyshared/cache/listener.go)
- `file:third_party/openbao/internal/command/agentproxyshared/cache/listener_test.go` file listener_test.go (third_party/openbao/internal/command/agentproxyshared/cache/listener_test.go)
- `file:third_party/openbao/internal/command/agentproxyshared/cache/proxy.go` file proxy.go (third_party/openbao/internal/command/agentproxyshared/cache/proxy.go)
- `file:third_party/openbao/internal/command/agentproxyshared/cache/testing.go` file testing.go (third_party/openbao/internal/command/agentproxyshared/cache/testing.go)
- `function:066c605bd6c667b70919d2eda8f85cc7` function StartListener (third_party/openbao/internal/command/agentproxyshared/cache/listener.go)
- `function:3ba9a60a8e419435a75f9021654ae94b` function NewLeaseCache (third_party/openbao/internal/command/agentproxyshared/cache/lease_cache.go)
- `function:61da32d59d1876de30750dc2b8ef71cb` function NewAPIProxy (third_party/openbao/internal/command/agentproxyshared/cache/api_proxy.go)
- `function:6eb376e38d7382717ba68c6c77a986c9` function NewMockProxier (third_party/openbao/internal/command/agentproxyshared/cache/testing.go)
- `function:d57ef6e3217c3f808459e2842d0ccc2d` function NewSendResponse (third_party/openbao/internal/command/agentproxyshared/cache/proxy.go)
- `function:f1d3ae36f34877a17d3cb0f6ca86a806` function ProxyHandler (third_party/openbao/internal/command/agentproxyshared/cache/handler.go)
- `interface:3f99f353c860aac9aee1e27f73bc3d1f` interface Proxier (third_party/openbao/internal/command/agentproxyshared/cache/proxy.go)
- `method:0ed25ce68f40e2ae40e2f92048b8e3a9` method Proxier.Send (third_party/openbao/internal/command/agentproxyshared/cache/proxy.go)
- `method:2f668cb9c6e9d5d886d9578ca327b6ca` method LeaseCache.HandleCacheClear (third_party/openbao/internal/command/agentproxyshared/cache/lease_cache.go)
- `method:364f71fd5698665d24456387697a4f56` method LeaseCache.PersistentStorage (third_party/openbao/internal/command/agentproxyshared/cache/lease_cache.go)
- `method:4896fbe21f146c34696c144198741f67` method mockProxier.ResponseIndex (third_party/openbao/internal/command/agentproxyshared/cache/testing.go)
- `method:496e34e748f8a4229e4c5331cadd644d` method LeaseCache.RegisterAutoAuthToken (third_party/openbao/internal/command/agentproxyshared/cache/lease_cache.go)
- `method:4a536980b121b274b6f9d2986b0498f4` method LeaseCache.SetShuttingDown (third_party/openbao/internal/command/agentproxyshared/cache/lease_cache.go)
- `method:56c8c42ddf9d4760b9b507484a2fdd29` method LeaseCache.Restore (third_party/openbao/internal/command/agentproxyshared/cache/lease_cache.go)
- `method:7a0834e74012cfdbf5dc1e53d3b28f90` method LeaseCache.Set (third_party/openbao/internal/command/agentproxyshared/cache/lease_cache.go)
- `method:7fe2b11ccf35ad5e4244a767541e3b35` method mockTokenVerifierProxier.GetCurrentRequestToken (third_party/openbao/internal/command/agentproxyshared/cache/testing.go)
- `method:8b6939d4b3c2cc7219f9d32d2e199324` method mockTokenVerifierProxier.Send (third_party/openbao/internal/command/agentproxyshared/cache/testing.go)
- `method:8e9496434f57eac64a19d4af20b14795` method LeaseCache.Evict (third_party/openbao/internal/command/agentproxyshared/cache/lease_cache.go)
- `method:bc251d186b496bc9f4f8985663659102` method APIProxy.Send (third_party/openbao/internal/command/agentproxyshared/cache/api_proxy.go)
- `method:bc8c62bda0b52028e90875ca129e4a4f` method LeaseCache.Send (third_party/openbao/internal/command/agentproxyshared/cache/lease_cache.go)
- `method:c871dd4238246c098b6f7ee62180f629` method LeaseCache.SetPersistentStorage (third_party/openbao/internal/command/agentproxyshared/cache/lease_cache.go)
- `method:d13c8469f09338bf6f418c467acbd39d` method mockProxier.Send (third_party/openbao/internal/command/agentproxyshared/cache/testing.go)
- `method:d255a5ce2644390517f61e30993d649a` method LeaseCache.Flush (third_party/openbao/internal/command/agentproxyshared/cache/lease_cache.go)
- `method:e2ec35611b55f1b7fd75bf5326a89404` method mockDelayProxier.Send (third_party/openbao/internal/command/agentproxyshared/cache/testing.go)
- `struct:222f85cecb09886cfd7361ac8fdbaa58` struct ListenerBundle (third_party/openbao/internal/command/agentproxyshared/cache/listener.go)
- `struct:416f160565b75ca927b9a8e36d0e2885` struct SendRequest (third_party/openbao/internal/command/agentproxyshared/cache/proxy.go)
- `struct:61462adc6d54d695c8ca3ff258d691cc` struct CacheMeta (third_party/openbao/internal/command/agentproxyshared/cache/proxy.go)
- `struct:64c3ca80392f178b7b9e63336363a071` struct APIProxyConfig (third_party/openbao/internal/command/agentproxyshared/cache/api_proxy.go)

_4 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
