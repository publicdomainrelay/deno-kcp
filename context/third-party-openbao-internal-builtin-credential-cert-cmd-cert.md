# Context: third-party-openbao-internal-builtin-credential-cert-cmd-cert

Repository: `deno-kcp`

This context exists to pin down the contract of the cert plugin's binary entry point: the sequence of flag parsing, TLS material derivation from the plugin API client meta, and the multiplexed serve call that registers `cert.Factory` as the backend factory. It matters because the entry point is the boundary between the plugin process and the OpenBao/Vault plugin protocol, and because the explicit `TLSProviderFunc` is what keeps the plugin loadable by older Vault versions without AutoMTLS. It also fixes the failure behavior — log and exit non-zero — so a failed serve is never silently ignored. The context deliberately holds no business logic: everything about certificate auth lives in the cert package, and this file must stay a thin bootstrapper.

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
requirements:
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/cert/cmd/cert/main.go
  id: r.log-and-exit-on-serve-failure
  level: MUST
  text: When `plugin.ServeMultiplex` returns an error, the cert command's `main` MUST
    build a logger with `hclog.New(&hclog.LoggerOptions{})`, log the error under the
    message `plugin shutting down` with the `error` key, and terminate with `os.Exit(1)`.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/cert/cmd/cert/main.go
  id: r.parse-plugin-api-client-flags
  level: MUST
  text: The cert command's `main` MUST construct an `api.PluginAPIClientMeta`, take
    its `FlagSet`, and parse `os.Args[1:]` before serving, and MUST derive the TLS
    config and the TLS provider function from that same meta.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/cert/cmd/cert/main.go
  id: r.remain-thin-package-main-binary
  level: SHOULD
  text: The cert command SHOULD remain a `package main` binary whose only logic is
    flag parsing, TLS setup, and the serve call, leaving all backend behavior to the
    imported cert package.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/cert/cmd/cert/main.go
  id: r.retain-tls-provider-for-automtls-backcompat
  level: MUST
  text: The cert command's `main` MUST set `TLSProviderFunc` on the serve options
    from `api.VaultPluginTLSProvider(tlsConfig)` so the plugin stays loadable by Vault
    versions that do not support plugin AutoMTLS.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/cert/cmd/cert/main.go
  id: r.serve-cert-factory-as-multiplexed-plugin
  level: MUST
  text: The cert command's `main` MUST register the cert credential backend by passing
    `cert.Factory` as `BackendFactoryFunc` to `plugin.ServeMultiplex`.
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/credential/cert/cmd/cert/main.go` file main.go (third_party/openbao/internal/builtin/credential/cert/cmd/cert/main.go)
<!-- SPECD_MANAGED_END -->
