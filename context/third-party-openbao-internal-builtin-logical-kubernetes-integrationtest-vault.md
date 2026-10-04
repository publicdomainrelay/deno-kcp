# Context: third-party-openbao-internal-builtin-logical-kubernetes-integrationtest-vault

Repository: `deno-kcp`

These are test-fixture manifests, not application code: they exist so the kubernetes secrets-engine integration tests have a real cluster with known ServiceAccounts, known RBAC grants, and a host-reachable Vault. The split is deliberate — hostPortPatch is applied over the Vault helm chart, testServiceAccounts creates the subjects, testRoles declares the permissions, and testBindings attaches them, so a test can assert behaviour for a privileged ServiceAccount, an under-privileged one, and a token-creating one.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/logical/kubernetes/integrationtest/vault/hostPortPatch.yaml` file hostPortPatch.yaml (third_party/openbao/internal/builtin/logical/kubernetes/integrationtest/vault/hostPortPatch.yaml)
- `file:third_party/openbao/internal/builtin/logical/kubernetes/integrationtest/vault/testBindings.yaml` file testBindings.yaml (third_party/openbao/internal/builtin/logical/kubernetes/integrationtest/vault/testBindings.yaml)
- `file:third_party/openbao/internal/builtin/logical/kubernetes/integrationtest/vault/testRoles.yaml` file testRoles.yaml (third_party/openbao/internal/builtin/logical/kubernetes/integrationtest/vault/testRoles.yaml)
- `file:third_party/openbao/internal/builtin/logical/kubernetes/integrationtest/vault/testServiceAccounts.yaml` file testServiceAccounts.yaml (third_party/openbao/internal/builtin/logical/kubernetes/integrationtest/vault/testServiceAccounts.yaml)
<!-- SPECD_MANAGED_END -->
