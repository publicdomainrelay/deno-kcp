# Context: third-party-openbao-internal-vault-external-tests-plugin

Repository: `deno-kcp`

The context exists to verify that OpenBao can build, register, mount, use, reload and recover external plugins across all supported plugin protocol versions and plugin types, and that plugin-related audit records carry the metadata needed to identify an externally mounted plugin. It is the integration-level safety net for the plugin catalog, plugin multiplexing, plugin lifecycle on seal/unseal and reload, and the audit enrichment of plugin mounts, so that changes to those subsystems fail loudly in CI instead of at an operator's deployment.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/plugin/external_plugin_test.go` file external_plugin_test.go (third_party/openbao/internal/vault/external_tests/plugin/external_plugin_test.go)
- `file:third_party/openbao/internal/vault/external_tests/plugin/plugin_test.go` file plugin_test.go (third_party/openbao/internal/vault/external_tests/plugin/plugin_test.go)
<!-- SPECD_MANAGED_END -->
