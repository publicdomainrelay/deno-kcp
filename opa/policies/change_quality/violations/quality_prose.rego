package deno_kcp.policies.change_quality

import rego.v1

import data.deno_kcp.lib.prose
import data.deno_kcp.lib.spec
import data.deno_kcp.lib.text
import data.deno_kcp.lib.violation

# The prose a requirement carries: whether its wording matches the level it
# declares, whether it leans on a word that asserts nothing, whether it is a
# sentence at all, whether it repeats its own id, whether it is a bare list of
# names, and whether a MUST names anything an observer could watch happen.

violations contains v if {
	row := spec.all_requirements(input.spec_tree)[_]
	level := object.get(row.requirement, "level", "")
	is_string(level)
	level != ""
	body := object.get(row.requirement, "text", "")
	is_string(body)
	implied := text.level_disagrees(level, body)
	v := violation.build(
		policy_id,
		"quality-level-text-disagreement",
		violation.requirement_location(row.context, row.path, row.index),
		sprintf(
			"requirement %s declares level %s but its wording reads as %s: %q",
			[row.requirement.id, level, implied, body],
		),
		{"requirement": row.requirement.id, "declared": level, "implied": implied},
	)
}

violations contains v if {
	row := spec.all_requirements(input.spec_tree)[_]
	body := object.get(row.requirement, "text", "")
	is_string(body)
	text.has_vague_term(body)
	not regex.match(`[0-9]`, body)
	terms := text.vague_terms_in(body)
	v := violation.build(
		policy_id,
		"quality-vague-term",
		violation.requirement_location(row.context, row.path, row.index),
		sprintf(
			"requirement %s says %v with no number or unit beside it; a reader checks a quantity, not a word",
			[row.requirement.id, terms],
		),
		{"requirement": row.requirement.id, "terms": terms},
	)
}

violations contains v if {
	row := spec.all_requirements(input.spec_tree)[_]
	body := object.get(row.requirement, "text", "")
	is_string(body)
	text.has_non_normative_phrase(body)
	phrases := text.non_normative_in(body)
	v := violation.build(
		policy_id,
		"quality-non-normative-phrase",
		violation.requirement_location(row.context, row.path, row.index),
		sprintf(
			"requirement %s leans on %v; a requirement states what holds, not what might be worth doing",
			[row.requirement.id, phrases],
		),
		{"requirement": row.requirement.id, "phrases": phrases},
	)
}

violations contains v if {
	row := spec.all_requirements(input.spec_tree)[_]
	body := object.get(row.requirement, "text", "")
	is_string(body)
	text.has_placeholder(body)
	markers := [marker | some marker in text.placeholder_markers; text.contains_any(body, [marker])]
	v := violation.build(
		policy_id,
		"quality-placeholder",
		violation.requirement_location(row.context, row.path, row.index),
		sprintf(
			"requirement %s still carries %v; a placeholder is a requirement that was never written",
			[row.requirement.id, markers],
		),
		{"requirement": row.requirement.id, "markers": markers},
	)
}

violations contains v if {
	row := spec.all_requirements(input.spec_tree)[_]
	body := object.get(row.requirement, "text", "")
	is_string(body)
	text.word_count(body) > 0
	not text.starts_upper(body)
	not text.ends_with_period(body)
	v := violation.build(
		policy_id,
		"quality-not-a-sentence",
		violation.requirement_location(row.context, row.path, row.index),
		sprintf(
			"requirement %s is neither capitalised nor ended with a period: %q",
			[row.requirement.id, body],
		),
		{"requirement": row.requirement.id, "words": text.word_count(body)},
	)
}

violations contains v if {
	row := spec.all_requirements(input.spec_tree)[_]
	body := object.get(row.requirement, "text", "")
	is_string(body)
	text.sentence_count(body) > max_sentences
	v := violation.build(
		policy_id,
		"quality-many-sentences",
		violation.requirement_location(row.context, row.path, row.index),
		sprintf(
			"requirement %s carries %d sentences; past %d it is several requirements sharing one id, so a delta against it cannot be reviewed",
			[row.requirement.id, text.sentence_count(body), max_sentences],
		),
		{"requirement": row.requirement.id, "sentences": text.sentence_count(body)},
	)
}

violations contains v if {
	row := spec.all_requirements(input.spec_tree)[_]
	body := object.get(row.requirement, "text", "")
	is_string(body)
	id := object.get(row.requirement, "id", "")
	is_string(id)
	prose.repeats_identifier(body, id)
	v := violation.build(
		policy_id,
		"quality-echoes-identifier",
		violation.requirement_location(row.context, row.path, row.index),
		sprintf(
			"requirement %s repeats its own id words in its text: %q",
			[id, body],
		),
		{"requirement": id},
	)
}

violations contains v if {
	row := spec.all_requirements(input.spec_tree)[_]
	body := object.get(row.requirement, "text", "")
	is_string(body)
	prose.enumerates_names(body)
	v := violation.build(
		policy_id,
		"quality-enumerates-without-structure",
		violation.requirement_location(row.context, row.path, row.index),
		sprintf(
			"requirement %s is a bare list of names: %q; a list names what is involved, not what an engineer should check",
			[row.requirement.id, body],
		),
		{"requirement": row.requirement.id},
	)
}

violations contains v if {
	row := spec.all_requirements(input.spec_tree)[_]
	level := object.get(row.requirement, "level", "")
	is_string(level)
	level == "MUST"
	body := object.get(row.requirement, "text", "")
	is_string(body)
	text.word_count(body) > 0
	not prose.is_observable(body)
	v := violation.build(
		policy_id,
		"quality-requirement-not-observable",
		violation.requirement_location(row.context, row.path, row.index),
		sprintf(
			"requirement %s is a MUST but names nothing an observer could watch: %q",
			[row.requirement.id, body],
		),
		{"requirement": row.requirement.id},
	)
}
