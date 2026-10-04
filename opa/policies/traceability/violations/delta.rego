package deno_kcp.policies.traceability

import rego.v1

import data.deno_kcp.lib.change
import data.deno_kcp.lib.paths
import data.deno_kcp.lib.spec
import data.deno_kcp.lib.violation

# Whether the files the spec delta names were actually touched. The delta is
# read from the requirement-level diff of the base tree against the head tree,
# because the SpecChange record carries only the one edit that produced it.

requirement_pointer(row) := sprintf("/spec/requirements/%s", [row.id])

violations contains v if {
	is_object(input.base_tree)
	rows := spec.requirement_diff(input.base_tree, input.spec_tree)
	row := rows[_]
	row.op in {"changed", "added"}
	refs := change.requirement_file_refs(row.to)
	count(refs) > 0
	diff_set := change.diff_path_set(input)
	count({f | some f in refs; f in diff_set}) == 0
	v := violation.build(
		policy_id,
		"trace-changed-requirement-code-ref-untouched",
		violation.location("spec_requirement", row.context, sprintf("specs/%s.yaml", [row.context]), requirement_pointer(row)),
		sprintf("requirement %s is %s but every file it names (%v) is absent from the diff, so the change did not realize it", [row.id, row.op, refs]),
		{"context": row.context, "requirement": row.id, "op": row.op, "codeRefs": refs},
	)
}

violations contains v if {
	is_object(input.base_tree)
	rows := spec.requirement_diff(input.base_tree, input.spec_tree)
	row := rows[_]
	row.op == "added"
	refs := object.get(row.to, "codeRefs", null)
	not is_array(refs)
	v := violation.build(
		policy_id,
		"trace-added-requirement-without-code",
		violation.location("spec_requirement", row.context, sprintf("specs/%s.yaml", [row.context]), requirement_pointer(row)),
		sprintf("added requirement %s names no code, so nothing in the diff can realize it", [row.id]),
		{"context": row.context, "requirement": row.id},
	)
}

violations contains v if {
	is_object(input.base_tree)
	rows := spec.requirement_diff(input.base_tree, input.spec_tree)
	row := rows[_]
	row.op == "added"
	refs := object.get(row.to, "codeRefs", null)
	is_array(refs)
	count(refs) == 0
	v := violation.build(
		policy_id,
		"trace-added-requirement-without-code",
		violation.location("spec_requirement", row.context, sprintf("specs/%s.yaml", [row.context]), requirement_pointer(row)),
		sprintf("added requirement %s carries an empty codeRefs list, so nothing in the diff can realize it", [row.id]),
		{"context": row.context, "requirement": row.id},
	)
}

violations contains v if {
	is_object(input.change)
	is_object(input.base_tree)
	change.has_diff(input)
	diff_paths := change.diff_paths(input)
	count(diff_paths) > 0
	count([p | some p in diff_paths; not paths.is_test_path(p)]) == 0
	rows := spec.requirement_diff(input.base_tree, input.spec_tree)
	row := rows[_]
	row.op in {"added", "changed"}
	object.get(row.to, "level", "") == "MUST"
	v := violation.build(
		policy_id,
		"trace-test-changed-without-requirement",
		violation.change_location(object.get(input.change, "name", ""), object.get(input.change, "path", ""), "/spec/delta"),
		sprintf("the diff touches only test files while MUST requirement %s was %s; the realization is not in the tests alone", [row.id, row.op]),
		{"context": row.context, "requirement": row.id},
	)
}

violations contains v if {
	is_object(input.base_tree)
	rows := spec.requirement_diff(input.base_tree, input.spec_tree)
	row := rows[_]
	row.op in {"changed", "added"}
	text := object.get(row.to, "text", null)
	is_string(text)
	refs := change.requirement_file_refs(row.to)
	script := refs[_]
	change.is_script_path(script)
	contains(text, paths.basename(script))
	not script in change.diff_path_set(input)
	v := violation.build(
		policy_id,
		"trace-acceptance-script-untouched",
		violation.location("spec_requirement", row.context, sprintf("specs/%s.yaml", [row.context]), requirement_pointer(row)),
		sprintf("requirement %s names the script %s but the diff did not touch it", [row.id, script]),
		{"context": row.context, "requirement": row.id, "script": script},
	)
}
