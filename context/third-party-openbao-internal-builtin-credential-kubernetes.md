# Context: third-party-openbao-internal-builtin-credential-kubernetes

Repository: `deno-kcp`

This context exists to specify the vendored OpenBao Kubernetes credential backend as it stands in third_party: how the credential backend is constructed and registered, how its config, login and role paths are served, how service account JWTs are reviewed against the Kubernetes TokenReview API, how the local service account token and CA certificate are cached between re-reads, how role namespace constraints are validated, and how the OpenBao CLI authenticates with this method. It fixes the package's exported and receiver-side interfaces and the invariants the construction, caching, token review and CLI paths must keep, so downstream work in deno-kcp can rely on the vendored behaviour instead of re-deriving it from source.

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
interfaces:
- file: third_party/openbao/internal/builtin/credential/kubernetes/backend.go
  kind: function
  name: Backend
  signature: func Backend() *kubeAuthBackend
- file: third_party/openbao/internal/builtin/credential/kubernetes/cli.go
  kind: struct
  name: CLIHandler
  signature: type CLIHandler struct
- file: third_party/openbao/internal/builtin/credential/kubernetes/cli.go
  kind: method
  name: CLIHandler.Auth
  signature: func (CLIHandler) Auth(c *api.Client, m map[string]string, nonInteractive
    bool) (*api.Secret, error)
- file: third_party/openbao/internal/builtin/credential/kubernetes/cli.go
  kind: method
  name: CLIHandler.Help
  signature: func (CLIHandler) Help() string
- file: third_party/openbao/internal/builtin/credential/kubernetes/path_login.go
  kind: struct
  name: DontVerifySignature
  signature: type DontVerifySignature struct
- file: third_party/openbao/internal/builtin/credential/kubernetes/path_login.go
  kind: method
  name: DontVerifySignature.VerifySignature
  signature: func (DontVerifySignature) VerifySignature(_ context.Context, token string)
    (map[string]any, error)
- file: third_party/openbao/internal/builtin/credential/kubernetes/backend.go
  kind: function
  name: Factory
  signature: func Factory(ctx context.Context, conf *logical.BackendConfig) (logical.Backend,
    error)
- file: third_party/openbao/internal/builtin/credential/kubernetes/caching_file_reader.go
  kind: method
  name: cachingFileReader.ReadFile
  signature: func (r *cachingFileReader) ReadFile() (string, error)
- file: third_party/openbao/internal/builtin/credential/kubernetes/token_review.go
  kind: method
  name: mockTokenReview.Review
  signature: func (mockTokenReview) Review(ctx context.Context, client *http.Client,
    cjwt string, aud []string) (*tokenReviewResult, error)
- file: third_party/openbao/internal/builtin/credential/kubernetes/token_review.go
  kind: method
  name: tokenReviewAPI.Review
  signature: func (tokenReviewAPI) Review(ctx context.Context, client *http.Client,
    jwt string, aud []string) (*tokenReviewResult, error)
- file: third_party/openbao/internal/builtin/credential/kubernetes/token_review.go
  kind: method
  name: tokenReviewer.Review
  signature: func (tokenReviewer) Review(context.Context, *http.Client, string, []string)
    (*tokenReviewResult, error)
requirements:
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/kubernetes/backend.go
  - function:327b75a4a5fb57df99217daba68cba71
  id: r.backend-defaults
  level: MUST
  text: Backend must initialize the backend with caching readers for the local service
    account JWT and the local CA certificate, a default HTTP client, a default TLS
    config, tokenReviewAPIFactory as the review factory, and newNsValidatorWrapper
    as the namespace validator factory.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/kubernetes/backend.go
  - function:327b75a4a5fb57df99217daba68cba71
  id: r.backend-wiring
  level: MUST
  text: Backend must return a *kubeAuthBackend whose embedded framework.Backend has
    BackendType logical.TypeCredential, registers configPath and login as unauthenticated-capable
    paths together with the role paths, seals configPath in storage, and sets AuthRenew,
    InitializeFunc and Clean to the backend's own handlers.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/kubernetes/caching_file_reader.go
  - method:53fa3d1aced7908095cdee08f2ae461e
  id: r.caching-file-read-cached-path
  level: MUST
  text: cachingFileReader.ReadFile must return the cached buffer without touching
    disk when the current time is still before the cached entry's expiry, taking only
    a read lock on that fast path.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/kubernetes/caching_file_reader.go
  - method:53fa3d1aced7908095cdee08f2ae461e
  id: r.caching-file-read-refresh
  level: MUST
  text: cachingFileReader.ReadFile must, when the cache is stale, take the write lock,
    read the file at its configured path, store the contents with an expiry of now
    plus the reader's ttl, and return them, propagating any read error to the caller.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/kubernetes/cli.go
  - method:8ad91efa91cec3204661b42e891f67f3
  - method:9eae0147fbec06afdf57274020958504
  - struct:fefe415f0b107e91a29b213fd80bd8c0
  id: r.cli-auth-method
  level: MUST
  text: CLIHandler must implement the API client's auth method contract with Auth,
    which takes the client, the method's config map and the nonInteractive flag and
    returns an *api.Secret, and Help, which returns the method's usage string.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/kubernetes/path_login.go
  - method:d04985173a58026168200c3ff3a0587c
  - struct:8bf50c53cde4e4947d58ad31a0196ce1
  id: r.dont-verify-signature
  level: MUST
  text: The backend must provide a DontVerifySignature type whose VerifySignature
    method accepts a context and a token and returns the token's claims as a map[string]any
    without verifying the signature, so deployments that delegate validation to the
    Kubernetes API can skip local verification.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/kubernetes/backend.go
  - function:02af8fb6e7e72058037837483ef89f71
  id: r.factory-builds-backend
  level: MUST
  text: The package must expose Factory, taking a context and a *logical.BackendConfig,
    that constructs the Kubernetes backend with Backend and calls Setup on it before
    returning it as a logical.Backend, so the framework can register it as a credential
    backend.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/kubernetes/namespace_validator.go
  - file:third_party/openbao/internal/builtin/credential/kubernetes/path_role.go
  id: r.namespace-validation
  level: SHOULD
  text: Role namespace constraints should be checked by the namespace validator wrapper,
    which rejects patterns that do not match at least one namespace, so a role cannot
    be created that no service account could ever satisfy.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/kubernetes/path_config.go
  - file:third_party/openbao/internal/builtin/credential/kubernetes/path_login.go
  - file:third_party/openbao/internal/builtin/credential/kubernetes/path_role.go
  id: r.paths-config-login-role
  level: MUST
  text: The backend must serve the config path for cluster connection settings and
    token reviewer credentials, the login path for service account JWT login, and
    the role paths for creating, reading, listing and deleting Kubernetes roles with
    their bound service accounts, namespaces and audiences.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/kubernetes/backend_test.go
  - file:third_party/openbao/internal/builtin/credential/kubernetes/caching_file_reader_test.go
  - file:third_party/openbao/internal/builtin/credential/kubernetes/common_test.go
  - file:third_party/openbao/internal/builtin/credential/kubernetes/helpers.go
  - file:third_party/openbao/internal/builtin/credential/kubernetes/path_config_test.go
  - file:third_party/openbao/internal/builtin/credential/kubernetes/path_login_test.go
  - file:third_party/openbao/internal/builtin/credential/kubernetes/path_role_test.go
  id: r.test-coverage
  level: SHOULD
  text: The backend, caching file reader, config path, login path and role path behaviour
    should be covered by table-driven Go tests that reuse the shared helpers in helpers.go
    and common_test.go.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/kubernetes/token_review.go
  - method:84bdf065c1d51b833921a33903250bcf
  - method:91a4bfbeebd874d4186c44a632319427
  - method:b92e2797c1b174f002efaaff58811eb9
  id: r.token-review-indirection
  level: MUST
  text: Token review must go through the tokenReviewer interface, with tokenReviewAPI
    as the production implementation that calls the Kubernetes TokenReview API with
    a context, HTTP client, JWT and audiences, and mockTokenReview as the test implementation
    used in place of it.
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/credential/kubernetes/backend.go` file backend.go (third_party/openbao/internal/builtin/credential/kubernetes/backend.go)
- `file:third_party/openbao/internal/builtin/credential/kubernetes/backend_test.go` file backend_test.go (third_party/openbao/internal/builtin/credential/kubernetes/backend_test.go)
- `file:third_party/openbao/internal/builtin/credential/kubernetes/caching_file_reader.go` file caching_file_reader.go (third_party/openbao/internal/builtin/credential/kubernetes/caching_file_reader.go)
- `file:third_party/openbao/internal/builtin/credential/kubernetes/caching_file_reader_test.go` file caching_file_reader_test.go (third_party/openbao/internal/builtin/credential/kubernetes/caching_file_reader_test.go)
- `file:third_party/openbao/internal/builtin/credential/kubernetes/cli.go` file cli.go (third_party/openbao/internal/builtin/credential/kubernetes/cli.go)
- `file:third_party/openbao/internal/builtin/credential/kubernetes/common_test.go` file common_test.go (third_party/openbao/internal/builtin/credential/kubernetes/common_test.go)
- `file:third_party/openbao/internal/builtin/credential/kubernetes/helpers.go` file helpers.go (third_party/openbao/internal/builtin/credential/kubernetes/helpers.go)
- `file:third_party/openbao/internal/builtin/credential/kubernetes/namespace_validator.go` file namespace_validator.go (third_party/openbao/internal/builtin/credential/kubernetes/namespace_validator.go)
- `file:third_party/openbao/internal/builtin/credential/kubernetes/path_config.go` file path_config.go (third_party/openbao/internal/builtin/credential/kubernetes/path_config.go)
- `file:third_party/openbao/internal/builtin/credential/kubernetes/path_config_test.go` file path_config_test.go (third_party/openbao/internal/builtin/credential/kubernetes/path_config_test.go)
- `file:third_party/openbao/internal/builtin/credential/kubernetes/path_login.go` file path_login.go (third_party/openbao/internal/builtin/credential/kubernetes/path_login.go)
- `file:third_party/openbao/internal/builtin/credential/kubernetes/path_login_test.go` file path_login_test.go (third_party/openbao/internal/builtin/credential/kubernetes/path_login_test.go)
- `file:third_party/openbao/internal/builtin/credential/kubernetes/path_role.go` file path_role.go (third_party/openbao/internal/builtin/credential/kubernetes/path_role.go)
- `file:third_party/openbao/internal/builtin/credential/kubernetes/path_role_test.go` file path_role_test.go (third_party/openbao/internal/builtin/credential/kubernetes/path_role_test.go)
- `file:third_party/openbao/internal/builtin/credential/kubernetes/token_review.go` file token_review.go (third_party/openbao/internal/builtin/credential/kubernetes/token_review.go)
- `function:02af8fb6e7e72058037837483ef89f71` function Factory (third_party/openbao/internal/builtin/credential/kubernetes/backend.go)
- `function:327b75a4a5fb57df99217daba68cba71` function Backend (third_party/openbao/internal/builtin/credential/kubernetes/backend.go)
- `method:53fa3d1aced7908095cdee08f2ae461e` method cachingFileReader.ReadFile (third_party/openbao/internal/builtin/credential/kubernetes/caching_file_reader.go)
- `method:84bdf065c1d51b833921a33903250bcf` method mockTokenReview.Review (third_party/openbao/internal/builtin/credential/kubernetes/token_review.go)
- `method:8ad91efa91cec3204661b42e891f67f3` method CLIHandler.Auth (third_party/openbao/internal/builtin/credential/kubernetes/cli.go)
- `method:91a4bfbeebd874d4186c44a632319427` method tokenReviewAPI.Review (third_party/openbao/internal/builtin/credential/kubernetes/token_review.go)
- `method:9eae0147fbec06afdf57274020958504` method CLIHandler.Help (third_party/openbao/internal/builtin/credential/kubernetes/cli.go)
- `method:b92e2797c1b174f002efaaff58811eb9` method tokenReviewer.Review (third_party/openbao/internal/builtin/credential/kubernetes/token_review.go)
- `method:d04985173a58026168200c3ff3a0587c` method DontVerifySignature.VerifySignature (third_party/openbao/internal/builtin/credential/kubernetes/path_login.go)
- `struct:8bf50c53cde4e4947d58ad31a0196ce1` struct DontVerifySignature (third_party/openbao/internal/builtin/credential/kubernetes/path_login.go)
- `struct:fefe415f0b107e91a29b213fd80bd8c0` struct CLIHandler (third_party/openbao/internal/builtin/credential/kubernetes/cli.go)
<!-- SPECD_MANAGED_END -->
