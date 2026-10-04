# Context: third-party-openbao-release

Repository: `deno-kcp`

The context exists so that OpenBao releases can be produced as native Linux packages without hand-written per-format stubs: nfpm reads this one YAML manifest and emits both deb and rpm artifacts. It pins the packaging contract that release automation depends on — package name and metadata, GOARCH/GOOS/VERSION substitution, the install layout and file modes, the config files that must survive upgrades, the maintainer script hooks, and the signing key source — so a change to any of those is a change to what ships to package repositories.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/.release/nfpm.yaml` file nfpm.yaml (third_party/openbao/.release/nfpm.yaml)
<!-- SPECD_MANAGED_END -->
