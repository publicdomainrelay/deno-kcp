# Context: third-party-openbao-sdk-queue

Repository: `deno-kcp`

This context exists to record the vendored OpenBao SDK priority queue that this repository carries under third_party, so that its contract, its exported surface and its locking and copy semantics are described from the code as it stands rather than inferred. It matters because the package is third-party code retained verbatim except for the queue import path, and anything that consumes it needs to know that ordering is lowest-int64-wins, that keys are unique and immutable once pushed, that pushes clone their input, and that every public operation is mutex-guarded.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/queue/priority_queue.go` file priority_queue.go (third_party/openbao/sdk/queue/priority_queue.go)
- `file:third_party/openbao/sdk/queue/priority_queue_test.go` file priority_queue_test.go (third_party/openbao/sdk/queue/priority_queue_test.go)
- `function:8c560b7d1b2182d690d8e2257c10f53c` function New (third_party/openbao/sdk/queue/priority_queue.go)
- `method:1e21ef9ecdbf74b7d1e82434a43b4fdc` method PriorityQueue.Push (third_party/openbao/sdk/queue/priority_queue.go)
- `method:27eeaabf9bcda277d96139bcd9789878` method queue.Less (third_party/openbao/sdk/queue/priority_queue.go)
- `method:329614106bb685f4fd551d53358daa97` method PriorityQueue.Pop (third_party/openbao/sdk/queue/priority_queue.go)
- `method:34a9d798013468550f8b53ff68d3cd8d` method queue.Swap (third_party/openbao/sdk/queue/priority_queue.go)
- `method:63fa393a0e2e4d628f37acdd4f732467` method queue.Push (third_party/openbao/sdk/queue/priority_queue.go)
- `method:6d4de202ef0f1f820ef44d730d9197f6` method queue.Pop (third_party/openbao/sdk/queue/priority_queue.go)
- `method:9d3108c5979daba6563ca673841d8f9b` method queue.Len (third_party/openbao/sdk/queue/priority_queue.go)
- `method:e1751c7c2e16c44f7f95a526c610a29c` method PriorityQueue.PopByKey (third_party/openbao/sdk/queue/priority_queue.go)
- `method:f985a2dedd426f7289a840dbcd24e30c` method PriorityQueue.Len (third_party/openbao/sdk/queue/priority_queue.go)
- `struct:54b043abf4de82c270fabef9612f374a` struct Item (third_party/openbao/sdk/queue/priority_queue.go)
- `struct:d57b802de9250e42431273c1d2a8d46b` struct PriorityQueue (third_party/openbao/sdk/queue/priority_queue.go)
<!-- SPECD_MANAGED_END -->
