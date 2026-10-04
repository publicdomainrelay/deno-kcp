package deno_kcp.policies.spec_structure

import rego.v1

import data.deno_kcp.lib.refs
import data.deno_kcp.lib.spec
import data.deno_kcp.lib.text
import data.deno_kcp.lib.violation

violations contains v if {
	row := spec.all_requirements(input.spec_tree)[_]
	not is_string(object.get(row.requirement, "text", null))
	v := violation.build(
		policy_id,
		"requirement-text-missing",
		violation.requirement_location(row.context, row.path, row.index),
		sprintf("requirement %s has no text", [object.get(row.requirement, "id", "?")]),
		{"requirement": object.get(row.requirement, "id", "")},
	)
}

violations contains v if {
	row := spec.all_requirements(input.spec_tree)[_]
	body := object.get(row.requirement, "text", "")
	is_string(body)
	text.word_count(body) < min_requirement_words
	v := violation.build(
		policy_id,
		"requirement-text-too-short",
		violation.requirement_location(row.context, row.path, row.index),
		sprintf(
			"requirement %s states %d words; a reader needs at least %d to check it",
			[row.requirement.id, text.word_count(body), min_requirement_words],
		),
		{"requirement": row.requirement.id, "words": text.word_count(body)},
	)
}

violations contains v if {
	row := spec.all_requirements(input.spec_tree)[_]
	body := object.get(row.requirement, "text", "")
	is_string(body)
	text.word_count(body) >= min_requirement_words
	text.word_count(body) < terse_requirement_words
	v := violation.build(
		policy_id,
		"requirement-text-terse",
		violation.requirement_location(row.context, row.path, row.index),
		sprintf(
			"requirement %s states %d words; under %d a reader has to guess what would satisfy it",
			[row.requirement.id, text.word_count(body), terse_requirement_words],
		),
		{"requirement": row.requirement.id, "words": text.word_count(body)},
	)
}

violations contains v if {
	row := spec.all_requirements(input.spec_tree)[_]
	body := object.get(row.requirement, "text", "")
	is_string(body)
	text.word_count(body) > max_requirement_words
	v := violation.build(
		policy_id,
		"requirement-text-too-long",
		violation.requirement_location(row.context, row.path, row.index),
		sprintf(
			"requirement %s states %d words; past %d it is several requirements sharing one id, so a delta against it cannot be reviewed",
			[row.requirement.id, text.word_count(body), max_requirement_words],
		),
		{"requirement": row.requirement.id, "words": text.word_count(body)},
	)
}

violations contains v if {
	row := spec.all_requirements(input.spec_tree)[_]
	body := object.get(row.requirement, "text", "")
	is_string(body)
	found := refs.machine_paths(body)
	count(found) > 0
	v := violation.build(
		policy_id,
		"requirement-text-has-machine-path",
		violation.requirement_location(row.context, row.path, row.index),
		sprintf(
			"requirement %s names %v, a path that exists on the machine that wrote it and nowhere else",
			[row.requirement.id, found],
		),
		{"requirement": row.requirement.id, "paths": found},
	)
}
