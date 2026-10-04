package deno_kcp.policies.traceability

import rego.v1

import data.deno_kcp.lib.change
import data.deno_kcp.lib.spec
import data.deno_kcp.lib.violation

# Whether the diff realizes the context the change names, and where the arch
# overlay says the change's files are.

# The file refs a delta row adds: the head's file refs minus the base's. For an
# added requirement the base is null and every head ref is new.
new_file_refs(row) := refs if {
	to_refs := change.requirement_file_refs(row.to)
	from_refs := change.requirement_file_refs(row.from)
	refs := {p | some p in to_refs; not p in from_refs}
}

violations contains v if {
	is_object(input.change)
	context := change.change_context_name(input.change)
	context != ""
	diff_set := change.diff_path_set(input)
	count(diff_set) > 0
	owned := change.context_file_refs(input.spec_tree, context)
	count(owned) > 0
	count(diff_set & owned) == 0
	v := violation.build(
		policy_id,
		"trace-diff-touches-unrelated-context",
		violation.change_location(object.get(input.change, "name", ""), object.get(input.change, "path", ""), "/spec/systemContext"),
		sprintf("the diff touches %d files but none of the %d the context %s names, so it realizes nothing this change is about", [count(diff_set), count(owned), context]),
		{"context": context, "paths": change.diff_paths(input)},
	)
}

violations contains v if {
	is_object(input.change)
	change.has_diff(input)
	context := change.change_context_name(input.change)
	context != ""
	count(change.delta_requirements(input.change)) > 0
	count(change.diff_paths(input)) == 0
	v := violation.build(
		policy_id,
		"trace-diff-touches-nothing",
		violation.change_location(object.get(input.change, "name", ""), object.get(input.change, "path", ""), "/spec/delta"),
		sprintf("the change claims a delta of %d requirement(s) but the diff is empty", [count(change.delta_requirements(input.change))]),
		{"context": context},
	)
}

violations contains v if {
	is_object(input.change)
	is_object(input.base_tree)
	context := change.change_context_name(input.change)
	context != ""
	rows := spec.requirement_diff(input.base_tree, input.spec_tree)
	row := rows[_]
	row.op in {"added", "changed"}
	row.context == context
	refs := new_file_refs(row)
	some f in refs
	f in change.arch_requirement_file_refs(input.spec_tree, row.context, row.id)
	not f in change.diff_path_set(input)
	v := violation.build(
		policy_id,
		"trace-arch-overlay-file-untouched",
		violation.change_location(object.get(input.change, "name", ""), object.get(input.change, "path", ""), "/spec/delta"),
		sprintf("requirement %s adds file %s to the arch overlay for %s, but the diff did not touch it", [row.id, f, row.context]),
		{"context": row.context, "requirement": row.id, "path": f},
	)
}
