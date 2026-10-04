package deno_kcp.policies.acceptance_integrity

import rego.v1

import data.deno_kcp.lib.change
import data.deno_kcp.lib.spec
import data.deno_kcp.lib.violation

# The acceptance steps the repository manifest declares, and the verify vector
# that runs before them.
steps := change.acceptance_steps(input.spec_tree)

repository_pointer := "/spec/acceptance"

violations contains v if {
	some index, step in steps
	name := object.get(step, "name", null)
	not is_string(name)
	v := violation.build(
		policy_id,
		"acceptance-step-name-missing",
		violation.location("repository", "", "repository.yaml", sprintf("/spec/acceptance/%d", [index])),
		sprintf("acceptance step %d carries no name; every acceptance step is addressable by a unique name", [index]),
		{"index": index},
	)
}

violations contains v if {
	some index, step in steps
	name := object.get(step, "name", null)
	is_string(name)
	name == ""
	v := violation.build(
		policy_id,
		"acceptance-step-name-missing",
		violation.location("repository", "", "repository.yaml", sprintf("/spec/acceptance/%d", [index])),
		sprintf("acceptance step %d carries an empty name; every acceptance step is addressable by a unique name", [index]),
		{"index": index},
	)
}

violations contains v if {
	some name in spec.duplicated(change.step_names(steps))
	count([n | some n in change.step_names(steps); n == name]) > 1
	v := violation.build(
		policy_id,
		"acceptance-step-name-duplicate",
		violation.location("repository", "", "repository.yaml", repository_pointer),
		sprintf("acceptance names step %q more than once, so a result cannot say which step it reports", [name]),
		{"name": name},
	)
}

violations contains v if {
	some index, step in steps
	name := object.get(step, "name", null)
	is_string(name)
	contains(name, "\n")
	v := violation.build(
		policy_id,
		"acceptance-step-name-has-newline",
		violation.location("repository", "", "repository.yaml", sprintf("/spec/acceptance/%d", [index])),
		sprintf("acceptance step %d carries a name with a newline, so it cannot be matched to a result", [index]),
		{"index": index, "name": name},
	)
}

violations contains v if {
	some index, step in steps
	command := object.get(step, "command", null)
	command == null
	v := violation.build(
		policy_id,
		"acceptance-step-command-empty",
		violation.location("repository", "", "repository.yaml", sprintf("/spec/acceptance/%d", [index])),
		sprintf("acceptance step %q declares no command, so it can never run", [change.step_name(step)]),
		{"index": index},
	)
}

violations contains v if {
	some index, step in steps
	command := object.get(step, "command", null)
	is_array(command)
	count(command) == 0
	v := violation.build(
		policy_id,
		"acceptance-step-command-empty",
		violation.location("repository", "", "repository.yaml", sprintf("/spec/acceptance/%d", [index])),
		sprintf("acceptance step %q declares an empty command, so it runs nothing", [change.step_name(step)]),
		{"index": index},
	)
}

violations contains v if {
	some index, step in steps
	command := object.get(step, "command", null)
	command != null
	is_array(command) == false
	v := violation.build(
		policy_id,
		"acceptance-step-command-not-a-list",
		violation.location("repository", "", "repository.yaml", sprintf("/spec/acceptance/%d", [index])),
		sprintf("acceptance step %q declares command %v, which is not an argv list", [change.step_name(step), command]),
		{"index": index, "command": command},
	)
}

violations contains v if {
	some index, step in steps
	timeout := object.get(step, "timeoutSeconds", null)
	is_number(timeout)
	timeout < 0
	v := violation.build(
		policy_id,
		"acceptance-step-timeout-negative",
		violation.location("repository", "", "repository.yaml", sprintf("/spec/acceptance/%d", [index])),
		sprintf("acceptance step %q declares timeoutSeconds %v; a timeout is zero or more", [change.step_name(step), timeout]),
		{"index": index, "timeoutSeconds": timeout},
	)
}

violations contains v if {
	change.has_acceptance(input.spec_tree)
	count(change.gated_steps(steps)) == 0
	v := violation.build(
		policy_id,
		"acceptance-no-gate",
		violation.location("repository", "", "repository.yaml", repository_pointer),
		"repository.yaml declares acceptance but no step sets gate: true, so no acceptance step can fail the change",
		{"steps": count(steps)},
	)
}

violations contains v if {
	gated := change.gated_steps(steps)
	count(gated) > 0
	count([s | some s in gated; not change.is_trivial_command(change.step_command(s))]) == 0
	v := violation.build(
		policy_id,
		"acceptance-gate-is-a-report",
		violation.location("repository", "", "repository.yaml", repository_pointer),
		sprintf("all %d gating acceptance step(s) run an empty or trivial command, so the gate only prints a report", [count(gated)]),
		{"steps": count(gated)},
	)
}

violations contains v if {
	raw := object.get(change.repository_spec(input.spec_tree), "verify", null)
	raw == null
	v := violation.build(
		policy_id,
		"verify-empty",
		violation.location("repository", "", "repository.yaml", "/spec/verify"),
		"repository.yaml declares no verify vector, so a realization runs nothing before it is accepted",
		{},
	)
}

violations contains v if {
	raw := object.get(change.repository_spec(input.spec_tree), "verify", null)
	is_array(raw)
	count(raw) == 0
	v := violation.build(
		policy_id,
		"verify-empty",
		violation.location("repository", "", "repository.yaml", "/spec/verify"),
		"repository.yaml declares an empty verify vector, so every realization passes without running anything",
		{},
	)
}

violations contains v if {
	raw := object.get(change.repository_spec(input.spec_tree), "verify", null)
	raw != null
	is_array(raw) == false
	v := violation.build(
		policy_id,
		"verify-not-a-list",
		violation.location("repository", "", "repository.yaml", "/spec/verify"),
		sprintf("repository.yaml declares verify %v, which is not an argv list", [raw]),
		{"verify": raw},
	)
}

violations contains v if {
	raw := object.get(change.repository_spec(input.spec_tree), "verify", null)
	change.verify_has_skip(raw)
	v := violation.build(
		policy_id,
		"verify-contains-skip",
		violation.location("repository", "", "repository.yaml", "/spec/verify"),
		sprintf("verify %v contains an option that skips the tests, so verify exits 0 without testing", [raw]),
		{"verify": raw},
	)
}

violations contains v if {
	raw := object.get(change.repository_spec(input.spec_tree), "verify", null)
	change.is_shell_argv(raw)
	v := violation.build(
		policy_id,
		"verify-command-is-a-shell",
		violation.location("repository", "", "repository.yaml", "/spec/verify"),
		sprintf("verify %v runs a compound command behind a shell, so its exit code is the shell's, not the tests'", [raw]),
		{"verify": raw},
	)
}
