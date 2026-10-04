package deno_kcp.policies.arch_consistency

import rego.v1

import data.deno_kcp.lib.arch
import data.deno_kcp.lib.spec
import data.deno_kcp.lib.violation

arch_path := ".tools/open-architecture/arch.yaml"

arch_entries := arch.arch_entries(input.spec_tree)

in_scope_arch_entries := rows if {
	rows := [entry |
		some entry in arch_entries
		name := object.get(entry, "name", "")
		is_string(name)
		name != ""
		spec.in_scope(name)
	]
}

arch_entry_names := names if {
	names := {name |
		some entry in arch_entries
		name := object.get(entry, "name", "")
		is_string(name)
		name != ""
	}
}

arch_location(name, pointer) := loc if {
	loc := violation.location("arch", name, arch_path, pointer)
}

violations contains v if {
	row := spec.contexts_in_scope(input.spec_tree)[_]
	not row.name in arch_entry_names
	v := violation.build(
		policy_id,
		"arch-context-missing",
		arch_location(row.name, "/system_contexts"),
		sprintf("context %s is rendered in %s but has no system_contexts entry in %s", [row.name, row.path, arch_path]),
		{"context": row.name, "spec_path": row.path},
	)
}

violations contains v if {
	entry := in_scope_arch_entries[_]
	name := object.get(entry, "name", "")
	not name in arch.all_context_names(input.spec_tree)
	v := violation.build(
		policy_id,
		"arch-context-extra",
		arch_location(name, sprintf("/system_contexts/%s", [name])),
		sprintf("%s carries a system_contexts entry %s with no specs/%s.yaml", [arch_path, name, name]),
		{"context": name},
	)
}

violations contains v if {
	entry := in_scope_arch_entries[_]
	name := object.get(entry, "name", "")
	id := object.get(entry, "id", "")
	is_string(id)
	not startswith(id, "sc.")
	v := violation.build(
		policy_id,
		"arch-context-id-not-prefixed",
		arch_location(name, sprintf("/system_contexts/%s/id", [name])),
		sprintf("arch entry %s carries id %q; an arch context id is sc.%s", [name, id, name]),
		{"context": name, "id": id},
	)
}

violations contains v if {
	entry := in_scope_arch_entries[_]
	name := object.get(entry, "name", "")
	id := object.get(entry, "id", "")
	is_string(id)
	startswith(id, "sc.")
	spec.arch_id_to_name(id) != name
	v := violation.build(
		policy_id,
		"arch-name-mismatch",
		arch_location(name, sprintf("/system_contexts/%s/id", [name])),
		sprintf("arch entry %s carries id %q, which reads back as %s", [name, id, spec.arch_id_to_name(id)]),
		{"context": name, "id": id},
	)
}

duplicate_arch_ids := {id |
	some entry in in_scope_arch_entries
	id := object.get(entry, "id", "")
	is_string(id)
	id != ""
	count([e | some e in in_scope_arch_entries; object.get(e, "id", "") == id]) > 1
}

violations contains v if {
	some id in duplicate_arch_ids
	rows := [entry | some entry in in_scope_arch_entries; object.get(entry, "id", "") == id]
	entry := rows[0]
	name := object.get(entry, "name", "")
	names := [object.get(e, "name", "") | some e in rows]
	v := violation.build(
		policy_id,
		"arch-context-id-duplicate",
		arch_location(name, sprintf("/system_contexts/%s/id", [name])),
		sprintf("arch id %q is carried by %d entries: %v", [id, count(rows), names]),
		{"id": id, "contexts": names, "count": count(rows)},
	)
}
