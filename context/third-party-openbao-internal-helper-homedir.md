# Context: third-party-openbao-internal-helper-homedir

Repository: `deno-kcp`

This context exists so that OpenBao-derived code in this repository has one place to resolve the home directory portably and to turn user-supplied `~`-prefixed configuration paths into absolute ones. It isolates the platform difference in home-directory discovery and the caching of that lookup, and gives callers a single expansion routine that fails loudly instead of silently mishandling `~user` paths.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/helper/homedir/homedir.go` file homedir.go (third_party/openbao/internal/helper/homedir/homedir.go)
- `file:third_party/openbao/internal/helper/homedir/homedir_test.go` file homedir_test.go (third_party/openbao/internal/helper/homedir/homedir_test.go)
- `function:4cb6dd1a877c5fa72a15a67c31238a1e` function Dir (third_party/openbao/internal/helper/homedir/homedir.go)
- `function:c145f28b3a5d3aef304d86cc7e6ad2d5` function Expand (third_party/openbao/internal/helper/homedir/homedir.go)
<!-- SPECD_MANAGED_END -->
