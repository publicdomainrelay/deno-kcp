package deno_kcp.policies.spec_structure

import rego.v1

import data.deno_kcp.lib.spec
import data.deno_kcp.lib.violation

violations contains v if {
	row := spec.all_requirements(input.spec_tree)[_]
	refs := object.get(row.requirement, "codeRefs", null)
	is_array(refs) == false
	refs != null
	v := violation.build(
		policy_id,
		"requirement-code-refs-not-a-list",
		violation.requirement_location(row.context, row.path, row.index),
		sprintf("requirement %s carries codeRefs that are not a list", [row.requirement.id]),
		{"requirement": row.requirement.id, "codeRefs": refs},
	)
}

violations contains v if {
	row := spec.all_requirements(input.spec_tree)[_]
	ref := object.get(row.requirement, "codeRefs", [])[_]
	not is_string(ref)
	v := violation.build(
		policy_id,
		"requirement-code-ref-not-a-string",
		violation.requirement_location(row.context, row.path, row.index),
		sprintf("requirement %s carries a codeRef that is not a string", [row.requirement.id]),
		{"requirement": row.requirement.id, "codeRef": ref},
	)
}
