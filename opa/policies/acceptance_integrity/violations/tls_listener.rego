package deno_kcp.policies.acceptance_integrity

import rego.v1

import data.deno_kcp.lib.change
import data.deno_kcp.lib.violation

# A spec that says a service runs with SERVICE_TLS true and then checks it over
# http:// checks the wrong listener. Both the acceptance command and the
# requirement prose are read for an http:// fetch, and the same context's prose
# is read for the TLS claim.

violations contains v if {
	is_object(input.change)
	context := change.change_context_name(input.change)
	context != ""
	requirements := change.context_requirements(input.spec_tree, context)
	some index, req in requirements
	text := object.get(req, "text", null)
	is_string(text)
	url := change.real_http_url(text)
	some other in requirements
	change.declares_service_tls(object.get(other, "text", ""))
	spec_path := object.get(change.context_of(input.spec_tree, context), "spec_path", "")
	v := violation.build(
		policy_id,
		"acceptance-http-check-on-tls-listener",
		violation.requirement_location(context, spec_path, index),
		sprintf("requirement %q fetches %s over http://, but this spec declares SERVICE_TLS true, so the fetch reaches a TLS listener and checks nothing; it must use https://", [object.get(req, "id", ""), url]),
		{"context": context, "requirement": object.get(req, "id", ""), "url": url},
	)
}

violations contains v if {
	is_object(input.change)
	context := change.change_context_name(input.change)
	context != ""
	some index, step in change.acceptance_steps(input.spec_tree)
	command := change.step_command(step)
	is_array(command)
	joined := concat(" ", [t | some t in command; is_string(t)])
	url := change.real_http_url(joined)
	some req in change.context_requirements(input.spec_tree, context)
	change.declares_service_tls(object.get(req, "text", ""))
	v := violation.build(
		policy_id,
		"acceptance-http-check-on-tls-listener",
		violation.location("repository", "", "repository.yaml", sprintf("/spec/acceptance/%d", [index])),
		sprintf("acceptance step %q fetches %s over http://, but this spec declares SERVICE_TLS true, so the fetch reaches a TLS listener and checks nothing; it must use https://", [change.step_name(step), url]),
		{"context": context, "step": change.step_name(step), "url": url},
	)
}
