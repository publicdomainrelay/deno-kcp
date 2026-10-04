# Context: internal-livegate

Repository: `deno-kcp`

This context exists so that live, environment-dependent tests share one consistent skip-or-fail policy instead of each test inventing its own. A live test needs to behave two ways: on an ordinary developer or unit-test run it must skip quietly, because the real kcp, kine, kubectl and deno binaries are not present; in a dedicated live CI run it must fail loudly, because a skipped live test there would look like success while nothing was verified. RequiresLive names the single switch, DENO_KCP_REQUIRE_LIVE=1, that separates the two modes, and Require turns that boolean into the right testing.T outcome. Short adds the standard Go short-mode convention on top, so `go test -short` counts as a reason to skip unless live is explicitly required. Keeping the policy in one three-function package means the decision is auditable in one place and every caller cannot drift.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:internal/livegate/livegate.go` file livegate.go (internal/livegate/livegate.go)
- `function:0e31bdc8610f1db91dd40606eac8d2a2` function RequiresLive (internal/livegate/livegate.go)
- `function:105aa5910047c1743f2bbed1f73895c8` function Short (internal/livegate/livegate.go)
- `function:cc9c12855dee252d71eac5766360e2f9` function Require (internal/livegate/livegate.go)
<!-- SPECD_MANAGED_END -->
