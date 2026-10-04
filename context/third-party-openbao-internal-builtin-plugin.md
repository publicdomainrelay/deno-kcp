# Context: third-party-openbao-internal-builtin-plugin

Repository: `deno-kcp`

This context exists so OpenBao can mount a plugin as a builtin logical backend without paying plugin startup cost until the mount is first used. It resolves a plugin by name, type and version from the backend config, validates at load time that the lazily started plugin still matches the type and special paths observed in metadata mode, and survives plugin crashes by relaunching and retrying the failed method exactly once.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/plugin/backend.go` file backend.go (third_party/openbao/internal/builtin/plugin/backend.go)
- `file:third_party/openbao/internal/builtin/plugin/backend_lazyLoad_test.go` file backend_lazyLoad_test.go (third_party/openbao/internal/builtin/plugin/backend_lazyLoad_test.go)
- `file:third_party/openbao/internal/builtin/plugin/backend_test.go` file backend_test.go (third_party/openbao/internal/builtin/plugin/backend_test.go)
- `function:279285827f28c5fefc4e75c39b7fc39b` function Backend (third_party/openbao/internal/builtin/plugin/backend.go)
- `function:54cad82c274bb42c350b1fc292eccfd2` function Factory (third_party/openbao/internal/builtin/plugin/backend.go)
- `method:1827cfcd152d3afd0a38f2a6e8f0fc68` method PluginBackend.Logger (third_party/openbao/internal/builtin/plugin/backend.go)
- `method:1d5b59bbcacffc0d501f10e5157bc440` method PluginBackend.Setup (third_party/openbao/internal/builtin/plugin/backend.go)
- `method:25485adf3c6948547038555a16260759` method PluginBackend.HandleExistenceCheck (third_party/openbao/internal/builtin/plugin/backend.go)
- `method:2ca5bfb1f82e31c97888163ed21ba51a` method PluginBackend.SpecialPaths (third_party/openbao/internal/builtin/plugin/backend.go)
- `method:5720d926d077fea76c8590513e3d5138` method PluginBackend.Type (third_party/openbao/internal/builtin/plugin/backend.go)
- `method:5dbccf29070dfb9dc7c08eea2b372bb7` method PluginBackend.Cleanup (third_party/openbao/internal/builtin/plugin/backend.go)
- `method:740d924e05ea66e53ffa1d14d8a26c4e` method PluginBackend.System (third_party/openbao/internal/builtin/plugin/backend.go)
- `method:9eff9c5894c27395cd43737fb5d364a4` method PluginBackend.Initialize (third_party/openbao/internal/builtin/plugin/backend.go)
- `method:dccf4dff09449e12f867f360073b5537` method PluginBackend.InvalidateKey (third_party/openbao/internal/builtin/plugin/backend.go)
- `method:e9311d1022b961fc21571d99db324f56` method PluginBackend.HandleRequest (third_party/openbao/internal/builtin/plugin/backend.go)
- `method:eb22d417068f282674a039b8d17d06a4` method PluginBackend.PluginVersion (third_party/openbao/internal/builtin/plugin/backend.go)
- `struct:aac12544428d4d44fc72971986a2d518` struct PluginBackend (third_party/openbao/internal/builtin/plugin/backend.go)
<!-- SPECD_MANAGED_END -->
