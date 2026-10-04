package deno_kcp.policies.traceability

import rego.v1

# traceability asks whether the code diff actually realizes the spec delta the
# change claims, and whether the change record names what it touched. The delta
# is read from the requirement-level diff of the base tree against the head
# tree, not from the SpecChange record alone, which carries only the edit that
# produced that record. Every rule tolerates input.base_tree being null, so the
# base tree walks without a change and reports nothing.

policy_id := "traceability"

# metadata names, for every violation this policy can raise, the severity it
# carries, the requirement level it corresponds to, and a one-line title. The
# aggregator joins it into each violation by id.
metadata := {
	"trace-files-touched-not-in-diff": {"severity": "error", "level": "MUST", "title": "filesTouched names a path the diff did not touch"},
	"trace-files-touched-empty": {"severity": "warning", "level": "SHOULD", "title": "A change names no files it touched"},
	"trace-files-touched-absolute": {"severity": "error", "level": "MUST", "title": "filesTouched names an absolute path"},
	"trace-commit-not-in-diff": {"severity": "error", "level": "MUST", "title": "status.commit is not the diff head or one of its commits"},
	"trace-branch-commit-mismatch": {"severity": "error", "level": "MUST", "title": "status.branch does not name the toSpecHash it records"},
	"trace-changed-requirement-code-ref-untouched": {"severity": "error", "level": "MUST", "title": "A changed requirement names only files the diff did not touch"},
	"trace-added-requirement-without-code": {"severity": "warning", "level": "SHOULD", "title": "An added requirement names no code"},
	"trace-diff-touches-unrelated-context": {"severity": "warning", "level": "SHOULD", "title": "The diff touches no file of the context the change names"},
	"trace-diff-touches-nothing": {"severity": "error", "level": "MUST", "title": "A change claims a delta but its diff is empty"},
	"trace-status-observed-files-stale": {"severity": "warning", "level": "SHOULD", "title": "The status observed files omit a file the change touched"},
	"trace-synced-commit-not-observed": {"severity": "error", "level": "MUST", "title": "A Succeeded change synced a commit it did not observe"},
	"trace-realized-spec-hash-stale": {"severity": "error", "level": "MUST", "title": "A Succeeded change realized a different spec hash"},
	"trace-arch-overlay-file-untouched": {"severity": "warning", "level": "SHOULD", "title": "A file the arch overlay adds for a requirement was not touched"},
	"trace-test-changed-without-requirement": {"severity": "warning", "level": "SHOULD", "title": "The diff changes only tests while a MUST requirement was added"},
	"trace-acceptance-script-untouched": {"severity": "error", "level": "MUST", "title": "A requirement names a script the diff did not touch"},
}
