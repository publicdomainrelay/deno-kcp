# Context: third-party-openbao-github

Repository: `deno-kcp`

This context exists to record that third_party/openbao/.github/ is vendored upstream configuration, not deno-kcp project logic. It fixes the boundary between the OpenBao subtree's own actionlint, dependabot, and security-insights settings and the parent repository's workflow, dependency, and security configuration, so that a reader or a tool does not mistake the vendored YAML for first-party deno-kcp policy. It also records that the directory exports nothing callable, which keeps the low-confidence OpenBao symbol matches in internal/provider from being read as consumers of these files.

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
requirements:
- codeRefs:
  - file:third_party/openbao/.github/actionlint.yaml
  id: r.actionlint-config-scoped-to-vendored-tree
  level: MUST
  text: The actionlint configuration at third_party/openbao/.github/actionlint.yaml
    must remain the lint configuration for the vendored OpenBao repository's own workflows
    and must not be treated as the parent deno-kcp project's workflow lint configuration.
- codeRefs:
  - file:third_party/openbao/.github/dependabot.yml
  id: r.dependabot-config-scoped-to-vendored-tree
  level: MUST
  text: The dependabot configuration at third_party/openbao/.github/dependabot.yml
    must declare dependency-update policy only for the vendored OpenBao project's
    ecosystems, with no update entries for deno-kcp packages.
- codeRefs:
  - file:third_party/openbao/.github/actionlint.yaml
  - file:third_party/openbao/.github/dependabot.yml
  - file:third_party/openbao/.github/security-insights.yml
  id: r.no-exported-interfaces-from-vendored-github-dir
  level: MUST
  text: Nothing under third_party/openbao/.github/ may be imported or called from
    deno-kcp code; the directory exposes no functions, methods, or types because it
    holds YAML configuration only.
- codeRefs:
  - file:third_party/openbao/.github/actionlint.yaml
  - file:third_party/openbao/.github/dependabot.yml
  - file:third_party/openbao/.github/security-insights.yml
  id: r.openbao-integration-owned-by-provider-package
  level: SHOULD
  text: OpenBao support that deno-kcp itself owns should stay in internal/provider,
    keeping the vendored GitHub configuration directory free of project logic and
    unmodified from upstream.
- codeRefs:
  - file:third_party/openbao/.github/security-insights.yml
  id: r.security-insights-describes-vendored-project
  level: MUST
  text: The security-insights document at third_party/openbao/.github/security-insights.yml
    must describe the security posture of the vendored OpenBao project, not of deno-kcp.
- codeRefs:
  - file:third_party/openbao/.github/actionlint.yaml
  - file:third_party/openbao/.github/dependabot.yml
  - file:third_party/openbao/.github/security-insights.yml
  id: r.vendored-files-changed-only-by-upstream-sync
  level: SHOULD
  text: Edits to the vendored GitHub configuration files should arrive through an
    upstream OpenBao sync rather than as local deno-kcp changes, so the subtree stays
    diffable against its upstream source.
- codeRefs:
  - file:third_party/openbao/.github/actionlint.yaml
  - file:third_party/openbao/.github/dependabot.yml
  - file:third_party/openbao/.github/security-insights.yml
  id: r.vendored-openbao-github-config-present
  level: MUST
  text: The vendored OpenBao subtree must carry its GitHub configuration under third_party/openbao/.github/,
    consisting of the actionlint, dependabot, and security-insights YAML files observed
    there.
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/.github/actionlint.yaml` file actionlint.yaml (third_party/openbao/.github/actionlint.yaml)
- `file:third_party/openbao/.github/dependabot.yml` file dependabot.yml (third_party/openbao/.github/dependabot.yml)
- `file:third_party/openbao/.github/security-insights.yml` file security-insights.yml (third_party/openbao/.github/security-insights.yml)
<!-- SPECD_MANAGED_END -->
