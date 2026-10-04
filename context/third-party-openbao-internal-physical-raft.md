# Context: third-party-openbao-internal-physical-raft

Repository: `deno-kcp`

_(empty: write what this context is for)_

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/physical/raft/bolt_32bit_test.go` file bolt_32bit_test.go (third_party/openbao/internal/physical/raft/bolt_32bit_test.go)
- `file:third_party/openbao/internal/physical/raft/bolt_64bit_test.go` file bolt_64bit_test.go (third_party/openbao/internal/physical/raft/bolt_64bit_test.go)
- `file:third_party/openbao/internal/physical/raft/bolt_linux.go` file bolt_linux.go (third_party/openbao/internal/physical/raft/bolt_linux.go)
- `file:third_party/openbao/internal/physical/raft/chunking_test.go` file chunking_test.go (third_party/openbao/internal/physical/raft/chunking_test.go)
- `file:third_party/openbao/internal/physical/raft/fsm.go` file fsm.go (third_party/openbao/internal/physical/raft/fsm.go)
- `file:third_party/openbao/internal/physical/raft/fsm_test.go` file fsm_test.go (third_party/openbao/internal/physical/raft/fsm_test.go)
- `file:third_party/openbao/internal/physical/raft/io.go` file io.go (third_party/openbao/internal/physical/raft/io.go)
- `file:third_party/openbao/internal/physical/raft/raft.go` file raft.go (third_party/openbao/internal/physical/raft/raft.go)
- `file:third_party/openbao/internal/physical/raft/raft_autopilot.go` file raft_autopilot.go (third_party/openbao/internal/physical/raft/raft_autopilot.go)
- `file:third_party/openbao/internal/physical/raft/raft_autopilot_delegate.go` file raft_autopilot_delegate.go (third_party/openbao/internal/physical/raft/raft_autopilot_delegate.go)
- `file:third_party/openbao/internal/physical/raft/raft_autopilot_promoter.go` file raft_autopilot_promoter.go (third_party/openbao/internal/physical/raft/raft_autopilot_promoter.go)
- `file:third_party/openbao/internal/physical/raft/raft_test.go` file raft_test.go (third_party/openbao/internal/physical/raft/raft_test.go)
- `file:third_party/openbao/internal/physical/raft/snapshot.go` file snapshot.go (third_party/openbao/internal/physical/raft/snapshot.go)
- `file:third_party/openbao/internal/physical/raft/snapshot_test.go` file snapshot_test.go (third_party/openbao/internal/physical/raft/snapshot_test.go)
- `file:third_party/openbao/internal/physical/raft/streamlayer.go` file streamlayer.go (third_party/openbao/internal/physical/raft/streamlayer.go)
- `file:third_party/openbao/internal/physical/raft/streamlayer_test.go` file streamlayer_test.go (third_party/openbao/internal/physical/raft/streamlayer_test.go)
- `file:third_party/openbao/internal/physical/raft/testing.go` file testing.go (third_party/openbao/internal/physical/raft/testing.go)
- `file:third_party/openbao/internal/physical/raft/transaction.go` file transaction.go (third_party/openbao/internal/physical/raft/transaction.go)
- `file:third_party/openbao/internal/physical/raft/types.pb.go` file types.pb.go (third_party/openbao/internal/physical/raft/types.pb.go)
- `file:third_party/openbao/internal/physical/raft/varint.go` file varint.go (third_party/openbao/internal/physical/raft/varint.go)
- `file:third_party/openbao/internal/physical/raft/vars_32bit.go` file vars_32bit.go (third_party/openbao/internal/physical/raft/vars_32bit.go)
- `file:third_party/openbao/internal/physical/raft/vars_64bit.go` file vars_64bit.go (third_party/openbao/internal/physical/raft/vars_64bit.go)
- `function:164254f53f6206af52081a87057102d0` function GenerateTLSKey (third_party/openbao/internal/physical/raft/streamlayer.go)
- `function:2cd9a57baaf8aedaee77c5bc67fc4945` function NewFollowerStates (third_party/openbao/internal/physical/raft/raft_autopilot.go)
- `function:302f03fe6eba9fdd09b0d778708fde9e` function NewDelimitedWriter (third_party/openbao/internal/physical/raft/varint.go)
- `function:8fdfaadeea389ad8827123ca0667edc3` function NewDelimitedReader (third_party/openbao/internal/physical/raft/varint.go)
- `function:a06354a7695369b1a926f53aab9fe332` function NewReadableDuration (third_party/openbao/internal/physical/raft/raft_autopilot.go)
- `function:ae2373b5ef07fdd39d70442cdaa90a8e` function EnsurePath (third_party/openbao/internal/physical/raft/raft.go)
- `function:c6424ba6d32d1bd5208bbea0be76ddfe` function NewDelegate (third_party/openbao/internal/physical/raft/raft_autopilot_delegate.go)
- `function:d69e06476c768295cc387a93f789e216` function NewFSM (third_party/openbao/internal/physical/raft/fsm.go)
- `function:da25f1ac82ba779c3c3b51e39206e270` function FsmTxnCommitIndexTracker (third_party/openbao/internal/physical/raft/transaction.go)
- `function:dec9a24a5c6d850e18447c418e3abf2e` function NewRaftBackend (third_party/openbao/internal/physical/raft/raft.go)
- `function:e3649e8b97f223cfefaa33d8a328b984` function GetRaft (third_party/openbao/internal/physical/raft/testing.go)
- `function:ed1cf6052c55d355366f380f37439e96` function NewRaftLayer (third_party/openbao/internal/physical/raft/streamlayer.go)
- `function:f35ab37dc164304f4a4160d45cbb7273` function NewBoltSnapshotStore (third_party/openbao/internal/physical/raft/snapshot.go)
- `interface:4c2a2d2e7f0f18a6379132013517f2ed` interface Reader (third_party/openbao/internal/physical/raft/io.go)
- `interface:7cbdf475fea12d50cc27d3386b4797af` interface ReadCloser (third_party/openbao/internal/physical/raft/io.go)
- `interface:7ef4422a3095549ca3890f0edcc99545` interface WriteCloser (third_party/openbao/internal/physical/raft/io.go)
- `interface:f66038b895eec635126052fb47dd45ff` interface Writer (third_party/openbao/internal/physical/raft/io.go)
- `method:0002f1d54b03ac4234113e648b356325` method FSMChunkStorage.GetChunks (third_party/openbao/internal/physical/raft/fsm.go)
- `method:00a5be77460d0431dcdd0ff602bfd228` method Server.GetSuffrage (third_party/openbao/internal/physical/raft/types.pb.go)
- `method:020fe98423802f3f0cf39b10e1c45b2f` method sealer.Seal (third_party/openbao/internal/physical/raft/raft.go)
- `method:03beaf8812066949e52cabbdf332126d` method RaftBackend.FailGetInTxn (third_party/openbao/internal/physical/raft/raft.go)

_226 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
