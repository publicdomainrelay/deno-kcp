# Context: third-party-openbao-internal-helper-pluginutil-oci

Repository: `deno-kcp`

The context exists so that OpenBao servers can declare plugins by OCI image reference and have the binary fetched, verified, cached, and pruned without an out-of-band download step. It centralizes registry access, digest and checksum verification, tar extraction with size and disk-space limits, symlink layout, and garbage collection of unreferenced plugin binaries so that server startup and plugin initialization code (plugin_init.go, server.go, plugin_catalog_oci) share one implementation of plugin lifecycle on disk.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/helper/pluginutil/oci/downloader.go` file downloader.go (third_party/openbao/internal/helper/pluginutil/oci/downloader.go)
- `file:third_party/openbao/internal/helper/pluginutil/oci/downloader_test.go` file downloader_test.go (third_party/openbao/internal/helper/pluginutil/oci/downloader_test.go)
- `function:83b6010e0b001058041ada9ccf0a7f47` function NewPluginDownloader (third_party/openbao/internal/helper/pluginutil/oci/downloader.go)
- `method:0c31963a1d256e47e6fd88c31d7e8ab1` method PluginDownloader.Download (third_party/openbao/internal/helper/pluginutil/oci/downloader.go)
- `method:364b9a07d9740dfbf70af0bcacda2843` method PluginDownloader.IsCached (third_party/openbao/internal/helper/pluginutil/oci/downloader.go)
- `method:4491f433a58e1d354f3dd5795b47073c` method PluginDownloader.Prune (third_party/openbao/internal/helper/pluginutil/oci/downloader.go)
- `method:814afd6594193d47b551b264302aaf6f` method PluginDownloader.Reconcile (third_party/openbao/internal/helper/pluginutil/oci/downloader.go)
- `struct:a4123959d4f63cc63d31d23177faf31d` struct PluginDownloader (third_party/openbao/internal/helper/pluginutil/oci/downloader.go)
<!-- SPECD_MANAGED_END -->
