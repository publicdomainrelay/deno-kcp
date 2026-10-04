# Context: third-party-openbao-internal-builtin-credential-approle-cmd-approle

Repository: `deno-kcp`

This context exists so the AppRole credential backend can run as an out-of-process OpenBao plugin binary. It isolates the harness boilerplate — flag parsing, TLS provider derivation, and multiplexed serving — from the backend implementation, which lives in the parent `approle` package and is reached only through the `approle.Factory` symbol. Keeping this file thin means the backend stays testable and buildable without the plugin harness, while the binary itself remains compileable against host versions that predate plugin AutoMTLS.

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
requirements:
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/approle/cmd/approle/main.go
  id: r.legacy-automtls-compat
  level: SHOULD
  text: '`TLSProviderFunc` remains set on the serve options to keep backwards compatibility
    with host versions that do not support plugin AutoMTLS, as noted in the source
    comment.'
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/approle/cmd/approle/main.go
  id: r.no-owned-abstractions
  level: SHOULD
  text: 'The file stays a thin entrypoint: it declares no types and exports no interfaces,
    delegating backend behavior entirely to `approle.Factory`.'
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/approle/cmd/approle/main.go
  id: r.package-main-entrypoint
  level: MUST
  text: The file declares `package main` and provides the process entrypoint `func
    main()` that starts the AppRole plugin binary.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/approle/cmd/approle/main.go
  id: r.parse-plugin-flags
  level: MUST
  text: '`main` constructs an `api.PluginAPIClientMeta`, takes its flag set, and parses
    `os.Args[1:]` through it, so the plugin honors the harness-supplied plugin API
    flags.'
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/approle/cmd/approle/main.go
  id: r.serve-approle-factory
  level: MUST
  text: '`main` calls `plugin.ServeMultiplex` with `plugin.ServeOpts` whose `BackendFactoryFunc`
    is `approle.Factory`, so the multiplexed plugin serves the AppRole credential
    backend.'
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/approle/cmd/approle/main.go
  id: r.serve-error-exit
  level: MUST
  text: When `plugin.ServeMultiplex` returns an error, `main` builds an `hclog` logger,
    logs the message "plugin shutting down" with the error, and calls `os.Exit(1)`;
    on success it returns normally.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/approle/cmd/approle/main.go
  id: r.tls-provider-from-meta
  level: MUST
  text: '`main` obtains the TLS config via `apiClientMeta.GetTLSConfig()` and converts
    it into a provider function with `api.VaultPluginTLSProvider`, passing that function
    as `TLSProviderFunc` to the serve options.'
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/credential/approle/cmd/approle/main.go` file main.go (third_party/openbao/internal/builtin/credential/approle/cmd/approle/main.go)
<!-- SPECD_MANAGED_END -->
