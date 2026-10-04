# Context: third-party-openbao-internal-builtin-credential-cert

Repository: `deno-kcp`

This context exists so the vendored certificate auth backend can be described and reasoned about as a unit inside deno-kcp without reading the whole OpenBao tree. It fixes the contract of the plugin boundary (Factory, Backend), the persisted models (CertEntry, CRLInfo, CDPInfo, RevokedSerialInfo, config), the login parsing type ParsedCert, the CLI surface CLIHandler, and the test-only OCSP responder abstractions (Source, Stats, Responder) so that callers and tests can rely on those shapes staying stable.

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
interfaces:
- file: third_party/openbao/internal/builtin/credential/cert/backend.go
  kind: function
  name: Backend
  signature: func Backend() *backend
- file: third_party/openbao/internal/builtin/credential/cert/path_crls.go
  kind: struct
  name: CDPInfo
  signature: type CDPInfo struct
- file: third_party/openbao/internal/builtin/credential/cert/cli.go
  kind: struct
  name: CLIHandler
  signature: type CLIHandler struct
- file: third_party/openbao/internal/builtin/credential/cert/cli.go
  kind: method
  name: CLIHandler.Auth
  signature: func (c *CLIHandler) Auth(c *api.Client, m map[string]string, nonInteractive
    bool) (*api.Secret, error)
- file: third_party/openbao/internal/builtin/credential/cert/cli.go
  kind: method
  name: CLIHandler.Help
  signature: func (c *CLIHandler) Help() string
- file: third_party/openbao/internal/builtin/credential/cert/path_crls.go
  kind: struct
  name: CRLInfo
  signature: type CRLInfo struct
- file: third_party/openbao/internal/builtin/credential/cert/path_certs.go
  kind: struct
  name: CertEntry
  signature: type CertEntry struct
- file: third_party/openbao/internal/builtin/credential/cert/backend.go
  kind: function
  name: Factory
  signature: func Factory(ctx context.Context, conf *logical.BackendConfig) (logical.Backend,
    error)
- file: third_party/openbao/internal/builtin/credential/cert/test_responder.go
  kind: type_alias
  name: InMemorySource
  signature: type InMemorySource = inMemorySource
- file: third_party/openbao/internal/builtin/credential/cert/test_responder.go
  kind: method
  name: InMemorySource.Response
  signature: func (s *inMemorySource) Response(request *ocsp.Request) ([]byte, http.Header,
    error)
- file: third_party/openbao/internal/builtin/credential/cert/test_responder.go
  kind: function
  name: NewResponder
  signature: func NewResponder(t logger, source Source, stats Stats) *Responder
- file: third_party/openbao/internal/builtin/credential/cert/path_login.go
  kind: struct
  name: ParsedCert
  signature: type ParsedCert struct
- file: third_party/openbao/internal/builtin/credential/cert/test_responder.go
  kind: struct
  name: Responder
  signature: type Responder struct
- file: third_party/openbao/internal/builtin/credential/cert/test_responder.go
  kind: method
  name: Responder.ServeHTTP
  signature: func (r *Responder) ServeHTTP(response http.ResponseWriter, request *http.Request)
- file: third_party/openbao/internal/builtin/credential/cert/path_crls.go
  kind: struct
  name: RevokedSerialInfo
  signature: type RevokedSerialInfo struct
- file: third_party/openbao/internal/builtin/credential/cert/test_responder.go
  kind: interface
  name: Source
  signature: type Source interface { Response(*ocsp.Request) ([]byte, http.Header,
    error) }
- file: third_party/openbao/internal/builtin/credential/cert/test_responder.go
  kind: method
  name: Source.Response
  signature: Response(*ocsp.Request) ([]byte, http.Header, error)
- file: third_party/openbao/internal/builtin/credential/cert/test_responder.go
  kind: interface
  name: Stats
  signature: type Stats interface { ResponseStatus(ocsp.ResponseStatus) }
- file: third_party/openbao/internal/builtin/credential/cert/test_responder.go
  kind: method
  name: Stats.ResponseStatus
  signature: ResponseStatus(ocsp.ResponseStatus)
- file: third_party/openbao/internal/builtin/credential/cert/path_certs.go
  kind: method
  name: backend.Cert
  signature: func (b *backend) Cert(ctx context.Context, s logical.Storage, n string)
    (*CertEntry, error)
- file: third_party/openbao/internal/builtin/credential/cert/path_config.go
  kind: method
  name: backend.Config
  signature: func (b *backend) Config(ctx context.Context, s logical.Storage) (*config,
    error)
- file: third_party/openbao/internal/builtin/credential/cert/test_responder.go
  kind: method
  name: logger.Log
  signature: Log(args ...any)
requirements:
- codeRefs:
  - function:42cceadbbd0f8df40027590f47656487
  id: r.backend-credential-type
  level: MUST
  text: Backend must declare itself a credential backend, leave login unauthenticated,
    and bind AuthRenew, Invalidate, InitializeFunc and PeriodicFunc.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/cert/backend.go
  - function:42cceadbbd0f8df40027590f47656487
  id: r.backend-registers-paths
  level: MUST
  text: Backend must build the framework backend with the config, login, cert list,
    cert, CRL list and CRL paths registered.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/cert/path_certs.go
  - struct:e446e9e05f48ea7c891d27cfa34a529d
  id: r.cert-entry-model
  level: MUST
  text: CertEntry must be the persisted model for a trusted certificate, holding its
    display name, certificate, allowed names, and OCSP and CRL settings.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/cert/path_certs.go
  - method:2d9f47bd78bc973dc683c9f0f9d94e2e
  id: r.cert-entry-read
  level: MUST
  text: backend.Cert must load a single certificate entry by name from logical.Storage
    and return a *CertEntry.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/cert/cli.go
  - method:8556abce7d0cf924ce7ee08a61eebea2
  - struct:60313d404e3b3e8b40f051ee5df4e931
  id: r.cli-auth
  level: MUST
  text: CLIHandler.Auth must read the certificate and key material from the flag map
    and perform the login against the API client, prompting interactively unless nonInteractive
    is set.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/cert/cli.go
  - method:f32b6755c5f86dee518395e8e7e15635
  id: r.cli-help
  level: SHOULD
  text: CLIHandler.Help must return the usage text listing the certificate and key
    flags.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/cert/path_config.go
  - method:cf22b5c6d810aee02ceca1e0d1296d3a
  id: r.config-read
  level: MUST
  text: backend.Config must read the stored backend configuration from logical.Storage
    and return a *config.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/cert/path_crls.go
  - struct:01e4d3c7ec30c3564df9a9b16bd278fb
  - struct:6bbd456d2f678c9d1fba6ab37f0b52d6
  - struct:c7aa588f816dd55064a102f183d866c4
  id: r.crl-models
  level: SHOULD
  text: CRLInfo, CDPInfo and RevokedSerialInfo must model a fetched CRL, a CRL distribution
    point, and a revoked serial with its revocation time.
- codeRefs:
  - function:42cceadbbd0f8df40027590f47656487
  id: r.crl-update-mutex
  level: MUST
  text: Backend must initialize the CRL update mutex before the backend is returned.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/cert/backend.go
  - function:859819ac737a5574ef6b1770d830c0a7
  id: r.factory-builds-backend
  level: MUST
  text: Factory must construct the certificate auth backend from a logical.BackendConfig
    and return it as a logical.Backend, or an error if Setup fails.
- codeRefs:
  - method:5821e773476c6b95e496711d61fcea30
  - type_alias:e76e1f58a9b7aa450c6c19a98833f224
  id: r.in-memory-source
  level: MUST
  text: InMemorySource must be a Source usable in tests, answering each ocsp.Request
    with response bytes and headers.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/cert/path_login.go
  - struct:5604b58f9ff783036d182617e1fee2c2
  id: r.login-parsed-cert
  level: MUST
  text: ParsedCert must carry the parsed client certificate together with its extracted
    leaf and chain so login can match it against configuration.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/cert/test_responder.go
  - interface:20094092bbb6241582f6aaf9352d521c
  - method:04baf26219751e66ee6104e3c0b6ec69
  id: r.ocsp-source
  level: MUST
  text: 'Source must abstract an OCSP responder: Response takes an *ocsp.Request and
    returns the response bytes and HTTP headers, or an error.'
- codeRefs:
  - function:38f23895e75370bf0ff233c1544baa5c
  - struct:666f3c7e4303a760c159dfad86d3eb1d
  id: r.responder-construction
  level: MUST
  text: NewResponder must build a *Responder from a logger, a Source and a Stats sink.
- codeRefs:
  - method:1f85655785aede6aa99b6317f9f1fb2d
  id: r.responder-logging
  level: MAY
  text: Responder may log through the logger it was built with, which must accept
    variadic arguments.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/cert/test_responder.go
  - method:ba7e314f6769e1b01e3f770e02f1d377
  id: r.responder-serve-http
  level: MUST
  text: Responder.ServeHTTP must decode the OCSP request from the HTTP request, obtain
    the response from its Source, record the status, and write the response to the
    client.
- codeRefs:
  - interface:52a6394aac3479b39b8f8ab4e92dd26a
  - method:69d1cc722f8b88ee968450b82e9a7167
  id: r.responder-stats
  level: SHOULD
  text: Stats must expose the last observed OCSP response status so tests can assert
    on the responder's behavior.
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
