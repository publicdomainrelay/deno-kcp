package deno_kcp.policies.change_integrity

import rego.v1

import data.deno_kcp.lib.violation

delta_location(change, index) := loc if {
	loc := violation.change_location(change.name, change.path, sprintf("/spec/delta/requirements/%d", [index]))
}

violations contains v if {
	has_change
	change := input.change
	some index, entry in delta_requirements(change)
	op := object.get(entry, "op", null)
	not is_string(op)
	v := violation.build(
		policy_id,
		"change-delta-entry-missing-op",
		delta_location(change, index),
		sprintf("delta entry %d declares no op, so nothing says whether the requirement was added, removed or changed", [index]),
		{"delta_index": index},
	)
}

violations contains v if {
	has_change
	change := input.change
	some index, entry in delta_requirements(change)
	op := object.get(entry, "op", "")
	is_string(op)
	op != ""
	not op in delta_ops
	v := violation.build(
		policy_id,
		"change-delta-op-invalid",
		delta_location(change, index),
		sprintf("delta entry %d declares op %q; an op is added, removed or changed", [index, op]),
		{"delta_index": index, "op": op},
	)
}

violations contains v if {
	has_change
	change := input.change
	some index, entry in delta_requirements(change)
	id := object.get(entry, "id", null)
	not is_string(id)
	v := violation.build(
		policy_id,
		"change-delta-entry-missing-id",
		delta_location(change, index),
		sprintf("delta entry %d names no requirement, so it cannot be applied to anything", [index]),
		{"delta_index": index},
	)
}

violations contains v if {
	has_change
	change := input.change
	some index, entry in delta_requirements(change)
	object.get(entry, "op", "") == "changed"
	from := object.get(entry, "from", null)
	not is_object(from)
	v := violation.build(
		policy_id,
		"change-delta-changed-needs-both-sides",
		delta_location(change, index),
		sprintf("delta entry %s is a change but carries no from side, so there is nothing to have changed from", [object.get(entry, "id", "?")]),
		{"delta_index": index, "id": object.get(entry, "id", "")},
	)
}

violations contains v if {
	has_change
	change := input.change
	some index, entry in delta_requirements(change)
	object.get(entry, "op", "") == "changed"
	from := object.get(entry, "from", null)
	to := object.get(entry, "to", null)
	is_object(from)
	not is_object(to)
	v := violation.build(
		policy_id,
		"change-delta-changed-needs-both-sides",
		delta_location(change, index),
		sprintf("delta entry %s is a change but carries no to side, so nothing says what it became", [object.get(entry, "id", "?")]),
		{"delta_index": index, "id": object.get(entry, "id", "")},
	)
}

violations contains v if {
	has_change
	change := input.change
	some index, entry in delta_requirements(change)
	object.get(entry, "op", "") == "added"
	is_object(object.get(entry, "from", null))
	v := violation.build(
		policy_id,
		"change-delta-added-needs-only-to",
		delta_location(change, index),
		sprintf("delta entry %s is an addition but carries a from side, so it is a change wearing the wrong op", [object.get(entry, "id", "?")]),
		{"delta_index": index, "id": object.get(entry, "id", "")},
	)
}

violations contains v if {
	has_change
	change := input.change
	some index, entry in delta_requirements(change)
	object.get(entry, "op", "") == "removed"
	is_object(object.get(entry, "to", null))
	v := violation.build(
		policy_id,
		"change-delta-removed-needs-only-from",
		delta_location(change, index),
		sprintf("delta entry %s is a removal but carries a to side, so it is a change wearing the wrong op", [object.get(entry, "id", "?")]),
		{"delta_index": index, "id": object.get(entry, "id", "")},
	)
}

violations contains v if {
	has_change
	change := input.change
	some index, entry in delta_requirements(change)
	field := object.get(entry, "fields", [])[_]
	is_string(field)
	not field in delta_fields
	v := violation.build(
		policy_id,
		"change-delta-field-unknown",
		delta_location(change, index),
		sprintf("delta entry %s names field %q, which is not a field a requirement or an interface carries", [object.get(entry, "id", "?"), field]),
		{"delta_index": index, "id": object.get(entry, "id", ""), "field": field},
	)
}

violations contains v if {
	has_change
	change := input.change
	some index, entry in delta_requirements(change)
	object.get(entry, "op", "") == "changed"
	from := object.get(entry, "from", null)
	to := object.get(entry, "to", null)
	is_object(from)
	is_object(to)
	from == to
	v := violation.build(
		policy_id,
		"change-delta-entry-identical",
		delta_location(change, index),
		sprintf("delta entry %s is a change whose two sides are identical, so it records an edit that did not happen", [object.get(entry, "id", "?")]),
		{"delta_index": index, "id": object.get(entry, "id", "")},
	)
}
