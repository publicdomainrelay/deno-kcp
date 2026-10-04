package deno_kcp.policies.change_integrity

import rego.v1

import data.deno_kcp.lib.refs
import data.deno_kcp.lib.spec
import data.deno_kcp.lib.violation

violations contains v if {
	has_change
	change := input.change
	name := object.get(change, "name", "")
	is_string(name)
	not refs.is_change_name(name)
	v := violation.build(
		policy_id,
		"change-name-malformed",
		violation.change_location(name, change.path, "/metadata/name"),
		sprintf("change name %q is not <context>-s2c-<12 hex> or <context>-c2s-<12 hex>-<12 hex>", [name]),
		{"name": name},
	)
}

violations contains v if {
	has_change
	change := input.change
	context := context_of(change)
	name := object.get(change, "name", "")
	is_string(name)
	context != ""
	not refs.is_change_name_for(name, context)
	v := violation.build(
		policy_id,
		"change-name-context-mismatch",
		violation.change_location(name, change.path, "/metadata/name"),
		sprintf("change %q names systemContext %s, so it is a change of another context's history", [name, context]),
		{"name": name, "systemContext": context},
	)
}

violations contains v if {
	has_change
	change := input.change
	metadata_name := object.get(change_metadata(change), "name", null)
	not is_string(metadata_name)
	v := violation.build(
		policy_id,
		"change-metadata-missing",
		violation.change_location(object.get(change, "name", ""), change.path, "/metadata/name"),
		"the change record carries no metadata.name",
		{},
	)
}

violations contains v if {
	has_change
	change := input.change
	context := object.get(change_spec(change), "systemContext", null)
	not is_string(context)
	v := violation.build(
		policy_id,
		"change-system-context-missing",
		violation.change_location(change.name, change.path, "/spec/systemContext"),
		"the change names no system context, so nothing says what it changes",
		{},
	)
}

violations contains v if {
	has_change
	change := input.change
	context := context_of(change)
	context != ""
	object.get(object.get(input.spec_tree, "contexts", {}), context, null) == null
	v := violation.build(
		policy_id,
		"change-system-context-unknown",
		violation.change_location(change.name, change.path, "/spec/systemContext"),
		sprintf("the change names context %s, which the tree does not hold", [context]),
		{"systemContext": context, "known": spec.context_names(input.spec_tree)},
	)
}

violations contains v if {
	has_change
	change := input.change
	direction := object.get(change_spec(change), "direction", null)
	not is_string(direction)
	v := violation.build(
		policy_id,
		"change-direction-missing",
		violation.change_location(change.name, change.path, "/spec/direction"),
		"the change declares no direction, so nothing says whether it edits the spec or the code",
		{},
	)
}

violations contains v if {
	has_change
	change := input.change
	direction := object.get(change_spec(change), "direction", "")
	is_string(direction)
	direction != ""
	not direction in change_directions
	v := violation.build(
		policy_id,
		"change-direction-invalid",
		violation.change_location(change.name, change.path, "/spec/direction"),
		sprintf("the change declares direction %q; a direction is SpecToCode or CodeToSpec", [direction]),
		{"direction": direction},
	)
}

violations contains v if {
	has_change
	change := input.change
	recorded := object.get(change_status(change), "phase", null)
	not is_string(recorded)
	v := violation.build(
		policy_id,
		"change-phase-missing",
		violation.change_location(change.name, change.path, "/status/phase"),
		"the change records no phase",
		{},
	)
}

violations contains v if {
	has_change
	change := input.change
	recorded := object.get(change_status(change), "phase", "")
	is_string(recorded)
	recorded != ""
	not recorded in change_phases
	v := violation.build(
		policy_id,
		"change-phase-invalid",
		violation.change_location(change.name, change.path, "/status/phase"),
		sprintf("the change records phase %q; a phase is Pending, Running, Succeeded or Failed", [recorded]),
		{"phase": recorded},
	)
}

violations contains v if {
	has_change
	change := input.change
	object.get(change_spec(change), "direction", "") == "SpecToCode"
	to_hash := object.get(change_spec(change), "toSpecHash", null)
	not is_string(to_hash)
	v := violation.build(
		policy_id,
		"change-hash-missing",
		violation.change_location(change.name, change.path, "/spec/toSpecHash"),
		"a SpecToCode change carries no toSpecHash, so nothing says which spec state the code was realized from",
		{},
	)
}

violations contains v if {
	has_change
	change := input.change
	to_hash := object.get(change_spec(change), "toSpecHash", null)
	is_string(to_hash)
	not refs.is_hash(to_hash)
	v := violation.build(
		policy_id,
		"change-hash-invalid",
		violation.change_location(change.name, change.path, "/spec/toSpecHash"),
		sprintf("toSpecHash %q is not a sha256 digest", [to_hash]),
		{"toSpecHash": to_hash},
	)
}

violations contains v if {
	has_change
	change := input.change
	from_hash := object.get(change_spec(change), "fromSpecHash", null)
	is_string(from_hash)
	not refs.is_hash(from_hash)
	v := violation.build(
		policy_id,
		"change-from-hash-invalid",
		violation.change_location(change.name, change.path, "/spec/fromSpecHash"),
		sprintf("fromSpecHash %q is not a sha256 digest", [from_hash]),
		{"fromSpecHash": from_hash},
	)
}

violations contains v if {
	has_change
	change := input.change
	from_hash := object.get(change_spec(change), "fromSpecHash", "")
	to_hash := object.get(change_spec(change), "toSpecHash", "")
	from_hash != ""
	from_hash == to_hash
	v := violation.build(
		policy_id,
		"change-to-hash-equals-from-hash",
		violation.change_location(change.name, change.path, "/spec/toSpecHash"),
		sprintf("the change moves the spec from %s to itself", [substring(from_hash, 0, 12)]),
		{"fromSpecHash": from_hash, "toSpecHash": to_hash},
	)
}

violations contains v if {
	has_change
	change := input.change
	object.get(change_spec(change), "direction", "") == "CodeToSpec"
	from_commit := object.get(change_spec(change), "fromCommit", "")
	to_commit := object.get(change_spec(change), "toCommit", "")
	from_commit == ""
	to_commit != ""
	v := violation.build(
		policy_id,
		"change-code-to-spec-commits-unpaired",
		violation.change_location(change.name, change.path, "/spec/fromCommit"),
		"a CodeToSpec change names toCommit without fromCommit, so the span it covers has no start",
		{"fromCommit": from_commit, "toCommit": to_commit},
	)
}

violations contains v if {
	has_change
	change := input.change
	object.get(change_spec(change), "direction", "") == "CodeToSpec"
	from_commit := object.get(change_spec(change), "fromCommit", "")
	to_commit := object.get(change_spec(change), "toCommit", "")
	from_commit != ""
	to_commit == ""
	v := violation.build(
		policy_id,
		"change-code-to-spec-commits-unpaired",
		violation.change_location(change.name, change.path, "/spec/toCommit"),
		"a CodeToSpec change names fromCommit without toCommit, so the span it covers has no end",
		{"fromCommit": from_commit, "toCommit": to_commit},
	)
}

violations contains v if {
	has_change
	change := input.change
	object.get(change_spec(change), "direction", "") == "CodeToSpec"
	from_commit := object.get(change_spec(change), "fromCommit", "")
	to_commit := object.get(change_spec(change), "toCommit", "")
	from_commit != ""
	from_commit == to_commit
	v := violation.build(
		policy_id,
		"change-commits-equal",
		violation.change_location(change.name, change.path, "/spec/toCommit"),
		sprintf("a CodeToSpec change names commit %s as both ends, so no code moved", [substring(from_commit, 0, 12)]),
		{"fromCommit": from_commit, "toCommit": to_commit},
	)
}

violations contains v if {
	has_change
	change := input.change
	some field in ["fromCommit", "toCommit"]
	value := object.get(change_spec(change), field, "")
	is_string(value)
	value != ""
	not regex.match(commit_pattern, value)
	v := violation.build(
		policy_id,
		"change-commit-invalid",
		violation.change_location(change.name, change.path, sprintf("/spec/%s", [field])),
		sprintf("%s %q is not a 40 character lowercase sha", [field, value]),
		{"field": field, "value": value},
	)
}

violations contains v if {
	has_change
	change := input.change
	to_hash := object.get(change_spec(change), "toSpecHash", "")
	is_string(to_hash)
	refs.is_hash(to_hash)
	context := context_of(change)
	context != ""
	known := known_spec_hashes(input.spec_tree, context)
	count(known) > 0
	not to_hash in known
	v := violation.build(
		policy_id,
		"change-to-spec-hash-not-in-tree",
		violation.change_location(change.name, change.path, "/spec/toSpecHash"),
		sprintf(
			"toSpecHash %s is neither the hash the context's code was realized from nor the hash its graph vertex carries, so the change points at a spec state the tree has never seen",
			[substring(to_hash, 0, 12)],
		),
		{"toSpecHash": to_hash, "known": known},
	)
}
