# Context: third-party-openbao-internal-vault-identity

Repository: `deno-kcp`

_(empty: write what this context is for)_

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/identity/lookup.go` file lookup.go (third_party/openbao/internal/vault/identity/lookup.go)
- `file:third_party/openbao/internal/vault/identity/mfa.go` file mfa.go (third_party/openbao/internal/vault/identity/mfa.go)
- `file:third_party/openbao/internal/vault/identity/store.go` file store.go (third_party/openbao/internal/vault/identity/store.go)
- `file:third_party/openbao/internal/vault/identity/store_aliases.go` file store_aliases.go (third_party/openbao/internal/vault/identity/store_aliases.go)
- `file:third_party/openbao/internal/vault/identity/store_entities.go` file store_entities.go (third_party/openbao/internal/vault/identity/store_entities.go)
- `file:third_party/openbao/internal/vault/identity/store_group_aliases.go` file store_group_aliases.go (third_party/openbao/internal/vault/identity/store_group_aliases.go)
- `file:third_party/openbao/internal/vault/identity/store_groups.go` file store_groups.go (third_party/openbao/internal/vault/identity/store_groups.go)
- `file:third_party/openbao/internal/vault/identity/store_oidc.go` file store_oidc.go (third_party/openbao/internal/vault/identity/store_oidc.go)
- `file:third_party/openbao/internal/vault/identity/store_oidc_provider.go` file store_oidc_provider.go (third_party/openbao/internal/vault/identity/store_oidc_provider.go)
- `file:third_party/openbao/internal/vault/identity/store_schema.go` file store_schema.go (third_party/openbao/internal/vault/identity/store_schema.go)
- `file:third_party/openbao/internal/vault/identity/store_structs.go` file store_structs.go (third_party/openbao/internal/vault/identity/store_structs.go)
- `file:third_party/openbao/internal/vault/identity/store_upgrade.go` file store_upgrade.go (third_party/openbao/internal/vault/identity/store_upgrade.go)
- `file:third_party/openbao/internal/vault/identity/store_util.go` file store_util.go (third_party/openbao/internal/vault/identity/store_util.go)
- `function:25eef2407a8fbe0908712bfa26a12b59` function NewOIDCCache (third_party/openbao/internal/vault/identity/store_oidc.go)
- `function:5e198781c89dfa398d767fa65f225c67` function IsTargetNamespacedKey (third_party/openbao/internal/vault/identity/store_oidc.go)
- `function:9a1e70541a717e1949d53fe2f0ac3aac` function ChangedAliasIndex (third_party/openbao/internal/vault/identity/store.go)
- `function:a0682dc3ca805b467ae2b0927d07169d` function LowercaseIdentityIDs (third_party/openbao/internal/vault/identity/store_oidc_provider.go)
- `function:fbb51151baa31d84118521a4b6739fc8` function NewIdentityStore (third_party/openbao/internal/vault/identity/store.go)
- `interface:09cc5be174c8f1018c819ded7cd0c9e3` interface LoggerAdder (third_party/openbao/internal/vault/identity/store.go)
- `interface:40c34ef251254636285fb26d3e668695` interface Namespacer (third_party/openbao/internal/vault/identity/store_structs.go)
- `interface:63a95dd01b6529284ad740a4b8b7dc0a` interface MFABackend (third_party/openbao/internal/vault/identity/mfa.go)
- `interface:6ee494f9715a75f9c94fa1951d1977eb` interface TOTPPersister (third_party/openbao/internal/vault/identity/store_structs.go)
- `interface:c43b10edf46f93df414f23fb18c0371f` interface TokenStorer (third_party/openbao/internal/vault/identity/store_structs.go)
- `interface:dc053fc95cbbf99260aeb61705cbc006` interface LocalNode (third_party/openbao/internal/vault/identity/store_structs.go)
- `method:05cc0a50ea8cdc8f61618648dc063c8c` method IdentityStore.MemDBAliasByFactorsInTxn (third_party/openbao/internal/vault/identity/store_util.go)
- `method:064df75847df7716da78d8ff1c0d070e` method IdentityStore.LoadOIDCClients (third_party/openbao/internal/vault/identity/store_oidc_provider.go)
- `method:0738bffcf8e33837658dca7ae39c1eb0` method IdentityStore.MemDBEntityByAliasID (third_party/openbao/internal/vault/identity/store_util.go)
- `method:07b707cb5d0153f032cb238889d289d1` method LocalNode.HAState (third_party/openbao/internal/vault/identity/store_structs.go)
- `method:0aa05a8f81fdf9d8fe0782e356f94a64` method IdentityStore.MemDBEntityByAliasIDInTxn (third_party/openbao/internal/vault/identity/store_util.go)
- `method:0cf022ee549eea43a0fb802944d4e1cb` method IdentityStore.MemDBDeleteEntityByIDInTxn (third_party/openbao/internal/vault/identity/store_util.go)
- `method:0e19a5ac8051c394c89093819228b606` method IdentityStore.MemDBDeleteEntityByID (third_party/openbao/internal/vault/identity/store_util.go)
- `method:0e1bdf77b25885fbec153395a9bef2ff` method MFABackend.CleanupNamespace (third_party/openbao/internal/vault/identity/mfa.go)
- `method:0ebd56effc14bcb2474fa49f4f48be90` method userError.Unwrap (third_party/openbao/internal/vault/identity/store_entities.go)
- `method:12ae58ebb7ecdfbbed3d0f3dd183ba60` method IdentityStore.MemDBGroupsByMemberEntityID (third_party/openbao/internal/vault/identity/store_util.go)
- `method:131e56190aca454a5788dfddbc2d18fe` method NamedKey.GenerateAndSetNextKey (third_party/openbao/internal/vault/identity/store_oidc.go)
- `method:13efc92be0a1ccdf2b70f2c6ef0895e1` method NamedKey.GenerateAndSetKey (third_party/openbao/internal/vault/identity/store_oidc.go)
- `method:179eb06308243620e986a3ddba7dc4c6` method MFABackend.PutMFALoginEnforcementConfig (third_party/openbao/internal/vault/identity/mfa.go)
- `method:18df5f139c9f29e5ef4eb2606f2d4306` method IdentityStore.MemDBGroupByIDInTxn (third_party/openbao/internal/vault/identity/store_util.go)
- `method:1a096884d509a69e493e04de281b6e8a` method IdentityStore.MemDBGroupByAliasIDInTxn (third_party/openbao/internal/vault/identity/store_util.go)
- `method:1e5d1ca2caa6c30a4c050926d116835f` method MFABackend.DeleteMFALoginEnforcementConfigByNameAndNamespace (third_party/openbao/internal/vault/identity/mfa.go)
- `method:1eb3f11fafe2cb2d956b38a53983b0a1` method TokenStorer.LookupToken (third_party/openbao/internal/vault/identity/store_structs.go)

_105 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
