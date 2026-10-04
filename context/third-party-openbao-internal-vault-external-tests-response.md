# Context: third-party-openbao-internal-vault-external-tests-response

Repository: `deno-kcp`

This file exists as an external (black-box, HTTP-level) acceptance test of the response-header allow-list feature: it verifies that a plugin mount cannot leak arbitrary HTTP response headers to clients, and that an operator can opt a specific header back in through the mount's allowed_response_headers tuning, including with different letter casing. It is an upstream OpenBao test vendored under third_party/ in this repository, so it documents the observed behaviour of the vendored vault HTTP handler, not behaviour authored in this repo.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/response/allowed_response_headers_test.go` file allowed_response_headers_test.go (third_party/openbao/internal/vault/external_tests/response/allowed_response_headers_test.go)
<!-- SPECD_MANAGED_END -->
