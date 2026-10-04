# Context: third-party-openbao-api-auth-approle

Repository: `deno-kcp`

This context exists to describe the vendored OpenBao AppRole auth-method package that deno-kcp carries under `third_party/openbao`, so its public surface (constructor, functional options, `Login`) and its documented behavior (single secret-ID source, late resolution of file and environment values, bounded file read, optional wrapping-token unwrap, write to `auth/<mountPath>/login`) are recorded as requirements rather than re-derived from source on each change. It anchors the contract other parts of the repository rely on when authenticating to OpenBao with a role ID and secret ID, and it marks the package as upstream code whose behavior is already exercised by its own tests.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/api/auth/approle/approle.go` file approle.go (third_party/openbao/api/auth/approle/approle.go)
- `file:third_party/openbao/api/auth/approle/approle_test.go` file approle_test.go (third_party/openbao/api/auth/approle/approle_test.go)
- `function:0c0251b3ee8a686ab995281e430c7e47` function NewAppRoleAuth (third_party/openbao/api/auth/approle/approle.go)
- `function:b150309c06eb8e362fc9a3720b1bbc68` function WithMountPath (third_party/openbao/api/auth/approle/approle.go)
- `function:cf9e6e345dad7784ebf823bf8dc110b4` function WithWrappingToken (third_party/openbao/api/auth/approle/approle.go)
- `method:4a1253c4affe90d74083c66b48949310` method AppRoleAuth.Login (third_party/openbao/api/auth/approle/approle.go)
- `struct:c3b9a9c281a7dab56060d3c1d0f103f3` struct AppRoleAuth (third_party/openbao/api/auth/approle/approle.go)
- `struct:fdf7d8abfcfc08357b55b8a35bd83ff6` struct SecretID (third_party/openbao/api/auth/approle/approle.go)
- `type_alias:de2ec0e4cb842660b1b1f573ff29926d` type_alias LoginOption (third_party/openbao/api/auth/approle/approle.go)
<!-- SPECD_MANAGED_END -->
