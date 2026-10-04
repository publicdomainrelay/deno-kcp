# Context: third-party-openbao

Repository: `deno-kcp`

This context exists to mark the boundary of the vendored upstream OpenBao tree inside deno-kcp, so that readers and tools do not confuse it with deno-kcp's first-party OpenBao handling in internal/provider. It records that the copies under third_party/openbao are upstream sources carried alongside the repository, together with the two golangci-lint configurations and the publiccode.yml that travel with them, and it records that the tree exposes no interfaces of its own to the deno-kcp module. It is a containment and provenance note rather than a behavioral contract: the renames and edits to make upstream OpenBao usable by deno-kcp happen in the first-party packages, not here.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/.golangci.deprecations.yml` file .golangci.deprecations.yml (third_party/openbao/.golangci.deprecations.yml)
- `file:third_party/openbao/.golangci.yml` file .golangci.yml (third_party/openbao/.golangci.yml)
- `file:third_party/openbao/main.go` file main.go (third_party/openbao/main.go)
- `file:third_party/openbao/publiccode.yml` file publiccode.yml (third_party/openbao/publiccode.yml)
<!-- SPECD_MANAGED_END -->
