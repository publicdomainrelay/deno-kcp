# Context: third-party-openbao-api

Repository: `deno-kcp`

This context exists to pin down how a caller authenticates against OpenBao credential backends and manages tokens from the Go API client, so that the Auth/AuthMethod seam and the MFA paths are described exactly as the vendored code implements them. It names the client entry point (Client.Auth), the delegation contract every backend satisfies (AuthMethod.Login), the MFA login and validation calls, and the token create accessor, so that the observed exports and their obligations are captured rather than inferred.

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
interfaces:
- file: third_party/openbao/api/auth.go
  kind: struct
  name: Auth
  signature: type Auth struct { c *Client }
- file: third_party/openbao/api/auth.go
  kind: method
  name: Auth.Login
  signature: func (a *Auth) Login(ctx context.Context, authMethod AuthMethod) (*Secret,
    error)
- file: third_party/openbao/api/auth.go
  kind: method
  name: Auth.MFALogin
  signature: func (a *Auth) MFALogin(ctx context.Context, authMethod AuthMethod, creds
    ...string) (*Secret, error)
- file: third_party/openbao/api/auth.go
  kind: method
  name: Auth.MFAValidate
  signature: func (a *Auth) MFAValidate(ctx context.Context, mfaSecret *Secret, payload
    map[string]any) (*Secret, error)
- file: third_party/openbao/api/auth.go
  kind: method
  name: Auth.Token
  signature: func (a *Auth) Token() *TokenAuth
- file: third_party/openbao/api/auth.go
  kind: interface
  name: AuthMethod
  signature: type AuthMethod interface { Login(ctx context.Context, client *Client)
    (*Secret, error) }
- file: third_party/openbao/api/auth.go
  kind: method
  name: AuthMethod.Login
  signature: Login(ctx context.Context, client *Client) (*Secret, error)
- file: third_party/openbao/api/auth.go
  kind: method
  name: Client.Auth
  signature: func (c *Client) Auth() *Auth
- file: third_party/openbao/api/sys_mfa.go
  kind: method
  name: Sys.MFAValidate
  signature: func (c *Sys) MFAValidate(requestID string, payload map[string]any) (*Secret,
    error)
- file: third_party/openbao/api/auth_token.go
  kind: struct
  name: TokenAuth
  signature: type TokenAuth struct { c *Client }
- file: third_party/openbao/api/auth_token.go
  kind: method
  name: TokenAuth.Create
  signature: func (c *TokenAuth) Create(opts *TokenCreateRequest) (*Secret, error)
- file: third_party/openbao/api/auth_token.go
  kind: method
  name: TokenAuth.CreateWithContext
  signature: func (c *TokenAuth) CreateWithContext(ctx context.Context, opts *TokenCreateRequest)
    (*Secret, error)
requirements:
- codeRefs:
  - file:third_party/openbao/api/auth.go
  id: r.auth-entry-point
  level: MUST
  text: The credential-backend API client is obtained by calling Client.Auth(), which
    returns an *Auth bound to that client.
- codeRefs:
  - file:third_party/openbao/api/auth.go
  id: r.auth-login-delegates
  level: MUST
  text: Auth.Login takes an AuthMethod and delegates the actual credential exchange
    to that method's Login, returning its *Secret or error.
- codeRefs:
  - file:third_party/openbao/api/auth.go
  id: r.authmethod-seam
  level: MUST
  text: Every credential backend integrates by implementing the AuthMethod interface,
    whose only method is Login(ctx context.Context, client *Client) (*Secret, error).
- codeRefs:
  - file:third_party/openbao/api/auth.go
  id: r.mfa-login-creds
  level: MUST
  text: Auth.MFALogin accepts an AuthMethod plus variadic MFA credential strings and
    selects the single-phase or two-phase MFA flow accordingly.
- codeRefs:
  - file:third_party/openbao/api/auth.go
  id: r.mfa-validate
  level: MUST
  text: Auth.MFAValidate validates a given MFA secret against a payload map and returns
    the resulting *Secret or error.
- codeRefs:
  - file:third_party/openbao/api/sys_mfa.go
  id: r.sys-mfa-validate
  level: SHOULD
  text: Sys.MFAValidate takes a requestID and payload map and forwards to the context-aware
    MFA validate call with context.Background().
- codeRefs:
  - file:third_party/openbao/api/auth.go
  - file:third_party/openbao/api/auth_token.go
  id: r.token-auth-accessor
  level: MUST
  text: Auth.Token() returns a *TokenAuth carrying the same underlying client, giving
    access to token create operations.
- codeRefs:
  - file:third_party/openbao/api/auth_token.go
  id: r.token-create-context
  level: MUST
  text: TokenAuth.Create forwards to TokenAuth.CreateWithContext using context.Background(),
    so the context-aware variant remains the single implementation point.
- codeRefs:
  - file:third_party/openbao/api/auth.go
  id: r.two-phase-mfa-contract
  level: MUST
  text: The two-phase MFA login path calls AuthMethod.Login and, when the returned
    secret is nil, lacks Auth, or lacks MFARequirement, appends the warning "expected
    secret to contain MFARequirements" to the secret and returns the error "assumed
    two-phase MFA login, returned secret is missing MFARequirements".
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/api/api_test.go` file api_test.go (third_party/openbao/api/api_test.go)
- `file:third_party/openbao/api/auth.go` file auth.go (third_party/openbao/api/auth.go)
- `file:third_party/openbao/api/auth_test.go` file auth_test.go (third_party/openbao/api/auth_test.go)
- `file:third_party/openbao/api/auth_token.go` file auth_token.go (third_party/openbao/api/auth_token.go)
- `file:third_party/openbao/api/client.go` file client.go (third_party/openbao/api/client.go)
- `file:third_party/openbao/api/client_test.go` file client_test.go (third_party/openbao/api/client_test.go)
- `file:third_party/openbao/api/env.go` file env.go (third_party/openbao/api/env.go)
- `file:third_party/openbao/api/env_test.go` file env_test.go (third_party/openbao/api/env_test.go)
- `file:third_party/openbao/api/help.go` file help.go (third_party/openbao/api/help.go)
- `file:third_party/openbao/api/index.go` file index.go (third_party/openbao/api/index.go)
- `file:third_party/openbao/api/kv.go` file kv.go (third_party/openbao/api/kv.go)
- `file:third_party/openbao/api/kv_test.go` file kv_test.go (third_party/openbao/api/kv_test.go)
- `file:third_party/openbao/api/kv_v1.go` file kv_v1.go (third_party/openbao/api/kv_v1.go)
- `file:third_party/openbao/api/kv_v2.go` file kv_v2.go (third_party/openbao/api/kv_v2.go)
- `file:third_party/openbao/api/lifetime_watcher.go` file lifetime_watcher.go (third_party/openbao/api/lifetime_watcher.go)
- `file:third_party/openbao/api/logical.go` file logical.go (third_party/openbao/api/logical.go)
- `file:third_party/openbao/api/output_policy.go` file output_policy.go (third_party/openbao/api/output_policy.go)
- `file:third_party/openbao/api/output_policy_test.go` file output_policy_test.go (third_party/openbao/api/output_policy_test.go)
- `file:third_party/openbao/api/output_string.go` file output_string.go (third_party/openbao/api/output_string.go)
- `file:third_party/openbao/api/output_string_test.go` file output_string_test.go (third_party/openbao/api/output_string_test.go)
- `file:third_party/openbao/api/plugin_helpers.go` file plugin_helpers.go (third_party/openbao/api/plugin_helpers.go)
- `file:third_party/openbao/api/plugin_helpers_test.go` file plugin_helpers_test.go (third_party/openbao/api/plugin_helpers_test.go)
- `file:third_party/openbao/api/plugin_types.go` file plugin_types.go (third_party/openbao/api/plugin_types.go)
- `file:third_party/openbao/api/renewer_test.go` file renewer_test.go (third_party/openbao/api/renewer_test.go)
- `file:third_party/openbao/api/request.go` file request.go (third_party/openbao/api/request.go)
- `file:third_party/openbao/api/request_test.go` file request_test.go (third_party/openbao/api/request_test.go)
- `file:third_party/openbao/api/response.go` file response.go (third_party/openbao/api/response.go)
- `file:third_party/openbao/api/rootcerts.go` file rootcerts.go (third_party/openbao/api/rootcerts.go)
- `file:third_party/openbao/api/secret.go` file secret.go (third_party/openbao/api/secret.go)
- `file:third_party/openbao/api/secret_test.go` file secret_test.go (third_party/openbao/api/secret_test.go)
- `file:third_party/openbao/api/ssh.go` file ssh.go (third_party/openbao/api/ssh.go)
- `file:third_party/openbao/api/ssh_agent.go` file ssh_agent.go (third_party/openbao/api/ssh_agent.go)
- `file:third_party/openbao/api/ssh_agent_test.go` file ssh_agent_test.go (third_party/openbao/api/ssh_agent_test.go)
- `file:third_party/openbao/api/sys.go` file sys.go (third_party/openbao/api/sys.go)
- `file:third_party/openbao/api/sys_audit.go` file sys_audit.go (third_party/openbao/api/sys_audit.go)
- `file:third_party/openbao/api/sys_auth.go` file sys_auth.go (third_party/openbao/api/sys_auth.go)
- `file:third_party/openbao/api/sys_capabilities.go` file sys_capabilities.go (third_party/openbao/api/sys_capabilities.go)
- `file:third_party/openbao/api/sys_config_cors.go` file sys_config_cors.go (third_party/openbao/api/sys_config_cors.go)
- `file:third_party/openbao/api/sys_generate_root.go` file sys_generate_root.go (third_party/openbao/api/sys_generate_root.go)
- `file:third_party/openbao/api/sys_hastatus.go` file sys_hastatus.go (third_party/openbao/api/sys_hastatus.go)
- `file:third_party/openbao/api/sys_health.go` file sys_health.go (third_party/openbao/api/sys_health.go)
- `file:third_party/openbao/api/sys_init.go` file sys_init.go (third_party/openbao/api/sys_init.go)
- `file:third_party/openbao/api/sys_leader.go` file sys_leader.go (third_party/openbao/api/sys_leader.go)
- `file:third_party/openbao/api/sys_leases.go` file sys_leases.go (third_party/openbao/api/sys_leases.go)
- `file:third_party/openbao/api/sys_mfa.go` file sys_mfa.go (third_party/openbao/api/sys_mfa.go)
- `file:third_party/openbao/api/sys_monitor.go` file sys_monitor.go (third_party/openbao/api/sys_monitor.go)
- `file:third_party/openbao/api/sys_mounts.go` file sys_mounts.go (third_party/openbao/api/sys_mounts.go)
- `file:third_party/openbao/api/sys_mounts_test.go` file sys_mounts_test.go (third_party/openbao/api/sys_mounts_test.go)
- `file:third_party/openbao/api/sys_namespaces.go` file sys_namespaces.go (third_party/openbao/api/sys_namespaces.go)
- `file:third_party/openbao/api/sys_namespaces_test.go` file sys_namespaces_test.go (third_party/openbao/api/sys_namespaces_test.go)
- `file:third_party/openbao/api/sys_plugins.go` file sys_plugins.go (third_party/openbao/api/sys_plugins.go)
- `file:third_party/openbao/api/sys_plugins_test.go` file sys_plugins_test.go (third_party/openbao/api/sys_plugins_test.go)
- `file:third_party/openbao/api/sys_policy.go` file sys_policy.go (third_party/openbao/api/sys_policy.go)
- `file:third_party/openbao/api/sys_raft.go` file sys_raft.go (third_party/openbao/api/sys_raft.go)
- `file:third_party/openbao/api/sys_rekey.go` file sys_rekey.go (third_party/openbao/api/sys_rekey.go)

_548 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
