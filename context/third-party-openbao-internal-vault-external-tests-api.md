# Context: third-party-openbao-internal-vault-external-tests-api

Repository: `deno-kcp`

The context exists to specify the behavior the OpenBao external API test package must preserve, so that a change to the vendored tree or to the client it drives can be judged against the assertions these tests already encode. It matters because these are the only tests in the repository that check the `api` client against a genuinely running Vault core rather than a mock, so they pin down the wire contract (response envelope parsing, token accessor semantics, sudo path list, rotation and rekey verification) that any refactor of the client or of the test harness must keep true.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/api/api_integration_test.go` file api_integration_test.go (third_party/openbao/internal/vault/external_tests/api/api_integration_test.go)
- `file:third_party/openbao/internal/vault/external_tests/api/index_test.go` file index_test.go (third_party/openbao/internal/vault/external_tests/api/index_test.go)
- `file:third_party/openbao/internal/vault/external_tests/api/kv_helpers_test.go` file kv_helpers_test.go (third_party/openbao/internal/vault/external_tests/api/kv_helpers_test.go)
- `file:third_party/openbao/internal/vault/external_tests/api/renewer_integration_test.go` file renewer_integration_test.go (third_party/openbao/internal/vault/external_tests/api/renewer_integration_test.go)
- `file:third_party/openbao/internal/vault/external_tests/api/secret_test.go` file secret_test.go (third_party/openbao/internal/vault/external_tests/api/secret_test.go)
- `file:third_party/openbao/internal/vault/external_tests/api/sudo_paths_test.go` file sudo_paths_test.go (third_party/openbao/internal/vault/external_tests/api/sudo_paths_test.go)
- `file:third_party/openbao/internal/vault/external_tests/api/sys_rotate_ext_test.go` file sys_rotate_ext_test.go (third_party/openbao/internal/vault/external_tests/api/sys_rotate_ext_test.go)
<!-- SPECD_MANAGED_END -->
