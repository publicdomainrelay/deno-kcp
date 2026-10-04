package deno_kcp.policies.change_quality

import rego.v1

import data.deno_kcp.lib.prose
import data.deno_kcp.lib.spec
import data.deno_kcp.lib.violation

# The intent and the requirement it governs are one prose and its check. When
# the intent carries the same long run of words as one of the context's own
# requirements, it restates that requirement instead of saying what the context
# is for.

violations contains v if {
	row := spec.contexts_in_scope(input.spec_tree)[_]
	intent := spec.intent(row.context)
	is_string(intent)
	intent != ""
	some index, requirement in spec.requirements(row.context)
	body := object.get(requirement, "text", "")
	is_string(body)
	prose.shares_run(intent, body, min_shared_run)
	v := violation.build(
		policy_id,
		"quality-intent-restates-a-requirement",
		violation.requirement_location(row.name, row.path, index),
		sprintf(
			"intent of context %s shares a %d-word run with requirement %s; the intent says what the context is for, the requirement says what to check",
			[row.name, min_shared_run, object.get(requirement, "id", "?")],
		),
		{"context": row.name, "requirement": object.get(requirement, "id", "")},
	)
}
