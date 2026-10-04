# Context: third-party-openbao-internal-helper-identity

Repository: `deno-kcp`

_(empty: write what this context is for)_

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/helper/identity/identity.go` file identity.go (third_party/openbao/internal/helper/identity/identity.go)
- `file:third_party/openbao/internal/helper/identity/sentinel.go` file sentinel.go (third_party/openbao/internal/helper/identity/sentinel.go)
- `file:third_party/openbao/internal/helper/identity/types.pb.go` file types.pb.go (third_party/openbao/internal/helper/identity/types.pb.go)
- `function:2dea232655a7227c40ee3249769304c2` function ToSDKEntity (third_party/openbao/internal/helper/identity/identity.go)
- `function:565b69f3842b1e6add6876bc37af887b` function ToSDKGroups (third_party/openbao/internal/helper/identity/identity.go)
- `function:a56aa82127d755b088d2dbb960f2f300` function ToSDKGroup (third_party/openbao/internal/helper/identity/identity.go)
- `function:f0dbc95dbc4552d8b598838dc3963d39` function ToSDKAlias (third_party/openbao/internal/helper/identity/identity.go)
- `method:07188bac0ddd0bdf184f40bfaaa358a4` method Group.Descriptor (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:0990d3641a76b905e6a41983f8785fd5` method Group.GetParentGroupIDs (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:0cd9e5a7144fdf4f81caca70678adbb4` method Group.GetName (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:0f296dfb5192107082a5c668650c5aff` method Group.GetModifyIndex (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:177814e65fe6a22c0b973f933ce2d751` method PersonaIndexEntry.GetEntityID (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:183fa03222159edc932ae71b61b95788` method PersonaIndexEntry.GetCreationTime (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:1b074507c8b2673724ee776090541db7` method Group.GetCreationTime (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:1d45232cef5804a73e409bce8b322e0f` method EntityStorageEntry.ProtoReflect (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:21459f1476d4ad0526f18b0210c47f05` method PersonaIndexEntry.GetMountType (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:257e51e5d27c25c8ffce6ebaea043727` method EntityStorageEntry.GetMetadata (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:28df9afcf8f7eb8c3c9f22125436cb12` method Entity.String (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:2a04e2723735fa06824cceb45c8497d8` method EntityStorageEntry.GetBucketKeyHash (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:2ac86f8dcde200fcf7386b4ec3cd12e3` method Entity.Clone (third_party/openbao/internal/helper/identity/identity.go)
- `method:2af2e4a9f91df441c10290f6043aa7cf` method Entity.GetBucketKey (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:2cfe5b89173660182d2000010f7917a3` method PersonaIndexEntry.GetMountAccessor (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:2ea93462942a470f7d0b7eca34f7bb48` method PersonaIndexEntry.GetName (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:33086909f4c7f44a4b4eba7b3b0e83d9` method Group.SentinelGet (third_party/openbao/internal/helper/identity/sentinel.go)
- `method:35115e00d99b877b233cd60c75025042` method Entity.GetAliases (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:370391f1d1b670a349ff8ae2b7c28a5d` method EntityStorageEntry.Descriptor (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:37d1c651299599200a11ac10f79430d6` method Entity.GetName (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:3a59fc3ebf81f1bba50fb60f550ebe24` method Alias.GetMergedFromCanonicalIDs (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:3ed4ed76b0799eb6836a4d8bf8deb852` method Entity.Reset (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:3ef05e60536baf567e56b8a9497ef19b` method Group.GetType (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:3f0629ced431fa65c18afd1251a88fde` method Group.GetLastUpdateTime (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:3f2ff671f75ec299da3b0b43dd8e3ba4` method Entity.GetLastUpdateTime (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:4021e634dba69aab9bd00e1945126142` method Alias.GetName (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:4470085374d7f4ba436e452ec8293f68` method LocalAliases.GetAliases (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:45aee78f3df6456b1b7ff9a8d980fc41` method Alias.String (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:46780d87b13b5d16fe0a0e498b581e80` method LocalAliases.ProtoReflect (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:494eb64560312218991148e364119c70` method Entity.GetCreationTime (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:4b347d858e40f0f50ab3336fd4ec802c` method Alias.GetCustomMetadata (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:4d02e5c3f8937b92b8e9d15eaa0371d7` method Group.GetMemberEntityIDs (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:5034f8fb0e5f72abaaa5f21845549ab8` method Entity.SentinelKeys (third_party/openbao/internal/helper/identity/sentinel.go)
- `method:52b0d695bf53c8740965c04aec7010d7` method PersonaIndexEntry.ProtoReflect (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:542a3ced8dc08d352698121422996ee8` method Alias.Reset (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:54aeba2dba3e7531305602cfa7248af9` method EntityStorageEntry.GetPolicies (third_party/openbao/internal/helper/identity/types.pb.go)
- `method:56ddad86501a1ab53631528dc66dfa1b` method EntityStorageEntry.GetName (third_party/openbao/internal/helper/identity/types.pb.go)

_69 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
