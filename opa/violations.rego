package deno_kcp

import rego.v1

import data.deno_kcp.lib.violation

# The aggregator. Every policy set under policies/ contributes its own
# `violations` set and its own `metadata`. This package unions them, joins each
# violation with the severity and title its policy declared, and answers the one
# question a caller asks: is this spec tree, change and code diff safe.

policy_names := {"spec_structure"}

violations contains v if {
	some policy in policy_names
	some v in data.deno_kcp.policies[policy].violations
}

metadata := {policy: m |
	some policy in policy_names
	m := data.deno_kcp.policies[policy].metadata
}

report := violation.build_report(violations, metadata)

# The ids every violation this run raised can carry, so a caller can gate on
# one specific violation without counting.
violation_ids := {v.id | some v in violations}

by_policy(policy) := {v | some v in violations; v.policy == policy}

errors := [v | some v in violations; v.id in error_ids]

error_ids := {v.id |
	some v in violations
	meta := object.get(object.get(metadata, v.policy, {}), v.violation, {})
	object.get(meta, "severity", "error") == "error"
}

passed := count(errors) == 0

gate := passed
