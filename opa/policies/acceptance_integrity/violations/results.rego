package deno_kcp.policies.acceptance_integrity

import rego.v1

import data.deno_kcp.lib.change
import data.deno_kcp.lib.violation

# The results the change recorded for the acceptance it ran.
results := change.acceptance_results(input.change)

# A gating step failed when its recorded result says it did not pass, or its
# recorded exit code is non-zero. A step with no result at all is a different
# finding (acceptance-step-without-result), not a failure.
gating_failed(step) if {
	result := change.result_for(results, change.step_name(step))
	object.get(result, "passed", null) == false
}

gating_failed(step) if {
	result := change.result_for(results, change.step_name(step))
	code := change.result_exit_code(result)
	code != 0
}

violations contains v if {
	is_object(input.change)
	some index, result in results
	name := change.result_name(result)
	name != ""
	not name in change.step_names(steps)
	v := violation.build(
		policy_id,
		"acceptance-result-without-step",
		violation.change_location(object.get(input.change, "name", ""), object.get(input.change, "path", ""), sprintf("/status/acceptance/%d", [index])),
		sprintf("acceptance result %q matches no declared step, so its verdict belongs to nothing", [name]),
		{"index": index, "name": name},
	)
}

violations contains v if {
	is_object(input.change)
	some step in change.gated_steps(steps)
	name := change.step_name(step)
	name != ""
	count([r | some r in results; change.result_name(r) == name]) == 0
	v := violation.build(
		policy_id,
		"acceptance-step-without-result",
		violation.change_location(object.get(input.change, "name", ""), object.get(input.change, "path", ""), "/status/acceptance"),
		sprintf("gating acceptance step %q recorded no result, so the gate cannot be judged", [name]),
		{"name": name},
	)
}

violations contains v if {
	is_object(input.change)
	some index, result in results
	object.get(result, "passed", null) == true
	code := change.result_exit_code(result)
	code != 0
	v := violation.build(
		policy_id,
		"acceptance-result-passed-inconsistent",
		violation.change_location(object.get(input.change, "name", ""), object.get(input.change, "path", ""), sprintf("/status/acceptance/%d", [index])),
		sprintf("acceptance result %q is marked passed: true but its exitCode is %v", [change.result_name(result), code]),
		{"index": index, "name": change.result_name(result), "exitCode": code},
	)
}

violations contains v if {
	is_object(input.change)
	some index, result in results
	object.get(result, "passed", null) == false
	code := change.result_exit_code(result)
	code == 0
	v := violation.build(
		policy_id,
		"acceptance-result-passed-inconsistent",
		violation.change_location(object.get(input.change, "name", ""), object.get(input.change, "path", ""), sprintf("/status/acceptance/%d", [index])),
		sprintf("acceptance result %q is marked passed: false but its exitCode is 0", [change.result_name(result)]),
		{"index": index, "name": change.result_name(result), "exitCode": code},
	)
}

violations contains v if {
	is_object(input.change)
	some index, result in results
	not is_number(object.get(result, "exitCode", null))
	v := violation.build(
		policy_id,
		"acceptance-result-missing-exit-code",
		violation.change_location(object.get(input.change, "name", ""), object.get(input.change, "path", ""), sprintf("/status/acceptance/%d", [index])),
		sprintf("acceptance result %q records no exit code, so passed cannot be checked against it", [change.result_name(result)]),
		{"index": index, "name": change.result_name(result)},
	)
}

violations contains v if {
	is_object(input.change)
	some index, result in results
	object.get(result, "passed", null) == true
	duration := change.result_duration(result)
	duration == 0
	v := violation.build(
		policy_id,
		"acceptance-result-zero-duration",
		violation.change_location(object.get(input.change, "name", ""), object.get(input.change, "path", ""), sprintf("/status/acceptance/%d", [index])),
		sprintf("acceptance result %q is passed: true with durationSeconds 0, so it ran nothing", [change.result_name(result)]),
		{"index": index, "name": change.result_name(result)},
	)
}

violations contains v if {
	is_object(input.change)
	some index, result in results
	object.get(result, "passed", null) == true
	out := change.result_output(result)
	change.output_contradicts_pass(out)
	v := violation.build(
		policy_id,
		"acceptance-output-contradicts-passed",
		violation.change_location(object.get(input.change, "name", ""), object.get(input.change, "path", ""), sprintf("/status/acceptance/%d", [index])),
		sprintf("acceptance result %q is passed: true but its outputTail contains a failure marker; the output is %q", [change.result_name(result), out]),
		{"index": index, "name": change.result_name(result)},
	)
}

violations contains v if {
	is_object(input.change)
	some step in change.gated_steps(steps)
	gating_failed(step)
	name := change.step_name(step)
	result := change.result_for(results, name)
	v := violation.build(
		policy_id,
		"acceptance-gate-failed",
		violation.change_location(object.get(input.change, "name", ""), object.get(input.change, "path", ""), "/status/acceptance"),
		sprintf("gating acceptance step %q failed (exitCode %v, passed %v), so the change did not pass its gate", [name, object.get(result, "exitCode", null), object.get(result, "passed", null)]),
		{"name": name, "exitCode": object.get(result, "exitCode", null)},
	)
}

violations contains v if {
	is_object(input.change)
	change.change_phase(input.change) == "Succeeded"
	some step in change.gated_steps(steps)
	gating_failed(step)
	v := violation.build(
		policy_id,
		"acceptance-frozen-repository",
		violation.change_location(object.get(input.change, "name", ""), object.get(input.change, "path", ""), "/status/phase"),
		sprintf("change is phase Succeeded while gating acceptance step %q failed; a gating acceptance that cannot pass freezes every realization as Failed", [change.step_name(step)]),
		{"name": change.step_name(step), "phase": "Succeeded"},
	)
}

violations contains v if {
	is_object(input.change)
	some index, result in results
	object.get(result, "passed", null) == false
	out := object.get(result, "outputTail", null)
	is_string(out)
	trim_space(out) == ""
	v := violation.build(
		policy_id,
		"acceptance-output-tail-empty-on-failure",
		violation.change_location(object.get(input.change, "name", ""), object.get(input.change, "path", ""), sprintf("/status/acceptance/%d", [index])),
		sprintf("acceptance result %q failed but recorded no output, so the failure cannot be diagnosed", [change.result_name(result)]),
		{"index": index, "name": change.result_name(result)},
	)
}

violations contains v if {
	is_object(input.change)
	some index, result in results
	object.get(result, "passed", null) == false
	not is_string(object.get(result, "outputTail", null))
	v := violation.build(
		policy_id,
		"acceptance-output-tail-empty-on-failure",
		violation.change_location(object.get(input.change, "name", ""), object.get(input.change, "path", ""), sprintf("/status/acceptance/%d", [index])),
		sprintf("acceptance result %q failed but recorded no outputTail, so the failure cannot be diagnosed", [change.result_name(result)]),
		{"index": index, "name": change.result_name(result)},
	)
}
