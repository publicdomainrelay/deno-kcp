# Context: third-party-openbao-internal-command-agentproxyshared-sink-mock

Repository: `deno-kcp`

This context exists to specify a test double for the agent proxy sink abstraction. Callers that must not touch a real destination (file or network) can construct a mock sink through NewSink, hand it to code that expects sink.Sink, drive token writes through the interface, and then read back the last token with Token to assert what was written. It is pure test scaffolding: no persistence, no error paths, no external side effects.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/command/agentproxyshared/sink/mock/mock_sink.go` file mock_sink.go (third_party/openbao/internal/command/agentproxyshared/sink/mock/mock_sink.go)
- `function:11877249d28ac132fb67460ba056fd5c` function NewSink (third_party/openbao/internal/command/agentproxyshared/sink/mock/mock_sink.go)
- `method:38f6c8938385fa7264817dd532303198` method mockSink.WriteToken (third_party/openbao/internal/command/agentproxyshared/sink/mock/mock_sink.go)
- `method:b795e07eb6f6a2517ff57f43e1d5d341` method mockSink.Token (third_party/openbao/internal/command/agentproxyshared/sink/mock/mock_sink.go)
<!-- SPECD_MANAGED_END -->
