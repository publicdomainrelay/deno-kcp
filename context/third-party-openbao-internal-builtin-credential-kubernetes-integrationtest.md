# Context: third-party-openbao-internal-builtin-credential-kubernetes-integrationtest

Repository: `deno-kcp`

This context exists to verify, end to end against a real Kubernetes cluster, that the OpenBao Kubernetes credential backend authenticates projected service-account JWTs correctly and rejects the cases it should. It is an opt-in integration harness rather than library code, requiring INTEGRATION_TESTS to be set plus a cluster with a test namespace, a deployed Vault/OpenBao reachable via port forward, and a test-token-reviewer-account service account with TokenReview access. Its reason to exist is to exercise the login path and the boundary behaviors — token reviewer configuration, namespace label selectors, unauthorized service accounts, and audience binding — that unit tests cannot reproduce without a live API server.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/credential/kubernetes/integrationtest/integration_test.go` file integration_test.go (third_party/openbao/internal/builtin/credential/kubernetes/integrationtest/integration_test.go)
<!-- SPECD_MANAGED_END -->
