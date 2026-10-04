# Context: third-party-openbao-internal-command-agentproxyshared-sink-inmem

Repository: `deno-kcp`

This context exists to describe the in-memory implementation of the agent proxy sink interface, the alternative to the file sink for deployments that must not persist a token to disk. It matters because WriteToken is the hook that both retains the token in process memory and pushes it into the lease cache so cached leases are invalidated and re-authenticated when the token rotates, while Token is the read path other agent components use to fetch the current credential.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/command/agentproxyshared/sink/inmem/inmem_sink.go` file inmem_sink.go (third_party/openbao/internal/command/agentproxyshared/sink/inmem/inmem_sink.go)
- `function:b01b1fa25047842ed99f8dda474fa46b` function New (third_party/openbao/internal/command/agentproxyshared/sink/inmem/inmem_sink.go)
- `method:53c83733cd1819b3ce234033f1bb0527` method inmemSink.WriteToken (third_party/openbao/internal/command/agentproxyshared/sink/inmem/inmem_sink.go)
- `method:559cadf1bde829922d9e7a655c71ce22` method inmemSink.Token (third_party/openbao/internal/command/agentproxyshared/sink/inmem/inmem_sink.go)
<!-- SPECD_MANAGED_END -->
