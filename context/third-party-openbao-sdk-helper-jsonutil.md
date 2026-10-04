# Context: third-party-openbao-sdk-helper-jsonutil

Repository: `deno-kcp`

This context exists so the rest of the OpenBao code tree has one shared, consistent way to serialize and deserialize JSON, including the compressed-storage form used by the logical storage layer (StorageEntry.DecodeJSON calls jsonutil.DecodeJSON). It is upstream vendored SDK code, not logic owned by this repository, and it is documented here because the repository depends on its exact behavior: nil-input rejection, the compression canary convention, the gzip BestCompression default, and json.Number decoding semantics. Nothing in this context is a command entrypoint; it is a library surface consumed by many builtin credential and storage paths.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/helper/jsonutil/json.go` file json.go (third_party/openbao/sdk/helper/jsonutil/json.go)
- `file:third_party/openbao/sdk/helper/jsonutil/json_test.go` file json_test.go (third_party/openbao/sdk/helper/jsonutil/json_test.go)
- `function:182e13ed382d22eedd3d9a5a1a2a4585` function EncodeJSON (third_party/openbao/sdk/helper/jsonutil/json.go)
- `function:186d1ab83658f923b0f4e72c1353748e` function DecodeJSON (third_party/openbao/sdk/helper/jsonutil/json.go)
- `function:508dfa21a4c58aba9d9ec2ee8d9f996a` function DecodeJSONFromReader (third_party/openbao/sdk/helper/jsonutil/json.go)
- `function:f8402c5f985190e386f7283f906c2157` function EncodeJSONAndCompress (third_party/openbao/sdk/helper/jsonutil/json.go)
<!-- SPECD_MANAGED_END -->
