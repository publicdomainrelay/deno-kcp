# Context: third-party-openbao-internal-vault-barrier

Repository: `deno-kcp`

_(empty: write what this context is for)_

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/barrier/aes_gcm.go` file aes_gcm.go (third_party/openbao/internal/vault/barrier/aes_gcm.go)
- `file:third_party/openbao/internal/vault/barrier/aes_gcm_test.go` file aes_gcm_test.go (third_party/openbao/internal/vault/barrier/aes_gcm_test.go)
- `file:third_party/openbao/internal/vault/barrier/barrier.go` file barrier.go (third_party/openbao/internal/vault/barrier/barrier.go)
- `file:third_party/openbao/internal/vault/barrier/barrier_test.go` file barrier_test.go (third_party/openbao/internal/vault/barrier/barrier_test.go)
- `file:third_party/openbao/internal/vault/barrier/keyring.go` file keyring.go (third_party/openbao/internal/vault/barrier/keyring.go)
- `file:third_party/openbao/internal/vault/barrier/keyring_test.go` file keyring_test.go (third_party/openbao/internal/vault/barrier/keyring_test.go)
- `file:third_party/openbao/internal/vault/barrier/testing.go` file testing.go (third_party/openbao/internal/vault/barrier/testing.go)
- `file:third_party/openbao/internal/vault/barrier/view.go` file view.go (third_party/openbao/internal/vault/barrier/view.go)
- `file:third_party/openbao/internal/vault/barrier/view_test.go` file view_test.go (third_party/openbao/internal/vault/barrier/view_test.go)
- `function:212ac5b5fd50f9ea86b12a89c0b268b8` function DeserializeKey (third_party/openbao/internal/vault/barrier/keyring.go)
- `function:78ee8569bf4e3161bf35d7493cf7be23` function NewKeyring (third_party/openbao/internal/vault/barrier/keyring.go)
- `function:cc55fdbd079856880adf56c011277b95` function NewView (third_party/openbao/internal/vault/barrier/view.go)
- `function:d5a8564281df503f3fd2e06388caf481` function NewAESGCMBarrier (third_party/openbao/internal/vault/barrier/aes_gcm.go)
- `function:f04155311a4b35251245e079d6615601` function DeserializeKeyring (third_party/openbao/internal/vault/barrier/keyring.go)
- `function:fcf85cd1dc11b0be141bc2116f96ce2a` function MockBarrier (third_party/openbao/internal/vault/barrier/testing.go)
- `interface:0d8475f05a238a682dc72e8d4a9f5455` interface TransactionalSecurityBarrier (third_party/openbao/internal/vault/barrier/barrier.go)
- `interface:1b96c08c3514ee79d57ae665713d52bd` interface View (third_party/openbao/internal/vault/barrier/view.go)
- `interface:207898b6e4cd19e2d7fa89cc07044e22` interface Encryptor (third_party/openbao/internal/vault/barrier/barrier.go)
- `interface:a367f77e485ff5f9a8787e3f91db2843` interface TransactionalView (third_party/openbao/internal/vault/barrier/view.go)
- `interface:ea02f92865540d966019e6a844381766` interface SecurityBarrierCore (third_party/openbao/internal/vault/barrier/barrier.go)
- `interface:ed5e38b34fcfa33e1a7cf94fa7ccd051` interface SecurityBarrierTransaction (third_party/openbao/internal/vault/barrier/barrier.go)
- `interface:f0e627c72ef8d3aa115f0653867c751b` interface SecurityBarrier (third_party/openbao/internal/vault/barrier/barrier.go)
- `interface:f5eddde16b4c4941ccf3302e837e6419` interface ViewTransaction (third_party/openbao/internal/vault/barrier/view.go)
- `method:01f46b2e1487c02a24ffbe9e07454e05` method AESGCMBarrier.Get (third_party/openbao/internal/vault/barrier/aes_gcm.go)
- `method:03ddb9678c65fca974cf74a8781d7c11` method view.ListPage (third_party/openbao/internal/vault/barrier/view.go)
- `method:03f87e1361b5c863025fdf331b9c268e` method SecurityBarrierCore.RotationConfig (third_party/openbao/internal/vault/barrier/barrier.go)
- `method:04da6e33f37a8852acc37c873f68b861` method SecurityBarrierCore.RotateRootKey (third_party/openbao/internal/vault/barrier/barrier.go)
- `method:09e8ac98b3f4f584ac98f696ab52f28b` method SecurityBarrierCore.GenerateKey (third_party/openbao/internal/vault/barrier/barrier.go)
- `method:152a9953f667d702bfbd60f1ca262ea4` method SecurityBarrierCore.SetReadOnly (third_party/openbao/internal/vault/barrier/barrier.go)
- `method:16d8d732e71b4460a802f98d9fd0a077` method AESGCMBarrierTransaction.List (third_party/openbao/internal/vault/barrier/aes_gcm.go)
- `method:189e94bd01af44917df86e7cdd4691c4` method AESGCMBarrierTransaction.Delete (third_party/openbao/internal/vault/barrier/aes_gcm.go)
- `method:18a38a790007525544cf0b64d40e6998` method AESGCMBarrier.CheckUpgrade (third_party/openbao/internal/vault/barrier/aes_gcm.go)
- `method:1b5d06a834f190c451d862cd684144d1` method SecurityBarrierCore.KeyLength (third_party/openbao/internal/vault/barrier/barrier.go)
- `method:1c12ece98e58fef4e317440c506c67c1` method AESGCMBarrier.TotalLocalEncryptions (third_party/openbao/internal/vault/barrier/aes_gcm.go)
- `method:1ea2514dab7b64705327ac0b243dbdb9` method AESGCMBarrier.List (third_party/openbao/internal/vault/barrier/aes_gcm.go)
- `method:1fc75f2c0105cd52e6dd108008474608` method SecurityBarrierCore.Seal (third_party/openbao/internal/vault/barrier/barrier.go)
- `method:212982b4180c6b7aa27f08992aad6080` method AESGCMBarrierTransaction.ListPage (third_party/openbao/internal/vault/barrier/aes_gcm.go)
- `method:28339de270d301e0fd81b191a3775f29` method AESGCMBarrier.RotationConfig (third_party/openbao/internal/vault/barrier/aes_gcm.go)
- `method:2b4fe8762429aec39a4180bd07ebbf45` method AESGCMBarrier.Keyring (third_party/openbao/internal/vault/barrier/aes_gcm.go)
- `method:2cd6cb9190ead5e50ddb06dc4b234923` method viewCore.Prefix (third_party/openbao/internal/vault/barrier/view.go)
- `method:356fb99e742cb25010fbb4e6e2f5e34e` method AESGCMBarrier.SetReadOnly (third_party/openbao/internal/vault/barrier/aes_gcm.go)
- `method:378543af250556d7ec61185e20e1a22f` method viewTransaction.Commit (third_party/openbao/internal/vault/barrier/view.go)
- `method:3c0cd9988a47cc0dc81f14427b7517c5` method KeyRotationConfig.Equals (third_party/openbao/internal/vault/barrier/keyring.go)
- `method:3cf5455e54a41cacd1318c8e0a7a4653` method SecurityBarrierCore.ReloadRootKey (third_party/openbao/internal/vault/barrier/barrier.go)

_87 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
