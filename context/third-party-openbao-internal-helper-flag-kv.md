# Context: third-party-openbao-internal-helper-flag-kv

Repository: `deno-kcp`

This context exists so the specification records the key=value flag helper that OpenBao's command layer uses to let users pass repeatable key=value options on the CLI, pinning down exactly how a raw argument is parsed into the map and what happens on malformed input, so that a reimplementation or a port preserves the same parsing contract, the same error string, and the same lazy nil-map allocation.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/helper/flag-kv/flag.go` file flag.go (third_party/openbao/internal/helper/flag-kv/flag.go)
- `file:third_party/openbao/internal/helper/flag-kv/flag_test.go` file flag_test.go (third_party/openbao/internal/helper/flag-kv/flag_test.go)
- `method:892fa5b5c168c53de9e1dd9227f346e5` method Flag.String (third_party/openbao/internal/helper/flag-kv/flag.go)
- `method:a1ac532bfe770bf08649ebb6c002c71f` method Flag.Set (third_party/openbao/internal/helper/flag-kv/flag.go)
- `type_alias:44a5f1a6527223ee7eba67cc11ec2e38` type_alias Flag (third_party/openbao/internal/helper/flag-kv/flag.go)
<!-- SPECD_MANAGED_END -->
