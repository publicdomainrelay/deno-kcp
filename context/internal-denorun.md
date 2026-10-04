# Context: internal-denorun

Repository: `deno-kcp`

This context exists to hold the reconciliation logic for a single DenoRun as an isolated, side-effect-free decider. The provider observes the cluster and the workload, builds an Observed value, and asks the Reconciler what the next state should be; the Reconciler never talks to the API server itself. That split lets the run lifecycle rules, retry and backoff handling, deadline enforcement, TTL cleanup, and finalizer removal be tested as plain data-in data-out cases while the provider keeps the write path and the guards against stale cached objects.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:internal/denorun/denorun.go` file denorun.go (internal/denorun/denorun.go)
- `file:internal/denorun/denorun_test.go` file denorun_test.go (internal/denorun/denorun_test.go)
- `function:ebb0b90e032475ce8ac596f8c699f18d` function New (internal/denorun/denorun.go)
- `method:f155b5d02f0b9e87bf309fef18faa708` method Reconciler.Reconcile (internal/denorun/denorun.go)
- `struct:46375556082738a3e31036edf9eb66d4` struct Observed (internal/denorun/denorun.go)
- `struct:729b6f20e41c65ca009aeef5ce0be147` struct Result (internal/denorun/denorun.go)
- `struct:871d7b88332e893f59d62b5249a55bca` struct RunObservation (internal/denorun/denorun.go)
- `struct:8cfd6dfc94f9f9f64a46b94dc7cac4c6` struct Reconciler (internal/denorun/denorun.go)
- `struct:ee4d89fa2c7dd0cff8185caf5882f1e5` struct Options (internal/denorun/denorun.go)
- `type_alias:30190d31491ebfeaec53888338d8ddf7` type_alias Op (internal/denorun/denorun.go)
- `type_alias:bd23d69ec74e9fe3e50fcdbd3c0331ba` type_alias RunState (internal/denorun/denorun.go)
<!-- SPECD_MANAGED_END -->
