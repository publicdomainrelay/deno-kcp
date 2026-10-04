# Context: third-party-openbao-sdk-physical

Repository: `deno-kcp`

_(empty: write what this context is for)_

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/physical/cache.go` file cache.go (third_party/openbao/sdk/physical/cache.go)
- `file:third_party/openbao/sdk/physical/encoding.go` file encoding.go (third_party/openbao/sdk/physical/encoding.go)
- `file:third_party/openbao/sdk/physical/entry.go` file entry.go (third_party/openbao/sdk/physical/entry.go)
- `file:third_party/openbao/sdk/physical/error.go` file error.go (third_party/openbao/sdk/physical/error.go)
- `file:third_party/openbao/sdk/physical/latency.go` file latency.go (third_party/openbao/sdk/physical/latency.go)
- `file:third_party/openbao/sdk/physical/listing.go` file listing.go (third_party/openbao/sdk/physical/listing.go)
- `file:third_party/openbao/sdk/physical/physical.go` file physical.go (third_party/openbao/sdk/physical/physical.go)
- `file:third_party/openbao/sdk/physical/physical_access.go` file physical_access.go (third_party/openbao/sdk/physical/physical_access.go)
- `file:third_party/openbao/sdk/physical/physical_view.go` file physical_view.go (third_party/openbao/sdk/physical/physical_view.go)
- `file:third_party/openbao/sdk/physical/testing.go` file testing.go (third_party/openbao/sdk/physical/testing.go)
- `file:third_party/openbao/sdk/physical/transactions.go` file transactions.go (third_party/openbao/sdk/physical/transactions.go)
- `file:third_party/openbao/sdk/physical/write_notifier.go` file write_notifier.go (third_party/openbao/sdk/physical/write_notifier.go)
- `function:2773de0d74caf975495b1df34f2aa3f2` function NewLatencyInjector (third_party/openbao/sdk/physical/latency.go)
- `function:2c3211f729a5fb94085fd69b2f0be6c1` function NewPhysicalAccess (third_party/openbao/sdk/physical/physical_access.go)
- `function:34327220403569fa0aff0977c0c1f591` function NewCache (third_party/openbao/sdk/physical/cache.go)
- `function:34f9a200d286ca26f172fafe9c35b6d9` function ExerciseTransactionalBackend (third_party/openbao/sdk/physical/testing.go)
- `function:3aee5dde26ea2637ff9ca7a8b4120606` function NewWriteNotifier (third_party/openbao/sdk/physical/write_notifier.go)
- `function:53225bb6c155915c3d2308b06988e63d` function Prefixes (third_party/openbao/sdk/physical/physical.go)
- `function:535042a02a24c9c58620a8f8f73e5bf3` function UnfencedWriteCtx (third_party/openbao/sdk/physical/physical.go)
- `function:561c6b9266d3a78ad6b74428ac50ec7d` function NewPermitPool (third_party/openbao/sdk/physical/physical.go)
- `function:714984d2ed75dac6bfd87f642ad23447` function NewErrorInjector (third_party/openbao/sdk/physical/error.go)
- `function:72f695e0a898c83f112db456c8a1d4b1` function NewStorageEncoding (third_party/openbao/sdk/physical/encoding.go)
- `function:74f5abaeca87696c252646165f7d64bb` function NewView (third_party/openbao/sdk/physical/physical_view.go)
- `function:7a68fe5f09705029eb92a822dd50d285` function IsUnfencedWrite (third_party/openbao/sdk/physical/physical.go)
- `function:ab3724de969fbcf4b7c60877fe893a52` function ExerciseBackend_ListPrefix (third_party/openbao/sdk/physical/testing.go)
- `function:cdf9401bd1ce3d8e201d0bb21c095eb2` function ExerciseBackend (third_party/openbao/sdk/physical/testing.go)
- `function:f38102f89c2dd4dd5ab77bd257bb3242` function ExerciseHABackend (third_party/openbao/sdk/physical/testing.go)
- `function:ff4d7eee1ee723e8b6728c7b4904d7b3` function CacheRefreshContext (third_party/openbao/sdk/physical/cache.go)
- `interface:0047ee89f59f43dfe4e94ec0eee269e1` interface TransactionalStorageEncoding (third_party/openbao/sdk/physical/encoding.go)
- `interface:05f1884eee66d15665c49c8df37093e2` interface FencingHABackend (third_party/openbao/sdk/physical/physical.go)
- `interface:08ffcc14df3c8b65543b0d305373c3e9` interface Transaction (third_party/openbao/sdk/physical/transactions.go)
- `interface:105a98988cc407ace2a693c323fe82f0` interface RedirectDetect (third_party/openbao/sdk/physical/physical.go)
- `interface:13bd2e0d23b764cee32c11c2f8dc9018` interface ReplicationIndexBackend (third_party/openbao/sdk/physical/physical.go)
- `interface:3abc2ea0c97155337bff68b1c25b282d` interface StorageEncoding (third_party/openbao/sdk/physical/encoding.go)
- `interface:3d13c6617dfad919aaca553fabf6b528` interface CacheInvalidationBackend (third_party/openbao/sdk/physical/physical.go)
- `interface:3e369c75b5f78584ecb1fb21b4e3f76d` interface Cache (third_party/openbao/sdk/physical/cache.go)
- `interface:5b84e8caa4286b4b2b689fd80ebd982c` interface ErrorInjector (third_party/openbao/sdk/physical/error.go)
- `interface:78bc32a027b56ca8606681d66c086d75` interface RemoteLock (third_party/openbao/sdk/physical/physical.go)
- `interface:8c498e2cc09fa8cf2e6cebb864101897` interface HABackend (third_party/openbao/sdk/physical/physical.go)
- `interface:9852d12ad0d3e5dbdf54721c45db0b05` interface Transactional (third_party/openbao/sdk/physical/transactions.go)
- `interface:a169b37932f13dfaab67c2887a0b2628` interface TransactionalBackend (third_party/openbao/sdk/physical/transactions.go)
- `interface:c42dc92aaf803810f2890fe01b5c2e74` interface Backend (third_party/openbao/sdk/physical/physical.go)
- `interface:c4f6350d056e8dd0c44a4be82e5f4d52` interface Lock (third_party/openbao/sdk/physical/physical.go)
- `interface:c551f864d0a2d50fbce634ac814b194c` interface TransactionalCache (third_party/openbao/sdk/physical/cache.go)
- `interface:c55488afd8098351787fbc2017fc50be` interface StorageEncodingTransaction (third_party/openbao/sdk/physical/encoding.go)
- `interface:d74a7bde4c43f84103136095df7eeee9` interface ToggleablePurgemonster (third_party/openbao/sdk/physical/physical.go)
- `method:06bfe54d55d7d12ca01fad789ea1d1c5` method PhysicalAccess.Delete (third_party/openbao/sdk/physical/physical_access.go)
- `method:0775930799b3c6c71386dbd6956849ae` method storageEncoding.Put (third_party/openbao/sdk/physical/encoding.go)
- `method:082b9444e66f470df2382ba626b3d47c` method Lister.ListPage (third_party/openbao/sdk/physical/listing.go)

_103 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
