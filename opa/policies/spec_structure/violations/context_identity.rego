package deno_kcp.policies.spec_structure

import rego.v1

import data.deno_kcp.lib.refs
import data.deno_kcp.lib.spec
import data.deno_kcp.lib.text
import data.deno_kcp.lib.violation

violations contains v if {
	row := spec.contexts_in_scope(input.spec_tree)[_]
	object.get(spec.document_of(row.context), "apiVersion", null) != document_api_version
	v := violation.build(
		policy_id,
		"context-api-version-invalid",
		violation.context_location(row.name, row.path),
		sprintf(
			"context %s declares apiVersion %q; the schema is %s",
			[row.name, object.get(spec.document_of(row.context), "apiVersion", "<missing>"), document_api_version],
		),
		{"apiVersion": object.get(spec.document_of(row.context), "apiVersion", null)},
	)
}

violations contains v if {
	row := spec.contexts_in_scope(input.spec_tree)[_]
	object.get(spec.document_of(row.context), "kind", null) != "SystemContext"
	v := violation.build(
		policy_id,
		"context-kind-invalid",
		violation.context_location(row.name, row.path),
		sprintf("context %s declares kind %q; a spec document is kind SystemContext", [row.name, object.get(spec.document_of(row.context), "kind", "<missing>")]),
		{"kind": object.get(spec.document_of(row.context), "kind", null)},
	)
}

violations contains v if {
	row := spec.contexts_in_scope(input.spec_tree)[_]
	name := object.get(spec.document_metadata(row.context), "name", null)
	not is_string(name)
	v := violation.build(
		policy_id,
		"context-metadata-missing",
		violation.context_location(row.name, row.path),
		sprintf("context file %s declares no metadata.name", [row.path]),
		{},
	)
}

violations contains v if {
	row := spec.contexts_in_scope(input.spec_tree)[_]
	name := object.get(spec.document_metadata(row.context), "name", "")
	is_string(name)
	name != row.name
	v := violation.build(
		policy_id,
		"context-metadata-name-mismatch",
		violation.context_location(row.name, row.path),
		sprintf("context %s declares metadata.name %q; the file names it %s", [row.path, name, row.name]),
		{"declared": name, "file": row.name},
	)
}

violations contains v if {
	row := spec.contexts_in_scope(input.spec_tree)[_]
	namespace := object.get(spec.document_metadata(row.context), "namespace", null)
	not is_string(namespace)
	v := violation.build(
		policy_id,
		"context-namespace-missing",
		violation.context_location(row.name, row.path),
		sprintf("context %s declares no metadata.namespace", [row.name]),
		{},
	)
}

violations contains v if {
	row := spec.contexts_in_scope(input.spec_tree)[_]
	not is_string(object.get(spec.spec_of(row.context), "intent", null))
	v := violation.build(
		policy_id,
		"context-intent-missing",
		violation.context_location(row.name, row.path),
		sprintf("context %s states no intent", [row.name]),
		{},
	)
}

violations contains v if {
	row := spec.contexts_in_scope(input.spec_tree)[_]
	body := spec.intent(row.context)
	is_string(body)
	text.word_count(body) > 0
	text.word_count(body) < min_intent_words
	v := violation.build(
		policy_id,
		"context-intent-too-short",
		violation.context_location(row.name, row.path),
		sprintf(
			"context %s states its intent in %d words; a reader needs at least %d to know what it is for",
			[row.name, text.word_count(body), min_intent_words],
		),
		{"words": text.word_count(body)},
	)
}

violations contains v if {
	row := spec.contexts_in_scope(input.spec_tree)[_]
	repository := object.get(spec.spec_of(row.context), "repository", null)
	not is_string(repository)
	v := violation.build(
		policy_id,
		"context-repository-missing",
		violation.context_location(row.name, row.path),
		sprintf("context %s names no repository", [row.name]),
		{},
	)
}

violations contains v if {
	row := spec.contexts_in_scope(input.spec_tree)[_]
	upstream := object.get(spec.spec_of(row.context), "upstream", null)
	not is_string(upstream)
	v := violation.build(
		policy_id,
		"context-upstream-missing",
		violation.context_location(row.name, row.path),
		sprintf("context %s declares no upstream; a context says where it sits with upstream: self", [row.name]),
		{},
	)
}

violations contains v if {
	row := spec.contexts_in_scope(input.spec_tree)[_]
	upstream := object.get(spec.spec_of(row.context), "upstream", null)
	is_string(upstream)
	not refs.is_ref(upstream)
	v := violation.build(
		policy_id,
		"context-upstream-invalid",
		violation.context_location(row.name, row.path),
		sprintf("context %s declares upstream %q; a reference is self or sc./up./ov./orch. and a DNS-1123 name", [row.name, upstream]),
		{"upstream": upstream},
	)
}

violations contains v if {
	row := spec.contexts_in_scope(input.spec_tree)[_]
	count(spec.requirements(row.context)) == 0
	v := violation.build(
		policy_id,
		"context-requirements-missing",
		violation.context_location(row.name, row.path),
		sprintf("context %s declares no requirements, so nothing about it can be checked", [row.name]),
		{},
	)
}
