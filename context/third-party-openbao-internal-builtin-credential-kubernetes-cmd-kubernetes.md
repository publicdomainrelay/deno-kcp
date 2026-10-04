# Context: third-party-openbao-internal-builtin-credential-kubernetes-cmd-kubernetes

Repository: `deno-kcp`

This context exists to pin down the contract of the Kubernetes credential backend's plugin binary: which SDK entry point it serves through, how it obtains its TLS provider, and how it fails. It gives reviewers and downstream tooling a stable statement of the entry point's obligations, because the file itself is a few statements of wiring whose correctness is entirely about calling the OpenBao plugin SDK in the right order with the right arguments.

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
requirements:
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/kubernetes/cmd/kubernetes/main.go
  id: r.fatal-exit
  level: MUST
  text: A failure from flag parsing or from ServeMultiplex must be logged through
    the hclog logger at error level with the message 'plugin shutting down' and the
    error attached under the 'error' key, then the process must exit with status code
    1.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/kubernetes/cmd/kubernetes/main.go
  id: r.flag-parsing
  level: MUST
  text: The process must parse its API client plugin flags from os.Args[1:] with the
    flag set returned by api.PluginAPIClientMeta.FlagSet, and must treat a parse error
    as fatal.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/kubernetes/cmd/kubernetes/main.go
  id: r.plugin-serve-multiplex
  level: MUST
  text: The entry point must serve the Kubernetes credential backend through plugin.ServeMultiplex
    using a plugin.ServeOpts whose BackendFactoryFunc is kubeauth.Factory.
- codeRefs:
  - file:third_party/openbao/internal/builtin/credential/kubernetes/cmd/kubernetes/main.go
  id: r.tls-provider-compat
  level: MUST
  text: ServeMultiplex must receive a TLSProviderFunc built by api.VaultPluginTLSProvider
    over the config from api.PluginAPIClientMeta.GetTLSConfig, so the plugin keeps
    backwards compatibility with Vault versions that do not support plugin AutoMTLS.
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/credential/kubernetes/cmd/kubernetes/main.go` file main.go (third_party/openbao/internal/builtin/credential/kubernetes/cmd/kubernetes/main.go)
<!-- SPECD_MANAGED_END -->
