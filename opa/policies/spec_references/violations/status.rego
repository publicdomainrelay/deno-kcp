package deno_kcp.policies.spec_references

import rego.v1

import data.deno_kcp.lib.spec
import data.deno_kcp.lib.violation

# The CodeSynced condition says whether the code was reconciled to the spec. A
# change recorded Succeeded while the context it names still records CodeSynced
# False is a change that claims an outcome the context denies.
succeeded_change_contexts := {name |
	some change in spec.all_changes(input.spec_tree)
	object.get(spec.change_status(change), "phase", "") == "Succeeded"
	name := spec.change_context(change)
	is_string(name)
	name != ""
}

violations contains v if {
	ctx := spec.contexts_in_scope(input.spec_tree)[_]
	condition := spec.condition_of_type(ctx.context, "CodeSynced")
	object.get(condition, "status", "") == "False"
	ctx.name in succeeded_change_contexts
	reason := object.get(condition, "reason", "")
	v := violation.build(
		policy_id,
		"status-code-synced-false",
		violation.status_location(ctx.name, object.get(ctx.context, "status_path", ""), "/conditions"),
		sprintf("context %s records CodeSynced False (%s) while a change for it is recorded phase Succeeded; a realization cannot have succeeded against a context whose code was never synced", [ctx.name, reason]),
		{"context": ctx.name, "reason": reason},
	)
}
