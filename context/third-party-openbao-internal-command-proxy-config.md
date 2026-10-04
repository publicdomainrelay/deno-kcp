# Context: third-party-openbao-internal-command-proxy-config

Repository: `deno-kcp`

This context exists so the proxy command's configuration contract is described independently of the rest of the proxy implementation: which blocks and fields exist, what each loader does with a path, how multiple files combine, which defaults and environment variables are applied, and which combinations of blocks are rejected. It gives the reader the rules the proxy binary relies on when it starts, without needing to read the OpenBao agent config package it was forked from.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/command/proxy/config/config.go` file config.go (third_party/openbao/internal/command/proxy/config/config.go)
- `file:third_party/openbao/internal/command/proxy/config/config_test.go` file config_test.go (third_party/openbao/internal/command/proxy/config/config_test.go)
- `function:58233c8751bc532ee0bd7ceb2b0a1669` function LoadConfigDir (third_party/openbao/internal/command/proxy/config/config.go)
- `function:6f3aa78b4a2366bf4da19d9d96a99e6e` function NewConfig (third_party/openbao/internal/command/proxy/config/config.go)
- `function:81223ed17bf84bacce9a2a42cece863f` function LoadConfigFile (third_party/openbao/internal/command/proxy/config/config.go)
- `function:9f3f0cbf037e405e6dd671b66222c8b2` function LoadConfig (third_party/openbao/internal/command/proxy/config/config.go)
- `method:26952baea9d476449508d9297101a9c1` method Config.Merge (third_party/openbao/internal/command/proxy/config/config.go)
- `method:786f3040dae784eff8500a5a7f0161ba` method transportDialer.DialContext (third_party/openbao/internal/command/proxy/config/config.go)
- `method:adad1d15d5506eee2f708e2337dbf6bf` method Config.ValidateConfig (third_party/openbao/internal/command/proxy/config/config.go)
- `method:db5214262f0a15764a3f5a52b34903ec` method transportDialer.Dial (third_party/openbao/internal/command/proxy/config/config.go)
- `method:dee50bdca0490db920677c670a150440` method Config.Prune (third_party/openbao/internal/command/proxy/config/config.go)
- `struct:07ed422d82f6e9bfb21e6a107e72731f` struct Method (third_party/openbao/internal/command/proxy/config/config.go)
- `struct:171cca82ce1530d98edda3d9f3b9ce25` struct APIProxy (third_party/openbao/internal/command/proxy/config/config.go)
- `struct:46ba8a4512b4471214d9f680f3788717` struct Vault (third_party/openbao/internal/command/proxy/config/config.go)
- `struct:5164d9eec48b0d48fcc9ca7430690c69` struct AutoAuth (third_party/openbao/internal/command/proxy/config/config.go)
- `struct:69b9869445749914751ff5e9ba95b3c1` struct Config (third_party/openbao/internal/command/proxy/config/config.go)
- `struct:bb3dd2f39815037df9a5a07ac65f9598` struct Cache (third_party/openbao/internal/command/proxy/config/config.go)
- `struct:dba8ff9e6100707a39a3327d53449ae9` struct Sink (third_party/openbao/internal/command/proxy/config/config.go)
- `struct:e1a43e95f6d8e49289fb0ab7d02bca13` struct Retry (third_party/openbao/internal/command/proxy/config/config.go)
<!-- SPECD_MANAGED_END -->
