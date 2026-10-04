# Context: third-party-openbao-internal-vault-external-tests-pprof-pprof-binary

Repository: `deno-kcp`

This context exists to verify that the sys/pprof endpoints behave the same way on a real OpenBao server process as they do on the fake test cluster used by the sibling pprof package. The two tests are deliberately thin: they only build the exec dev cluster, wire the binary path and listen address, and hand the cluster to the shared pprof test bodies, because the mechanism under test is the exec-based cluster, not the pprof assertions themselves. The BAO_BINARY gate keeps the suite from failing on machines without a built server binary.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/pprof/pprof_binary/pprof_test.go` file pprof_test.go (third_party/openbao/internal/vault/external_tests/pprof/pprof_binary/pprof_test.go)
<!-- SPECD_MANAGED_END -->
