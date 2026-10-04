# Context: third-party-openbao-internal-command-agentproxyshared-sink

Repository: `deno-kcp`

This context exists to specify the agent's sink subsystem: the abstraction over anywhere an auth token can be delivered, the per-sink configuration and key material that transforms a token on the way out, and the server loop that fans one freshly received token out to every configured sink with retry and shutdown semantics. It is the contract that concrete sinks — file, in-memory, mock and similar — implement, and the contract the agent cache and proxy layers call into when a token changes. The spec pins down the exported surface (Sink, SinkReader, SinkConfig, SinkServerConfig, SinkServer, NewSinkServer, SinkServer.Run) and the invariants the run loop must keep, so implementations and callers can be checked against the code that is actually present.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/command/agentproxyshared/sink/sink.go` file sink.go (third_party/openbao/internal/command/agentproxyshared/sink/sink.go)
- `function:2f41b009a7ffd88a0049dfd048945027` function NewSinkServer (third_party/openbao/internal/command/agentproxyshared/sink/sink.go)
- `interface:0cd1f681043f9d746f5097add6157e65` interface SinkReader (third_party/openbao/internal/command/agentproxyshared/sink/sink.go)
- `interface:69a57c3657369fde08e7d237a02f64b7` interface Sink (third_party/openbao/internal/command/agentproxyshared/sink/sink.go)
- `method:55bc74ab20086a4a1747d7325eebdf07` method SinkReader.Token (third_party/openbao/internal/command/agentproxyshared/sink/sink.go)
- `method:63fd61f4db5ab68916313ad158ac8c58` method Sink.WriteToken (third_party/openbao/internal/command/agentproxyshared/sink/sink.go)
- `method:a588aa6c95d117ad20bf34755c761423` method SinkServer.Run (third_party/openbao/internal/command/agentproxyshared/sink/sink.go)
- `struct:79c67763e1eb080619b9463cd322fbe4` struct SinkServerConfig (third_party/openbao/internal/command/agentproxyshared/sink/sink.go)
- `struct:cf40f598989975787152ae0484c4fc75` struct SinkServer (third_party/openbao/internal/command/agentproxyshared/sink/sink.go)
- `struct:ff6363c0efe5a7c163853d933a2f2fca` struct SinkConfig (third_party/openbao/internal/command/agentproxyshared/sink/sink.go)
<!-- SPECD_MANAGED_END -->
