package deno_kcp.policies.traceability_test

import rego.v1

import data.deno_kcp.policies.traceability as policy

full_hash := "1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef"

head_commit := "ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00"

req(code_refs) := {
	"id": "r.a",
	"level": "MUST",
	"text": "The provider writes the observed facts for the workspace it watches after every reconcile.",
	"codeRefs": code_refs,
}

req_without_code := {
	"id": "r.a",
	"level": "MUST",
	"text": "The provider writes the observed facts for the workspace it watches after every reconcile.",
}

head_context := {
	"name": "demo",
	"spec_path": "specs/demo.yaml",
	"status_path": "status/demo.yaml",
	"spec": {"requirements": [req(["file:deploy/a.sh"])]},
	"status": {
		"observed": {"files": ["deploy/a.sh"], "fingerprint": "aa"},
		"observedCommit": head_commit,
		"syncedCommit": head_commit,
		"realizedSpecHash": full_hash,
	},
}

head_tree := {
	"repository": {},
	"contexts": {"demo": head_context},
	"changes": {},
	"arch": {"system_contexts": [{"id": "sc.demo", "name": "demo", "code": ["deploy/a.sh"], "requirements": [{"id": "r.a", "codeRefs": ["file:deploy/a.sh"]}]}]},
}

base_tree := {
	"ref": "origin/open-architecture/deno-kcp",
	"repository": {},
	"contexts": {"demo": head_context},
	"changes": {},
	"context_names": ["demo"],
}

valid_diff := {
	"base": "origin/main",
	"head": head_commit,
	"paths": ["deploy/a.sh"],
	"commits": [{"sha": head_commit, "subject": "realize demo", "author": "specd", "date": "2026-01-01T00:00:00Z"}],
	"added": ["deploy/a.sh"],
	"modified": [],
	"deleted": [],
	"renamed": [],
	"untracked_paths": [],
}

valid_change := {
	"name": "demo-s2c-12345678",
	"path": "changes/demo-s2c-12345678.yaml",
	"document": {
		"spec": {"systemContext": "demo", "direction": "SpecToCode", "toSpecHash": full_hash, "delta": {"requirements": []}},
		"status": {
			"phase": "Succeeded",
			"commit": head_commit,
			"branch": "spec/demo/12345678",
			"filesTouched": ["deploy/a.sh"],
			"acceptance": [],
		},
	},
}

valid_input := {"spec_tree": head_tree, "base_tree": base_tree, "change": valid_change, "diff": valid_diff, "options": {"scope": "own"}}

ids(violations) := {v.id | some v in violations}

input_for(tree, base, change, diff) := {"spec_tree": tree, "base_tree": base, "change": change, "diff": diff, "options": {"scope": "own"}}

change_status_with(overrides) := object.union(valid_change, {
	"document": object.union(valid_change.document, {"status": object.union(valid_change.document.status, overrides)}),
})

change_spec_with(overrides) := object.union(valid_change, {
	"document": object.union(valid_change.document, {"spec": object.union(valid_change.document.spec, overrides)}),
})

context_with_reqs(reqs) := object.union(head_context, {"spec": object.union(head_context.spec, {"requirements": reqs})})

context_with_status(overrides) := object.union(head_context, {"status": object.union(head_context.status, overrides)})

tree_with_context(ctx) := object.union(head_tree, {"contexts": {"demo": ctx}})

base_with_context(ctx) := object.union(base_tree, {"contexts": {"demo": ctx}})

test_valid_input_raises_nothing if {
	violations := policy.violations with input as valid_input
	count(violations) == 0
}

test_base_input_without_change_raises_nothing if {
	violations := policy.violations with input as {"spec_tree": head_tree, "base_tree": base_tree, "change": null, "diff": null, "options": {"scope": "own"}}
	count(violations) == 0
}

test_null_base_tree_raises_nothing if {
	violations := policy.violations with input as input_for(head_tree, null, valid_change, valid_diff)
	count(violations) == 0
}

test_trace_files_touched_not_in_diff if {
	violations := policy.violations with input as input_for(head_tree, base_tree, change_status_with({"filesTouched": ["deploy/ghost.sh"]}), valid_diff)
	"traceability/trace-files-touched-not-in-diff" in ids(violations)
}

test_trace_files_touched_empty if {
	violations := policy.violations with input as input_for(head_tree, base_tree, change_status_with({"filesTouched": []}), valid_diff)
	"traceability/trace-files-touched-empty" in ids(violations)
}

test_trace_files_touched_absolute if {
	violations := policy.violations with input as input_for(head_tree, base_tree, change_status_with({"filesTouched": ["/etc/passwd"]}), valid_diff)
	"traceability/trace-files-touched-absolute" in ids(violations)
}

test_trace_commit_not_in_diff if {
	violations := policy.violations with input as input_for(head_tree, base_tree, change_status_with({"commit": "00112233445566778899aabbccddeeff00112233"}), valid_diff)
	"traceability/trace-commit-not-in-diff" in ids(violations)
}

test_trace_branch_commit_mismatch if {
	violations := policy.violations with input as input_for(head_tree, base_tree, change_status_with({"branch": "spec/demo/deadbeef"}), valid_diff)
	"traceability/trace-branch-commit-mismatch" in ids(violations)
}

test_trace_changed_requirement_code_ref_untouched if {
	base_ctx := context_with_reqs([req(["file:deploy/old.sh"])])
	head_ctx := context_with_reqs([req(["file:deploy/new.sh"])])
	violations := policy.violations with input as input_for(tree_with_context(head_ctx), base_with_context(base_ctx), valid_change, valid_diff)
	"traceability/trace-changed-requirement-code-ref-untouched" in ids(violations)
}

test_trace_added_requirement_without_code if {
	base_ctx := context_with_reqs([])
	head_ctx := context_with_reqs([req_without_code])
	violations := policy.violations with input as input_for(tree_with_context(head_ctx), base_with_context(base_ctx), valid_change, valid_diff)
	"traceability/trace-added-requirement-without-code" in ids(violations)
}

test_trace_diff_touches_unrelated_context if {
	diff := object.union(valid_diff, {"paths": ["other/x.go"]})
	violations := policy.violations with input as input_for(head_tree, base_tree, valid_change, diff)
	"traceability/trace-diff-touches-unrelated-context" in ids(violations)
}

test_trace_diff_touches_nothing if {
	diff := object.union(valid_diff, {"paths": []})
	change := change_spec_with({"delta": {"requirements": [{"id": "r.a", "op": "changed"}]}})
	violations := policy.violations with input as input_for(head_tree, base_tree, change, diff)
	"traceability/trace-diff-touches-nothing" in ids(violations)
}

test_trace_status_observed_files_stale if {
	ctx := context_with_status({"observed": {"files": ["deploy/other.sh"], "fingerprint": "aa"}})
	violations := policy.violations with input as input_for(tree_with_context(ctx), base_tree, valid_change, valid_diff)
	"traceability/trace-status-observed-files-stale" in ids(violations)
}

test_trace_synced_commit_not_observed if {
	ctx := context_with_status({"syncedCommit": "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"})
	violations := policy.violations with input as input_for(tree_with_context(ctx), base_tree, valid_change, valid_diff)
	"traceability/trace-synced-commit-not-observed" in ids(violations)
}

test_trace_realized_spec_hash_stale if {
	ctx := context_with_status({"realizedSpecHash": "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"})
	violations := policy.violations with input as input_for(tree_with_context(ctx), base_tree, valid_change, valid_diff)
	"traceability/trace-realized-spec-hash-stale" in ids(violations)
}

test_trace_arch_overlay_file_untouched if {
	base_ctx := context_with_reqs([req(["file:deploy/old.sh"])])
	head_ctx := context_with_reqs([req(["file:deploy/old.sh", "file:deploy/new.sh"])])
	tree := object.union(tree_with_context(head_ctx), {"arch": {"system_contexts": [{"id": "sc.demo", "name": "demo", "code": ["deploy/a.sh"], "requirements": [{"id": "r.a", "codeRefs": ["file:deploy/new.sh"]}]}]}})
	violations := policy.violations with input as input_for(tree, base_with_context(base_ctx), valid_change, valid_diff)
	"traceability/trace-arch-overlay-file-untouched" in ids(violations)
}

test_trace_test_changed_without_requirement if {
	base_ctx := context_with_reqs([req(["file:deploy/old.sh"])])
	head_ctx := context_with_reqs([req(["file:deploy/new.sh"])])
	diff := object.union(valid_diff, {"paths": ["deploy/x_test.go"]})
	violations := policy.violations with input as input_for(tree_with_context(head_ctx), base_with_context(base_ctx), valid_change, diff)
	"traceability/trace-test-changed-without-requirement" in ids(violations)
}

test_trace_acceptance_script_untouched if {
	base_ctx := context_with_reqs([req(["file:deploy/old.sh"])])
	head_req := object.union(req(["file:deploy/run.sh"]), {"text": "The script run.sh is the live acceptance of the example, and it exits non-zero unless every check passes."})
	head_ctx := context_with_reqs([head_req])
	violations := policy.violations with input as input_for(tree_with_context(head_ctx), base_with_context(base_ctx), valid_change, valid_diff)
	"traceability/trace-acceptance-script-untouched" in ids(violations)
}

test_metadata_names_every_violation_the_policy_can_raise if {
	some id, meta in policy.metadata
	count(object.keys(meta)) == 3
	meta.severity in {"error", "warning", "info"}
	meta.level in {"MUST", "SHOULD", "MAY"}
	is_string(meta.title)
	startswith(id, "")
}
