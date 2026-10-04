# Context: third-party-openbao-internal-vault-routing

Repository: `deno-kcp`

_(empty: write what this context is for)_

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/routing/mount_entry.go` file mount_entry.go (third_party/openbao/internal/vault/routing/mount_entry.go)
- `file:third_party/openbao/internal/vault/routing/mount_table.go` file mount_table.go (third_party/openbao/internal/vault/routing/mount_table.go)
- `file:third_party/openbao/internal/vault/routing/router.go` file router.go (third_party/openbao/internal/vault/routing/router.go)
- `file:third_party/openbao/internal/vault/routing/router_test.go` file router_test.go (third_party/openbao/internal/vault/routing/router_test.go)
- `file:third_party/openbao/internal/vault/routing/routing.go` file routing.go (third_party/openbao/internal/vault/routing/routing.go)
- `function:3f8d0efa49d347811e59864a81e24e13` function NewRouter (third_party/openbao/internal/vault/routing/router.go)
- `function:598a764835555ff929b98b230368d95f` function ParseUnauthenticatedPaths (third_party/openbao/internal/vault/routing/router.go)
- `function:70e79ca4c970c2a745fe67fe03129c9d` function PathsToRadix (third_party/openbao/internal/vault/routing/router.go)
- `interface:8945ea83968aa3197d0c77e2ef8bf7bb` interface Deserializable (third_party/openbao/internal/vault/routing/mount_entry.go)
- `method:01925a0fa8b9126001e46ffa606a95cc` method MountTable.FindByPath (third_party/openbao/internal/vault/routing/mount_table.go)
- `method:0dd9546057bf8ac9f78c39fafa44aba6` method Router.MatchingPrefixInternal (third_party/openbao/internal/vault/routing/router.go)
- `method:23fdf617629df5b0441039b029ce6a57` method RouteEntry.SaltID (third_party/openbao/internal/vault/routing/router.go)
- `method:26cfe967d1628fb86939938da37b68ee` method MountEntry.Deserialize (third_party/openbao/internal/vault/routing/mount_entry.go)
- `method:294b794a2f2c5061c66996080b406fad` method Router.Mount (third_party/openbao/internal/vault/routing/router.go)
- `method:2c83029fa1ec83b90d0d0525df1104e5` method MountEntry.APIPathNoNamespace (third_party/openbao/internal/vault/routing/mount_entry.go)
- `method:3101ff0fc94cca41afdc6d7579adfda6` method Router.MatchingMountByAPIPath (third_party/openbao/internal/vault/routing/router.go)
- `method:36ae59223f6b3de0d4b31af0ff34d3cf` method Router.ResolvePath (third_party/openbao/internal/vault/routing/router.go)
- `method:3bd7d8a2ef3a1884b336ccbc08504044` method RouteEntry.Deserialize (third_party/openbao/internal/vault/routing/router.go)
- `method:3c3190192be061f1c6343c2818263c34` method MountEntry.MountClass (third_party/openbao/internal/vault/routing/mount_entry.go)
- `method:3de69813bc0bc6eb30091d92d79a9ec0` method Router.MatchingMount (third_party/openbao/internal/vault/routing/router.go)
- `method:3ef49830e4b6aa13bd1c77b6c7c6f51b` method RouteEntry.SetLoginPaths (third_party/openbao/internal/vault/routing/router.go)
- `method:514205cbd0f146c2a273f3bce875b86f` method Router.MountConflict (third_party/openbao/internal/vault/routing/router.go)
- `method:52b72138b1d32c1aecee211a3b808af6` method Router.MatchingSystemView (third_party/openbao/internal/vault/routing/router.go)
- `method:57c4dbcaca1444b60eb5bd3af6a56851` method Router.MatchingStorageByAPIPath (third_party/openbao/internal/vault/routing/router.go)
- `method:5827ef0daa222bfc3293aea1969d4109` method Router.Taint (third_party/openbao/internal/vault/routing/router.go)
- `method:588741170312cd5ea3640f96b75e8167` method Router.GetRecords (third_party/openbao/internal/vault/routing/router.go)
- `method:59085db6951ee5fbca5d81b8c3462963` method Deserializable.Deserialize (third_party/openbao/internal/vault/routing/mount_entry.go)
- `method:5c1b59258b264ff07be7d89e569dcda6` method Router.MatchingStoragePrefixByAPIPath (third_party/openbao/internal/vault/routing/router.go)
- `method:65961d8ce41fcd625fb2cc5b512722c0` method Router.MatchingMountByAccessor (third_party/openbao/internal/vault/routing/router.go)
- `method:68902c73cc6ec547ff9499801ea3961a` method Router.Untaint (third_party/openbao/internal/vault/routing/router.go)
- `method:6bf77a858ca3669ef0f10d0d440cc0d2` method Router.MatchingBackend (third_party/openbao/internal/vault/routing/router.go)
- `method:6cdf114d9d125760d3387cc3bc683634` method Router.MatchingMountByUUID (third_party/openbao/internal/vault/routing/router.go)
- `method:792c4945871c5543b8536981bef5b2d5` method MountEntry.APIPath (third_party/openbao/internal/vault/routing/mount_entry.go)
- `method:7a06758a106cb8019827f82e7ee2a11b` method Router.MatchingStorageByStoragePath (third_party/openbao/internal/vault/routing/router.go)
- `method:87b2150b4407e5e00d3b22f72fb7459e` method Router.SetTokenStoreSaltFunc (third_party/openbao/internal/vault/routing/router.go)
- `method:8ab5c421de92dd46e17162b6df8cb0f9` method MountEntry.IsExternalPlugin (third_party/openbao/internal/vault/routing/mount_entry.go)
- `method:8e6b89e2736e11e9b9f5f3ea6d43b976` method MountTable.Delta (third_party/openbao/internal/vault/routing/mount_table.go)
- `method:9b4b65ff59a13c25c627575c191dc6bf` method Router.ValidateMountByAccessor (third_party/openbao/internal/vault/routing/router.go)
- `method:b0671e89df0a15f5b9ba5edbff7153db` method Router.Remount (third_party/openbao/internal/vault/routing/router.go)
- `method:b1f5b2a40c6682947221ab2fa2d62b25` method MountTable.SetTaint (third_party/openbao/internal/vault/routing/mount_table.go)
- `method:b2fa87db977662e2ee63b8b0fec69519` method Router.RouteExistenceCheck (third_party/openbao/internal/vault/routing/router.go)
- `method:b58c072c0f285ea264917421a4ccdc90` method Router.Reset (third_party/openbao/internal/vault/routing/router.go)
- `method:b65362a647c4670723e13eba1c5d8382` method RouteEntry.SetRootPaths (third_party/openbao/internal/vault/routing/router.go)
- `method:c0eb86f313b77eca2b9d630b125c7fff` method Router.LoginPath (third_party/openbao/internal/vault/routing/router.go)
- `method:c9c63dd8d033c6e1354255e10099d7ce` method Router.Invalidate (third_party/openbao/internal/vault/routing/router.go)

_24 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
