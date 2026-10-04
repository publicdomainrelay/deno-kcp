# Context: third-party-openbao-api-auth-jwt

Repository: `deno-kcp`

This context exists to describe the JWT auth method of the embedded OpenBao client library that deno-kcp carries under third_party, so that the role-based login path used against an OpenBao server has a written contract independent of the surrounding vendored tree. It records how a JWTAuth value is validated and assembled, how options mutate it, and where the token comes from, so callers can rely on construction either failing fast with a named error or yielding a JWTAuth ready to log in.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/api/auth/jwt/jwt.go` file jwt.go (third_party/openbao/api/auth/jwt/jwt.go)
- `function:04979f4a112ef4def1b90b2d82880584` function WithMountPath (third_party/openbao/api/auth/jwt/jwt.go)
- `function:1b614483408b422219bfc3d70828cf47` function WithTokenFromPath (third_party/openbao/api/auth/jwt/jwt.go)
- `function:5b77232edaba34ac15adc8636b883ad9` function WithTokenFromEnv (third_party/openbao/api/auth/jwt/jwt.go)
- `function:6cd6a31e27f327715c4ff05f356f84e5` function New (third_party/openbao/api/auth/jwt/jwt.go)
- `function:eeaf585452aa898fd223655de1516ade` function WithToken (third_party/openbao/api/auth/jwt/jwt.go)
- `method:bd156f15d59c7a024f3b42cc22eaaf42` method JWTAuth.Login (third_party/openbao/api/auth/jwt/jwt.go)
- `struct:abb2bb341ee56ffb83644c314d2fc9e4` struct JWTAuth (third_party/openbao/api/auth/jwt/jwt.go)
- `type_alias:a4524c14e23c21e6a0c9ec52c5c0345f` type_alias Option (third_party/openbao/api/auth/jwt/jwt.go)
<!-- SPECD_MANAGED_END -->
