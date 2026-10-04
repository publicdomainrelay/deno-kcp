package deno_kcp.policies.spec_references

import rego.v1

import data.deno_kcp.lib.arch
import data.deno_kcp.lib.paths
import data.deno_kcp.lib.spec
import data.deno_kcp.lib.violation

ref_rows := arch.code_ref_rows(input.spec_tree)

context_of(name) := ctx if {
	ctx := object.get(object.get(input.spec_tree, "contexts", {}), name, {})
}

ref_location(row) := loc if {
	row.scope == "requirement"
	loc := violation.requirement_location(row.context, row.path, row.index)
}

ref_location(row) := loc if {
	row.scope == "context"
	loc := violation.spec_location(row.context, row.path, sprintf("/spec/codeRefs/%d", [row.index]))
}

ref_parts(ref) := parts if {
	parts := split(ref, ":")
}

ref_kind(ref) := kind if {
	parts := ref_parts(ref)
	count(parts) >= 2
	kind := parts[0]
}

ref_payload(ref) := payload if {
	parts := ref_parts(ref)
	count(parts) >= 2
	payload := concat(":", array.slice(parts, 1, count(parts)))
}

# A symbol ref is a known non-file kind with a non-empty, whitespace-free
# payload. Every symbol ref in a real tree is a 32 hex codegraph id, but a tree
# may also name a symbol by its Type.Method name, so both are accepted.
is_symbol_ref(ref) if {
	is_string(ref)
	parts := ref_parts(ref)
	count(parts) >= 2
	parts[0] in paths.code_ref_schemes
	parts[0] != "file"
	payload := concat(":", array.slice(parts, 1, count(parts)))
	payload != ""
	not regex.match(`\s`, payload)
}

symbol_refs contains ref if {
	row := ref_rows[_]
	ref := row.ref
	is_symbol_ref(ref)
}

symbol_ref_payloads contains payload if {
	some ref in symbol_refs
	payload := ref_payload(ref)
}

violations contains v if {
	row := ref_rows[_]
	ref := row.ref
	is_string(ref)
	count(ref_parts(ref)) < 2
	v := violation.build(
		policy_id,
		"code-ref-malformed",
		ref_location(row),
		sprintf("code ref %q in context %s is not kind:payload; a ref is a kind from the observer's set, a colon, and a payload", [ref, row.context]),
		{"context": row.context, "requirement": row.requirement, "ref": ref},
	)
}

violations contains v if {
	row := ref_rows[_]
	ref := row.ref
	is_string(ref)
	kind := ref_kind(ref)
	not kind in paths.code_ref_schemes
	v := violation.build(
		policy_id,
		"code-ref-unknown-kind",
		ref_location(row),
		sprintf("code ref %q in context %s names kind %q; a kind is file, package, module, function, method, constructor, struct, interface, class, type_alias, enum, type, variable, constant or import", [ref, row.context, kind]),
		{"context": row.context, "requirement": row.requirement, "ref": ref, "kind": kind},
	)
}

violations contains v if {
	row := ref_rows[_]
	ref := row.ref
	is_string(ref)
	kind := ref_kind(ref)
	kind in paths.code_ref_schemes
	ref_payload(ref) == ""
	v := violation.build(
		policy_id,
		"code-ref-empty-payload",
		ref_location(row),
		sprintf("code ref %q in context %s names nothing after the kind", [ref, row.context]),
		{"context": row.context, "requirement": row.requirement, "ref": ref, "kind": kind},
	)
}

violations contains v if {
	row := ref_rows[_]
	ref := row.ref
	is_string(ref)
	kind := ref_kind(ref)
	kind in paths.code_ref_schemes
	payload := ref_payload(ref)
	payload != ""
	regex.match(`\s`, payload)
	v := violation.build(
		policy_id,
		"code-ref-whitespace-in-payload",
		ref_location(row),
		sprintf("code ref %q in context %s carries whitespace in its payload %q; a payload is a path, a name or a codegraph id with no spaces", [ref, row.context, payload]),
		{"context": row.context, "requirement": row.requirement, "ref": ref, "payload": payload},
	)
}

duplicate_requirement_ref_keys := {key |
	some row in ref_rows
	row.scope == "requirement"
	key := sprintf("%s|%s|%s", [row.context, row.requirement, row.ref])
	count([r | some r in ref_rows; r.scope == "requirement"; r.context == row.context; r.requirement == row.requirement; r.ref == row.ref]) > 1
}

violations contains v if {
	some key in duplicate_requirement_ref_keys
	rows := [r | some r in ref_rows; r.scope == "requirement"; sprintf("%s|%s|%s", [r.context, r.requirement, r.ref]) == key]
	row := rows[0]
	v := violation.build(
		policy_id,
		"code-ref-duplicate-in-requirement",
		ref_location(row),
		sprintf("requirement %s of context %s declares code ref %q %d times; a ref is declared once", [row.requirement, row.context, row.ref, count(rows)]),
		{"context": row.context, "requirement": row.requirement, "ref": row.ref, "count": count(rows)},
	)
}

duplicate_context_ref_keys := {key |
	some row in ref_rows
	row.scope == "context"
	key := sprintf("%s|%s", [row.context, row.ref])
	count([r | some r in ref_rows; r.scope == "context"; r.context == row.context; r.ref == row.ref]) > 1
}

violations contains v if {
	some key in duplicate_context_ref_keys
	rows := [r | some r in ref_rows; r.scope == "context"; sprintf("%s|%s", [r.context, r.ref]) == key]
	row := rows[0]
	v := violation.build(
		policy_id,
		"code-ref-duplicate-in-context",
		ref_location(row),
		sprintf("context %s declares code ref %q %d times on its own codeRefs list; a ref is declared once", [row.context, row.ref, count(rows)]),
		{"context": row.context, "ref": row.ref, "count": count(rows)},
	)
}

violations contains v if {
	row := ref_rows[_]
	ref := row.ref
	paths.is_file_ref(ref)
	file := paths.code_ref_file(ref)
	file != ""
	paths.is_absolute(file)
	v := violation.build(
		policy_id,
		"code-ref-path-absolute",
		ref_location(row),
		sprintf("code ref %q in context %s names the absolute path %q; a file ref is repo-relative", [ref, row.context, file]),
		{"context": row.context, "requirement": row.requirement, "ref": ref, "path": file},
	)
}

violations contains v if {
	row := ref_rows[_]
	ref := row.ref
	paths.is_file_ref(ref)
	file := paths.code_ref_file(ref)
	file != ""
	paths.has_parent_escape(file)
	v := violation.build(
		policy_id,
		"code-ref-path-escaping",
		ref_location(row),
		sprintf("code ref %q in context %s names %q, which escapes the repository root with ..", [ref, row.context, file]),
		{"context": row.context, "requirement": row.requirement, "ref": ref, "path": file},
	)
}

violations contains v if {
	row := ref_rows[_]
	ref := row.ref
	paths.is_file_ref(ref)
	file := paths.code_ref_file(ref)
	file != ""
	paths.has_windows_separator(file)
	v := violation.build(
		policy_id,
		"code-ref-path-not-repo-relative",
		ref_location(row),
		sprintf("code ref %q in context %s names %q with backslashes; a file ref uses repo-relative forward slashes", [ref, row.context, file]),
		{"context": row.context, "requirement": row.requirement, "ref": ref, "path": file},
	)
}

violations contains v if {
	row := ref_rows[_]
	ref := row.ref
	paths.is_file_ref(ref)
	file := paths.code_ref_file(ref)
	file != ""
	arch.has_observed_files(row.context_data)
	not spec.file_known(input.spec_tree, file)
	not file in arch.observed_files(row.context_data)
	v := violation.build(
		policy_id,
		"code-ref-file-missing",
		ref_location(row),
		sprintf("code ref %q in context %s names %q, which is in no file index and was never observed; the reference resolves to nothing", [ref, row.context, file]),
		{"context": row.context, "requirement": row.requirement, "ref": ref, "path": file},
	)
}

violations contains v if {
	row := ref_rows[_]
	ref := row.ref
	paths.is_file_ref(ref)
	file := paths.code_ref_file(ref)
	file != ""
	spec.file_known(input.spec_tree, file)
	arch.has_observed_files(row.context_data)
	not file in arch.observed_files(row.context_data)
	v := violation.build(
		policy_id,
		"code-ref-file-not-observed",
		ref_location(row),
		sprintf("code ref %q in context %s names %q, which exists but is not among the files the context observed", [ref, row.context, file]),
		{"context": row.context, "requirement": row.requirement, "ref": ref, "path": file},
	)
}

violations contains v if {
	row := ref_rows[_]
	ref := row.ref
	is_symbol_ref(ref)
	arch.has_observed_interfaces(row.context_data)
	ids := arch.observed_interface_ids(row.context_data)
	names := arch.observed_interface_names(row.context_data)
	payload := ref_payload(ref)
	not ref in ids
	not payload in names
	v := violation.build(
		policy_id,
		"code-ref-symbol-unobserved",
		ref_location(row),
		sprintf("code ref %q in context %s names no interface the context observed; a symbol ref resolves to a codegraph id in the observed interfaces, or to an observed interface name", [ref, row.context]),
		{"context": row.context, "requirement": row.requirement, "ref": ref, "payload": payload},
	)
}
