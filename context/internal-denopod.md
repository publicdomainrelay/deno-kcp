# Context: internal-denopod

Repository: `deno-kcp`

This context exists so the DenoPod lifecycle can be specified and tested without a Kubernetes client or a live deno process. Reconcile is the single decision point that turns an observed pod plus its execution observation into a target state, and every branch is covered by internal/denopod/denopod_test.go, which drives the reconciler with table-style Observed values and asserts on the returned Result. The package mirrors the shape of internal/policyengine but adds exit-code and output capture, so the spec records the exact contract other reconcile loops in this repository follow.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:internal/denopod/denopod.go` file denopod.go (internal/denopod/denopod.go)
- `file:internal/denopod/denopod_test.go` file denopod_test.go (internal/denopod/denopod_test.go)
- `function:3f0c5153e0db566485eab480379f957d` function New (internal/denopod/denopod.go)
- `method:73925188636ee222feadc0ef8ca57514` method Reconciler.Reconcile (internal/denopod/denopod.go)
- `struct:0ffa826db7f6371892be099973c54fbd` struct ExecutionObservation (internal/denopod/denopod.go)
- `struct:4c5bf8db95a5eabcdd5969ee40a83886` struct Observed (internal/denopod/denopod.go)
- `struct:5fda3baee56d4ff8e55031565365af74` struct Reconciler (internal/denopod/denopod.go)
- `struct:aff6e789cdee650936e8e9c4badaedd7` struct Result (internal/denopod/denopod.go)
- `struct:e87bab6be297f86edc21719c386c6996` struct Options (internal/denopod/denopod.go)
- `type_alias:26dc5a9867b60f56e7de57f597ef8248` type_alias ExecutionState (internal/denopod/denopod.go)
- `type_alias:a490e5e249e0847d63dd37e654172f27` type_alias Op (internal/denopod/denopod.go)
<!-- SPECD_MANAGED_END -->
