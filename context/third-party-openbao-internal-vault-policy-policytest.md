# Context: third-party-openbao-internal-vault-policy-policytest

Repository: `deno-kcp`

This context exists to pin the observable behaviour of layered Vault ACL evaluation: an ACL assembled from several stacked policies must allow, deny or grant root privileges on exactly the paths and operations the table lists. It lives in policytest rather than a _test.go file so multiple packages can import it and run the identical suite against ACLs they build by different construction paths, which keeps layered-policy resolution honest across callers without duplicating the expectation table.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/policy/policytest/acl.go` file acl.go (third_party/openbao/internal/vault/policy/policytest/acl.go)
- `function:c661ac0e792f811fac9344e9db3e2bbf` function TestLayeredACL (third_party/openbao/internal/vault/policy/policytest/acl.go)
<!-- SPECD_MANAGED_END -->
