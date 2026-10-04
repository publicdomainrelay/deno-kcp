# Context: third-party-openbao-internal-builtin-credential-jwt

Repository: `deno-kcp`

This context exists because the JWT/OIDC auth plugin is vendored third-party OpenBao code inside deno-kcp, and it needs one spec that states what the package actually provides: the backend factory, the CLI login handler, the QR rendering writer, the CustomProvider contract, the three optional provider extension interfaces, the provider registry and resolution function, and the five concrete provider implementations. Recording these interfaces and requirements makes the vendored plugin's public surface explicit, so that changes to it, or reliance on it from elsewhere in the repository, can be checked against a stated contract instead of re-reading the files.

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
interfaces:
- file: third_party/openbao/internal/builtin/credential/jwt/provider_azure.go
  kind: struct
  name: AzureProvider
  signature: type AzureProvider struct{}
- file: third_party/openbao/internal/builtin/credential/jwt/provider_azure.go
  kind: method
  name: AzureProvider.FetchGroups
  signature: func (_ context.Context, b *jwtAuthBackend, allClaims map[string]any,
    role *jwtRole, tokenSource oauth2.TokenSource) (any, error)
- file: third_party/openbao/internal/builtin/credential/jwt/provider_azure.go
  kind: method
  name: AzureProvider.Initialize
  signature: func (_ context.Context, _ *jwtConfig) error
- file: third_party/openbao/internal/builtin/credential/jwt/provider_azure.go
  kind: method
  name: AzureProvider.SensitiveKeys
  signature: func () []string
- file: third_party/openbao/internal/builtin/credential/jwt/cli.go
  kind: struct
  name: CLIHandler
  signature: type CLIHandler struct{}
- file: third_party/openbao/internal/builtin/credential/jwt/cli.go
  kind: method
  name: CLIHandler.Auth
  signature: func (c *api.Client, m map[string]string, nonInteractive bool) (*api.Secret,
    error)
- file: third_party/openbao/internal/builtin/credential/jwt/cli.go
  kind: method
  name: CLIHandler.Help
  signature: func () string
- file: third_party/openbao/internal/builtin/credential/jwt/provider_config.go
  kind: interface
  name: CustomProvider
  signature: type CustomProvider interface
- file: third_party/openbao/internal/builtin/credential/jwt/provider_config.go
  kind: method
  name: CustomProvider.Initialize
  signature: func (context.Context, *jwtConfig) error
- file: third_party/openbao/internal/builtin/credential/jwt/provider_config.go
  kind: method
  name: CustomProvider.SensitiveKeys
  signature: func () []string
- file: third_party/openbao/internal/builtin/credential/jwt/backend.go
  kind: function
  name: Factory
  signature: func Factory(ctx context.Context, c *logical.BackendConfig) (logical.Backend,
    error)
- file: third_party/openbao/internal/builtin/credential/jwt/provider_gsuite.go
  kind: struct
  name: GSuiteProvider
  signature: type GSuiteProvider struct{}
- file: third_party/openbao/internal/builtin/credential/jwt/provider_gsuite.go
  kind: method
  name: GSuiteProvider.FetchGroups
  signature: func (ctx context.Context, b *jwtAuthBackend, allClaims map[string]any,
    role *jwtRole, _ oauth2.TokenSource) (any, error)
- file: third_party/openbao/internal/builtin/credential/jwt/provider_gsuite.go
  kind: method
  name: GSuiteProvider.FetchUserInfo
  signature: func (ctx context.Context, b *jwtAuthBackend, allClaims map[string]any,
    role *jwtRole) error
- file: third_party/openbao/internal/builtin/credential/jwt/provider_gsuite.go
  kind: method
  name: GSuiteProvider.Initialize
  signature: func (ctx context.Context, jc *jwtConfig) error
- file: third_party/openbao/internal/builtin/credential/jwt/provider_gsuite.go
  kind: method
  name: GSuiteProvider.SensitiveKeys
  signature: func () []string
- file: third_party/openbao/internal/builtin/credential/jwt/provider_gsuite.go
  kind: struct
  name: GSuiteProviderConfig
  signature: type GSuiteProviderConfig struct{}
- file: third_party/openbao/internal/builtin/credential/jwt/provider_config.go
  kind: interface
  name: GroupsFetcher
  signature: type GroupsFetcher interface
- file: third_party/openbao/internal/builtin/credential/jwt/provider_config.go
  kind: method
  name: GroupsFetcher.FetchGroups
  signature: func (context.Context, *jwtAuthBackend, map[string]any, *jwtRole, oauth2.TokenSource)
    (any, error)
- file: third_party/openbao/internal/builtin/credential/jwt/provider_ibmisam.go
  kind: struct
  name: IBMISAMProvider
  signature: type IBMISAMProvider struct{}
- file: third_party/openbao/internal/builtin/credential/jwt/provider_ibmisam.go
  kind: method
  name: IBMISAMProvider.FetchGroups
  signature: func (_ context.Context, b *jwtAuthBackend, allClaims map[string]any,
    role *jwtRole, _ oauth2.TokenSource) (any, error)
- file: third_party/openbao/internal/builtin/credential/jwt/provider_ibmisam.go
  kind: method
  name: IBMISAMProvider.Initialize
  signature: func (_ context.Context, _ *jwtConfig) error
- file: third_party/openbao/internal/builtin/credential/jwt/provider_ibmisam.go
  kind: method
  name: IBMISAMProvider.SensitiveKeys
  signature: func () []string
- file: third_party/openbao/internal/builtin/credential/jwt/provider_config.go
  kind: interface
  name: KeySetDiscovery
  signature: type KeySetDiscovery interface
- file: third_party/openbao/internal/builtin/credential/jwt/provider_config.go
  kind: method
  name: KeySetDiscovery.NewKeySet
  signature: func (context.Context) (jwt.KeySet, error)
- file: third_party/openbao/internal/builtin/credential/jwt/provider_kubernetes.go
  kind: struct
  name: KubernetesProvider
  signature: type KubernetesProvider struct{}
- file: third_party/openbao/internal/builtin/credential/jwt/provider_kubernetes.go
  kind: method
  name: KubernetesProvider.Initialize
  signature: func (_ context.Context, jc *jwtConfig) error
- file: third_party/openbao/internal/builtin/credential/jwt/provider_kubernetes.go
  kind: method
  name: KubernetesProvider.NewKeySet
  signature: func (ctx context.Context) (jwt.KeySet, error)
- file: third_party/openbao/internal/builtin/credential/jwt/provider_kubernetes.go
  kind: method
  name: KubernetesProvider.SensitiveKeys
  signature: func () []string
- file: third_party/openbao/internal/builtin/credential/jwt/provider_config.go
  kind: function
  name: NewProviderConfig
  signature: func NewProviderConfig(ctx context.Context, jc *jwtConfig, providerMap
    map[string]CustomProvider) (CustomProvider, error)
- file: third_party/openbao/internal/builtin/credential/jwt/provider_config.go
  kind: function
  name: ProviderMap
  signature: func ProviderMap() map[string]CustomProvider
- file: third_party/openbao/internal/builtin/credential/jwt/provider_secureauth.go
  kind: struct
  name: SecureAuthProvider
  signature: type SecureAuthProvider struct{}
- file: third_party/openbao/internal/builtin/credential/jwt/provider_secureauth.go
  kind: method
  name: SecureAuthProvider.FetchGroups
  signature: func (_ context.Context, b *jwtAuthBackend, allClaims map[string]any,
    role *jwtRole, _ oauth2.TokenSource) (any, error)
- file: third_party/openbao/internal/builtin/credential/jwt/provider_secureauth.go
  kind: method
  name: SecureAuthProvider.Initialize
  signature: func (_ context.Context, _ *jwtConfig) error
- file: third_party/openbao/internal/builtin/credential/jwt/provider_secureauth.go
  kind: method
  name: SecureAuthProvider.SensitiveKeys
  signature: func () []string
- file: third_party/openbao/internal/builtin/credential/jwt/provider_config.go
  kind: interface
  name: UserInfoFetcher
  signature: type UserInfoFetcher interface
- file: third_party/openbao/internal/builtin/credential/jwt/provider_config.go
  kind: method
  name: UserInfoFetcher.FetchUserInfo
  signature: func (context.Context, *jwtAuthBackend, map[string]any, *jwtRole) error
- file: third_party/openbao/internal/builtin/credential/jwt/provider_kubernetes.go
  kind: method
  name: bearerAuthRoundTripper.RoundTrip
  signature: func (req *http.Request) (*http.Response, error)
- file: third_party/openbao/internal/builtin/credential/jwt/path_cel_role.go
  kind: method
  name: celRoleEntry.ToResponseData
  signature: func () map[string]any
- file: third_party/openbao/internal/builtin/credential/jwt/path_config.go
  kind: method
  name: jwtAuthBackend.OverrideAllowedServerNames
  signature: func (config *tls.Config, allowedServerNames []string) error
- file: third_party/openbao/internal/builtin/credential/jwt/path_config.go
  kind: method
  name: jwtAuthBackend.OverrideRootCAs
  signature: func (config *tls.Config, caPEM string) error
- file: third_party/openbao/internal/builtin/credential/jwt/cli_qr.go
  kind: method
  name: qrWriter.Close
  signature: func () error
- file: third_party/openbao/internal/builtin/credential/jwt/cli_qr.go
  kind: method
  name: qrWriter.Write
  signature: func (mat qrcode.Matrix) error
requirements:
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/jwt/provider_azure.go
  - method:9c1a85349889175dd19ebc5b4c234d0e
  - method:f23f86a746915df19ece4ee0652b2635
  - method:f44a301c51f8a3354f996a4e86555eb0
  - struct:a7f127fd95102100f0f18d76de51bebf
  id: r.azure-provider
  level: MUST
  text: AzureProvider must implement CustomProvider by providing Initialize and SensitiveKeys,
    and must implement GroupsFetcher to read Azure group claims using a token source.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/jwt/path_cel_role.go
  - method:d1bc9606c8ea747394528f2e0ff8fcca
  id: r.cel-role-response-data
  level: SHOULD
  text: celRoleEntry must expose ToResponseData so a CEL role can be returned to callers
    as a map including its name, program, message, leeway durations, and bound audiences.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/jwt/cli.go
  - method:2ea83227e27300282fe1a79a916ab8e7
  - method:af6b0a43380a455f476e08d07e9424b6
  - struct:db2d1e01a99b36b79270a663da886784
  id: r.cli-handler-auth-and-help
  level: MUST
  text: CLIHandler must implement the login handler surface by providing Auth, which
    returns an api.Secret from a client and argument map, and Help, which returns
    the handler's usage string.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/jwt/provider_config.go
  - interface:dea4f4408f174e0e44dbc4b9990ff1b6
  - method:b5c1037ca76c126e302cd2386f269535
  - method:f6dc2a1305631a4e5aed98ae5182a6ff
  id: r.custom-provider-contract
  level: MUST
  text: CustomProvider must declare Initialize, which configures the provider from
    a jwtConfig, and SensitiveKeys, which lists config keys that must be treated as
    sensitive.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/jwt/backend.go
  - function:feda0111c34e54bcf65564d604597024
  id: r.factory-builds-backend
  level: MUST
  text: Factory must construct the JWT auth backend via backend() and call Setup with
    the given context and logical.BackendConfig, returning the error when setup fails.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/jwt/provider_config.go
  - interface:71c866c0e8ec854a28bb092f4a691fb4
  - method:a38d9639c7ce42999b1bdccce545f56c
  id: r.groups-fetcher-extension
  level: MAY
  text: A provider may implement GroupsFetcher to resolve group membership for the
    supplied backend, claims, role, and token source.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/jwt/provider_gsuite.go
  - method:0fe63ee4b732ca90d1396796ba1d7532
  - method:537b90c97136dcd1a46fd2c1e4c98257
  - method:623bc476c4bc640716c31c6fa05ea3f9
  - method:8e5cfec6794d474487fb282c6e892cc7
  - struct:0964f5289584cfe47953f4addbbc6d1b
  - struct:ba488616fa918c6b38a0505e67a773e1
  id: r.gsuite-provider
  level: MUST
  text: GSuiteProvider must implement CustomProvider and both the GroupsFetcher and
    UserInfoFetcher extensions, using GSuiteProviderConfig for its credentials.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/jwt/provider_ibmisam.go
  - method:024e80766a8fc0c2a81b11c0df1f6052
  - method:07204bfd32f940f7840a7e4d72f3f64c
  - method:8236c0a303de2ed217ff95320c457d51
  - struct:8b9a7bfa1724f9dec14f7e039672857c
  id: r.ibmisam-provider
  level: MUST
  text: IBMISAMProvider must implement CustomProvider with a no-op Initialize, SensitiveKeys,
    and a GroupsFetcher that reads IBM ISAM group claims.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/jwt/provider_config.go
  - interface:cb0c1606ad2bdc8c7adaafc6455e1404
  - method:e27b4ac52fe81524f211f1b1f3f04ad0
  id: r.keyset-discovery-extension
  level: MAY
  text: A provider may implement KeySetDiscovery to supply its own jwt.KeySet for
    token verification instead of static keys.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/jwt/provider_kubernetes.go
  - method:22172237ae323d0f356882f386db517b
  - method:23a9fdee658f6e8e82875f5560774748
  - method:83d7bcf6e957254f1a757403e05ac862
  - method:98b8b0ed6019a86d3c2431bf580cd8f6
  - struct:0189a1a44cec03c325321246a3bb2fa5
  id: r.kubernetes-provider
  level: MUST
  text: KubernetesProvider must implement CustomProvider plus KeySetDiscovery, initializing
    from jwtConfig and fetching the cluster key set over HTTP with bearer authentication.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/jwt/provider_config.go
  - function:84a4a29e110029257b545cef297e879b
  id: r.new-provider-config-resolves
  level: MUST
  text: NewProviderConfig must select and initialize a provider for the given jwtConfig
    from the supplied provider map, returning an error when the configured type is
    unknown or initialization fails.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/jwt/provider_config.go
  - function:dfb510af7533096386061e2d440cad57
  id: r.provider-map-registry
  level: MUST
  text: ProviderMap must return the builtin provider registry keyed by provider type
    name, mapping each name to its CustomProvider implementation.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/jwt/cli_qr.go
  - method:12b8ff544a353f0e50c1edcea29582bf
  - method:5db037b3792e6a4a6a8f31633a90be36
  id: r.qr-writer-renders-matrix
  level: SHOULD
  text: qrWriter must write a qrcode.Matrix to its io.Writer as block characters,
    using truecolor escapes when COLORTERM is truecolor or 24bit, and Close must report
    no error.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/jwt/provider_secureauth.go
  - method:016b42a8b334ce3fd58e083bc9fb2ec3
  - method:bddecf12562770c74e69475c32a20efd
  - method:d947e28a4fdc1acd1fea9a5519d08c8b
  - struct:e20504017f16190adf38adeb0ffdc2db
  id: r.secureauth-provider
  level: MUST
  text: SecureAuthProvider must implement CustomProvider with a no-op Initialize,
    SensitiveKeys, and a GroupsFetcher that reads SecureAuth group claims.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/jwt/path_config.go
  - method:8bd0fd72eb36c7fbb66c9016095f332b
  - method:abe2643d08001568769db0443cc98435
  id: r.tls-overrides
  level: SHOULD
  text: jwtAuthBackend must allow a config path to override the TLS client configuration
    by appending root CAs from PEM and by constraining the set of allowed server names.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/jwt/provider_config.go
  - interface:766b57f5904c2ea206e8d3a8474ab7fb
  - method:f96a798512a1468ec33e1cfd5acf0a11
  id: r.user-info-fetcher-extension
  level: MAY
  text: A provider may implement UserInfoFetcher to enrich allClaims from the provider's
    userinfo endpoint for the supplied backend and role.
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/credential/jwt/backend.go` file backend.go (third_party/openbao/internal/builtin/credential/jwt/backend.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/claims.go` file claims.go (third_party/openbao/internal/builtin/credential/jwt/claims.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/claims_test.go` file claims_test.go (third_party/openbao/internal/builtin/credential/jwt/claims_test.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/cli.go` file cli.go (third_party/openbao/internal/builtin/credential/jwt/cli.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/cli_auth_no_sigtstp.go` file cli_auth_no_sigtstp.go (third_party/openbao/internal/builtin/credential/jwt/cli_auth_no_sigtstp.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/cli_auth_sigtstp.go` file cli_auth_sigtstp.go (third_party/openbao/internal/builtin/credential/jwt/cli_auth_sigtstp.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/cli_qr.go` file cli_qr.go (third_party/openbao/internal/builtin/credential/jwt/cli_qr.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/cli_qr_test.go` file cli_qr_test.go (third_party/openbao/internal/builtin/credential/jwt/cli_qr_test.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/cli_test.go` file cli_test.go (third_party/openbao/internal/builtin/credential/jwt/cli_test.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/html_responses.go` file html_responses.go (third_party/openbao/internal/builtin/credential/jwt/html_responses.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/path_cel_login.go` file path_cel_login.go (third_party/openbao/internal/builtin/credential/jwt/path_cel_login.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/path_cel_login_test.go` file path_cel_login_test.go (third_party/openbao/internal/builtin/credential/jwt/path_cel_login_test.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/path_cel_role.go` file path_cel_role.go (third_party/openbao/internal/builtin/credential/jwt/path_cel_role.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/path_cel_role_test.go` file path_cel_role_test.go (third_party/openbao/internal/builtin/credential/jwt/path_cel_role_test.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/path_config.go` file path_config.go (third_party/openbao/internal/builtin/credential/jwt/path_config.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/path_config_test.go` file path_config_test.go (third_party/openbao/internal/builtin/credential/jwt/path_config_test.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/path_login.go` file path_login.go (third_party/openbao/internal/builtin/credential/jwt/path_login.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/path_login_test.go` file path_login_test.go (third_party/openbao/internal/builtin/credential/jwt/path_login_test.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/path_oidc.go` file path_oidc.go (third_party/openbao/internal/builtin/credential/jwt/path_oidc.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/path_oidc_test.go` file path_oidc_test.go (third_party/openbao/internal/builtin/credential/jwt/path_oidc_test.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/path_role.go` file path_role.go (third_party/openbao/internal/builtin/credential/jwt/path_role.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/path_role_test.go` file path_role_test.go (third_party/openbao/internal/builtin/credential/jwt/path_role_test.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/provider_azure.go` file provider_azure.go (third_party/openbao/internal/builtin/credential/jwt/provider_azure.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/provider_azure_test.go` file provider_azure_test.go (third_party/openbao/internal/builtin/credential/jwt/provider_azure_test.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/provider_config.go` file provider_config.go (third_party/openbao/internal/builtin/credential/jwt/provider_config.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/provider_config_test.go` file provider_config_test.go (third_party/openbao/internal/builtin/credential/jwt/provider_config_test.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/provider_gsuite.go` file provider_gsuite.go (third_party/openbao/internal/builtin/credential/jwt/provider_gsuite.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/provider_gsuite_test.go` file provider_gsuite_test.go (third_party/openbao/internal/builtin/credential/jwt/provider_gsuite_test.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/provider_ibmisam.go` file provider_ibmisam.go (third_party/openbao/internal/builtin/credential/jwt/provider_ibmisam.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/provider_ibmisam_test.go` file provider_ibmisam_test.go (third_party/openbao/internal/builtin/credential/jwt/provider_ibmisam_test.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/provider_kubernetes.go` file provider_kubernetes.go (third_party/openbao/internal/builtin/credential/jwt/provider_kubernetes.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/provider_kubernetes_test.go` file provider_kubernetes_test.go (third_party/openbao/internal/builtin/credential/jwt/provider_kubernetes_test.go)
- `file:third_party/openbao/internal/builtin/credential/jwt/provider_secureauth.go` file provider_secureauth.go (third_party/openbao/internal/builtin/credential/jwt/provider_secureauth.go)

_44 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
