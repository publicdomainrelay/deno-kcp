# Context: third-party-openbao-internal-vault-external-tests-policy

Repository: `deno-kcp`

The context exists so the templated-policy and policy-pagination behaviour of the Vault core can be described and verified end to end from outside the vault package. The tests encode the observable contract of the HTTP policy surface: what a login or renewal response must report for token, identity, and combined policy sets; how pagination_limit and required_parameters on an ACL path constrain list and scan operations; when identity template values resolve versus deny; and how policy data propagates to a standby core when the cache is disabled. A block of LDAP-auth tests is commented out because it depends on an LDAP plugin and container, so the remaining tests use userpass and the built-in KV backend only.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/policy/acl_templating_test.go` file acl_templating_test.go (third_party/openbao/internal/vault/external_tests/policy/acl_templating_test.go)
- `file:third_party/openbao/internal/vault/external_tests/policy/policy_test.go` file policy_test.go (third_party/openbao/internal/vault/external_tests/policy/policy_test.go)
<!-- SPECD_MANAGED_END -->
