package deno_kcp.policies.spec_structure

import rego.v1

import data.deno_kcp.lib.spec
import data.deno_kcp.lib.violation

violations contains v if {
	row := spec.all_requirements(input.spec_tree)[_]
	not is_string(object.get(row.requirement, "level", null))
	v := violation.build(
		policy_id,
		"requirement-level-missing",
		violation.requirement_location(row.context, row.path, row.index),
		sprintf("requirement %s declares no level", [object.get(row.requirement, "id", "?")]),
		{"requirement": object.get(row.requirement, "id", "")},
	)
}

violations contains v if {
	row := spec.all_requirements(input.spec_tree)[_]
	level := object.get(row.requirement, "level", "")
	is_string(level)
	level != ""
	not level in spec.requirement_levels
	v := violation.build(
		policy_id,
		"requirement-level-invalid",
		violation.requirement_location(row.context, row.path, row.index),
		sprintf(
			"requirement %s declares level %q; a level is MUST, SHOULD or MAY",
			[row.requirement.id, level],
		),
		{"requirement": row.requirement.id, "level": level},
	)
}
