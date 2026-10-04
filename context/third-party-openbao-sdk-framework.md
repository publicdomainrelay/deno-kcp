# Context: third-party-openbao-sdk-framework

Repository: `deno-kcp`

The package exists so that a plugin can declare its HTTP surface as data — a list of Path values with patterns, fields and an OperationFunc each — and let the framework do routing, existence checks, field decoding and validation, response shaping, lease extension, and OpenAPI emission. It is vendored third-party code under third_party/openbao/sdk, consumed by this repository rather than authored here, so the spec records the exported API surface and the behaviour the code must keep for the depending backends to work.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/framework/backend.go` file backend.go (third_party/openbao/sdk/framework/backend.go)
- `file:third_party/openbao/sdk/framework/backend_test.go` file backend_test.go (third_party/openbao/sdk/framework/backend_test.go)
- `file:third_party/openbao/sdk/framework/field_data.go` file field_data.go (third_party/openbao/sdk/framework/field_data.go)
- `file:third_party/openbao/sdk/framework/field_data_test.go` file field_data_test.go (third_party/openbao/sdk/framework/field_data_test.go)
- `file:third_party/openbao/sdk/framework/field_type.go` file field_type.go (third_party/openbao/sdk/framework/field_type.go)
- `file:third_party/openbao/sdk/framework/filter.go` file filter.go (third_party/openbao/sdk/framework/filter.go)
- `file:third_party/openbao/sdk/framework/identity.go` file identity.go (third_party/openbao/sdk/framework/identity.go)
- `file:third_party/openbao/sdk/framework/identity_test.go` file identity_test.go (third_party/openbao/sdk/framework/identity_test.go)
- `file:third_party/openbao/sdk/framework/lease.go` file lease.go (third_party/openbao/sdk/framework/lease.go)
- `file:third_party/openbao/sdk/framework/lease_test.go` file lease_test.go (third_party/openbao/sdk/framework/lease_test.go)
- `file:third_party/openbao/sdk/framework/openapi.go` file openapi.go (third_party/openbao/sdk/framework/openapi.go)
- `file:third_party/openbao/sdk/framework/openapi_test.go` file openapi_test.go (third_party/openbao/sdk/framework/openapi_test.go)
- `file:third_party/openbao/sdk/framework/path.go` file path.go (third_party/openbao/sdk/framework/path.go)
- `file:third_party/openbao/sdk/framework/path_map.go` file path_map.go (third_party/openbao/sdk/framework/path_map.go)
- `file:third_party/openbao/sdk/framework/path_map_test.go` file path_map_test.go (third_party/openbao/sdk/framework/path_map_test.go)
- `file:third_party/openbao/sdk/framework/path_struct.go` file path_struct.go (third_party/openbao/sdk/framework/path_struct.go)
- `file:third_party/openbao/sdk/framework/path_struct_test.go` file path_struct_test.go (third_party/openbao/sdk/framework/path_struct_test.go)
- `file:third_party/openbao/sdk/framework/path_test.go` file path_test.go (third_party/openbao/sdk/framework/path_test.go)
- `file:third_party/openbao/sdk/framework/policy_map.go` file policy_map.go (third_party/openbao/sdk/framework/policy_map.go)
- `file:third_party/openbao/sdk/framework/policy_map_test.go` file policy_map_test.go (third_party/openbao/sdk/framework/policy_map_test.go)
- `file:third_party/openbao/sdk/framework/secret.go` file secret.go (third_party/openbao/sdk/framework/secret.go)
- `file:third_party/openbao/sdk/framework/secret_test.go` file secret_test.go (third_party/openbao/sdk/framework/secret_test.go)
- `file:third_party/openbao/sdk/framework/template.go` file template.go (third_party/openbao/sdk/framework/template.go)
- `file:third_party/openbao/sdk/framework/testing.go` file testing.go (third_party/openbao/sdk/framework/testing.go)
- `file:third_party/openbao/sdk/framework/wal.go` file wal.go (third_party/openbao/sdk/framework/wal.go)
- `file:third_party/openbao/sdk/framework/wal_test.go` file wal_test.go (third_party/openbao/sdk/framework/wal_test.go)
- `function:0028be1de12ba6bef00d3e1fb60e4b52` function NewOASDocument (third_party/openbao/sdk/framework/openapi.go)
- `function:023464880305b582c393e68bfa96807d` function TestBackendRoutes (third_party/openbao/sdk/framework/testing.go)
- `function:05a495b2d9c18fd5b278b7577edd9569` function PathAppend (third_party/openbao/sdk/framework/path.go)
- `function:0c6f85a813572cc33c3f91839c85fcd2` function GetWAL (third_party/openbao/sdk/framework/wal.go)
- `function:0de629d000606114b1ef2e4580e6d5a9` function MatchAllRegex (third_party/openbao/sdk/framework/path.go)
- `function:33e77a0b87122f030c420983e426f2e9` function GenericNameRegex (third_party/openbao/sdk/framework/path.go)
- `function:46246a69971342055d0735001ad50723` function CalculateTTL (third_party/openbao/sdk/framework/lease.go)
- `function:4f52da51e339e7114337d715edaeb9f7` function OptionalParamRegex (third_party/openbao/sdk/framework/path.go)
- `function:5f111d929f25de87bbc5447daefb0b95` function GlobListFilter (third_party/openbao/sdk/framework/filter.go)
- `function:6ac2ae45010883122cff7c87f0b3c39a` function DeleteWAL (third_party/openbao/sdk/framework/wal.go)
- `function:78e6b547965e022d718e82362df72f11` function HandlePatchOperation (third_party/openbao/sdk/framework/backend.go)
- `function:7cb155705ab33f37dec1f85c9cfb30c3` function ParseFieldType (third_party/openbao/sdk/framework/field_type.go)
- `function:82e414d2c78ae16af09375033079b5e3` function PopulateIdentityTemplate (third_party/openbao/sdk/framework/identity.go)
- `function:8465914540267955672f669e8d9dbef2` function OptionalGenericNameRegex (third_party/openbao/sdk/framework/path.go)
- `function:93827947b27e47ac9bf58a0e2838d4c3` function LeaseExtend (third_party/openbao/sdk/framework/lease.go)
- `function:97ba9e3269067a0a17fe3af55b2e7bd2` function GenericNameWithAtRegex (third_party/openbao/sdk/framework/path.go)
- `function:aa979bbdc44e7694c80d2d2b93c3640b` function ListWAL (third_party/openbao/sdk/framework/wal.go)
- `function:af6e936ef7bef04c1d426ab90b823361` function NewOASDocumentFromMap (third_party/openbao/sdk/framework/openapi.go)
- `function:bae938f2213cd5d05c587e1b40efd91b` function NewOASOperation (third_party/openbao/sdk/framework/openapi.go)
- `function:c3834b0cf7aafae27971beeea1dbe846` function PutWAL (third_party/openbao/sdk/framework/wal.go)
- `function:d0b90263b7114903892f00914d31cfcb` function ValidateIdentityTemplate (third_party/openbao/sdk/framework/identity.go)
- `interface:bec23c61feb51a19cac02ea5ec15d026` interface OperationHandler (third_party/openbao/sdk/framework/path.go)
- `method:0849067c783a880306c88ea24c0ca2f8` method Backend.HandleExistenceCheck (third_party/openbao/sdk/framework/backend.go)

_80 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
