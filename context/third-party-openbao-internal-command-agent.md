# Context: third-party-openbao-internal-command-agent

Repository: `deno-kcp`

This context exists so the agent command has one place where its integration-level contract is demonstrated: a reusable JWT fixture for auto-auth tests, plus end-to-end tests that each prove a distinct auth method or cache path works against a live server. It is the evidence layer for the agent's login and caching behaviour, not the implementation itself.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/command/agent/approle_end_to_end_test.go` file approle_end_to_end_test.go (third_party/openbao/internal/command/agent/approle_end_to_end_test.go)
- `file:third_party/openbao/internal/command/agent/auto_auth_preload_token_end_to_end_test.go` file auto_auth_preload_token_end_to_end_test.go (third_party/openbao/internal/command/agent/auto_auth_preload_token_end_to_end_test.go)
- `file:third_party/openbao/internal/command/agent/cache_end_to_end_test.go` file cache_end_to_end_test.go (third_party/openbao/internal/command/agent/cache_end_to_end_test.go)
- `file:third_party/openbao/internal/command/agent/cert_end_to_end_test.go` file cert_end_to_end_test.go (third_party/openbao/internal/command/agent/cert_end_to_end_test.go)
- `file:third_party/openbao/internal/command/agent/doc.go` file doc.go (third_party/openbao/internal/command/agent/doc.go)
- `file:third_party/openbao/internal/command/agent/jwt_end_to_end_test.go` file jwt_end_to_end_test.go (third_party/openbao/internal/command/agent/jwt_end_to_end_test.go)
- `file:third_party/openbao/internal/command/agent/testing.go` file testing.go (third_party/openbao/internal/command/agent/testing.go)
- `file:third_party/openbao/internal/command/agent/token_file_end_to_end_test.go` file token_file_end_to_end_test.go (third_party/openbao/internal/command/agent/token_file_end_to_end_test.go)
- `function:b694f010cebc494d1fe128a22732b5e2` function GetTestJWT (third_party/openbao/internal/command/agent/testing.go)
<!-- SPECD_MANAGED_END -->
