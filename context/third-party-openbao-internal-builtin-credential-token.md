# Context: third-party-openbao-internal-builtin-credential-token

Repository: `deno-kcp`

This context exists to pin down the token auth method's CLI surface: the exact handler type, the exact Auth signature the login command calls, and the exact help text and configuration keys the token method advertises. It is one of five sibling credential handler contexts, so recording the shared two-method contract here keeps the token variant distinguishable from cert, jwt, kubernetes and userpass variants that export identically named types and methods. Requirements are anchored to the observed declarations so the handler cannot drift from the login command's dynamic interface expectations or from its own documented flags.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/credential/token/cli.go` file cli.go (third_party/openbao/internal/builtin/credential/token/cli.go)
- `method:c0f8ecd2eba308d3bd0e3a89d53ac47f` method CLIHandler.Help (third_party/openbao/internal/builtin/credential/token/cli.go)
- `method:eaccceebed764c4834f9052a32fb9496` method CLIHandler.Auth (third_party/openbao/internal/builtin/credential/token/cli.go)
- `struct:1d7501e1dbe7dfbad42059c8f401e31c` struct CLIHandler (third_party/openbao/internal/builtin/credential/token/cli.go)
<!-- SPECD_MANAGED_END -->
