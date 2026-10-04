# Context: third-party-openbao-internal-version

Repository: `deno-kcp`

This context exists so the OpenBao binary can name itself. Every component that prints, logs, or transmits a version — the HTTP audit backend's User-Agent, the CLI commands, the sys/health endpoint, service registration, and the seal-status API — calls into this package instead of hardcoding a string. It separates the injected build facts (ldflags variables) from the presentation rules, so a single place decides how a commit, a prerelease tag, vendor metadata, and a commit date combine into a user-visible version string.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/version/cgo.go` file cgo.go (third_party/openbao/internal/version/cgo.go)
- `file:third_party/openbao/internal/version/version.go` file version.go (third_party/openbao/internal/version/version.go)
- `file:third_party/openbao/internal/version/version_base.go` file version_base.go (third_party/openbao/internal/version/version_base.go)
- `function:52fa50d01aba28104d7c44b8b362c0cb` function GetVersion (third_party/openbao/internal/version/version.go)
- `method:02fdf5a0f711c862d7f66d281c7111b7` method VersionInfo.VersionNumber (third_party/openbao/internal/version/version.go)
- `method:2a97cbe3c6dab4e6c39ea81d6a1b2161` method VersionInfo.FullVersionNumber (third_party/openbao/internal/version/version.go)
- `struct:2d3628dae900cade0193015ce3c20557` struct VersionInfo (third_party/openbao/internal/version/version.go)
<!-- SPECD_MANAGED_END -->
