# Context: third-party-openbao-internal-builtin-credential-userpass-cmd-userpass

Repository: `deno-kcp`

This context exists so the userpass credential backend can be run as a separate process under OpenBao's plugin multiplexing protocol, which is how a plugin binary is launched and handed a listener and TLS material by the host. It is the process boundary: everything about the backend's behavior is elsewhere, but the backend cannot be loaded at all without this main package parsing the plugin API client flags, constructing the TLS provider function that keeps backwards compatibility with hosts lacking plugin AutoMTLS, and serving userpass.Factory over multiplex. The error path exists so a failure to serve is reported and turned into a nonzero exit rather than a silent hang.

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
interfaces:
- file: third_party/openbao/internal/builtin/credential/userpass/cmd/userpass/main.go
  kind: function
  name: main
  signature: func main()
requirements:
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/userpass/cmd/userpass/main.go
  id: r.fail-loudly-on-serve-error
  level: MUST
  text: When plugin.ServeMultiplex returns a non-nil error, main logs it with an hclog
    logger using the message "plugin shutting down" and the error under the "error"
    key, then terminates with os.Exit(1); a successful serve never reaches that path.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/userpass/cmd/userpass/main.go
  id: r.main-package-entrypoint
  level: MUST
  text: The file declares package main and provides exactly one entrypoint function,
    main, with no arguments and no return value, living in third_party/openbao/internal/builtin/credential/userpass/cmd/userpass/main.go.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/userpass/cmd/userpass/main.go
  id: r.parse-plugin-api-client-flags
  level: MUST
  text: main constructs an api.PluginAPIClientMeta, obtains its flag set, and parses
    os.Args[1:] through it, so the host-supplied plugin API flags are consumed before
    serving.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/userpass/cmd/userpass/main.go
  id: r.serve-multiplex-userpass-factory
  level: MUST
  text: main serves the backend by calling plugin.ServeMultiplex with ServeOpts carrying
    BackendFactoryFunc set to userpass.Factory, so the userpass backend factory is
    what the multiplexed plugin exposes.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/userpass/cmd/userpass/main.go
  id: r.tls-provider-from-client-meta
  level: MUST
  text: main derives the TLS config with apiClientMeta.GetTLSConfig and wraps it with
    api.VaultPluginTLSProvider, passing the result as TLSProviderFunc so the plugin
    keeps backwards compatibility with hosts that do not support plugin AutoMTLS.
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/credential/userpass/cmd/userpass/main.go` file main.go (third_party/openbao/internal/builtin/credential/userpass/cmd/userpass/main.go)
<!-- SPECD_MANAGED_END -->
