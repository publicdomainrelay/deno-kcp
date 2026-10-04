# Context: third-party-openbao-internal-builtin-logical-pkiext

Repository: `deno-kcp`

This context exists so the PKI extension package can turn a stream of docker container log output into per-line callbacks during tests. The container log writer in this package duplicates the LogConsumerWriter type that also exists in the sdk/helper/docker and sdk/helper/testcluster/docker packages, differing only in that its callback field is exported as Consumer rather than unexported. The context documents that helper and the test files that depend on the pkiext package's test scaffolding, so that changes to log handling or to the pkiext test helpers keep the observed behaviour intact.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/logical/pkiext/nginx_test.go` file nginx_test.go (third_party/openbao/internal/builtin/logical/pkiext/nginx_test.go)
- `file:third_party/openbao/internal/builtin/logical/pkiext/test_helpers.go` file test_helpers.go (third_party/openbao/internal/builtin/logical/pkiext/test_helpers.go)
- `file:third_party/openbao/internal/builtin/logical/pkiext/zlint_test.go` file zlint_test.go (third_party/openbao/internal/builtin/logical/pkiext/zlint_test.go)
- `method:6122b5e075e25cc10903a024ace8994a` method LogConsumerWriter.Write (third_party/openbao/internal/builtin/logical/pkiext/test_helpers.go)
- `struct:f8a7e9b9c122ff59fce7fe136e4259e4` struct LogConsumerWriter (third_party/openbao/internal/builtin/logical/pkiext/test_helpers.go)
<!-- SPECD_MANAGED_END -->
