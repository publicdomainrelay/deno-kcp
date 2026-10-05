# Context: internal-livegate

Repository: `deno-kcp`

This context exists to hold the gate that decides whether a test requiring live infrastructure runs, fails or skips, so that ordinary runs stay green without the kcp, kine, kubectl and deno toolchain while a live-required run (DENO_KCP_REQUIRE_LIVE=1) cannot silently skip the live tests. It keeps that decision in one small exported surface, RequiresLive for callers that gate early, Require for callers that want fail-or-skip behavior, and Short for callers that additionally want the test to skip under go test -short.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:internal/livegate/livegate.go` file livegate.go (internal/livegate/livegate.go)
- `function:0e31bdc8610f1db91dd40606eac8d2a2` function RequiresLive (internal/livegate/livegate.go)
- `function:105aa5910047c1743f2bbed1f73895c8` function Short (internal/livegate/livegate.go)
- `function:cc9c12855dee252d71eac5766360e2f9` function Require (internal/livegate/livegate.go)
<!-- SPECD_MANAGED_END -->
