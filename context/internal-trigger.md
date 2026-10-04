# Context: internal-trigger

Repository: `deno-kcp`

This context is the trigger decider, the piece of the deno-kcp control plane that turns a finished policy workflow run into a deno job. It exists so the RunTrigger reconciliation decision is testable and side-effect free: the reconciler decides, and the provider layer acts. When the referenced run succeeds and its outputs match the trigger's match map, the decider asks for a job named <trigger>-<run> and records the run as consumed so the same run never fires twice; cancelled, failed, or unfinished runs leave the trigger pending or skipped. Deletion is handled by asking for finalizer removal.

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
