# Context: third-party-openbao-internal-builtin-credential-kubernetes-integrationtest-vault

Repository: `deno-kcp`

This context exists to hold the Kubernetes RBAC fixture manifests that the openbao kubernetes credential backend integration test applies before running. The test needs a ServiceAccount that the Vault server can use to review other pods' tokens, and it needs namespace-listing permission for both that reviewer account and the vault account so the test scenarios can enumerate namespaces during the auth flow. Keeping these as standalone YAML files under integrationtest/vault lets the test harness apply them verbatim to a throwaway cluster, isolating the test from any pre-existing RBAC state.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/credential/kubernetes/integrationtest/vault/namespaceControllerBinding.yaml` file namespaceControllerBinding.yaml (third_party/openbao/internal/builtin/credential/kubernetes/integrationtest/vault/namespaceControllerBinding.yaml)
- `file:third_party/openbao/internal/builtin/credential/kubernetes/integrationtest/vault/tokenReviewerBinding.yaml` file tokenReviewerBinding.yaml (third_party/openbao/internal/builtin/credential/kubernetes/integrationtest/vault/tokenReviewerBinding.yaml)
- `file:third_party/openbao/internal/builtin/credential/kubernetes/integrationtest/vault/tokenReviewerServiceAccount.yaml` file tokenReviewerServiceAccount.yaml (third_party/openbao/internal/builtin/credential/kubernetes/integrationtest/vault/tokenReviewerServiceAccount.yaml)
<!-- SPECD_MANAGED_END -->
