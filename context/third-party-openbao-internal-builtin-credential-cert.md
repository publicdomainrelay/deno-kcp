# Context: third-party-openbao-internal-builtin-credential-cert

Repository: `deno-kcp`

_(empty: write what this context is for)_

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/credential/cert/backend.go` file backend.go (third_party/openbao/internal/builtin/credential/cert/backend.go)
- `file:third_party/openbao/internal/builtin/credential/cert/backend_test.go` file backend_test.go (third_party/openbao/internal/builtin/credential/cert/backend_test.go)
- `file:third_party/openbao/internal/builtin/credential/cert/cli.go` file cli.go (third_party/openbao/internal/builtin/credential/cert/cli.go)
- `file:third_party/openbao/internal/builtin/credential/cert/path_certs.go` file path_certs.go (third_party/openbao/internal/builtin/credential/cert/path_certs.go)
- `file:third_party/openbao/internal/builtin/credential/cert/path_config.go` file path_config.go (third_party/openbao/internal/builtin/credential/cert/path_config.go)
- `file:third_party/openbao/internal/builtin/credential/cert/path_crls.go` file path_crls.go (third_party/openbao/internal/builtin/credential/cert/path_crls.go)
- `file:third_party/openbao/internal/builtin/credential/cert/path_crls_test.go` file path_crls_test.go (third_party/openbao/internal/builtin/credential/cert/path_crls_test.go)
- `file:third_party/openbao/internal/builtin/credential/cert/path_login.go` file path_login.go (third_party/openbao/internal/builtin/credential/cert/path_login.go)
- `file:third_party/openbao/internal/builtin/credential/cert/path_login_test.go` file path_login_test.go (third_party/openbao/internal/builtin/credential/cert/path_login_test.go)
- `file:third_party/openbao/internal/builtin/credential/cert/test_responder.go` file test_responder.go (third_party/openbao/internal/builtin/credential/cert/test_responder.go)
- `function:38f23895e75370bf0ff233c1544baa5c` function NewResponder (third_party/openbao/internal/builtin/credential/cert/test_responder.go)
- `function:42cceadbbd0f8df40027590f47656487` function Backend (third_party/openbao/internal/builtin/credential/cert/backend.go)
- `function:859819ac737a5574ef6b1770d830c0a7` function Factory (third_party/openbao/internal/builtin/credential/cert/backend.go)
- `interface:20094092bbb6241582f6aaf9352d521c` interface Source (third_party/openbao/internal/builtin/credential/cert/test_responder.go)
- `interface:52a6394aac3479b39b8f8ab4e92dd26a` interface Stats (third_party/openbao/internal/builtin/credential/cert/test_responder.go)
- `method:04baf26219751e66ee6104e3c0b6ec69` method Source.Response (third_party/openbao/internal/builtin/credential/cert/test_responder.go)
- `method:1f85655785aede6aa99b6317f9f1fb2d` method logger.Log (third_party/openbao/internal/builtin/credential/cert/test_responder.go)
- `method:2d9f47bd78bc973dc683c9f0f9d94e2e` method backend.Cert (third_party/openbao/internal/builtin/credential/cert/path_certs.go)
- `method:5821e773476c6b95e496711d61fcea30` method InMemorySource.Response (third_party/openbao/internal/builtin/credential/cert/test_responder.go)
- `method:69d1cc722f8b88ee968450b82e9a7167` method Stats.ResponseStatus (third_party/openbao/internal/builtin/credential/cert/test_responder.go)
- `method:8556abce7d0cf924ce7ee08a61eebea2` method CLIHandler.Auth (third_party/openbao/internal/builtin/credential/cert/cli.go)
- `method:ba7e314f6769e1b01e3f770e02f1d377` method Responder.ServeHTTP (third_party/openbao/internal/builtin/credential/cert/test_responder.go)
- `method:cf22b5c6d810aee02ceca1e0d1296d3a` method backend.Config (third_party/openbao/internal/builtin/credential/cert/path_config.go)
- `method:f32b6755c5f86dee518395e8e7e15635` method CLIHandler.Help (third_party/openbao/internal/builtin/credential/cert/cli.go)
- `struct:01e4d3c7ec30c3564df9a9b16bd278fb` struct RevokedSerialInfo (third_party/openbao/internal/builtin/credential/cert/path_crls.go)
- `struct:5604b58f9ff783036d182617e1fee2c2` struct ParsedCert (third_party/openbao/internal/builtin/credential/cert/path_login.go)
- `struct:60313d404e3b3e8b40f051ee5df4e931` struct CLIHandler (third_party/openbao/internal/builtin/credential/cert/cli.go)
- `struct:666f3c7e4303a760c159dfad86d3eb1d` struct Responder (third_party/openbao/internal/builtin/credential/cert/test_responder.go)
- `struct:6bbd456d2f678c9d1fba6ab37f0b52d6` struct CRLInfo (third_party/openbao/internal/builtin/credential/cert/path_crls.go)
- `struct:c7aa588f816dd55064a102f183d866c4` struct CDPInfo (third_party/openbao/internal/builtin/credential/cert/path_crls.go)
- `struct:e446e9e05f48ea7c891d27cfa34a529d` struct CertEntry (third_party/openbao/internal/builtin/credential/cert/path_certs.go)
- `type_alias:e76e1f58a9b7aa450c6c19a98833f224` type_alias InMemorySource (third_party/openbao/internal/builtin/credential/cert/test_responder.go)
<!-- SPECD_MANAGED_END -->
