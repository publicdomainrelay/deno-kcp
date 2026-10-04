package deno_kcp.policies.change_impact

import rego.v1

import data.deno_kcp.lib.spec

# change_impact asks what a change does to the meaning of the spec, rather than
# whether the record is well formed. It reads the whole spec delta of the
# branch, not only the delta entry the SpecChange record carries: a record names
# the edit that produced it, while the branch's effect is the difference between
# input.base_tree and input.spec_tree.
#
# The rules are comparative. A requirement that lost a code ref, a level that
# went down, a text that stopped forbidding: each is a weakening no
# well-formedness rule can see, because every document involved is well formed.

policy_id := "change_impact"

level_rank := {"MUST": 3, "SHOULD": 2, "MAY": 1}

# Phrases that make a sentence forbid or require, so that losing one is losing
# force. Kept here rather than in lib/text because what counts as a loss is this
# policy's judgement, not a fact about prose.
force_phrases := [
	"must not",
	"may not",
	"shall not",
	"must ",
	"shall ",
	"is required",
	"are required",
	"is forbidden",
	"never ",
	"only ",
	"exactly ",
	"at least ",
	"at most ",
	"no more than",
	"no fewer than",
]

has_base_tree if is_object(object.get(input, "base_tree", null))

has_change if is_object(object.get(input, "change", null))

change_label := name if {
	has_change
	name := object.get(input.change, "name", "")
}

change_label := "spec tree diff" if not has_change

change_phase := recorded if {
	has_change
	recorded := object.get(spec.change_status(input.change), "phase", "")
}

terminal if change_phase in {"Succeeded", "Failed"}

# The requirement-level rows of the branch's spec delta, as
# {context, op, id, from, to, fields}. Empty when neither a base tree nor a
# change record was loaded, so every rule below is silent rather than guessing.
delta_rows contains row if {
	has_base_tree
	some row in spec.requirement_diff(input.base_tree, input.spec_tree)
}

delta_rows contains row if {
	not has_base_tree
	has_change
	some entry in spec.change_delta_requirements(input.change)
	row := object.union(entry, {"context": spec.change_context(input.change)})
}

interface_rows contains row if {
	has_base_tree
	some row in spec.interface_diff(input.base_tree, input.spec_tree)
}

# The acceptance steps the repository manifest declares, and the ones that gate.
acceptance_steps := steps if {
	steps := object.get(
		object.get(object.get(input.spec_tree, "repository", {}), "spec", {}),
		"acceptance",
		[],
	)
	is_array(steps)
}

gating_steps := [step | some step in acceptance_steps; object.get(step, "gate", false) == true]

delta_location(row, pointer) := loc if {
	loc := {
		"kind": "spec_delta",
		"context": object.get(row, "context", ""),
		"path": sprintf("changes/%s", [change_label]),
		"pointer": pointer,
		"file": "",
		"line": 0,
	}
}

metadata := {
	"impact-removes-requirement": {"severity": "warning", "level": "SHOULD", "title": "A change removes a requirement"},
	"impact-removes-must-requirement": {"severity": "warning", "level": "SHOULD", "title": "A change removes a MUST requirement"},
	"impact-removes-requirement-without-replacement": {"severity": "error", "level": "MUST", "title": "A removed requirement's behaviour is not carried by anything added"},
	"impact-downgrades-level": {"severity": "error", "level": "MUST", "title": "A change weakens a requirement's level"},
	"impact-upgrades-level": {"severity": "warning", "level": "SHOULD", "title": "A change strengthens a requirement's level without new code"},
	"impact-drops-code-ref": {"severity": "error", "level": "MUST", "title": "A change drops a code ref a requirement was anchored to"},
	"impact-empties-code-refs": {"severity": "error", "level": "MUST", "title": "A change leaves a requirement with no code ref at all"},
	"impact-text-loses-force": {"severity": "error", "level": "MUST", "title": "A requirement's text stops forbidding what it forbade"},
	"impact-text-loses-tls": {"severity": "error", "level": "MUST", "title": "A requirement's text moves a check from https to http"},
	"impact-removes-interface": {"severity": "warning", "level": "SHOULD", "title": "A change removes a declared interface"},
	"impact-renames-interface": {"severity": "warning", "level": "SHOULD", "title": "A change removes an interface and adds one of the same name elsewhere"},
	"impact-must-change-without-acceptance": {"severity": "warning", "level": "SHOULD", "title": "A change moves a MUST requirement with no gating acceptance step to prove it"},
	"impact-removes-gating-acceptance": {"severity": "error", "level": "MUST", "title": "A change removes the gating acceptance step"},
	"impact-narrows-acceptance-timeout": {"severity": "warning", "level": "SHOULD", "title": "A change shortens an acceptance step's timeout"},
	"impact-removes-workspace-from-arch-overlay": {"severity": "warning", "level": "SHOULD", "title": "A change removes a workspace from the architecture overlay"},
}
