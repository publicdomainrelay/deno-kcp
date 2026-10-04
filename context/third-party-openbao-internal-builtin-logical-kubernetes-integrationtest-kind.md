# Context: third-party-openbao-internal-builtin-logical-kubernetes-integrationtest-kind

Repository: `deno-kcp`

The context exists so the Kubernetes backend integration tests can stand up a real cluster whose API server is reachable from the test process at a fixed loopback address. The host-port mapping is the contract: tests expect something listening on host 127.0.0.1:38300 to be forwarded to the cluster's container port 8200, which is where the OpenBao server under test is addressed. Keeping the mapping in a checked-in YAML file makes the cluster topology reproducible across machines instead of relying on manual kind flags.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/logical/kubernetes/integrationtest/kind/config.yaml` file config.yaml (third_party/openbao/internal/builtin/logical/kubernetes/integrationtest/kind/config.yaml)
<!-- SPECD_MANAGED_END -->
