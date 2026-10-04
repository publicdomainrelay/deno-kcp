# Context: third-party-openbao-github-workflows

Repository: `deno-kcp`

This context exists so the upstream OpenBao GitHub Actions automation travels with the vendored OpenBao tree instead of being reimplemented in deno-kcp. Keeping the eighteen workflow files verbatim under third_party/openbao/.github/workflows/ preserves the upstream CI, release, docs, security and housekeeping definitions as one identifiable vendored unit, so they can be diffed against upstream, re-synced when OpenBao changes, and kept clearly separate from any first-party workflow directory in deno-kcp. Nothing here is a program interface: the context describes configuration artifacts, not callable code.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/.github/workflows/changelog-checker.yml` file changelog-checker.yml (third_party/openbao/.github/workflows/changelog-checker.yml)
- `file:third_party/openbao/.github/workflows/ci.yml` file ci.yml (third_party/openbao/.github/workflows/ci.yml)
- `file:third_party/openbao/.github/workflows/code-checker.yml` file code-checker.yml (third_party/openbao/.github/workflows/code-checker.yml)
- `file:third_party/openbao/.github/workflows/codeql.yml` file codeql.yml (third_party/openbao/.github/workflows/codeql.yml)
- `file:third_party/openbao/.github/workflows/docs-ci.yml` file docs-ci.yml (third_party/openbao/.github/workflows/docs-ci.yml)
- `file:third_party/openbao/.github/workflows/docs-deploy.yml` file docs-deploy.yml (third_party/openbao/.github/workflows/docs-deploy.yml)
- `file:third_party/openbao/.github/workflows/go-dependency-submission.yml` file go-dependency-submission.yml (third_party/openbao/.github/workflows/go-dependency-submission.yml)
- `file:third_party/openbao/.github/workflows/mirror.yml` file mirror.yml (third_party/openbao/.github/workflows/mirror.yml)
- `file:third_party/openbao/.github/workflows/publiccodeyml-check.yml` file publiccodeyml-check.yml (third_party/openbao/.github/workflows/publiccodeyml-check.yml)
- `file:third_party/openbao/.github/workflows/release-images.yml` file release-images.yml (third_party/openbao/.github/workflows/release-images.yml)
- `file:third_party/openbao/.github/workflows/release-packages.yml` file release-packages.yml (third_party/openbao/.github/workflows/release-packages.yml)
- `file:third_party/openbao/.github/workflows/release.yml` file release.yml (third_party/openbao/.github/workflows/release.yml)
- `file:third_party/openbao/.github/workflows/scorecard.yml` file scorecard.yml (third_party/openbao/.github/workflows/scorecard.yml)
- `file:third_party/openbao/.github/workflows/sync-deps.yaml` file sync-deps.yaml (third_party/openbao/.github/workflows/sync-deps.yaml)
- `file:third_party/openbao/.github/workflows/test-acc-dockeronly-nightly.yml` file test-acc-dockeronly-nightly.yml (third_party/openbao/.github/workflows/test-acc-dockeronly-nightly.yml)
- `file:third_party/openbao/.github/workflows/test-go.yml` file test-go.yml (third_party/openbao/.github/workflows/test-go.yml)
- `file:third_party/openbao/.github/workflows/ui-ci.yml` file ui-ci.yml (third_party/openbao/.github/workflows/ui-ci.yml)
- `file:third_party/openbao/.github/workflows/verify-commits.yml` file verify-commits.yml (third_party/openbao/.github/workflows/verify-commits.yml)
<!-- SPECD_MANAGED_END -->
