# Context: third-party-openbao-sdk-helper-cryptoutil

Repository: `deno-kcp`

This context exists to specify the vendored `sdk/helper/cryptoutil` package of the OpenBao SDK as it is copied into the deno-kcp repository under `third_party/openbao`. It is a third-party shim, not first-party code: deno-kcp depends on OpenBao's helper packages, and this one carries the small hashing helper those packages or their consumers need. The context pins the exact contract of the one exported function so that callers elsewhere in the tree can rely on a stable BLAKE2b-256 digest over a string key, and so any future vendoring refresh can be checked against the same behavior.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/helper/cryptoutil/cryptoutil.go` file cryptoutil.go (third_party/openbao/sdk/helper/cryptoutil/cryptoutil.go)
- `file:third_party/openbao/sdk/helper/cryptoutil/cryptoutil_test.go` file cryptoutil_test.go (third_party/openbao/sdk/helper/cryptoutil/cryptoutil_test.go)
- `function:5dc45e55dcc09bc468fec4a497fac126` function Blake2b256Hash (third_party/openbao/sdk/helper/cryptoutil/cryptoutil.go)
<!-- SPECD_MANAGED_END -->
