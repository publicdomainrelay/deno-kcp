# Context: third-party-openbao-internal-vault-diagnose

Repository: `deno-kcp`

This context documents the diagnostic subsystem vendored from OpenBao so that its behaviour can be reasoned about without reading the Go sources. It exists to pin down what the package guarantees: the span-and-session protocol every check goes through, the file-permission and TLS rules the checks enforce, the shape of the rendered result, and the platform-specific split between unix and windows file ownership logic. Anyone changing or re-vendoring the diagnostic tooling needs these invariants stated.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/diagnose/file_checks.go` file file_checks.go (third_party/openbao/internal/vault/diagnose/file_checks.go)
- `file:third_party/openbao/internal/vault/diagnose/file_checks_test.go` file file_checks_test.go (third_party/openbao/internal/vault/diagnose/file_checks_test.go)
- `file:third_party/openbao/internal/vault/diagnose/file_checks_unix.go` file file_checks_unix.go (third_party/openbao/internal/vault/diagnose/file_checks_unix.go)
- `file:third_party/openbao/internal/vault/diagnose/file_checks_windows.go` file file_checks_windows.go (third_party/openbao/internal/vault/diagnose/file_checks_windows.go)
- `file:third_party/openbao/internal/vault/diagnose/helpers.go` file helpers.go (third_party/openbao/internal/vault/diagnose/helpers.go)
- `file:third_party/openbao/internal/vault/diagnose/helpers_test.go` file helpers_test.go (third_party/openbao/internal/vault/diagnose/helpers_test.go)
- `file:third_party/openbao/internal/vault/diagnose/mock_storage_backend.go` file mock_storage_backend.go (third_party/openbao/internal/vault/diagnose/mock_storage_backend.go)
- `file:third_party/openbao/internal/vault/diagnose/os_common.go` file os_common.go (third_party/openbao/internal/vault/diagnose/os_common.go)
- `file:third_party/openbao/internal/vault/diagnose/os_openbsd_arm.go` file os_openbsd_arm.go (third_party/openbao/internal/vault/diagnose/os_openbsd_arm.go)
- `file:third_party/openbao/internal/vault/diagnose/os_unix.go` file os_unix.go (third_party/openbao/internal/vault/diagnose/os_unix.go)
- `file:third_party/openbao/internal/vault/diagnose/os_windows.go` file os_windows.go (third_party/openbao/internal/vault/diagnose/os_windows.go)
- `file:third_party/openbao/internal/vault/diagnose/output.go` file output.go (third_party/openbao/internal/vault/diagnose/output.go)
- `file:third_party/openbao/internal/vault/diagnose/raft_checks.go` file raft_checks.go (third_party/openbao/internal/vault/diagnose/raft_checks.go)
- `file:third_party/openbao/internal/vault/diagnose/storage_checks.go` file storage_checks.go (third_party/openbao/internal/vault/diagnose/storage_checks.go)
- `file:third_party/openbao/internal/vault/diagnose/storage_checks_test.go` file storage_checks_test.go (third_party/openbao/internal/vault/diagnose/storage_checks_test.go)
- `file:third_party/openbao/internal/vault/diagnose/tls_verification.go` file tls_verification.go (third_party/openbao/internal/vault/diagnose/tls_verification.go)
- `file:third_party/openbao/internal/vault/diagnose/tls_verification_test.go` file tls_verification_test.go (third_party/openbao/internal/vault/diagnose/tls_verification_test.go)
- `function:01d13409a0f66c6ca7611b765edcf14a` function CurrentSession (third_party/openbao/internal/vault/diagnose/helpers.go)
- `function:077dfce5c711ad619b614d8b9480197d` function TLSCAFileCheck (third_party/openbao/internal/vault/diagnose/tls_verification.go)
- `function:0b74a3974c0c64f3bdda87eaa0f44d0b` function StartSpan (third_party/openbao/internal/vault/diagnose/helpers.go)
- `function:103414ab252298f367022fad7d289ae6` function NewTelemetryCollector (third_party/openbao/internal/vault/diagnose/output.go)
- `function:1f266af19e27fbcd2b424a843adab179` function ConsulDirectAccess (third_party/openbao/internal/vault/diagnose/storage_checks.go)
- `function:238970f9d548e05113b2015f954ccbf7` function TLSClientCAFileCheck (third_party/openbao/internal/vault/diagnose/tls_verification.go)
- `function:29950abbefb1d13b51b3748364bab5a8` function Advice (third_party/openbao/internal/vault/diagnose/helpers.go)
- `function:31f55fc24b8fc6bf7bb9917c24a5911f` function HasDB (third_party/openbao/internal/vault/diagnose/file_checks.go)
- `function:3b3fc36b0a2ff553c718821131cbc9c8` function EndToEndLatencyCheckRead (third_party/openbao/internal/vault/diagnose/storage_checks.go)
- `function:3c394f1d0805ac0bebd81da166d06b5b` function TLSFileWarningChecks (third_party/openbao/internal/vault/diagnose/tls_verification.go)
- `function:46916ec4481866b0eae041bb93fd8ea0` function Success (third_party/openbao/internal/vault/diagnose/helpers.go)
- `function:48bbf8d4d546a22c96e7c0e1c26095e5` function NearExpiration (third_party/openbao/internal/vault/diagnose/tls_verification.go)
- `function:4d8f11326ab7a2395b5b3ae0a85fc595` function Warn (third_party/openbao/internal/vault/diagnose/helpers.go)
- `function:538081c484ea52d7f375564864d27942` function Advise (third_party/openbao/internal/vault/diagnose/helpers.go)
- `function:5751359af658aca42f50270ee42c7467` function SpotError (third_party/openbao/internal/vault/diagnose/helpers.go)
- `function:5ba70567e9681e038bb1d42a54730c99` function SpotOk (third_party/openbao/internal/vault/diagnose/helpers.go)
- `function:63c609886747199e13e2f1e65682d21e` function SpotWarn (third_party/openbao/internal/vault/diagnose/helpers.go)
- `function:65000eb8d97b4d6d0d6e4c62e6a815b5` function WithTimeout (third_party/openbao/internal/vault/diagnose/helpers.go)
- `function:6deb04fc3ec65145725aa931037d4d78` function ListenerChecks (third_party/openbao/internal/vault/diagnose/tls_verification.go)
- `function:760ec569cefae891200beed07025f8bf` function TLSFileChecks (third_party/openbao/internal/vault/diagnose/tls_verification.go)
- `function:826e56fc7b14b5f6fc32a81263476d0e` function TLSCertCheck (third_party/openbao/internal/vault/diagnose/tls_verification.go)
- `function:8e2ab71ac554ea14baa62329b33dddf9` function RaftFileChecks (third_party/openbao/internal/vault/diagnose/raft_checks.go)
- `function:9134dea0a3098c266a4ab90fa7a14fcb` function EndToEndLatencyCheckDelete (third_party/openbao/internal/vault/diagnose/storage_checks.go)
- `function:a0b9d3226264e0999289ee2cafa94f16` function SpotCheck (third_party/openbao/internal/vault/diagnose/helpers.go)
- `function:a397007a7d7793145f0c8425ab7c9a0d` function OSChecks (third_party/openbao/internal/vault/diagnose/os_unix.go)

_39 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
