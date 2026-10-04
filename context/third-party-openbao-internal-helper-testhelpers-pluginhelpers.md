# Context: third-party-openbao-internal-helper-testhelpers-pluginhelpers

Repository: `deno-kcp`

This context exists so that OpenBao tests can mount and register real plugin binaries without hand-building them per test. Tests declare which plugin type they need; the helper resolves the builtin implementation, compiles it once per (name, type, version) into a caller-chosen directory, and hands back the metadata — file name and SHA-256 — that Vault's plugin registration API requires. The cache and the lock exist because compiling the same plugin repeatedly across a test run is slow, and the directory walk exists so the helper works whether the test process starts in the repository root or a nested package directory.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/helper/testhelpers/pluginhelpers/pluginhelpers.go` file pluginhelpers.go (third_party/openbao/internal/helper/testhelpers/pluginhelpers/pluginhelpers.go)
- `function:252e9ed92417656777ddce9af6febb09` function CompilePlugin (third_party/openbao/internal/helper/testhelpers/pluginhelpers/pluginhelpers.go)
- `function:7b6bbdabd3585e5219119d1bfb6f4e93` function GetPlugin (third_party/openbao/internal/helper/testhelpers/pluginhelpers/pluginhelpers.go)
- `struct:b88f26fa4c69a7e4fbf4a8b72c73413d` struct TestPlugin (third_party/openbao/internal/helper/testhelpers/pluginhelpers/pluginhelpers.go)
<!-- SPECD_MANAGED_END -->
