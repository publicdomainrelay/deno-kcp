package deno_kcp.policies.spec_structure

import rego.v1

import data.deno_kcp.lib.refs
import data.deno_kcp.lib.spec
import data.deno_kcp.lib.violation

requirement_key(row) := key if {
	key := sprintf("%s/%s", [row.context, object.get(row.requirement, "id", "")])
}

duplicate_requirement_keys := {key |
	some row in spec.all_requirements(input.spec_tree)
	key := requirement_key(row)
	count([r | some r in spec.all_requirements(input.spec_tree); requirement_key(r) == key]) > 1
}

violations contains v if {
	row := spec.all_requirements(input.spec_tree)[_]
	not is_string(object.get(row.requirement, "id", null))
	v := violation.build(
		policy_id,
		"requirement-id-missing",
		violation.requirement_location(row.context, row.path, row.index),
		sprintf("requirement at index %d of context %s has no id", [row.index, row.context]),
		{"requirement_index": row.index},
	)
}

violations contains v if {
	row := spec.all_requirements(input.spec_tree)[_]
	id := object.get(row.requirement, "id", "")
	is_string(id)
	id != ""
	not regex.match(refs.requirement_id_pattern, id)
	v := violation.build(
		policy_id,
		"requirement-id-malformed",
		violation.requirement_location(row.context, row.path, row.index),
		sprintf("requirement id %q is not r.<kebab-case>", [id]),
		{"requirement": id},
	)
}

violations contains v if {
	some key in duplicate_requirement_keys
	rows := [row | some row in spec.all_requirements(input.spec_tree); requirement_key(row) == key]
	row := rows[0]
	v := violation.build(
		policy_id,
		"requirement-id-duplicate",
		violation.requirement_location(row.context, row.path, row.index),
		sprintf(
			"context %s declares requirement id %s %d times; a delta addresses a requirement by id and cannot address a duplicate",
			[row.context, row.requirement.id, count(rows)],
		),
		{"requirement": row.requirement.id, "count": count(rows), "indices": [r.index | some r in rows]},
	)
}
