# Context: third-party-openbao-internal-vault-external-tests-token

Repository: `deno-kcp`

This context exists to keep the OpenBao token behavior verified against a real running core rather than against mocks. The two files are the external, black-box test layer for the token store: they mount real backends, authenticate real clients, and assert on API responses, lease counts, and token counts. Anyone changing token creation, orphan handling, entity binding, identity policy composition, CIDR restrictions, revocation-on-startup behavior, standby invalidation timing, or batch token lifecycle must expect these tests to be the contract that breaks first.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/token/batch_token_test.go` file batch_token_test.go (third_party/openbao/internal/vault/external_tests/token/batch_token_test.go)
- `file:third_party/openbao/internal/vault/external_tests/token/token_test.go` file token_test.go (third_party/openbao/internal/vault/external_tests/token/token_test.go)
<!-- SPECD_MANAGED_END -->
