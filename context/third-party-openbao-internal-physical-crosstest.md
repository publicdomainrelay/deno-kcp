# Context: third-party-openbao-internal-physical-crosstest

Repository: `deno-kcp`

This context exists so that every physical storage backend OpenBao ships can be held to one shared behavioral contract instead of being trusted individually. The layered comment at the top of the file states the intent explicitly: the storage stack composes a low-level backend, a cache, an encoding validation layer, barrier encryption, storage views and barrier views, and differences between these layers — or between backends under the same layer — produce subtle correctness bugs. The cross-test framework therefore instantiates the same backend types and the same cache/encoding/transaction compositions, drives identical read/write/list/transaction sequences at all of them, and fails when their observable results diverge, so that composition and stacking can be changed with confidence.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/physical/crosstest/cross_test.go` file cross_test.go (third_party/openbao/internal/physical/crosstest/cross_test.go)
<!-- SPECD_MANAGED_END -->
