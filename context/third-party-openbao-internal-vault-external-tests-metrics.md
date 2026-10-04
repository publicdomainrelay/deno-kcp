# Context: third-party-openbao-internal-vault-external-tests-metrics

Repository: `deno-kcp`

The context exists to pin down the externally observable behaviour of OpenBao's core metrics endpoint as seen from outside the vault package: which mount-table gauges appear, what their labels and values are, how they move when a new mount is added, and that leader and unseal gauges follow a leadership change. It is a black-box acceptance layer that talks to a real two-core cluster over the HTTP API rather than to internal metric registries, so it guards the metric names, label names and endpoint shape that operators and monitoring depend on.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/metrics/core_metrics_int_test.go` file core_metrics_int_test.go (third_party/openbao/internal/vault/external_tests/metrics/core_metrics_int_test.go)
<!-- SPECD_MANAGED_END -->
