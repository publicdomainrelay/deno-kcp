# Context: third-party-openbao-internal-helper-builtinplugins

Repository: `deno-kcp`

This context exists so the builtin plugin registry's lookup surface can be described and depended on without reading the vendored OpenBao sources: it is the single place that maps a builtin plugin name plus plugin type to its factory, its deprecation status, and the list of names that are still considered builtin. It exists because the rest of the tree, notably Vault core, binds to a BuiltinRegistry interface offering exactly Get, Keys, Contains and DeprecationStatus, so the behaviour of those four methods, including what happens for an unknown name or an unrecognised plugin type, is the contract callers rely on.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/helper/builtinplugins/registry.go` file registry.go (third_party/openbao/internal/helper/builtinplugins/registry.go)
- `file:third_party/openbao/internal/helper/builtinplugins/registry_test.go` file registry_test.go (third_party/openbao/internal/helper/builtinplugins/registry_test.go)
- `method:5202e75fa5e63c649bc628d07fd71ead` method registry.DeprecationStatus (third_party/openbao/internal/helper/builtinplugins/registry.go)
- `method:7009fa0b248f9892a4636e7bb62f619b` method registry.Keys (third_party/openbao/internal/helper/builtinplugins/registry.go)
- `method:b90fa5e560e9c3a6dd1a421c0cae9e35` method registry.Get (third_party/openbao/internal/helper/builtinplugins/registry.go)
- `method:df1edaefd7afbff8f01427741ebda7bb` method registry.Contains (third_party/openbao/internal/helper/builtinplugins/registry.go)
- `type_alias:f05ff2dd7360b0020cc866b46e434703` type_alias BuiltinFactory (third_party/openbao/internal/helper/builtinplugins/registry.go)
<!-- SPECD_MANAGED_END -->
