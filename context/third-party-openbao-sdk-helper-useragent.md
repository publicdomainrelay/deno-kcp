# Context: third-party-openbao-sdk-helper-useragent

Repository: `deno-kcp`

The package exists so that OpenBao API clients and external plugins identify themselves consistently and machine-parsably in the User-Agent header. PluginString gives plugin processes a way to advertise the host Vault version and their own plugin name without hand-formatting the header, while String serves callers that only need the generic agent string. Keeping the format in one place makes the emitted header uniform across components.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/helper/useragent/useragent.go` file useragent.go (third_party/openbao/sdk/helper/useragent/useragent.go)
- `file:third_party/openbao/sdk/helper/useragent/useragent_test.go` file useragent_test.go (third_party/openbao/sdk/helper/useragent/useragent_test.go)
- `function:c2b7b93f98bb13761bb4913658be6306` function String (third_party/openbao/sdk/helper/useragent/useragent.go)
- `function:f2ef3a3169d630fdb4bad111f1a84fbf` function PluginString (third_party/openbao/sdk/helper/useragent/useragent.go)
<!-- SPECD_MANAGED_END -->
