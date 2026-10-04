# Context: third-party-openbao-internal-helper-stubbolt

Repository: `deno-kcp`

This context exists so the repository records what the OpenBao third-party stub package guarantees: a compile-time-compatible, runtime-inert stand-in for the bolt and raft-boltdb API surface. It documents the deliberate failures (unimplemented errors) and the one non-failing accessor (Bucket), so callers and tests know the package is for linking and type-checking, not for storage, and so any future replacement or vendoring change is measured against this contract.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/helper/stubbolt/stubbolt.go` file stubbolt.go (third_party/openbao/internal/helper/stubbolt/stubbolt.go)
- `function:08d5377907086dbcefba0d746c9186d4` function Open (third_party/openbao/internal/helper/stubbolt/stubbolt.go)
- `method:40e99d79fb1a193ec0998ad116ed5969` method Tx.Bucket (third_party/openbao/internal/helper/stubbolt/stubbolt.go)
- `method:b0c8b034a5471f84e94df3f04f9e372e` method Bucket.ForEach (third_party/openbao/internal/helper/stubbolt/stubbolt.go)
- `method:d00ab011a65bc2464caf4e8c93979bab` method Tx.Rollback (third_party/openbao/internal/helper/stubbolt/stubbolt.go)
- `method:d73f51f6ce9fd2ad9e92ed519f9b8ff6` method DB.Begin (third_party/openbao/internal/helper/stubbolt/stubbolt.go)
- `struct:71fe871ff7ba40c9c02e4b454bfc4047` struct Bucket (third_party/openbao/internal/helper/stubbolt/stubbolt.go)
- `struct:8c440cfb0b89571960dbbcdf457e7c8e` struct Options (third_party/openbao/internal/helper/stubbolt/stubbolt.go)
- `struct:aa2cb4e4fa1d1517c6a2c54a82a69129` struct Tx (third_party/openbao/internal/helper/stubbolt/stubbolt.go)
- `struct:b03d9778234921efa7dd0017a2fac60a` struct DB (third_party/openbao/internal/helper/stubbolt/stubbolt.go)
<!-- SPECD_MANAGED_END -->
