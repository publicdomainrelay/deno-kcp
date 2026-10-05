# Context: internal-policyworkflowpod

Repository: `deno-kcp`

This context exists so the PolicyWorkflowPod decider can be reasoned about and tested on its own, apart from the provider's client, watches and status writes. The decider encodes two rules the rest of the runtime depends on: a pod is Ready only when the policy engine it references has a reachable endpoint, and it is Pending with reason EngineNotReady until then; and the concurrency and TTL knobs on the pod spec are resolved here so the provider, the admission queue and the workflow-run reconciler all agree on one answer. Because Observed carries EngineReady, EngineEndpoint, Active and Now as plain values, the reconcile path is deterministic and needs no fake clients.

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
