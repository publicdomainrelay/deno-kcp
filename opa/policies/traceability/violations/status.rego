package deno_kcp.policies.traceability

import rego.v1

import data.deno_kcp.lib.change
import data.deno_kcp.lib.violation

# Whether the context's recorded status agrees with what the change did.

violations contains v if {
	is_object(input.change)
	context := change.change_context_name(input.change)
	context != ""
	observed := change.context_observed_files(input.spec_tree, context)
	count(observed) > 0
	some f in change.files_touched(input.change)
	is_string(f)
	not f in {o | some o in observed}
	v := violation.build(
		policy_id,
		"trace-status-observed-files-stale",
		violation.change_location(object.get(input.change, "name", ""), object.get(input.change, "path", ""), "/status/filesTouched"),
		sprintf("the change touched %s but status.observed.files for %s does not list it, so the observation is stale", [f, context]),
		{"context": context, "path": f},
	)
}

violations contains v if {
	is_object(input.change)
	change.change_phase(input.change) == "Succeeded"
	context := change.change_context_name(input.change)
	context != ""
	observed := change.context_observed_commit(input.spec_tree, context)
	synced := change.context_synced_commit(input.spec_tree, context)
	observed != ""
	synced != ""
	synced != observed
	v := violation.build(
		policy_id,
		"trace-synced-commit-not-observed",
		violation.change_location(object.get(input.change, "name", ""), object.get(input.change, "path", ""), "/status/phase"),
		sprintf("change is Succeeded while %s records syncedCommit %s but observedCommit %s", [context, synced, observed]),
		{"context": context, "syncedCommit": synced, "observedCommit": observed},
	)
}

violations contains v if {
	is_object(input.change)
	change.change_phase(input.change) == "Succeeded"
	context := change.change_context_name(input.change)
	context != ""
	realized := change.context_realized_spec_hash(input.spec_tree, context)
	realized != ""
	hash := change.change_to_spec_hash(input.change)
	hash != ""
	realized != hash
	v := violation.build(
		policy_id,
		"trace-realized-spec-hash-stale",
		violation.change_location(object.get(input.change, "name", ""), object.get(input.change, "path", ""), "/status/phase"),
		sprintf("change is Succeeded while %s records realizedSpecHash %s but the change's toSpecHash is %s", [context, realized, hash]),
		{"context": context, "realizedSpecHash": realized, "toSpecHash": hash},
	)
}
