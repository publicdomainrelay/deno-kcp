package deno_kcp.policies.change_quality

import rego.v1

import data.deno_kcp.lib.prose
import data.deno_kcp.lib.spec
import data.deno_kcp.lib.violation

# The facts a change records about itself: the message it wrote, the agent log
# it kept, and whether a text edit changed anything but the punctuation.

scoped_change(change) if {
	context := spec.change_context(change)
	context != ""
	spec.in_scope(context)
}

agent_log_empty(change) if {
	log := object.get(spec.change_status(change), "agentLog", null)
	not is_string(log)
}

agent_log_empty(change) if {
	log := object.get(spec.change_status(change), "agentLog", "")
	is_string(log)
	trim_space(log) == ""
}

violations contains v if {
	change := spec.all_changes(input.spec_tree)[_]
	scoped_change(change)
	context := spec.change_context(change)
	message := object.get(spec.change_status(change), "message", "")
	is_string(message)
	message != ""
	not contains(message, context)
	v := violation.build(
		policy_id,
		"quality-change-message-names-no-context",
		violation.change_location(object.get(change, "name", ""), object.get(change, "path", ""), "/status/message"),
		sprintf(
			"change %s messages %q, which does not name its context %s; a reader of the message cannot tell which context changed",
			[object.get(change, "name", "?"), message, context],
		),
		{"change": object.get(change, "name", ""), "context": context, "message": message},
	)
}

violations contains v if {
	change := spec.all_changes(input.spec_tree)[_]
	scoped_change(change)
	agent_log_empty(change)
	v := violation.build(
		policy_id,
		"quality-agent-log-empty",
		violation.change_location(object.get(change, "name", ""), object.get(change, "path", ""), "/status/agentLog"),
		sprintf(
			"change %s records no agent log; a change without a log cannot be reviewed or reproduced",
			[object.get(change, "name", "?")],
		),
		{"change": object.get(change, "name", "")},
	)
}

violations contains v if {
	change := spec.all_changes(input.spec_tree)[_]
	scoped_change(change)
	some index, entry in spec.change_delta_requirements(change)
	is_object(entry)
	object.get(entry, "op", "") == "changed"
	fields := object.get(entry, "fields", [])
	is_array(fields)
	"text" in fields
	from := object.get(object.get(entry, "from", {}), "text", "")
	to := object.get(object.get(entry, "to", {}), "text", "")
	is_string(from)
	is_string(to)
	prose.text_adds_nothing(from, to)
	v := violation.build(
		policy_id,
		"quality-delta-text-change-adds-nothing",
		violation.change_location(
			object.get(change, "name", ""),
			object.get(change, "path", ""),
			sprintf("/spec/delta/requirements/%d", [index]),
		),
		sprintf(
			"delta of requirement %s changes its text only by punctuation or whitespace, from %q to %q; a text delta that adds nothing is noise in the record",
			[object.get(entry, "id", "?"), from, to],
		),
		{"requirement": object.get(entry, "id", ""), "from": from, "to": to},
	)
}
