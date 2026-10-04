# Context: third-party-openbao-sdk-helper-pathmanager

Repository: `deno-kcp`

The context exists to pin down the vendored pathmanager helper that deno-kcp inherits from the OpenBao SDK, so the prefix-set semantics (exception markers, trailing-star trimming, trailing-slash preservation, tree transactions) are stated as testable requirements rather than left implicit in a git sub-tree. It describes the code as it stands so later changes to the vendored copy can be checked against the behaviour the rest of the tree relies on.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/helper/pathmanager/pathmanager.go` file pathmanager.go (third_party/openbao/sdk/helper/pathmanager/pathmanager.go)
- `file:third_party/openbao/sdk/helper/pathmanager/pathmanager_test.go` file pathmanager_test.go (third_party/openbao/sdk/helper/pathmanager/pathmanager_test.go)
- `function:bb4b12e4d3e2911eee29db3c3c829185` function New (third_party/openbao/sdk/helper/pathmanager/pathmanager.go)
- `method:006f3d8b478c3c041905a76f7f1c23f6` method PathManager.Len (third_party/openbao/sdk/helper/pathmanager/pathmanager.go)
- `method:01de81b22d3091316959db92908a490b` method PathManager.HasPath (third_party/openbao/sdk/helper/pathmanager/pathmanager.go)
- `method:24b62e201eaa469b519cc090681b150d` method PathManager.RemovePathPrefix (third_party/openbao/sdk/helper/pathmanager/pathmanager.go)
- `method:2b8f9fe6f4ca40a55bdf750e790af9cb` method PathManager.Paths (third_party/openbao/sdk/helper/pathmanager/pathmanager.go)
- `method:710fff05c83c4dc5f779e84165610d81` method PathManager.HasPathSegments (third_party/openbao/sdk/helper/pathmanager/pathmanager.go)
- `method:9bd5291e12236e85703daf063c32b4b1` method PathManager.HasExactPath (third_party/openbao/sdk/helper/pathmanager/pathmanager.go)
- `method:c195b095041ba7f36698d9317f118f94` method PathManager.RemovePaths (third_party/openbao/sdk/helper/pathmanager/pathmanager.go)
- `method:d2684f578b8fac5756f29fe2bc4c6bfd` method PathManager.AddPaths (third_party/openbao/sdk/helper/pathmanager/pathmanager.go)
- `struct:bb16fff8e7fb7187acea6600aa0f635d` struct PathManager (third_party/openbao/sdk/helper/pathmanager/pathmanager.go)
<!-- SPECD_MANAGED_END -->
