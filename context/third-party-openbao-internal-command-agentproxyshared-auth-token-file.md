# Context: third-party-openbao-internal-command-agentproxyshared-auth-token-file

Repository: `deno-kcp`

This context exists so the agent has a documented contract for the token-file auth method: which configuration key it consumes, how it behaves when the file is missing, empty, or unreadable, and which parts of the auth.AuthMethod interface it intentionally leaves inert. It is the code under third_party/openbao/internal/command/agentproxyshared/auth/token-file and the tests that pin its constructor and authenticate behavior.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/command/agentproxyshared/auth/token-file/token_file.go` file token_file.go (third_party/openbao/internal/command/agentproxyshared/auth/token-file/token_file.go)
- `file:third_party/openbao/internal/command/agentproxyshared/auth/token-file/token_file_test.go` file token_file_test.go (third_party/openbao/internal/command/agentproxyshared/auth/token-file/token_file_test.go)
- `function:d24c73ee7eaff01d93be82b24abde9fe` function NewTokenFileAuthMethod (third_party/openbao/internal/command/agentproxyshared/auth/token-file/token_file.go)
- `method:52f55ad01b0a1ebc69331855c31658cc` method tokenFileMethod.Authenticate (third_party/openbao/internal/command/agentproxyshared/auth/token-file/token_file.go)
- `method:7a5b310b87c2220fa7bd24f3f18adbd7` method tokenFileMethod.Shutdown (third_party/openbao/internal/command/agentproxyshared/auth/token-file/token_file.go)
- `method:a2082400b947908a7d6ed3021eb187b7` method tokenFileMethod.NewCreds (third_party/openbao/internal/command/agentproxyshared/auth/token-file/token_file.go)
- `method:fbfd5d5c4f474ff71ee6fd810ca16d3c` method tokenFileMethod.CredSuccess (third_party/openbao/internal/command/agentproxyshared/auth/token-file/token_file.go)
<!-- SPECD_MANAGED_END -->
