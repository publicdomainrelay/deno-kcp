package deno_kcp.policies.change_security

import rego.v1

import data.deno_kcp.lib.code
import data.deno_kcp.lib.text
import data.deno_kcp.lib.violation

# A spec or a diff that widens authority: a role that gains a write verb or a
# wildcard, a binding to cluster-admin, a workload that gains privilege or a
# host path, a command that widens a restricted permission set, or a secret
# file made world writable.

rbac_item_pattern := `^\s*-\s*(\*|[a-z]+)\s*$`

rbac_verbs(body) := verbs if {
	is_string(body)
	verbs := {verb |
		some line in split(body, "\n")
		m := regex.find_all_string_submatch_n(rbac_item_pattern, line, 1)
		count(m) == 1
		verb := m[0][1]
	}
}

violations contains v if {
	file := code.diff_files(object.get(input, "diff", null))[_]
	path := code.file_path(file)
	head := code.file_head_text(file)
	base := code.file_base_text(file)
	head_verbs := rbac_verbs(head)
	base_verbs := rbac_verbs(base)
	count(base_verbs) > 0
	base_widening := {verb | some verb in base_verbs; not verb in read_only_verbs}
	head_widening := {verb | some verb in head_verbs; not verb in read_only_verbs}
	count(base_widening) == 0
	added_widening := {verb | some verb in head_widening; not verb in base_verbs}
	count(added_widening) > 0
	v := violation.build(
		policy_id,
		"security-rbac-verb-widened",
		violation.file_location("", path, 0),
		sprintf("%s had only read verbs %v and now grants %v; a role widened from reading to writing is the authority to change what it reads", [path, base_verbs, added_widening]),
		{"path": path, "base": base_verbs, "head": head_verbs, "added": added_widening},
	)
}

violations contains v if {
	file := code.diff_files(object.get(input, "diff", null))[_]
	path := code.file_path(file)
	head := code.file_head_text(file)
	base := code.file_base_text(file)
	head_verbs := rbac_verbs(head)
	"*" in head_verbs
	not "*" in rbac_verbs(base)
	v := violation.build(
		policy_id,
		"security-rbac-verb-widened",
		violation.file_location("", path, 0),
		sprintf("%s grants the wildcard verb *; a role that names every verb is the authority to do anything the API allows", [path]),
		{"path": path, "head": head_verbs},
	)
}

violations contains v if {
	row := code.added_rows(object.get(input, "diff", null))[_]
	code.contains_ci(row.text, "cluster-admin")
	code.contains_ci(row.head_text, "ClusterRoleBinding")
	v := violation.build(
		policy_id,
		"security-cluster-admin-binding",
		violation.file_location("", row.path, row.line),
		sprintf("added line %d of %s binds a subject to cluster-admin; cluster-admin is every verb on every resource in every namespace", [row.line, row.path]),
		{"path": row.path, "line": row.line},
	)
}

violations contains v if {
	row := code.added_rows(object.get(input, "diff", null))[_]
	regex.match(privileged_pattern, row.text)
	v := violation.build(
		policy_id,
		"security-privileged-workload",
		violation.file_location("", row.path, row.line),
		sprintf("added line %d of %s is %q, which asks the kernel for more than its namespace grants; a workload that privileged is not the workload the spec described", [row.line, row.path, trim_space(row.text)]),
		{"path": row.path, "line": row.line},
	)
}

violations contains v if {
	row := code.added_rows(object.get(input, "diff", null))[_]
	regex.match(hostpath_pattern, row.text)
	v := violation.build(
		policy_id,
		"security-hostpath-mount",
		violation.file_location("", row.path, row.line),
		sprintf("added line %d of %s mounts a host path; a mount of the node filesystem escapes the namespace the spec confines the workload to", [row.line, row.path]),
		{"path": row.path, "line": row.line},
	)
}

violations contains v if {
	row := code.added_rows(object.get(input, "diff", null))[_]
	regex.match(widened_permission_pattern, row.text)
	regex.match(restricted_permission_pattern, row.base_text)
	v := violation.build(
		policy_id,
		"security-widened-permission-set",
		violation.file_location("", row.path, row.line),
		sprintf("added line %d of %s is %q, which widens a restricted allow list to every permission; the runtime the spec described was one it could audit", [row.line, row.path, trim_space(row.text)]),
		{"path": row.path, "line": row.line},
	)
}

violations contains v if {
	row := code.added_rows(object.get(input, "diff", null))[_]
	regex.match(world_writable_pattern, row.text)
	text.contains_any(row.text, sensitive_markers)
	v := violation.build(
		policy_id,
		"security-world-writable-secret-file",
		violation.file_location("", row.path, row.line),
		sprintf("added line %d of %s makes a secret file world writable; any process on the host can then replace the key material it holds", [row.line, row.path]),
		{"path": row.path, "line": row.line},
	)
}
