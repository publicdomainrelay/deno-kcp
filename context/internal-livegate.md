# Context: internal-livegate

Repository: `deno-kcp`

This context exists so that live, environment-dependent tests share one consistent skip-or-fail policy instead of each test inventing its own. A live test needs to behave two ways: on an ordinary developer or unit-test run it must skip quietly, because the real kcp, kine, kubectl and deno binaries are not present; in a dedicated live CI run it must fail loudly, because a skipped live test there would look like success while nothing was verified. RequiresLive names the single switch, DENO_KCP_REQUIRE_LIVE=1, that separates the two modes, and Require turns that boolean into the right testing.T outcome. Short adds the standard Go short-mode convention on top, so `go test -short` counts as a reason to skip unless live is explicitly required. Keeping the policy in one three-function package means the decision is auditable in one place and every caller cannot drift.

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
interfaces:
- file: internal/livegate/livegate.go
  kind: function
  name: Require
  signature: func Require(t *testing.T, format string, args ...any)
- file: internal/livegate/livegate.go
  kind: function
  name: RequiresLive
  signature: func RequiresLive() bool
- file: internal/livegate/livegate.go
  kind: function
  name: Short
  signature: func Short(t *testing.T, format string, args ...any)
requirements:
- codeRefs:
  - file:internal/livegate/livegate.go
  - function:105aa5910047c1743f2bbed1f73895c8
  - function:cc9c12855dee252d71eac5766360e2f9
  id: r.helpers-attribute-caller
  level: MUST
  text: Require and Short MUST call t.Helper() first so failure and skip reports attribute
    the caller's line, not the gate's.
- codeRefs:
  - file:internal/livegate/livegate.go
  - function:0e31bdc8610f1db91dd40606eac8d2a2
  id: r.live-flag-from-env
  level: MUST
  text: RequiresLive MUST report true if and only if the environment variable DENO_KCP_REQUIRE_LIVE
    equals the string "1".
- codeRefs:
  - file:internal/livegate/livegate.go
  - function:0e31bdc8610f1db91dd40606eac8d2a2
  - function:cc9c12855dee252d71eac5766360e2f9
  id: r.require-fails-when-live-required
  level: MUST
  text: Require MUST call t.Fatalf with the caller's format and args when RequiresLive
    reports true, so a live test fails loudly instead of skipping in a live-required
    run.
- codeRefs:
  - file:internal/livegate/livegate.go
  - function:cc9c12855dee252d71eac5766360e2f9
  id: r.require-skips-otherwise
  level: MUST
  text: Require MUST call t.Skipf with the caller's format and args when RequiresLive
    reports false, so a live test skips quietly on ordinary runs.
- codeRefs:
  - file:internal/livegate/livegate.go
  - function:105aa5910047c1743f2bbed1f73895c8
  - function:cc9c12855dee252d71eac5766360e2f9
  id: r.short-delegates-to-require
  level: MUST
  text: Short MUST call Require with the same format and args exactly when testing.Short()
    is true, and MUST do nothing when short mode is off.
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

_None yet._
<!-- SPECD_MANAGED_END -->
