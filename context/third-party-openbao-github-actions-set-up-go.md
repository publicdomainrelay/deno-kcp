# Context: third-party-openbao-github-actions-set-up-go

Repository: `deno-kcp`

This context exists to pin down the contract of the vendored OpenBao workflow helper that sets up Go with a shared module cache, so the surrounding repository can rely on its inputs, outputs, cache key derivation, and cache-miss behavior without re-reading the YAML. It records the deliberate caching decisions encoded in the file: caching is left to this action rather than to actions/setup-go, the cache is cross-OS and lookup-only when no-restore is set, and no partial restore keys are used because GitHub caps repository caches at 10 GB and the same cache budget also holds Go test timing results.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/.github/actions/set-up-go/action.yml` file action.yml (third_party/openbao/.github/actions/set-up-go/action.yml)
<!-- SPECD_MANAGED_END -->
