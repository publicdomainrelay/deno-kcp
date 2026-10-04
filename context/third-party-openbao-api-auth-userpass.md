# Context: third-party-openbao-api-auth-userpass

Repository: `deno-kcp`

This context exists to pin the behaviour of the vendored OpenBao userpass auth method as this repository consumes it: the constructor contract, the mount-path option, the deferred password read, and the validate rules. It captures the code that is there so changes to the vendored copy can be checked against the expected interface and error strings, and so the conformance to api.AuthMethod is recorded.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/api/auth/userpass/userpass.go` file userpass.go (third_party/openbao/api/auth/userpass/userpass.go)
- `file:third_party/openbao/api/auth/userpass/userpass_test.go` file userpass_test.go (third_party/openbao/api/auth/userpass/userpass_test.go)
- `function:f5e1d9de7472feb4063d8d4b38e6638b` function WithMountPath (third_party/openbao/api/auth/userpass/userpass.go)
- `function:f736e7e6a1f4575d2650107dd15dd744` function NewUserpassAuth (third_party/openbao/api/auth/userpass/userpass.go)
- `method:9afc106af9cd9785e2aa574c2189b084` method UserpassAuth.Login (third_party/openbao/api/auth/userpass/userpass.go)
- `struct:96e3f457b1325f85ffcedcb95a8bb314` struct Password (third_party/openbao/api/auth/userpass/userpass.go)
- `struct:a59bb055a5013978de35ac677b4ec239` struct UserpassAuth (third_party/openbao/api/auth/userpass/userpass.go)
- `type_alias:d9885a92c719f1e783f19725804a4044` type_alias LoginOption (third_party/openbao/api/auth/userpass/userpass.go)
<!-- SPECD_MANAGED_END -->
