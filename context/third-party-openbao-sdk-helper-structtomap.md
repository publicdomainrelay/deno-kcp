# Context: third-party-openbao-sdk-helper-structtomap

Repository: `deno-kcp`

The structtomap package exists so code that must treat a struct as a generic key/value bag can convert one without writing per-type boilerplate. Reflection decides the keys, and the json struct tag decides the names, so a type's JSON representation and its map representation stay in agreement. This context documents the vendored OpenBao SDK helper as part of the deno-kcp tree: the contract Map offers to callers, the reflection rules it applies to fields, and the test cases that pin those rules down. Anyone reading the spec should be able to reimplement or audit Map without opening the file: which inputs produce empty maps, which fields are dropped, how embedding flattens, and how tag values map to keys.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/helper/structtomap/structtomap.go` file structtomap.go (third_party/openbao/sdk/helper/structtomap/structtomap.go)
- `file:third_party/openbao/sdk/helper/structtomap/structtomap_test.go` file structtomap_test.go (third_party/openbao/sdk/helper/structtomap/structtomap_test.go)
- `function:fcf7d3a59ddd8233006c6d8b7ed36394` function Map (third_party/openbao/sdk/helper/structtomap/structtomap.go)
<!-- SPECD_MANAGED_END -->
