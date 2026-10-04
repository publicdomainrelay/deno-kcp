# Context: third-party-openbao-internal-helper-versions

Repository: `deno-kcp`

The context exists so that the builtin-version helpers used across OpenBao can be described and depended on without reading the source: one function that names the version every builtin plugin reports, and one predicate that recognises that version from a semver metadata marker. It pins the exact semantics of the marker test (dot-split metadata, exact identifier match, never a substring match, non-semver input is not builtin) so callers that classify plugin versions keep consistent behavior.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/helper/versions/version.go` file version.go (third_party/openbao/internal/helper/versions/version.go)
- `file:third_party/openbao/internal/helper/versions/version_test.go` file version_test.go (third_party/openbao/internal/helper/versions/version_test.go)
- `function:1ea364583023f055fbce35602b2f3f9d` function GetBuiltinVersion (third_party/openbao/internal/helper/versions/version.go)
- `function:f639e0b5f55bb30e45c28d43ebe2f8d6` function IsBuiltinVersion (third_party/openbao/internal/helper/versions/version.go)
<!-- SPECD_MANAGED_END -->
