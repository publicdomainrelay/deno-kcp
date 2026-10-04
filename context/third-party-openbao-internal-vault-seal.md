# Context: third-party-openbao-internal-vault-seal

Repository: `deno-kcp`

_(empty: write what this context is for)_

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/seal/envelope.go` file envelope.go (third_party/openbao/internal/vault/seal/envelope.go)
- `file:third_party/openbao/internal/vault/seal/envelope_test.go` file envelope_test.go (third_party/openbao/internal/vault/seal/envelope_test.go)
- `file:third_party/openbao/internal/vault/seal/seal.go` file seal.go (third_party/openbao/internal/vault/seal/seal.go)
- `file:third_party/openbao/internal/vault/seal/seal_testing.go` file seal_testing.go (third_party/openbao/internal/vault/seal/seal_testing.go)
- `file:third_party/openbao/internal/vault/seal/shamirwrapper.go` file shamirwrapper.go (third_party/openbao/internal/vault/seal/shamirwrapper.go)
- `function:1aaf573ed2a8369b18e6a50d2749296a` function NewShamirWrapper (third_party/openbao/internal/vault/seal/shamirwrapper.go)
- `function:3e10133f89ef87ae59ed5ee7d8a3b7f4` function NewEnvelope (third_party/openbao/internal/vault/seal/envelope.go)
- `function:6e518653c302086fa5426b31ecc2f2ae` function NewToggleableTestSeal (third_party/openbao/internal/vault/seal/seal_testing.go)
- `function:7b45c9a04bd194309dce481869223099` function NewAccess (third_party/openbao/internal/vault/seal/seal.go)
- `function:cca408f342c172647650ff95c4dd9415` function NewTestSeal (third_party/openbao/internal/vault/seal/seal_testing.go)
- `interface:afaac00a9d21de40718500c5552db29b` interface Access (third_party/openbao/internal/vault/seal/seal.go)
- `method:08dd01392a2ffad48955b6e6d56b4249` method Envelope.Decrypt (third_party/openbao/internal/vault/seal/envelope.go)
- `method:198506727e64615a95ab6e16470c9be7` method access.Decrypt (third_party/openbao/internal/vault/seal/seal.go)
- `method:2fb2247f7429da01a67ba082d67f21f6` method ToggleableWrapper.Encrypt (third_party/openbao/internal/vault/seal/seal_testing.go)
- `method:376305645ff538bdb39da47f01e54f53` method access.SetConfig (third_party/openbao/internal/vault/seal/seal.go)
- `method:3c14682bf7bce86369e14e82117840c6` method ToggleableWrapper.Decrypt (third_party/openbao/internal/vault/seal/seal_testing.go)
- `method:406d3ef61e8e1597a161b9ded005a763` method ShamirWrapper.Type (third_party/openbao/internal/vault/seal/shamirwrapper.go)
- `method:534a067b023f95ddc90393842d539036` method access.Type (third_party/openbao/internal/vault/seal/seal.go)
- `method:659bdc903ad58e0381560759a2574fa5` method access.Encrypt (third_party/openbao/internal/vault/seal/seal.go)
- `method:78a01eaa48707823c0b739d357034194` method ToggleableWrapper.Type (third_party/openbao/internal/vault/seal/seal_testing.go)
- `method:7c2f8152d3977a09f192703547cc2575` method access.Init (third_party/openbao/internal/vault/seal/seal.go)
- `method:89fa7ef068356304b22bb4e499ea7e7d` method Envelope.Encrypt (third_party/openbao/internal/vault/seal/envelope.go)
- `method:950b7978c38d4d12e8235cca4cf10175` method Access.GetWrapper (third_party/openbao/internal/vault/seal/seal.go)
- `method:a5e27741c3a39dd34050d0b0e1961eb8` method access.GetWrapper (third_party/openbao/internal/vault/seal/seal.go)
- `method:a8e0030bbe3e6d000d2d42e7ce9d1e05` method access.Finalize (third_party/openbao/internal/vault/seal/seal.go)
- `method:bc4a91e21f497d9d9430cf90f7a7ac3e` method ToggleableWrapper.SetError (third_party/openbao/internal/vault/seal/seal_testing.go)
- `method:dd0c7dd26901375dc159bc6bb8b7895e` method access.KeyId (third_party/openbao/internal/vault/seal/seal.go)
- `struct:34990802a106e2116f074603b03f9633` struct ShamirWrapper (third_party/openbao/internal/vault/seal/shamirwrapper.go)
- `struct:479850c12230725a85d5623e41c503de` struct TestSealOpts (third_party/openbao/internal/vault/seal/seal_testing.go)
- `struct:a72f879be1bbf0cdf0f1372de5ca30cb` struct ToggleableWrapper (third_party/openbao/internal/vault/seal/seal_testing.go)
- `struct:cde35b63b8efef4de773f1fe38d109cc` struct Envelope (third_party/openbao/internal/vault/seal/envelope.go)
<!-- SPECD_MANAGED_END -->
