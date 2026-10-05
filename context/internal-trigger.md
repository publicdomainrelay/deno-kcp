# Context: internal-trigger

Repository: `deno-kcp`

This context exists so the RunTrigger resource has one deterministic, side-effect-free decider that the provider layer can drive. Splitting the decision out of the provider keeps the trigger's phase machine testable from plain Observed snapshots and keeps every client call, finalizer removal, and job creation in the caller's hands. Because the decider reads only what it is given and writes only what it returns, the same code runs under unit tests with a fixed clock and under the provider with the real one.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:internal/trigger/trigger.go` file trigger.go (internal/trigger/trigger.go)
- `file:internal/trigger/trigger_test.go` file trigger_test.go (internal/trigger/trigger_test.go)
- `function:f347057cde00720e2ba57c3dd951470c` function New (internal/trigger/trigger.go)
- `method:5926281263a64123a37f6099290debee` method Reconciler.Reconcile (internal/trigger/trigger.go)
- `struct:128da6e45c96bafe5081998013f47ffe` struct RunObservation (internal/trigger/trigger.go)
- `struct:9094b81797efe240a545142966b526c0` struct Reconciler (internal/trigger/trigger.go)
- `struct:a3fbb6626d9d915cb17e70f240a59a55` struct Result (internal/trigger/trigger.go)
- `struct:ce2bb0551ed1ce86badc642077aab120` struct Options (internal/trigger/trigger.go)
- `struct:dc3e99d1633068172953c5024a851849` struct Observed (internal/trigger/trigger.go)
- `type_alias:ea5d49f390b7f0cb47a28a95e8f58b81` type_alias Op (internal/trigger/trigger.go)
<!-- SPECD_MANAGED_END -->
