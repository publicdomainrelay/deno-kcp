# Context: third-party-openbao-internal-helper-tlsdebug

Repository: `deno-kcp`

This context documents the tlsdebug helper package as vendored under third_party/openbao: it exists so that builds can turn TLS session-key logging on or off without touching call sites, by swapping one file for another behind a build tag. The spec pins the observable contract of both variants, the nil-config guard, the error path when the key log file cannot be opened, and the configuration side effect of setting KeyLogWriter, so a re-vendoring or local patch can be checked against what the code actually does rather than what the release build happens to compile in.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/helper/tlsdebug/dummy_inject.go` file dummy_inject.go (third_party/openbao/internal/helper/tlsdebug/dummy_inject.go)
- `file:third_party/openbao/internal/helper/tlsdebug/inject.go` file inject.go (third_party/openbao/internal/helper/tlsdebug/inject.go)
- `function:6840fc0fc02bdfd7359c69c222489b7b` function Inject (third_party/openbao/internal/helper/tlsdebug/dummy_inject.go)
<!-- SPECD_MANAGED_END -->
