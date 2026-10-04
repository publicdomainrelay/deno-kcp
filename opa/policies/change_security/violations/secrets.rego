package deno_kcp.policies.change_security

import rego.v1

import data.deno_kcp.lib.code
import data.deno_kcp.lib.spec
import data.deno_kcp.lib.text
import data.deno_kcp.lib.violation

# A secret written down where it can be read: in a requirement's prose, in a
# context's intent, in the log or the acceptance output a change records, in a
# code ref, or in a line a diff adds. A spec names where a secret is injected,
# never the secret.

violations contains v if {
	row := spec.all_requirements(input.spec_tree)[_]
	body := object.get(row.requirement, "text", "")
	is_string(body)
	text.secret_like(body)
	found := text.secret_matches(body)
	v := violation.build(
		policy_id,
		"security-secret-in-requirement-text",
		violation.requirement_location(row.context, row.path, row.index),
		sprintf(
			"requirement %s carries %v in its text; a requirement names where a secret is injected, never the secret",
			[row.requirement.id, found],
		),
		{"requirement": row.requirement.id, "matches": found},
	)
}

violations contains v if {
	row := spec.contexts_in_scope(input.spec_tree)[_]
	body := spec.intent(row.context)
	is_string(body)
	body != ""
	text.secret_like(body)
	found := text.secret_matches(body)
	v := violation.build(
		policy_id,
		"security-secret-in-intent",
		violation.context_location(row.name, row.path),
		sprintf("intent of context %s carries %v; the intent says what the context is for, not the secret it uses", [row.name, found]),
		{"context": row.name, "matches": found},
	)
}

violations contains v if {
	chg := spec.all_changes(input.spec_tree)[_]
	status := spec.change_status(chg)
	body := object.get(status, "agentLog", "")
	is_string(body)
	body != ""
	text.secret_like(body)
	found := text.secret_matches(body)
	v := violation.build(
		policy_id,
		"security-secret-in-agent-log",
		violation.change_location(object.get(chg, "name", ""), object.get(chg, "path", ""), "/status/agentLog"),
		sprintf("agent log of change %s carries %v; a log is committed beside the change and read by everyone", [object.get(chg, "name", "?"), found]),
		{"change": object.get(chg, "name", ""), "matches": found},
	)
}

violations contains v if {
	chg := spec.all_changes(input.spec_tree)[_]
	status := spec.change_status(chg)
	results := object.get(status, "acceptance", [])
	is_array(results)
	some index, result in results
	body := object.get(result, "outputTail", "")
	is_string(body)
	body != ""
	text.secret_like(body)
	found := text.secret_matches(body)
	v := violation.build(
		policy_id,
		"security-secret-in-acceptance-output",
		violation.change_location(
			object.get(chg, "name", ""),
			object.get(chg, "path", ""),
			sprintf("/status/acceptance/%d/outputTail", [index]),
		),
		sprintf("acceptance %s of change %s printed %v; the tail is committed with the change", [object.get(result, "name", "?"), object.get(chg, "name", "?"), found]),
		{"change": object.get(chg, "name", ""), "acceptance": object.get(result, "name", ""), "matches": found},
	)
}

violations contains v if {
	row := spec.contexts_in_scope(input.spec_tree)[_]
	some index, req in spec.requirements(row.context)
	refs := object.get(req, "codeRefs", [])
	is_array(refs)
	some ref in refs
	is_string(ref)
	text.secret_like(ref)
	found := text.secret_matches(ref)
	v := violation.build(
		policy_id,
		"security-secret-in-code-ref",
		violation.requirement_location(row.name, row.path, index),
		sprintf("code ref %q of requirement %s carries %v; a ref names a file or symbol, never a secret", [ref, object.get(req, "id", ""), found]),
		{"requirement": object.get(req, "id", ""), "ref": ref, "matches": found},
	)
}

violations contains v if {
	row := spec.contexts_in_scope(input.spec_tree)[_]
	refs := object.get(spec.spec_of(row.context), "codeRefs", [])
	is_array(refs)
	some ref in refs
	is_string(ref)
	text.secret_like(ref)
	found := text.secret_matches(ref)
	v := violation.build(
		policy_id,
		"security-secret-in-code-ref",
		violation.context_location(row.name, row.path),
		sprintf("code ref %q of context %s carries %v; a ref names a file or symbol, never a secret", [ref, row.name, found]),
		{"context": row.name, "ref": ref, "matches": found},
	)
}

violations contains v if {
	tree := object.get(input, "spec_tree", {})
	texts := object.get(tree, "texts", {})
	is_object(texts)
	some path, body in texts
	is_string(body)
	regex.match(private_key_pattern, body)
	v := violation.build(
		policy_id,
		"security-private-key-in-spec",
		violation.file_location("", path, 0),
		sprintf("%s carries a BEGIN PRIVATE KEY block; a spec carries a reference to a key, never the key itself", [path]),
		{"path": path},
	)
}

violations contains v if {
	row := code.added_rows(object.get(input, "diff", null))[_]
	text.secret_like(row.text)
	found := text.secret_matches(row.text)
	v := violation.build(
		policy_id,
		"security-token-in-diff",
		violation.file_location("", row.path, row.line),
		sprintf("added line %d of %s carries %v; a diff commits a reference to a secret, never the secret", [row.line, row.path, found]),
		{"path": row.path, "line": row.line, "matches": found},
	)
}

violations contains v if {
	row := code.added_rows(object.get(input, "diff", null))[_]
	regex.match(high_entropy_pattern, row.text)
	v := violation.build(
		policy_id,
		"security-high-entropy-literal-in-diff",
		violation.file_location("", row.path, row.line),
		sprintf("added line %d of %s assigns a 64-character hex literal %q; key material is injected at run time, not committed", [row.line, row.path, row.text]),
		{"path": row.path, "line": row.line},
	)
}
