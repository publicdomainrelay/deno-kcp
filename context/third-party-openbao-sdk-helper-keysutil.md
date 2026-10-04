# Context: third-party-openbao-sdk-helper-keysutil

Repository: `deno-kcp`

The context exists so a caller can create, cache, lock, persist, rotate and use encryption and signing key policies without touching crypto or storage plumbing directly. It is the third-party vendored OpenBao SDK surface that deno-kcp imports; the specification records the exported contracts, the invariants the package enforces (bounded versus unbounded cache, policy upsert semantics, encrypted-key-storage policy preconditions) and the error behaviour callers depend on.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/helper/keysutil/cache.go` file cache.go (third_party/openbao/sdk/helper/keysutil/cache.go)
- `file:third_party/openbao/sdk/helper/keysutil/consts.go` file consts.go (third_party/openbao/sdk/helper/keysutil/consts.go)
- `file:third_party/openbao/sdk/helper/keysutil/encrypted_key_storage.go` file encrypted_key_storage.go (third_party/openbao/sdk/helper/keysutil/encrypted_key_storage.go)
- `file:third_party/openbao/sdk/helper/keysutil/encrypted_key_storage_test.go` file encrypted_key_storage_test.go (third_party/openbao/sdk/helper/keysutil/encrypted_key_storage_test.go)
- `file:third_party/openbao/sdk/helper/keysutil/lock_manager.go` file lock_manager.go (third_party/openbao/sdk/helper/keysutil/lock_manager.go)
- `file:third_party/openbao/sdk/helper/keysutil/policy.go` file policy.go (third_party/openbao/sdk/helper/keysutil/policy.go)
- `file:third_party/openbao/sdk/helper/keysutil/policy_test.go` file policy_test.go (third_party/openbao/sdk/helper/keysutil/policy_test.go)
- `file:third_party/openbao/sdk/helper/keysutil/transit_lru.go` file transit_lru.go (third_party/openbao/sdk/helper/keysutil/transit_lru.go)
- `file:third_party/openbao/sdk/helper/keysutil/transit_syncmap.go` file transit_syncmap.go (third_party/openbao/sdk/helper/keysutil/transit_syncmap.go)
- `file:third_party/openbao/sdk/helper/keysutil/util.go` file util.go (third_party/openbao/sdk/helper/keysutil/util.go)
- `function:1d458ac94b2715da4e400ddfbf371dd9` function NewLockManager (third_party/openbao/sdk/helper/keysutil/lock_manager.go)
- `function:2a87cace92603382e5beb4edd336728b` function NewPolicy (third_party/openbao/sdk/helper/keysutil/policy.go)
- `function:3e4f6969d3d1220e944bc8d8c35af55c` function LoadPolicy (third_party/openbao/sdk/helper/keysutil/policy.go)
- `function:67bb5a5d146c913f3def9109fe428458` function ParsePKCS8RSAPSSPrivateKey (third_party/openbao/sdk/helper/keysutil/util.go)
- `function:9341a61164694f2381542a5ad588a34f` function NewTransitLRU (third_party/openbao/sdk/helper/keysutil/transit_lru.go)
- `function:976f7d9bd248b78ce77da2af83a3520a` function NewEncryptedKeyStorageWrapper (third_party/openbao/sdk/helper/keysutil/encrypted_key_storage.go)
- `function:ad43b9f8f61564bcf485a7abff33e733` function ParsePKCS8Ed25519PrivateKey (third_party/openbao/sdk/helper/keysutil/util.go)
- `function:ff0ce92c8a83e968af8cfdafd51c6c30` function NewTransitSyncMap (third_party/openbao/sdk/helper/keysutil/transit_syncmap.go)
- `interface:830141fa8d760b438f5e31d59851eed4` interface AssociatedDataFactory (third_party/openbao/sdk/helper/keysutil/policy.go)
- `interface:8721bc8e07dffc831f75f3386e9b1e9e` interface ExternalKeyFactory (third_party/openbao/sdk/helper/keysutil/policy.go)
- `interface:9909f324cd2f9daa8c6582439ed2481b` interface Cache (third_party/openbao/sdk/helper/keysutil/cache.go)
- `method:04fee9ba96ea41388d07e107983293f0` method Cache.Load (third_party/openbao/sdk/helper/keysutil/cache.go)
- `method:05a633f13a53cd56881b9282c90c3a06` method LockManager.DeletePolicy (third_party/openbao/sdk/helper/keysutil/lock_manager.go)
- `method:06ff2de84e1bf2a6067702e4f33f0ede` method TransitSyncMap.Store (third_party/openbao/sdk/helper/keysutil/transit_syncmap.go)
- `method:0767af2699882fc39febeb829acf25e6` method Policy.VerifySignatureWithOptions (third_party/openbao/sdk/helper/keysutil/policy.go)
- `method:0b460a8ecbf1bf5d8ab82e9760252e29` method eksTransaction.Commit (third_party/openbao/sdk/helper/keysutil/encrypted_key_storage.go)
- `method:10c919ab6415c55c48deccde25449eef` method KeyType.KeyAgreementSupported (third_party/openbao/sdk/helper/keysutil/policy.go)
- `method:15d0f30ac3e1f0e49998469698347e87` method encryptedKeyStorage.Delete (third_party/openbao/sdk/helper/keysutil/encrypted_key_storage.go)
- `method:16451025956eadbc37c061c25f4da7d0` method Policy.Encrypt (third_party/openbao/sdk/helper/keysutil/policy.go)
- `method:17d516a3037d30a8b92859b7d264dab6` method encryptedKeyStorage.Get (third_party/openbao/sdk/helper/keysutil/encrypted_key_storage.go)
- `method:18f575ec48059faf1241d919a2544a20` method Policy.DecryptWithFactory (third_party/openbao/sdk/helper/keysutil/policy.go)
- `method:1b95308c2ca66c604eb82a180508c114` method Policy.MigrateKeyToKeysMap (third_party/openbao/sdk/helper/keysutil/policy.go)
- `method:1c333695df8590a153afbc640ee61eaf` method eksTransaction.Rollback (third_party/openbao/sdk/helper/keysutil/encrypted_key_storage.go)
- `method:201d5bbcc21048371fbf654450813940` method Policy.Backup (third_party/openbao/sdk/helper/keysutil/policy.go)
- `method:2102a48552a9a1f8264afd940ee07b38` method Policy.SignWithOptions (third_party/openbao/sdk/helper/keysutil/policy.go)
- `method:23ede54f884d8ccf0c57cf484599e312` method KeyType.DecryptionSupported (third_party/openbao/sdk/helper/keysutil/policy.go)
- `method:257a9f13afec023d15e35113ce27240f` method Cache.Delete (third_party/openbao/sdk/helper/keysutil/cache.go)
- `method:26bd41c6ece3bf1034f147e1ee3d2f62` method Policy.WrapKey (third_party/openbao/sdk/helper/keysutil/policy.go)
- `method:2a0ee584815d96b65f4e206798cc3e7a` method KeyType.SigningSupported (third_party/openbao/sdk/helper/keysutil/policy.go)
- `method:2ad3b6f442876d1a25649fbba6052a34` method Policy.SymmetricEncryptRaw (third_party/openbao/sdk/helper/keysutil/policy.go)
- `method:2e8d9a0a75030b14e0da1bc2a9141c0d` method Policy.Unlock (third_party/openbao/sdk/helper/keysutil/policy.go)
- `method:2fc115aad9e7b5b1ec837bc8a1655523` method TransitLRU.Size (third_party/openbao/sdk/helper/keysutil/transit_lru.go)
- `method:345ac29b5e8076933e60f8d5ba8f8a90` method Policy.ImportPublicOrPrivate (third_party/openbao/sdk/helper/keysutil/policy.go)
- `method:354d08fd351c6f0abd215b8d77dfdac5` method Policy.Upgrade (third_party/openbao/sdk/helper/keysutil/policy.go)
- `method:355d1fe4be287bf0cf5a906147d00645` method Policy.Persist (third_party/openbao/sdk/helper/keysutil/policy.go)

_75 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
