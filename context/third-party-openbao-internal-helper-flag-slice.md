# Context: third-party-openbao-internal-helper-flag-slice

Repository: `deno-kcp`

The package exists so a CLI command can accept a flag that appears more than once, with each occurrence contributing one more string to an ordered list. It is a leaf helper in the vendored third-party tree, depending only on the standard library strings package for joining. It exists because the standard flag package has no built-in repeated string flag, and the OpenBao command layer needs the raw values in the order they were given.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/helper/flag-slice/flag.go` file flag.go (third_party/openbao/internal/helper/flag-slice/flag.go)
- `file:third_party/openbao/internal/helper/flag-slice/flag_test.go` file flag_test.go (third_party/openbao/internal/helper/flag-slice/flag_test.go)
- `method:034969529844a720667adcf3ed37c437` method StringFlag.Set (third_party/openbao/internal/helper/flag-slice/flag.go)
- `method:7200b0805cd103fa07c81138c4863073` method StringFlag.String (third_party/openbao/internal/helper/flag-slice/flag.go)
- `type_alias:718f3bbeb4da00e52797b13de56943dd` type_alias StringFlag (third_party/openbao/internal/helper/flag-slice/flag.go)
<!-- SPECD_MANAGED_END -->
