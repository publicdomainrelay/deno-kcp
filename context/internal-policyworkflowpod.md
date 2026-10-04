# Context: internal-policyworkflowpod

Repository: `deno-kcp`

This context exists so the PolicyWorkflowPod decider has a describable contract separate from the provider that calls it. The provider owns the watch loop and status writes; this package owns only the decision, which makes the phase transitions, the condition wording, the requeue cadence and the TTL and concurrency helpers testable without a cluster. Capacity and RunTTL are exported because the admission source in internal/provider and the run reconciler need the same precedence rules the pod decider uses, so the rule lives here once instead of being re-derived at each call site.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:internal/policyworkflowpod/policyworkflowpod.go` file policyworkflowpod.go (internal/policyworkflowpod/policyworkflowpod.go)
- `file:internal/policyworkflowpod/policyworkflowpod_test.go` file policyworkflowpod_test.go (internal/policyworkflowpod/policyworkflowpod_test.go)
- `function:02acf20c6ae76f4247f2782b39f9905d` function New (internal/policyworkflowpod/policyworkflowpod.go)
- `function:bbc6e4753713c4d1d1079ae7e84ed8fa` function Capacity (internal/policyworkflowpod/policyworkflowpod.go)
- `function:d4ae60590520385e8ca42957d1cb728f` function RunTTL (internal/policyworkflowpod/policyworkflowpod.go)
- `method:84d4636db1ea631ee61b88e98f741d27` method Reconciler.Reconcile (internal/policyworkflowpod/policyworkflowpod.go)
- `struct:5aa211d3d5b215af5fa46eca88c2f0c0` struct Reconciler (internal/policyworkflowpod/policyworkflowpod.go)
- `struct:8099607c30978aaddc31c1f6fe9b615e` struct Options (internal/policyworkflowpod/policyworkflowpod.go)
- `struct:842e356a5ebdd4a78ce7849f4fada513` struct Observed (internal/policyworkflowpod/policyworkflowpod.go)
- `struct:8ded0e2d592b1dadd943f5bc7a97eb7f` struct Result (internal/policyworkflowpod/policyworkflowpod.go)
<!-- SPECD_MANAGED_END -->
