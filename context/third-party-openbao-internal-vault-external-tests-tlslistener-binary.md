# Context: third-party-openbao-internal-vault-external-tests-tlslistener-binary

Repository: `deno-kcp`

This context exists to prove, against a real OpenBao binary in real containers, that the ACME-driven TLS listener works end to end: HTTP-01 and TLS-ALPN-01 challenge solving, privileged and non-privileged port binding, custom cache paths, custom challenge ports, DNS resolution through an injected resolver, and refusal of denied domains. It exists because unit tests cannot exercise CertMagic listener startup, root-privileged port 80/443 binding, Docker port publishing, or DNS-based challenge routing, so the checks run as skipped-by-default external tests gated on a built binary being supplied.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/tlslistener_binary/tls_test.go` file tls_test.go (third_party/openbao/internal/vault/external_tests/tlslistener_binary/tls_test.go)
<!-- SPECD_MANAGED_END -->
