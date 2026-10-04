package deno_kcp.policies.acceptance_integrity_test

import rego.v1

import data.deno_kcp.policies.acceptance_integrity as policy

valid_step := {
	"name": "market-live",
	"command": ["bash", "accept.sh"],
	"gate": true,
	"timeoutSeconds": 600,
}

valid_result := {
	"name": "market-live",
	"exitCode": 0,
	"durationSeconds": 12.5,
	"passed": true,
	"outputTail": "all checks passed",
}

valid_repository := {
	"spec": {
		"branch": "spec/demo",
		"verify": ["go", "test", "./..."],
		"acceptance": [valid_step],
	},
}

valid_change := {
	"name": "demo-s2c-1234567890ab",
	"path": "changes/demo-s2c-1234567890ab.yaml",
	"document": {
		"spec": {"systemContext": "demo", "direction": "SpecToCode", "toSpecHash": "1234567890ab", "delta": {"requirements": []}},
		"status": {"phase": "Succeeded", "acceptance": [valid_result]},
	},
}

base_tree := {"repository": valid_repository, "contexts": {}, "changes": {}}

valid_input := {"spec_tree": base_tree, "base_tree": null, "change": valid_change, "diff": null, "options": {"scope": "own"}}

ids(violations) := {v.id | some v in violations}

repo_with(overrides) := object.union(valid_repository, {"spec": object.union(valid_repository.spec, overrides)})

tree_with(overrides) := object.union(base_tree, {"repository": repo_with(overrides)})

change_status_with(overrides) := object.union(valid_change, {
	"document": object.union(valid_change.document, {"status": object.union(valid_change.document.status, overrides)}),
})

input_for(tree, change) := {"spec_tree": tree, "base_tree": null, "change": change, "diff": null, "options": {"scope": "own"}}

test_valid_tree_raises_nothing if {
	violations := policy.violations with input as valid_input
	count(violations) == 0
}

test_base_input_without_change_raises_nothing if {
	violations := policy.violations with input as {"spec_tree": base_tree, "base_tree": null, "change": null, "diff": null, "options": {"scope": "own"}}
	count(violations) == 0
}

test_acceptance_step_name_missing if {
	step := object.remove(valid_step, ["name"])
	violations := policy.violations with input as input_for(tree_with({"acceptance": [step]}), valid_change)
	"acceptance_integrity/acceptance-step-name-missing" in ids(violations)
}

test_acceptance_step_name_duplicate if {
	violations := policy.violations with input as input_for(tree_with({"acceptance": [valid_step, valid_step]}), valid_change)
	"acceptance_integrity/acceptance-step-name-duplicate" in ids(violations)
}

test_acceptance_step_name_has_newline if {
	step := object.union(valid_step, {"name": "market\nlive"})
	violations := policy.violations with input as input_for(tree_with({"acceptance": [step]}), valid_change)
	"acceptance_integrity/acceptance-step-name-has-newline" in ids(violations)
}

test_acceptance_step_command_empty if {
	step := object.union(valid_step, {"command": []})
	violations := policy.violations with input as input_for(tree_with({"acceptance": [step]}), valid_change)
	"acceptance_integrity/acceptance-step-command-empty" in ids(violations)
}

test_acceptance_step_command_not_a_list if {
	step := object.union(valid_step, {"command": "bash accept.sh"})
	violations := policy.violations with input as input_for(tree_with({"acceptance": [step]}), valid_change)
	"acceptance_integrity/acceptance-step-command-not-a-list" in ids(violations)
}

test_acceptance_step_timeout_negative if {
	step := object.union(valid_step, {"timeoutSeconds": -1})
	violations := policy.violations with input as input_for(tree_with({"acceptance": [step]}), valid_change)
	"acceptance_integrity/acceptance-step-timeout-negative" in ids(violations)
}

test_acceptance_no_gate if {
	step := object.union(valid_step, {"gate": false})
	violations := policy.violations with input as input_for(tree_with({"acceptance": [step]}), valid_change)
	"acceptance_integrity/acceptance-no-gate" in ids(violations)
}

test_acceptance_gate_is_a_report if {
	step := object.union(valid_step, {"command": ["echo", "ok"]})
	violations := policy.violations with input as input_for(tree_with({"acceptance": [step]}), valid_change)
	"acceptance_integrity/acceptance-gate-is-a-report" in ids(violations)
}

test_verify_empty if {
	violations := policy.violations with input as input_for(tree_with({"verify": []}), valid_change)
	"acceptance_integrity/verify-empty" in ids(violations)
}

test_verify_not_a_list if {
	violations := policy.violations with input as input_for(tree_with({"verify": "go test ./..."}), valid_change)
	"acceptance_integrity/verify-not-a-list" in ids(violations)
}

test_verify_contains_skip if {
	violations := policy.violations with input as input_for(tree_with({"verify": ["go", "test", "-short", "./..."]}), valid_change)
	"acceptance_integrity/verify-contains-skip" in ids(violations)
}

test_verify_command_is_a_shell if {
	violations := policy.violations with input as input_for(tree_with({"verify": ["bash", "-c", "go test ./... && echo done"]}), valid_change)
	"acceptance_integrity/verify-command-is-a-shell" in ids(violations)
}

test_acceptance_result_without_step if {
	result := object.union(valid_result, {"name": "ghost"})
	violations := policy.violations with input as input_for(base_tree, change_status_with({"acceptance": [result]}))
	"acceptance_integrity/acceptance-result-without-step" in ids(violations)
}

test_acceptance_step_without_result if {
	violations := policy.violations with input as input_for(base_tree, change_status_with({"acceptance": []}))
	"acceptance_integrity/acceptance-step-without-result" in ids(violations)
}

test_acceptance_result_passed_inconsistent if {
	result := object.union(valid_result, {"passed": true, "exitCode": 1})
	violations := policy.violations with input as input_for(base_tree, change_status_with({"acceptance": [result]}))
	"acceptance_integrity/acceptance-result-passed-inconsistent" in ids(violations)
}

test_acceptance_result_missing_exit_code if {
	result := object.remove(valid_result, ["exitCode"])
	violations := policy.violations with input as input_for(base_tree, change_status_with({"acceptance": [result]}))
	"acceptance_integrity/acceptance-result-missing-exit-code" in ids(violations)
}

test_acceptance_result_zero_duration if {
	result := object.union(valid_result, {"durationSeconds": 0})
	violations := policy.violations with input as input_for(base_tree, change_status_with({"acceptance": [result]}))
	"acceptance_integrity/acceptance-result-zero-duration" in ids(violations)
}

test_acceptance_output_contradicts_passed if {
	result := object.union(valid_result, {"outputTail": "FAIL: five pods ready=false"})
	violations := policy.violations with input as input_for(base_tree, change_status_with({"acceptance": [result]}))
	"acceptance_integrity/acceptance-output-contradicts-passed" in ids(violations)
}

test_acceptance_gate_failed if {
	result := object.union(valid_result, {"passed": false, "exitCode": 1, "outputTail": "accept: fail"})
	violations := policy.violations with input as input_for(base_tree, change_status_with({"acceptance": [result]}))
	"acceptance_integrity/acceptance-gate-failed" in ids(violations)
}

test_acceptance_frozen_repository if {
	result := object.union(valid_result, {"passed": false, "exitCode": 1, "outputTail": "accept: fail"})
	violations := policy.violations with input as input_for(base_tree, change_status_with({"acceptance": [result], "phase": "Succeeded"}))
	"acceptance_integrity/acceptance-frozen-repository" in ids(violations)
}

test_acceptance_output_tail_empty_on_failure if {
	result := object.union(valid_result, {"passed": false, "exitCode": 1, "outputTail": ""})
	violations := policy.violations with input as input_for(base_tree, change_status_with({"acceptance": [result]}))
	"acceptance_integrity/acceptance-output-tail-empty-on-failure" in ids(violations)
}

test_acceptance_http_check_on_tls_listener if {
	context := {
		"name": "demo",
		"spec_path": "specs/demo.yaml",
		"status_path": "status/demo.yaml",
		"spec": {"requirements": [
			{"id": "r.tls", "level": "MUST", "text": "Every service pod sets SERVICE_TLS true and the listener the host reaches is the TLS one."},
			{"id": "r.check", "level": "MUST", "text": "The acceptance proves the pds answers with curl http://127.0.0.1:2585/xrpc/_health."},
		]},
		"status": {},
	}
	tree := object.union(base_tree, {"contexts": {"demo": context}})
	violations := policy.violations with input as input_for(tree, valid_change)
	"acceptance_integrity/acceptance-http-check-on-tls-listener" in ids(violations)
}

test_metadata_names_every_violation_the_policy_can_raise if {
	some id, meta in policy.metadata
	count(object.keys(meta)) == 3
	meta.severity in {"error", "warning", "info"}
	meta.level in {"MUST", "SHOULD", "MAY"}
	is_string(meta.title)
	startswith(id, "")
}
