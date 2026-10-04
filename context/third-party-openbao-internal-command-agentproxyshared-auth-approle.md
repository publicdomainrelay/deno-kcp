# Context: third-party-openbao-internal-command-agentproxyshared-auth-approle

Repository: `deno-kcp`

The context exists so the agent proxy can log in to OpenBao with AppRole credentials that live on disk rather than in memory, reading a required role ID file and an optional secret ID file at authentication time, with support for unwrapping a response-wrapped secret ID and for deleting the secret ID file once read. It defines the configuration surface for that login path (role_id_file_path, secret_id_file_path, remove_secret_id_file_after_reading, secret_id_response_wrapping_path) and implements the auth.AuthMethod interface used by the shared auth package, including the no-op rotation hooks NewCreds, CredSuccess and Shutdown that tell the caller this method has no credential watch channel.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/command/agentproxyshared/auth/approle/approle.go` file approle.go (third_party/openbao/internal/command/agentproxyshared/auth/approle/approle.go)
- `function:23702cdb560ebaf22d5fff5fe0a2c7b2` function NewApproleAuthMethod (third_party/openbao/internal/command/agentproxyshared/auth/approle/approle.go)
- `method:7b0e6de5a77ea6d0d6cffa4a561afdf9` method approleMethod.Shutdown (third_party/openbao/internal/command/agentproxyshared/auth/approle/approle.go)
- `method:9efa2f8bd29ab6444a35fa65ae08f0ca` method approleMethod.NewCreds (third_party/openbao/internal/command/agentproxyshared/auth/approle/approle.go)
- `method:a052addb3a943fe663c151d4ec54fa5a` method approleMethod.CredSuccess (third_party/openbao/internal/command/agentproxyshared/auth/approle/approle.go)
- `method:ae0e8df4f98addd9a1a546ad3ef7d460` method approleMethod.Authenticate (third_party/openbao/internal/command/agentproxyshared/auth/approle/approle.go)
<!-- SPECD_MANAGED_END -->
