# Context: third-party-openbao-github

Repository: `deno-kcp`

This context exists to record that third_party/openbao/.github/ is vendored upstream configuration, not deno-kcp project logic. It fixes the boundary between the OpenBao subtree's own actionlint, dependabot, and security-insights settings and the parent repository's workflow, dependency, and security configuration, so that a reader or a tool does not mistake the vendored YAML for first-party deno-kcp policy. It also records that the directory exports nothing callable, which keeps the low-confidence OpenBao symbol matches in internal/provider from being read as consumers of these files.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/.github/actionlint.yaml` file actionlint.yaml (third_party/openbao/.github/actionlint.yaml)
- `file:third_party/openbao/.github/dependabot.yml` file dependabot.yml (third_party/openbao/.github/dependabot.yml)
- `file:third_party/openbao/.github/security-insights.yml` file security-insights.yml (third_party/openbao/.github/security-insights.yml)
<!-- SPECD_MANAGED_END -->
