# Context: internal-denojob

Repository: `deno-kcp`

This context exists to fix the contract of the DenoJob decider: the inputs it reads (Observed plus Options) and the plan it emits (Result), separate from any Kubernetes client work. It is the place where job semantics — run creation, parallelism, completion counts, backoff and retries, suspension, deadlines, TTL deletion — are decided as a pure function so the provider can apply the result, and so the behaviour is testable by handing Reconcile an Observed and checking the Result. The tests in denojob_test.go are the executable statement of that contract.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:internal/denojob/denojob.go` file denojob.go (internal/denojob/denojob.go)
- `file:internal/denojob/denojob_test.go` file denojob_test.go (internal/denojob/denojob_test.go)
- `function:0d2947cb5cecdc22a1eed7036e77229b` function New (internal/denojob/denojob.go)
- `method:609e5eaa8563a6ad1508b812aa5604b4` method Reconciler.Reconcile (internal/denojob/denojob.go)
- `struct:0ba4feb0fbc5bf2cadab0956427bd073` struct Observed (internal/denojob/denojob.go)
- `struct:8a80dd72dde5aa7fad20d4a2a56c0c77` struct Reconciler (internal/denojob/denojob.go)
- `struct:a76d5210541b3f0c4f0346477f21b1c1` struct Result (internal/denojob/denojob.go)
- `struct:d14a57a215b6cff18c212b07ddfe93f7` struct RunObservation (internal/denojob/denojob.go)
- `struct:f9b27eae82ab32e2cb4cf25ca02b0e65` struct Options (internal/denojob/denojob.go)
<!-- SPECD_MANAGED_END -->
