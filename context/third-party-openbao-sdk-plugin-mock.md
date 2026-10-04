# Context: third-party-openbao-sdk-plugin-mock

Repository: `deno-kcp`

The context exists so that OpenBao's plugin framework can be tested without a real secrets engine. A host that mounts this backend gets deterministic answers on every path, and a transport under test gets every error shape the plugin RPC layer must round-trip. It is test scaffolding that is shipped as a plugin: the backend deliberately keeps a mutable internal value so the Invalidate callback has something observable to destroy, deliberately returns each error family from errors/type, and deliberately reports its type through FactoryType so that both logical and other backend types can be constructed from one implementation.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/plugin/mock/backend.go` file backend.go (third_party/openbao/sdk/plugin/mock/backend.go)
- `file:third_party/openbao/sdk/plugin/mock/backend_test.go` file backend_test.go (third_party/openbao/sdk/plugin/mock/backend_test.go)
- `file:third_party/openbao/sdk/plugin/mock/path_errors.go` file path_errors.go (third_party/openbao/sdk/plugin/mock/path_errors.go)
- `file:third_party/openbao/sdk/plugin/mock/path_internal.go` file path_internal.go (third_party/openbao/sdk/plugin/mock/path_internal.go)
- `file:third_party/openbao/sdk/plugin/mock/path_kv.go` file path_kv.go (third_party/openbao/sdk/plugin/mock/path_kv.go)
- `file:third_party/openbao/sdk/plugin/mock/path_raw.go` file path_raw.go (third_party/openbao/sdk/plugin/mock/path_raw.go)
- `file:third_party/openbao/sdk/plugin/mock/path_special.go` file path_special.go (third_party/openbao/sdk/plugin/mock/path_special.go)
- `function:29b5ac0aa3f1bb58f9485724fcaa3bfa` function Factory (third_party/openbao/sdk/plugin/mock/backend.go)
- `function:52321948a6b6882db51cccc986e38ba8` function New (third_party/openbao/sdk/plugin/mock/backend.go)
- `function:7aad236747ab98eb8b7854bb33bc0161` function Backend (third_party/openbao/sdk/plugin/mock/backend.go)
- `function:a116aae3917b0ad8d5f9b043180984a3` function FactoryType (third_party/openbao/sdk/plugin/mock/backend.go)
<!-- SPECD_MANAGED_END -->
