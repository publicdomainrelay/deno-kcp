# Context: third-party-openbao-tools-semgrep

Repository: `deno-kcp`

The context exists to statically catch Go mistakes that are cheap to make and expensive to debug: host/port concatenation done with fmt.Sprintf instead of net.JoinHostPort, path joining done with strings.Join, mutexes locked but not unlocked on a return branch, logger messages built with fmt.Sprintf, direct physical-storage access that bypasses encryption, replication state checks that should use IsPerfSecondary/IsDRSecondary helpers, and self-comparison expressions. It is a vendored copy, so it must keep the upstream rule ids, severities, messages, and suppression patterns intact so results stay comparable with upstream OpenBao.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/tools/semgrep/hostport.yml` file hostport.yml (third_party/openbao/tools/semgrep/hostport.yml)
- `file:third_party/openbao/tools/semgrep/joinpath.yml` file joinpath.yml (third_party/openbao/tools/semgrep/joinpath.yml)
- `file:third_party/openbao/tools/semgrep/lock-not-unlocked-on-return.yml` file lock-not-unlocked-on-return.yml (third_party/openbao/tools/semgrep/lock-not-unlocked-on-return.yml)
- `file:third_party/openbao/tools/semgrep/logger-sprintf.yml` file logger-sprintf.yml (third_party/openbao/tools/semgrep/logger-sprintf.yml)
- `file:third_party/openbao/tools/semgrep/physical-storage.yml` file physical-storage.yml (third_party/openbao/tools/semgrep/physical-storage.yml)
- `file:third_party/openbao/tools/semgrep/replication-has-state.yml` file replication-has-state.yml (third_party/openbao/tools/semgrep/replication-has-state.yml)
- `file:third_party/openbao/tools/semgrep/self-equals.yml` file self-equals.yml (third_party/openbao/tools/semgrep/self-equals.yml)
<!-- SPECD_MANAGED_END -->
