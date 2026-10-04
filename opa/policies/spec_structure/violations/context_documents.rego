package deno_kcp.policies.spec_structure

import rego.v1

import data.deno_kcp.lib.spec
import data.deno_kcp.lib.violation

violations contains v if {
	row := spec.contexts_in_scope(input.spec_tree)[_]
	not is_object(object.get(row.context, "status", null))
	v := violation.build(
		policy_id,
		"context-status-missing",
		violation.context_location(row.name, row.path),
		sprintf("context %s has no status file at %s, so no observed fact backs it", [row.name, object.get(row.context, "status_path", "")]),
		{"expected": object.get(row.context, "status_path", "")},
	)
}

violations contains v if {
	row := spec.contexts_in_scope(input.spec_tree)[_]
	not is_object(object.get(row.context, "context_doc", null))
	v := violation.build(
		policy_id,
		"context-document-missing",
		violation.context_location(row.name, row.path),
		sprintf("context %s has no context document at %s, so no model reads it", [row.name, object.get(row.context, "context_doc_path", "")]),
		{"expected": object.get(row.context, "context_doc_path", "")},
	)
}
