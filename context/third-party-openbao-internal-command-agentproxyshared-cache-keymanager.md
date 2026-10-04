# Context: third-party-openbao-internal-command-agentproxyshared-cache-keymanager

Repository: `deno-kcp`

This context exists to specify the key-material boundary of the agent proxy shared cache. The cache needs a wrapper to encrypt and decrypt cached responses and a way to hand back the material that reproduces the cache key, but it should not care how that material is produced or whether it is abstracted behind an external KMS. The KeyManager interface states that boundary in two methods, and PassthroughKeyManager supplies the simplest conforming behavior: one locally held AES-GCM root key, generated if absent, returned unchanged as the retrieval token. Reading this context tells a maintainer what the contract requires, what the passthrough implementation accepts and rejects, and which error strings and constants downstream code can depend on.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/command/agentproxyshared/cache/keymanager/manager.go` file manager.go (third_party/openbao/internal/command/agentproxyshared/cache/keymanager/manager.go)
- `file:third_party/openbao/internal/command/agentproxyshared/cache/keymanager/passthrough.go` file passthrough.go (third_party/openbao/internal/command/agentproxyshared/cache/keymanager/passthrough.go)
- `file:third_party/openbao/internal/command/agentproxyshared/cache/keymanager/passthrough_test.go` file passthrough_test.go (third_party/openbao/internal/command/agentproxyshared/cache/keymanager/passthrough_test.go)
- `function:d44e09ab3af0fd99b64a10c3f2faa4d2` function NewPassthroughKeyManager (third_party/openbao/internal/command/agentproxyshared/cache/keymanager/passthrough.go)
- `interface:d00c51a0235874fb732e081ad66bc03a` interface KeyManager (third_party/openbao/internal/command/agentproxyshared/cache/keymanager/manager.go)
- `method:08219df992da36d79b44d2a92e7f0c51` method KeyManager.RetrievalToken (third_party/openbao/internal/command/agentproxyshared/cache/keymanager/manager.go)
- `method:1d7f8031128f2daa290c05a3247b7687` method PassthroughKeyManager.RetrievalToken (third_party/openbao/internal/command/agentproxyshared/cache/keymanager/passthrough.go)
- `method:a129007c172ebe0a5d8127eb26368b58` method PassthroughKeyManager.Wrapper (third_party/openbao/internal/command/agentproxyshared/cache/keymanager/passthrough.go)
- `method:ff0d80c0ab9cc136eac0d0a232e1c88a` method KeyManager.Wrapper (third_party/openbao/internal/command/agentproxyshared/cache/keymanager/manager.go)
- `struct:194fd2b46e2244a6f7f3f7de2e915e3f` struct PassthroughKeyManager (third_party/openbao/internal/command/agentproxyshared/cache/keymanager/passthrough.go)
<!-- SPECD_MANAGED_END -->
