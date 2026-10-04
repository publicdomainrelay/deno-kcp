package deno_kcp.policies.change_impact

import rego.v1

import data.deno_kcp.lib.paths
import data.deno_kcp.lib.spec
import data.deno_kcp.lib.text
import data.deno_kcp.lib.violation

words_of(body) := words if {
	words := [word | some word in split(lower(body), " "); word != ""]
}

# Every run of n consecutive words in a text. Two texts that share one are
# saying the same thing somewhere, which is how a removed requirement is
# recognised as carried over rather than dropped.
runs(body, n) := runs if {
	words := words_of(body)
	runs := {concat(" ", array.slice(words, index, index + n)) |
		some index in numbers.range(0, count(words) - n)
	}
}

min_shared_run := 8

shares_a_run(left, right) if {
	is_string(left)
	is_string(right)
	count(runs(left, min_shared_run) & runs(right, min_shared_run)) > 0
}

file_refs(req) := refs if {
	refs := {paths.code_ref_file(ref) |
		some ref in spec.requirement_code_refs(req)
		paths.is_file_ref(ref)
	}
}

violations contains v if {
	row := delta_rows[_]
	row.op == "removed"
	v := violation.build(
		policy_id,
		"impact-removes-requirement",
		delta_location(row, "/op"),
		sprintf("the change removes requirement %s from context %s, so the behaviour it pinned down is no longer declared", [row.id, row.context]),
		{"requirement": row.id, "context": row.context, "level": object.get(row.from, "level", ""), "text": object.get(row.from, "text", "")},
	)
}

violations contains v if {
	row := delta_rows[_]
	row.op == "removed"
	object.get(row.from, "level", "") == "MUST"
	v := violation.build(
		policy_id,
		"impact-removes-must-requirement",
		delta_location(row, "/op"),
		sprintf("the change removes MUST requirement %s from context %s", [row.id, row.context]),
		{"requirement": row.id, "context": row.context, "text": object.get(row.from, "text", "")},
	)
}

violations contains v if {
	row := delta_rows[_]
	row.op == "removed"
	added := added_rows(row.context)
	not any_carries(added, row)
	v := violation.build(
		policy_id,
		"impact-removes-requirement-without-replacement",
		delta_location(row, "/op"),
		sprintf(
			"the change removes %s from context %s and nothing it adds shares a sentence with it, so the behaviour it required is now required by nothing",
			[row.id, row.context],
		),
		{"requirement": row.id, "context": row.context, "from": object.get(row.from, "text", "")},
	)
}

added_rows(context) := rows if {
	rows := [row |
		some row in delta_rows
		row.context == context
		row.op == "added"
		is_object(object.get(row, "to", null))
	]
}

# A requirement is carried over when something added anchors to the same code
# or says the same sentence. "three workspaces" becoming "four workspaces" is a
# replacement even though the two sentences are not identical, and the shared
# code ref is what shows it.
any_carries(added, removed) if {
	some candidate in added
	count(file_refs(candidate.to) & file_refs(removed.from)) > 0
}

any_carries(added, removed) if {
	some candidate in added
	shares_a_run(object.get(candidate.to, "text", ""), object.get(removed.from, "text", ""))
}

violations contains v if {
	row := delta_rows[_]
	row.op == "changed"
	from_level := object.get(row.from, "level", "")
	to_level := object.get(row.to, "level", "")
	level_rank[from_level] > level_rank[to_level]
	v := violation.build(
		policy_id,
		"impact-downgrades-level",
		delta_location(row, "/to/level"),
		sprintf(
			"requirement %s of context %s goes from %s to %s, so what the code must do becomes what it may do",
			[row.id, row.context, from_level, to_level],
		),
		{"requirement": row.id, "context": row.context, "from": from_level, "to": to_level},
	)
}

violations contains v if {
	row := delta_rows[_]
	row.op == "changed"
	from_level := object.get(row.from, "level", "")
	to_level := object.get(row.to, "level", "")
	level_rank[to_level] > level_rank[from_level]
	v := violation.build(
		policy_id,
		"impact-upgrades-level",
		delta_location(row, "/to/level"),
		sprintf(
			"requirement %s of context %s goes from %s to %s, which makes code that was compliant non-compliant in a record that does not say so",
			[row.id, row.context, from_level, to_level],
		),
		{"requirement": row.id, "context": row.context, "from": from_level, "to": to_level},
	)
}

violations contains v if {
	row := delta_rows[_]
	row.op == "changed"
	dropped := file_refs(row.from) - file_refs(row.to)
	count(dropped) > 0
	v := violation.build(
		policy_id,
		"impact-drops-code-ref",
		delta_location(row, "/to/codeRefs"),
		sprintf(
			"requirement %s of context %s stops pointing at %v, so nothing anchors what it requires to the code that does it",
			[row.id, row.context, sorted(dropped)],
		),
		{"requirement": row.id, "context": row.context, "dropped": sorted(dropped)},
	)
}

sorted(items) := out if {
	as_array := [item | some item in items]
	out := sort(as_array)
}

violations contains v if {
	row := delta_rows[_]
	row.op == "changed"
	before := spec.requirement_code_refs(row.from)
	after := spec.requirement_code_refs(row.to)
	count(before) > 0
	count(after) == 0
	v := violation.build(
		policy_id,
		"impact-empties-code-refs",
		delta_location(row, "/to"),
		sprintf(
			"requirement %s of context %s used to name %d code refs and now names none, so it is anchored to nothing",
			[row.id, row.context, count(before)],
		),
		{"requirement": row.id, "context": row.context, "before": before},
	)
}

violations contains v if {
	row := delta_rows[_]
	row.op == "changed"
	from_text := object.get(row.from, "text", "")
	to_text := object.get(row.to, "text", "")
	is_string(from_text)
	is_string(to_text)
	lost := {phrase | some phrase in force_phrases; text.contains_any(from_text, [phrase]); not text.contains_any(to_text, [phrase])}
	count(lost) > 0
	v := violation.build(
		policy_id,
		"impact-text-loses-force",
		delta_location(row, "/to/text"),
		sprintf(
			"requirement %s of context %s stops saying %v, so the text no longer forbids what the code has to do",
			[row.id, row.context, sorted(lost)],
		),
		{"requirement": row.id, "context": row.context, "lost": sorted(lost)},
	)
}

violations contains v if {
	row := delta_rows[_]
	row.op == "changed"
	from_text := object.get(row.from, "text", "")
	to_text := object.get(row.to, "text", "")
	count(text.https_urls(from_text)) > 0
	count(text.https_urls(to_text)) < count(text.https_urls(from_text))
	count(text.http_urls(to_text)) > count(text.http_urls(from_text))
	v := violation.build(
		policy_id,
		"impact-text-loses-tls",
		delta_location(row, "/to/text"),
		sprintf(
			"requirement %s of context %s loses %d https reference(s) and gains %d http one(s); a check moved to http against a TLS listener asserts nothing",
			[row.id, row.context, count(text.https_urls(from_text)) - count(text.https_urls(to_text)), count(text.http_urls(to_text)) - count(text.http_urls(from_text))],
		),
		{"requirement": row.id, "context": row.context},
	)
}

violations contains v if {
	row := interface_rows[_]
	row.op == "removed"
	v := violation.build(
		policy_id,
		"impact-removes-interface",
		delta_location(row, "/op"),
		sprintf("the change stops declaring interface %s of context %s", [object.get(row, "name", "?"), row.context]),
		{"interface": object.get(row, "name", ""), "context": row.context},
	)
}

violations contains v if {
	removed := interface_rows[_]
	removed.op == "removed"
	added := interface_rows[_]
	added.op == "added"
	added.name == removed.name
	object.get(added.to, "file", "") != object.get(removed.from, "file", "")
	v := violation.build(
		policy_id,
		"impact-renames-interface",
		delta_location(added, "/to"),
		sprintf(
			"interface %s of context %s moves from %s to %s without its name changing, which the observer will read as one interface disappearing and another appearing",
			[added.name, added.context, object.get(removed.from, "file", ""), object.get(added.to, "file", "")],
		),
		{"interface": added.name, "context": added.context, "from": object.get(removed.from, "file", ""), "to": object.get(added.to, "file", "")},
	)
}

violations contains v if {
	count(gating_steps) == 0
	moved := [row |
		some row in delta_rows
		row.op != "removed"
		level := object.get(row.to, "level", "")
		level == "MUST"
	]
	count(moved) > 0
	v := violation.build(
		policy_id,
		"impact-must-change-without-acceptance",
		{
			"kind": "repository",
			"context": object.get(moved[0], "context", ""),
			"path": "repository.yaml",
			"pointer": "/spec/acceptance",
			"file": "",
			"line": 0,
		},
		sprintf(
			"the change moves %d MUST requirement(s) and the repository declares %d acceptance step(s), none of which gate, so nothing has to pass before the code is trusted to do what the spec now says",
			[count(moved), count(acceptance_steps)],
		),
		{"must_changes": count(moved), "steps": count(acceptance_steps)},
	)
}

violations contains v if {
	has_base_tree
	before := object.get(object.get(object.get(input.base_tree, "repository", {}), "spec", {}), "acceptance", [])
	is_array(before)
	after := acceptance_steps
	removed := [step | some step in before; object.get(step, "gate", false) == true; not step.name in {s.name | some s in after}]
	count(removed) > 0
	v := violation.build(
		policy_id,
		"impact-removes-gating-acceptance",
		{
			"kind": "repository",
			"context": "",
			"path": "repository.yaml",
			"pointer": "/spec/acceptance",
			"file": "",
			"line": 0,
		},
		sprintf("the change removes the gating acceptance step(s) %v, so the gate that stopped a bad change no longer runs", [sorted({step.name | some step in removed})]),
		{"removed": sorted({step.name | some step in removed})},
	)
}

violations contains v if {
	has_base_tree
	before := {step.name: step |
		some step in object.get(object.get(object.get(input.base_tree, "repository", {}), "spec", {}), "acceptance", [])
	}
	some name, step in before
	after := {s.name: s | some s in acceptance_steps}
	head := object.get(after, name, null)
	is_object(head)
	before_timeout := object.get(step, "timeoutSeconds", 0)
	after_timeout := object.get(head, "timeoutSeconds", 0)
	before_timeout > 0
	after_timeout < before_timeout
	v := violation.build(
		policy_id,
		"impact-narrows-acceptance-timeout",
		{
			"kind": "repository",
			"context": "",
			"path": "repository.yaml",
			"pointer": sprintf("/spec/acceptance/%s/timeoutSeconds", [name]),
			"file": "",
			"line": 0,
		},
		sprintf(
			"acceptance step %s goes from %d to %d seconds; a step that cannot finish inside its timeout fails for being slow rather than for being wrong",
			[name, before_timeout, after_timeout],
		),
		{"step": name, "before": before_timeout, "after": after_timeout},
	)
}

# A workspace the architecture overlay declares and a requirement still names,
# dropped from both the overlay and the requirement by this change.
violations contains v if {
	has_base_tree
	has_change
	before := arch_workspaces(input.base_tree)
	after := arch_workspaces(input.spec_tree)
	removed := before - after
	count(removed) > 0
	named := [row |
		some row in delta_rows
		row.op != "added"
		some workspace in removed
		text.contains_any(object.get(row.from, "text", ""), [workspace])
	]
	count(named) > 0
	v := violation.build(
		policy_id,
		"impact-removes-workspace-from-arch-overlay",
		delta_location(named[0], "/from/text"),
		sprintf(
			"the change drops workspace(s) %v from the architecture overlay while requirement %s still names one of them",
			[sorted(removed), named[0].id],
		),
		{"removed": sorted(removed), "requirement": named[0].id},
	)
}

arch_workspaces(tree) := workspaces if {
	workspaces := {entry |
		some layout in overlay_entries(tree)
		some item in object.get(layout, "data", [])
		entry := object.get(item, "path", "")
		is_string(entry)
		entry != ""
	}
}

overlay_entries(tree) := entries if {
	entries := [overlay |
		some context in object.get(object.get(tree, "arch", {}), "system_contexts", [])
		some overlay in object.get(context, "overlay", [])
	]
}

violations contains v if {
	row := delta_rows[_]
	row.op == "removed"
	has_object_diff
	refs := file_refs(row.from)
	count(refs) > 0
	touched := refs & diff_path_set
	count(touched) == 0
	v := violation.build(
		policy_id,
		"impact-requirement-removed-but-code-unchanged",
		delta_location(row, "/op"),
		sprintf(
			"requirement %s was removed but the code it named, %v, is not in the diff, so the requirement went without the code following",
			[row.id, sorted(refs)],
		),
		{"requirement": row.id, "context": row.context, "refs": sorted(refs)},
	)
}

has_object_diff if {
	diff := object.get(input, "diff", null)
	is_object(diff)
}

diff_path_set := paths_set if {
	paths_set := {path | some path in object.get(object.get(input, "diff", {}), "paths", [])}
}
