# Context: third-party-openbao-internal-builtin-credential-kubernetes

Repository: `deno-kcp`

_(empty: write what this context is for)_

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
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
