# Context: internal-policyengine

Repository: `deno-kcp`

This context exists to keep PolicyEngine lifecycle policy separate from the machinery that carries it out. The provider observes runs and probes, fills in an Observed value, and hands it to the policyengine Reconciler; the Reconciler answers with a Result describing the engine's phase, any requeue delay, the run ID, and the ops to apply. Because the decider touches no cluster state directly, engine behaviour such as default restart, Never restart, and liveness-driven restart can be exercised in unit tests against plain structs instead of a live API server, and the same shape is shared with the sibling denopod, denorun, denojob and trigger deciders.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:internal/policyengine/policyengine.go` file policyengine.go (internal/policyengine/policyengine.go)
- `file:internal/policyengine/policyengine_test.go` file policyengine_test.go (internal/policyengine/policyengine_test.go)
- `function:26e6969406488bfc97e9ed77febe4974` function New (internal/policyengine/policyengine.go)
- `method:cf15bd5457ef89fffc8abf3947dbb830` method Reconciler.Reconcile (internal/policyengine/policyengine.go)
- `struct:2c2a9e18bb5ac0b6ffbbc8977980dbed` struct Reconciler (internal/policyengine/policyengine.go)
- `struct:51a6de2d483d5be40201c7de454f6cd7` struct ExecutionObservation (internal/policyengine/policyengine.go)
- `struct:7b1226e6c85673295723299601dd8674` struct Observed (internal/policyengine/policyengine.go)
- `struct:bea3d6cd026242f0ba9701845a99d9ef` struct Result (internal/policyengine/policyengine.go)
- `struct:c5868ebca402d6036b8a7d908bf1a8ba` struct Options (internal/policyengine/policyengine.go)
- `type_alias:43971b7fe73a576e55a3463fe8f33daf` type_alias Op (internal/policyengine/policyengine.go)
- `type_alias:c2475e9a59e50fceb012111299966c7a` type_alias ExecutionState (internal/policyengine/policyengine.go)
<!-- SPECD_MANAGED_END -->
