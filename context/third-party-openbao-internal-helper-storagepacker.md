# Context: third-party-openbao-internal-helper-storagepacker

Repository: `deno-kcp`

The context exists to specify the storagepacker helper as a self-contained unit inside third_party/openbao: its public API surface (StoragePacker methods, NewStoragePacker, and the generated Item and Bucket protobuf types), the bucket-key derivation rule, the locking discipline around bucket reads and writes, and the decompress/unmarshal path that every accessor shares. Downstream OpenBao identity code (entity, group and local alias packers) depends on this contract.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/helper/storagepacker/storagepacker.go` file storagepacker.go (third_party/openbao/internal/helper/storagepacker/storagepacker.go)
- `file:third_party/openbao/internal/helper/storagepacker/storagepacker_test.go` file storagepacker_test.go (third_party/openbao/internal/helper/storagepacker/storagepacker_test.go)
- `file:third_party/openbao/internal/helper/storagepacker/types.pb.go` file types.pb.go (third_party/openbao/internal/helper/storagepacker/types.pb.go)
- `function:4892f08282d073624e43f94ce475fee6` function NewStoragePacker (third_party/openbao/internal/helper/storagepacker/storagepacker.go)
- `method:049b1e8a2dd343e87780ea246edd3ef8` method Item.Descriptor (third_party/openbao/internal/helper/storagepacker/types.pb.go)
- `method:10e9b5e3715357f041973d7049de9074` method Bucket.Descriptor (third_party/openbao/internal/helper/storagepacker/types.pb.go)
- `method:1159578d7a4da3a9fd69f7f0e4306da1` method StoragePacker.GetItemWithStorage (third_party/openbao/internal/helper/storagepacker/storagepacker.go)
- `method:1546f4edd249d0d3695dd4c507553908` method StoragePacker.DeleteItemWithStorage (third_party/openbao/internal/helper/storagepacker/storagepacker.go)
- `method:179f3e948667946b5b546752ec7bc650` method Bucket.String (third_party/openbao/internal/helper/storagepacker/types.pb.go)
- `method:2cfbb5f821065e71d5924e7165ee98f9` method StoragePacker.GetItem (third_party/openbao/internal/helper/storagepacker/storagepacker.go)
- `method:321be0b131494579b3aa1319e004d6a7` method StoragePacker.DeleteMultipleItemsWithStorage (third_party/openbao/internal/helper/storagepacker/storagepacker.go)
- `method:42f3f9816b6a170b513393fffff43893` method Bucket.GetKey (third_party/openbao/internal/helper/storagepacker/types.pb.go)
- `method:4ea68f2b375a5eea6b98426d184a0d6f` method StoragePacker.GetBucketWithStorage (third_party/openbao/internal/helper/storagepacker/storagepacker.go)
- `method:5605698b6e4089f58fb86f8b2b65ad2b` method Bucket.ProtoReflect (third_party/openbao/internal/helper/storagepacker/types.pb.go)
- `method:592d9a518c0875805f12e02d90a339ac` method StoragePacker.View (third_party/openbao/internal/helper/storagepacker/storagepacker.go)
- `method:5e3fdf8c8f26162e96b2b161c8aa945d` method Item.Reset (third_party/openbao/internal/helper/storagepacker/types.pb.go)
- `method:611e4ddd411a973ce4af46b88d4fa0c4` method StoragePacker.SwapItem (third_party/openbao/internal/helper/storagepacker/storagepacker.go)
- `method:66509edfc33ffcf1d787d17b0fb16637` method StoragePacker.DeleteItem (third_party/openbao/internal/helper/storagepacker/storagepacker.go)
- `method:6ac054bf900c8bf5d29f5e78a2b77532` method StoragePacker.BucketKey (third_party/openbao/internal/helper/storagepacker/storagepacker.go)
- `method:76bff3d9582c9ee1235c855401a80d84` method Item.GetMessage (third_party/openbao/internal/helper/storagepacker/types.pb.go)
- `method:7e26b61e01086a228327a23a0b563a8b` method StoragePacker.PutItem (third_party/openbao/internal/helper/storagepacker/storagepacker.go)
- `method:7e694fa25e23670857c162a3e4cd9a81` method Item.ProtoMessage (third_party/openbao/internal/helper/storagepacker/types.pb.go)
- `method:83e51dd628dadb708809a6bf4cf9db29` method Bucket.GetItems (third_party/openbao/internal/helper/storagepacker/types.pb.go)
- `method:9e2ec9cf1ba6e22915319d5d5005eefa` method StoragePacker.PutItemWithStorage (third_party/openbao/internal/helper/storagepacker/storagepacker.go)
- `method:a8c57b82f9f33f23ee6e78eab5d295d0` method StoragePacker.GetBucket (third_party/openbao/internal/helper/storagepacker/storagepacker.go)
- `method:adfd6fa74f9b4444771acf4ae78c244c` method Item.GetID (third_party/openbao/internal/helper/storagepacker/types.pb.go)
- `method:bab2d31f24172605e8831608bac645b9` method StoragePacker.DeleteMultipleItems (third_party/openbao/internal/helper/storagepacker/storagepacker.go)
- `method:bc645d9e7dfa3df175ac7ac28c113743` method Item.ProtoReflect (third_party/openbao/internal/helper/storagepacker/types.pb.go)
- `method:c071787e1e36cf1ccf963bf9475cbad7` method Bucket.GetItemMap (third_party/openbao/internal/helper/storagepacker/types.pb.go)
- `method:c81e2f6b6bcfff728d51c1107803927f` method Bucket.Reset (third_party/openbao/internal/helper/storagepacker/types.pb.go)
- `method:d8de1235f153a06f89034f59b08c58c1` method Bucket.ProtoMessage (third_party/openbao/internal/helper/storagepacker/types.pb.go)
- `method:f78bce098659e1f682294a1005489e26` method Item.String (third_party/openbao/internal/helper/storagepacker/types.pb.go)
- `struct:0f854771b8ae5763bc97cb1892ca0543` struct StoragePacker (third_party/openbao/internal/helper/storagepacker/storagepacker.go)
- `struct:9454ff7b70791135edc179fc55d3dab1` struct Item (third_party/openbao/internal/helper/storagepacker/types.pb.go)
- `struct:f591721ec484a2e5c1dd5e3324c995e9` struct Bucket (third_party/openbao/internal/helper/storagepacker/types.pb.go)
<!-- SPECD_MANAGED_END -->
