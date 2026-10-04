package deno_kcp.policies.traceability

import rego.v1

import data.deno_kcp.lib.change
import data.deno_kcp.lib.paths
import data.deno_kcp.lib.violation

# What the change record says it touched, and whether the diff agrees.

violations contains v if {
	is_object(input.change)
	change.has_diff(input)
	some f in change.files_touched(input.change)
	is_string(f)
	not f in change.diff_path_set(input)
	v := violation.build(
		policy_id,
		"trace-files-touched-not-in-diff",
		violation.change_location(object.get(input.change, "name", ""), object.get(input.change, "path", ""), "/status/filesTouched"),
		sprintf("filesTouched names %s, which is not among the %d paths the diff touched", [f, count(change.diff_paths(input))]),
		{"path": f},
	)
}

violations contains v if {
	is_object(input.change)
	count(change.files_touched(input.change)) == 0
	v := violation.build(
		policy_id,
		"trace-files-touched-empty",
		violation.change_location(object.get(input.change, "name", ""), object.get(input.change, "path", ""), "/status/filesTouched"),
		"the change names no files it touched, so its realization cannot be traced to the code",
		{},
	)
}

violations contains v if {
	is_object(input.change)
	some f in change.files_touched(input.change)
	paths.is_absolute(f)
	v := violation.build(
		policy_id,
		"trace-files-touched-absolute",
		violation.change_location(object.get(input.change, "name", ""), object.get(input.change, "path", ""), "/status/filesTouched"),
		sprintf("filesTouched names the absolute path %s; every path is repo-relative", [f]),
		{"path": f},
	)
}

violations contains v if {
	is_object(input.change)
	change.has_diff(input)
	commit := change.change_commit(input.change)
	commit != ""
	not commit in change.commit_shas(input)
	commit != change.diff_head(input)
	v := violation.build(
		policy_id,
		"trace-commit-not-in-diff",
		violation.change_location(object.get(input.change, "name", ""), object.get(input.change, "path", ""), "/status/commit"),
		sprintf("status.commit %s is neither the diff head %s nor one of its %d commits", [commit, change.diff_head(input), count(change.diff_commits(input))]),
		{"commit": commit, "head": change.diff_head(input)},
	)
}

violations contains v if {
	is_object(input.change)
	context := change.change_context_name(input.change)
	context != ""
	hash := change.change_to_spec_hash(input.change)
	count(hash) >= 8
	branch := change.change_branch(input.change)
	branch != ""
	branch != sprintf("spec/%s/%s", [context, substring(hash, 0, 8)])
	v := violation.build(
		policy_id,
		"trace-branch-commit-mismatch",
		violation.change_location(object.get(input.change, "name", ""), object.get(input.change, "path", ""), "/status/branch"),
		sprintf("status.branch %s does not name toSpecHash %s; the branch for a SpecToCode change is spec/%s/%s", [branch, hash, context, substring(hash, 0, 8)]),
		{"branch": branch, "expected": sprintf("spec/%s/%s", [context, substring(hash, 0, 8)])},
	)
}
