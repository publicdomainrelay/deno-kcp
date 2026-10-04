package deno_kcp.policies.change_security

import rego.v1

import data.deno_kcp.lib.change
import data.deno_kcp.lib.code
import data.deno_kcp.lib.paths
import data.deno_kcp.lib.spec
import data.deno_kcp.lib.violation

# A spec or a diff that weakens transport: a delta that moves a check from
# https to http, a diff that replaces an https call with an http one, a command
# that pipes a fetched body into a shell, a repository manifest that gains a
# remote git source, or a line that turns certificate verification off.

violations contains v if {
	chg := spec.all_changes(input.spec_tree)[_]
	some index, entry in spec.change_delta_requirements(chg)
	is_object(entry)
	object.get(entry, "op", "") == "changed"
	fields := object.get(entry, "fields", [])
	is_array(fields)
	"text" in fields
	from := object.get(object.get(entry, "from", {}), "text", "")
	to := object.get(object.get(entry, "to", {}), "text", "")
	is_string(from)
	is_string(to)
	regex.match(`(?i)https:`, from)
	regex.match(`(?i)http:`, to)
	not regex.match(`(?i)https:`, to)
	v := violation.build(
		policy_id,
		"security-tls-downgrade-in-requirement",
		violation.change_location(
			object.get(chg, "name", ""),
			object.get(chg, "path", ""),
			sprintf("/spec/delta/requirements/%d", [index]),
		),
		sprintf("delta of requirement %s moves its text from an https check to an http one; an http fetch of a TLS listener checks nothing", [object.get(entry, "id", "?")]),
		{"requirement": object.get(entry, "id", ""), "from": from, "to": to},
	)
}

violations contains v if {
	d := object.get(input, "diff", null)
	removed := code.removed_rows(d)
	removed_paths := {row.path |
		some row in removed
		regex.match(`(?i)https://`, row.text)
	}
	row := code.added_rows(d)[_]
	row.path in removed_paths
	regex.match(`(?i)http://`, row.text)
	not regex.match(`(?i)https://`, row.text)
	v := violation.build(
		policy_id,
		"security-tls-downgrade-in-diff",
		violation.file_location("", row.path, row.line),
		sprintf("line %d of %s replaces an https call with %q; the TLS listener it reaches is not checked by an http fetch", [row.line, row.path, trim_space(row.text)]),
		{"path": row.path, "line": row.line},
	)
}

violations contains v if {
	steps := change.acceptance_steps(input.spec_tree)
	some index, step in steps
	command := change.step_command(step)
	is_array(command)
	joined := concat(" ", [part | some part in command; is_string(part)])
	regex.match(remote_exec_pattern, joined)
	v := violation.build(
		policy_id,
		"security-acceptance-runs-remote-code",
		violation.location("repository", "", "repository.yaml", sprintf("/spec/acceptance/%d/command", [index])),
		sprintf("acceptance %s runs %q, which fetches a body and hands it to a shell; code the spec never reviewed is not run by an acceptance step", [change.step_name(step), joined]),
		{"acceptance": change.step_name(step), "command": joined},
	)
}

violations contains v if {
	row := spec.all_requirements(input.spec_tree)[_]
	body := object.get(row.requirement, "text", "")
	is_string(body)
	regex.match(remote_exec_pattern, body)
	v := violation.build(
		policy_id,
		"security-acceptance-runs-remote-code",
		violation.requirement_location(row.context, row.path, row.index),
		sprintf("requirement %s pipes a fetched body to a shell; a requirement runs the code the spec names, not a body fetched at run time", [row.requirement.id]),
		{"requirement": row.requirement.id},
	)
}

violations contains v if {
	chg := spec.all_changes(input.spec_tree)[_]
	some index, entry in spec.change_delta_requirements(chg)
	is_object(entry)
	body := object.get(object.get(entry, "to", {}), "text", "")
	is_string(body)
	regex.match(remote_exec_pattern, body)
	v := violation.build(
		policy_id,
		"security-acceptance-runs-remote-code",
		violation.change_location(
			object.get(chg, "name", ""),
			object.get(chg, "path", ""),
			sprintf("/spec/delta/requirements/%d/to/text", [index]),
		),
		sprintf("delta of requirement %s introduces a command that pipes a fetched body to a shell; code the spec never reviewed is not run by an acceptance", [object.get(entry, "id", "?")]),
		{"requirement": object.get(entry, "id", "")},
	)
}

violations contains v if {
	file := code.diff_files(object.get(input, "diff", null))[_]
	path := code.file_path(file)
	paths.basename(path) == "repository.yaml"
	head := code.file_head_text(file)
	base := code.file_base_text(file)
	regex.match(`(?i)\bgit\s*:`, head)
	regex.match(`(?i)https?://`, head)
	not regex.match(`(?i)\bgit\s*:`, base)
	v := violation.build(
		policy_id,
		"security-remote-source-added",
		violation.file_location("", path, 0),
		sprintf("%s gains a remote git source; a spec tree describes the code checked out beside it, and a remote source is a different tree than the one under review", [path]),
		{"path": path},
	)
}

violations contains v if {
	row := code.added_rows(object.get(input, "diff", null))[_]
	regex.match(disabled_verification_pattern, row.text)
	not code.is_comment(row.text)
	v := violation.build(
		policy_id,
		"security-disabled-verification",
		violation.file_location("", row.path, row.line),
		sprintf("added line %d of %s is %q, which turns certificate verification off; a check that trusts any certificate checks nothing", [row.line, row.path, trim_space(row.text)]),
		{"path": row.path, "line": row.line},
	)
}
