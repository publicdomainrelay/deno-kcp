# Context: third-party-openbao-sdk-helper-errutil

Repository: `deno-kcp`

The context exists so that calling code can tag an error as either the caller's fault or the server's fault without depending on the full OpenBao SDK. Certificate creation in certutil needs exactly this split: invalid Not Before / Not After parameters must be reported to the requester as a UserError, while a failure to compute a subject key ID must be reported as an InternalError. Keeping the vendored types in third_party preserves a drop-in match with the upstream OpenBao SDK helper so that adjacent vendored packages, chiefly certutil, compile and type-assert against the same package path and names. The spec pins only what this file must keep true for that compatibility to hold: two exported structs, one exported string field each, and one Error method each that returns the field unchanged.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/helper/errutil/error.go` file error.go (third_party/openbao/sdk/helper/errutil/error.go)
- `method:9dc058a0b93a096517b7cf7d99b84bf9` method InternalError.Error (third_party/openbao/sdk/helper/errutil/error.go)
- `method:c005f97d9637c6ba6d1f4e44eab1ae4c` method UserError.Error (third_party/openbao/sdk/helper/errutil/error.go)
- `struct:0e0f46591e5e44fa46b17ca1d4f2b33a` struct InternalError (third_party/openbao/sdk/helper/errutil/error.go)
- `struct:58cac1ec3c195633337fd829177a9cf5` struct UserError (third_party/openbao/sdk/helper/errutil/error.go)
<!-- SPECD_MANAGED_END -->
