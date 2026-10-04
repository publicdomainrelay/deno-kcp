# Context: third-party-openbao-internal-vault-external-tests-workflows

Repository: `deno-kcp`

The context exists to prove end-to-end that the workflows engine behaves correctly across the HTTP surface: storage and listing of workflow definitions, execution of multi-flow workflows that template paths and thread responses between flows, rejection of recursive workflows, authentication with MFA enforcement, permission gating of unauthenticated execution, and the internal-only nature of the alias-lookahead operation. It anchors those invariants to runnable acceptance tests so a change in the workflows subsystem that breaks any of these observable behaviours fails the suite.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/workflows/workflow_test.go` file workflow_test.go (third_party/openbao/internal/vault/external_tests/workflows/workflow_test.go)
<!-- SPECD_MANAGED_END -->
