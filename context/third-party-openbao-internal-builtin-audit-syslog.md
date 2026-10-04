# Context: third-party-openbao-internal-builtin-audit-syslog

Repository: `deno-kcp`

This context exists to pin down the contract of the syslog audit device so that the vendored OpenBao audit subsystem can construct it and route audit entries through it without reading the implementation. It records that syslog plugs into the same Factory/Backend interface that the audit package declares and that the file, http and socket packages also satisfy, which lets the registry treat every sink uniformly and lets a change to one backend be checked against the shared contract.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/audit/syslog/backend.go` file backend.go (third_party/openbao/internal/builtin/audit/syslog/backend.go)
- `function:1bb7d10c19625969a2fad559b9fc2914` function Factory (third_party/openbao/internal/builtin/audit/syslog/backend.go)
- `method:0c13207964141302df87a24ba0d56d5c` method Backend.Reload (third_party/openbao/internal/builtin/audit/syslog/backend.go)
- `method:252a807dadfe136645b090b47d7f110c` method Backend.Invalidate (third_party/openbao/internal/builtin/audit/syslog/backend.go)
- `method:8b769d342ef8e785df720cdf2b1c0dca` method Backend.Salt (third_party/openbao/internal/builtin/audit/syslog/backend.go)
- `method:977c2abb299b7ba82de1c2f36f532af5` method Backend.LogRequest (third_party/openbao/internal/builtin/audit/syslog/backend.go)
- `method:c55f56a838db46051967178e0a12e791` method Backend.LogResponse (third_party/openbao/internal/builtin/audit/syslog/backend.go)
- `method:d5bf16c0d9eab948ff1cdf09a7fed065` method Backend.GetHash (third_party/openbao/internal/builtin/audit/syslog/backend.go)
- `method:ff26096cde106ddcce03b7d21b94a4e3` method Backend.LogTestMessage (third_party/openbao/internal/builtin/audit/syslog/backend.go)
- `struct:b13846d838452ef018cd519120bf0849` struct Backend (third_party/openbao/internal/builtin/audit/syslog/backend.go)
<!-- SPECD_MANAGED_END -->
