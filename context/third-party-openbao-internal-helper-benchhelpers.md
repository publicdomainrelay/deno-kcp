# Context: third-party-openbao-internal-helper-benchhelpers

Repository: `deno-kcp`

This context exists so tests written against the standard testing.TB surface, including calls to Parallel, can be handed to interfaces that require testinginterface.T. It bridges the two testing abstractions without rewriting the calling tests, and deliberately neutralizes parallelism at that boundary.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/helper/benchhelpers/benchhelpers.go` file benchhelpers.go (third_party/openbao/internal/helper/benchhelpers/benchhelpers.go)
- `function:a86b6e81dd96cb5082042370da2da224` function TBtoT (third_party/openbao/internal/helper/benchhelpers/benchhelpers.go)
- `method:9a051bcbeb3fa590d0bbc011d3c272ea` method tbWrapper.Parallel (third_party/openbao/internal/helper/benchhelpers/benchhelpers.go)
<!-- SPECD_MANAGED_END -->
