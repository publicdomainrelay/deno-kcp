# Context: third-party-openbao-internal-command-agentproxyshared-sink-file

Repository: `deno-kcp`

The context exists so the file sink's construction contract and write behaviour are described in one place: what configuration keys NewFileSink accepts, what validation it performs, how WriteToken writes through a temporary file and renames it atomically, and how the tests drive both. It also records that the sink is reached through the sink.Sink interface, so a change to either the config keys or the temporary-file protocol must keep the interface contract intact.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/command/agentproxyshared/sink/file/file_sink.go` file file_sink.go (third_party/openbao/internal/command/agentproxyshared/sink/file/file_sink.go)
- `file:third_party/openbao/internal/command/agentproxyshared/sink/file/file_sink_test.go` file file_sink_test.go (third_party/openbao/internal/command/agentproxyshared/sink/file/file_sink_test.go)
- `file:third_party/openbao/internal/command/agentproxyshared/sink/file/sink_test.go` file sink_test.go (third_party/openbao/internal/command/agentproxyshared/sink/file/sink_test.go)
- `function:1980f527e25c15d42d5fd3f44e98ead1` function NewFileSink (third_party/openbao/internal/command/agentproxyshared/sink/file/file_sink.go)
- `method:ad5cef131aceee3b60dbe1ec0fbcda62` method fileSink.WriteToken (third_party/openbao/internal/command/agentproxyshared/sink/file/file_sink.go)
<!-- SPECD_MANAGED_END -->
