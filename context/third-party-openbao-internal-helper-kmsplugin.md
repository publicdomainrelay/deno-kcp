# Context: third-party-openbao-internal-helper-kmsplugin

Repository: `deno-kcp`

KMS plugins in OpenBao must be usable before core is created and are declarative only, so they need their own catalog separate from the main core plugin catalog. This context gives core a stable way to obtain a sealed or unsealed KMS, key or auto-unseal wrapper by name from either a builtin or an external plugin, and keeps those long-lived objects correct across plugin process restarts and configuration reloads without the caller ever seeing gkwplugin.ErrPluginShutdown.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/helper/kmsplugin/catalog.go` file catalog.go (third_party/openbao/internal/helper/kmsplugin/catalog.go)
- `file:third_party/openbao/internal/helper/kmsplugin/catalog_test.go` file catalog_test.go (third_party/openbao/internal/helper/kmsplugin/catalog_test.go)
- `file:third_party/openbao/internal/helper/kmsplugin/kms.go` file kms.go (third_party/openbao/internal/helper/kmsplugin/kms.go)
- `file:third_party/openbao/internal/helper/kmsplugin/kms_test.go` file kms_test.go (third_party/openbao/internal/helper/kmsplugin/kms_test.go)
- `file:third_party/openbao/internal/helper/kmsplugin/metadata.go` file metadata.go (third_party/openbao/internal/helper/kmsplugin/metadata.go)
- `file:third_party/openbao/internal/helper/kmsplugin/metadata_test.go` file metadata_test.go (third_party/openbao/internal/helper/kmsplugin/metadata_test.go)
- `file:third_party/openbao/internal/helper/kmsplugin/wrapper.go` file wrapper.go (third_party/openbao/internal/helper/kmsplugin/wrapper.go)
- `file:third_party/openbao/internal/helper/kmsplugin/wrapper_test.go` file wrapper_test.go (third_party/openbao/internal/helper/kmsplugin/wrapper_test.go)
- `function:99c53ec37df8b361c1dc4fe016564398` function NewCatalog (third_party/openbao/internal/helper/kmsplugin/catalog.go)
- `method:1c6fd20ea8dc79b95591de2714383b81` method remoteKey.Sign (third_party/openbao/internal/helper/kmsplugin/kms.go)
- `method:30b192e5ac3a26f1e561b4e5472b8f3e` method remoteWrapper.Encrypt (third_party/openbao/internal/helper/kmsplugin/wrapper.go)
- `method:39299e5ae4e8b9db146dd7e281ad3795` method Catalog.ReloadConfig (third_party/openbao/internal/helper/kmsplugin/catalog.go)
- `method:466c4dd2f94ffcdf032d43d103192d40` method remoteWrapper.Finalize (third_party/openbao/internal/helper/kmsplugin/wrapper.go)
- `method:4760ea2f2d142cb98411add7b24c3a99` method remoteKMS.Open (third_party/openbao/internal/helper/kmsplugin/kms.go)
- `method:4bb019b429a33e752872982045033762` method remoteWrapper.Decrypt (third_party/openbao/internal/helper/kmsplugin/wrapper.go)
- `method:5ce1fff93401331e049ffeb0e1803115` method remoteWrapper.Type (third_party/openbao/internal/helper/kmsplugin/wrapper.go)
- `method:607235ba27d01589d303ec3f88e51418` method remoteKey.Verify (third_party/openbao/internal/helper/kmsplugin/kms.go)
- `method:756edcba37642f43afddbf3d07ecf8fc` method remoteKey.Encrypt (third_party/openbao/internal/helper/kmsplugin/kms.go)
- `method:762ebaea4f3d9751288c919ecdfd3086` method Catalog.GetMetadata (third_party/openbao/internal/helper/kmsplugin/metadata.go)
- `method:7a02da7d84ca6b512039f02a219e0b45` method remoteKey.ExportPublic (third_party/openbao/internal/helper/kmsplugin/kms.go)
- `method:8348e49626285f53cc456f1c5103f91a` method remoteWrapper.SetConfig (third_party/openbao/internal/helper/kmsplugin/wrapper.go)
- `method:906506648737d1f6df97c040ab255e7b` method remoteWrapper.KeyId (third_party/openbao/internal/helper/kmsplugin/wrapper.go)
- `method:a2074535537a502f8f3a05b893030b3b` method Catalog.OpenKMS (third_party/openbao/internal/helper/kmsplugin/kms.go)
- `method:a8d787ef27ff1570e4953f5b2e950e98` method Catalog.ConfigureWrapper (third_party/openbao/internal/helper/kmsplugin/wrapper.go)
- `method:c143c6f142920c746fa249bece6eccd4` method remoteKMS.GetKey (third_party/openbao/internal/helper/kmsplugin/kms.go)
- `method:cfb90db6340621ea6dfbc893bf81b2d5` method remoteKey.Decrypt (third_party/openbao/internal/helper/kmsplugin/kms.go)
- `method:d54eef420df20a8d0e75a873ae8cae4e` method remoteWrapper.Init (third_party/openbao/internal/helper/kmsplugin/wrapper.go)
- `method:e1a88070e93159d6c6612cfd62d22535` method remoteKMS.Close (third_party/openbao/internal/helper/kmsplugin/kms.go)
- `struct:f505aca759e0d5ab602240d7661125bd` struct Catalog (third_party/openbao/internal/helper/kmsplugin/catalog.go)
<!-- SPECD_MANAGED_END -->
