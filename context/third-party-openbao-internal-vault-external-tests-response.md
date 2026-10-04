# Context: third-party-openbao-internal-vault-external-tests-response

Repository: `deno-kcp`

This context exists to pin down the observable contract of the response-header allow-list in the vendored third_party/openbao vault HTTP handler, independent of this repository's own code: a plugin mount must not be able to leak arbitrary HTTP response headers to clients, and an operator must be able to opt a specific header back in per mount through the allowed_response_headers tuning, including when the configured casing differs from the emitted casing. Because the file is an external black-box test that speaks only over the HTTP API (client.Logical().ReadRaw, client.Sys().TuneMount) and not over internal Go packages, it documents the behaviour the vendored handler is expected to preserve across upstream updates rather than behaviour authored in this repo.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/response/allowed_response_headers_test.go` file allowed_response_headers_test.go (third_party/openbao/internal/vault/external_tests/response/allowed_response_headers_test.go)
<!-- SPECD_MANAGED_END -->
