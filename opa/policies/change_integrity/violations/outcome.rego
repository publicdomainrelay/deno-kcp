package deno_kcp.policies.change_integrity

import rego.v1

import data.deno_kcp.lib.paths
import data.deno_kcp.lib.violation

# A change that records no commit did not realize anything, so the rules that
# ask about the realization only apply once there is one.
realized(change) if {
	commit := object.get(change_status(change), "commit", "")
	is_string(commit)
	commit != ""
}

terminal(change) if phase(change) in {"Succeeded", "Failed"}

violations contains v if {
	has_change
	change := input.change
	terminal(change)
	commit := object.get(change_status(change), "branch", null)
	not is_string(commit)
	v := violation.build(
		policy_id,
		"change-branch-missing",
		violation.change_location(change.name, change.path, "/status/branch"),
		sprintf("change %s reached phase %s without recording the branch it was realized on", [change.name, phase(change)]),
		{"phase": phase(change)},
	)
}

violations contains v if {
	has_change
	change := input.change
	branch := object.get(change_status(change), "branch", "")
	is_string(branch)
	branch != ""
	not regex.match(branch_pattern, branch)
	v := violation.build(
		policy_id,
		"change-branch-malformed",
		violation.change_location(change.name, change.path, "/status/branch"),
		sprintf("branch %q is not spec/<context>/<first 8 of toSpecHash>", [branch]),
		{"branch": branch},
	)
}

violations contains v if {
	has_change
	change := input.change
	branch := object.get(change_status(change), "branch", "")
	is_string(branch)
	regex.match(branch_pattern, branch)
	to_hash := object.get(change_spec(change), "toSpecHash", "")
	is_string(to_hash)
	refs_match := endswith(branch, sprintf("/%s", [substring(to_hash, 0, 8)]))
	not refs_match
	v := violation.build(
		policy_id,
		"change-branch-hash-mismatch",
		violation.change_location(change.name, change.path, "/status/branch"),
		sprintf(
			"branch %q ends in %s but toSpecHash begins %s, so the branch is not the one this spec state was realized on",
			[branch, substring(branch, count(branch) - 8, 8), substring(to_hash, 0, 8)],
		),
		{"branch": branch, "toSpecHash": to_hash},
	)
}

violations contains v if {
	has_change
	change := input.change
	realized(change)
	files := object.get(change_status(change), "filesTouched", null)
	not is_array(files)
	v := violation.build(
		policy_id,
		"change-files-touched-missing",
		violation.change_location(change.name, change.path, "/status/filesTouched"),
		sprintf("change %s records a commit but no filesTouched list, so nothing says what it changed", [change.name]),
		{},
	)
}

violations contains v if {
	has_change
	change := input.change
	realized(change)
	files := files_touched(change)
	count(files) == 0
	v := violation.build(
		policy_id,
		"change-files-touched-empty",
		violation.change_location(change.name, change.path, "/status/filesTouched"),
		sprintf("change %s records a commit and an empty filesTouched list", [change.name]),
		{},
	)
}

violations contains v if {
	has_change
	change := input.change
	file := files_touched(change)[_]
	is_string(file)
	not paths.is_named_path(file)
	v := violation.build(
		policy_id,
		"change-files-touched-path-absolute",
		violation.change_location(change.name, change.path, "/status/filesTouched"),
		sprintf("filesTouched names %q, which is not a repo-relative path with forward slashes", [file]),
		{"file": file},
	)
}

violations contains v if {
	has_change
	change := input.change
	terminal(change)
	message := object.get(change_status(change), "message", "")
	is_string(message)
	trim_space(message) == ""
	v := violation.build(
		policy_id,
		"change-message-empty",
		violation.change_location(change.name, change.path, "/status/message"),
		sprintf("change %s reached phase %s with no message, so its outcome is unreadable", [change.name, phase(change)]),
		{},
	)
}

violations contains v if {
	has_change
	change := input.change
	terminal(change)
	log := object.get(change_status(change), "agentLog", "")
	is_string(log)
	trim_space(log) == ""
	v := violation.build(
		policy_id,
		"change-agent-log-empty",
		violation.change_location(change.name, change.path, "/status/agentLog"),
		sprintf("change %s reached phase %s with no agent log, so what the agent did cannot be reviewed", [change.name, phase(change)]),
		{},
	)
}

violations contains v if {
	has_change
	change := input.change
	rows := progress(change)
	count(rows) > max_progress_records
	v := violation.build(
		policy_id,
		"change-progress-over-cap",
		violation.change_location(change.name, change.path, "/status/progress"),
		sprintf("change %s carries %d progress records; the cap is %d and the oldest are meant to be evicted", [change.name, count(rows), max_progress_records]),
		{"records": count(rows), "cap": max_progress_records},
	)
}

violations contains v if {
	has_change
	change := input.change
	some index, result in acceptance_results(change)
	name := object.get(result, "name", null)
	not is_string(name)
	v := violation.build(
		policy_id,
		"change-acceptance-name-missing",
		violation.change_location(change.name, change.path, sprintf("/status/acceptance/%d", [index])),
		sprintf("acceptance result %d names no step, so it cannot be matched to the step that produced it", [index]),
		{"acceptance_index": index},
	)
}

violations contains v if {
	has_change
	change := input.change
	some index, result in acceptance_results(change)
	code := object.get(result, "exitCode", null)
	is_number(code)
	code < 0
	v := violation.build(
		policy_id,
		"change-acceptance-negative-exit-code",
		violation.change_location(change.name, change.path, sprintf("/status/acceptance/%d", [index])),
		sprintf("acceptance step %s reports exit code %d, which is a signal rather than a status", [object.get(result, "name", "?"), code]),
		{"acceptance_index": index, "exitCode": code},
	)
}

# The headline. specd's own gate semantics say a failing gating acceptance step
# fails the change; a record that says Succeeded while a step says passed false
# is a record the repository will trust and should not.
violations contains v if {
	has_change
	change := input.change
	phase(change) == "Succeeded"
	some index, result in acceptance_results(change)
	object.get(result, "passed", null) == false
	v := violation.build(
		policy_id,
		"change-succeeded-with-failed-acceptance",
		violation.change_location(change.name, change.path, sprintf("/status/acceptance/%d", [index])),
		sprintf(
			"change %s is Succeeded while acceptance step %s reports passed false (exit code %v, %v seconds), so the gate that exists to stop it was recorded and then ignored",
			[change.name, object.get(result, "name", "?"), object.get(result, "exitCode", null), object.get(result, "durationSeconds", null)],
		),
		{
			"phase": phase(change),
			"acceptance": object.get(result, "name", ""),
			"exitCode": object.get(result, "exitCode", null),
			"outputTail": object.get(result, "outputTail", ""),
		},
	)
}

violations contains v if {
	has_change
	change := input.change
	phase(change) == "Succeeded"
	code := object.get(change_status(change), "verifyExitCode", null)
	is_number(code)
	code != 0
	v := violation.build(
		policy_id,
		"change-succeeded-with-nonzero-verify",
		violation.change_location(change.name, change.path, "/status/verifyExitCode"),
		sprintf("change %s is Succeeded while the verify vector exited %d", [change.name, code]),
		{"verifyExitCode": code},
	)
}
