# Context: third-party-openbao-sdk-helper-custommetadata

Repository: `deno-kcp`

This context exists so the repository records the contract of the custommetadata helper as referenceable specification rather than as vendored OpenBao source. Custom metadata is the arbitrary user-supplied key-value supplemental information attached to a resource, so two things must be pinned down: the wire-to-storage conversion (TypeMap to TypeKVPairs) and its interaction with PATCH semantics, and the hard limits every writer of metadata is held to. Encoding those limits as spec lets callers and validators agree on the same bounds without re-reading the vendored package, and makes the nil-filtering rule of Parse explicit, since a null value is meaningful only during a patch and is otherwise flattened to an empty string.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/helper/custommetadata/custom_metadata.go` file custom_metadata.go (third_party/openbao/sdk/helper/custommetadata/custom_metadata.go)
- `file:third_party/openbao/sdk/helper/custommetadata/custom_metadata_test.go` file custom_metadata_test.go (third_party/openbao/sdk/helper/custommetadata/custom_metadata_test.go)
- `function:033e2afedd4e010b8e905d90383c072f` function Validate (third_party/openbao/sdk/helper/custommetadata/custom_metadata.go)
- `function:36566084e5022d041b516ae815d08b53` function Parse (third_party/openbao/sdk/helper/custommetadata/custom_metadata.go)
<!-- SPECD_MANAGED_END -->
