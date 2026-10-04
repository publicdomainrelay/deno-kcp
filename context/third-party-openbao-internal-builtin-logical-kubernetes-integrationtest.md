# Context: third-party-openbao-internal-builtin-logical-kubernetes-integrationtest

Repository: `deno-kcp`

The context exists so the Kubernetes secrets engine can be tested end to end against a live cluster instead of in isolation: it configures the backend, writes roles, requests credentials, then reads the resulting Kubernetes objects back through the real API to confirm labels, annotations, RBAC rules, bindings, TTLs and audiences are what the role asked for. It also pins the failure path — a service account JWT with no create permission must make the creds call fail, and the partially created Role and RoleBinding must be rolled back by the WAL after its minimum age. The environment contract (kubectl version, cluster namespace, CA, host, super and broken JWTs) is established once in `TestMain` so every test shares it.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/logical/kubernetes/integrationtest/creds_integration_test.go` file creds_integration_test.go (third_party/openbao/internal/builtin/logical/kubernetes/integrationtest/creds_integration_test.go)
- `file:third_party/openbao/internal/builtin/logical/kubernetes/integrationtest/helpers.go` file helpers.go (third_party/openbao/internal/builtin/logical/kubernetes/integrationtest/helpers.go)
- `file:third_party/openbao/internal/builtin/logical/kubernetes/integrationtest/integration_test.go` file integration_test.go (third_party/openbao/internal/builtin/logical/kubernetes/integrationtest/integration_test.go)
- `file:third_party/openbao/internal/builtin/logical/kubernetes/integrationtest/wal_rollback_test.go` file wal_rollback_test.go (third_party/openbao/internal/builtin/logical/kubernetes/integrationtest/wal_rollback_test.go)
<!-- SPECD_MANAGED_END -->
