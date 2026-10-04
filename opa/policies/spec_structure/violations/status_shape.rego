package deno_kcp.policies.spec_structure

import rego.v1

import data.deno_kcp.lib.refs
import data.deno_kcp.lib.spec
import data.deno_kcp.lib.violation

condition_types := {"SpecValid", "CodeSynced", "Drifted", "Indexed", "Populated", "BranchMismatch"}

violations contains v if {
	row := spec.contexts_in_scope(input.spec_tree)[_]
	is_object(object.get(row.context, "status", null))
	count(spec.conditions(row.context)) == 0
	v := violation.build(
		policy_id,
		"status-conditions-missing",
		violation.status_location(row.name, object.get(row.context, "status_path", ""), "/conditions"),
		sprintf("status of context %s carries no conditions, so nothing records whether the code and the spec agree", [row.name]),
		{},
	)
}

violations contains v if {
	row := spec.contexts_in_scope(input.spec_tree)[_]
	cond := spec.conditions(row.context)[_]
	not cond.type in condition_types
	v := violation.build(
		policy_id,
		"status-condition-type-unknown",
		violation.status_location(row.name, object.get(row.context, "status_path", ""), "/conditions"),
		sprintf("context %s carries condition type %q, which is not one of the six the schema names", [row.name, cond.type]),
		{"condition": cond},
	)
}

violations contains v if {
	row := spec.contexts_in_scope(input.spec_tree)[_]
	is_object(object.get(row.context, "status", null))
	fingerprint := object.get(spec.observed(row.context), "fingerprint", null)
	not is_string(fingerprint)
	v := violation.build(
		policy_id,
		"status-fingerprint-missing",
		violation.status_location(row.name, object.get(row.context, "status_path", ""), "/observed/fingerprint"),
		sprintf("status of context %s carries no observed fingerprint, so drift cannot be decided", [row.name]),
		{},
	)
}

violations contains v if {
	row := spec.contexts_in_scope(input.spec_tree)[_]
	hash := object.get(spec.status_of(row.context), "realizedSpecHash", null)
	is_string(hash)
	not refs.is_hash(hash)
	v := violation.build(
		policy_id,
		"status-realized-spec-hash-invalid",
		violation.status_location(row.name, object.get(row.context, "status_path", ""), "/realizedSpecHash"),
		sprintf("context %s records realizedSpecHash %q, which is not a sha256 digest", [row.name, hash]),
		{"realizedSpecHash": hash},
	)
}
