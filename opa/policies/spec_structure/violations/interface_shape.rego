package deno_kcp.policies.spec_structure

import rego.v1

import data.deno_kcp.lib.spec
import data.deno_kcp.lib.violation

interface_key(row) := key if {
	key := sprintf("%s/%s", [row.context, object.get(row.interface, "name", "")])
}

duplicate_interface_keys := {key |
	some row in spec.all_interfaces(input.spec_tree)
	key := interface_key(row)
	count([r | some r in spec.all_interfaces(input.spec_tree); interface_key(r) == key]) > 1
}

violations contains v if {
	row := spec.all_interfaces(input.spec_tree)[_]
	file := object.get(row.interface, "file", null)
	not is_string(file)
	v := violation.build(
		policy_id,
		"interface-file-missing",
		violation.interface_location(row.context, row.path, row.index),
		sprintf("interface %s names no file, so no observer can find it", [object.get(row.interface, "name", "?")]),
		{"interface": object.get(row.interface, "name", "")},
	)
}

violations contains v if {
	row := spec.all_interfaces(input.spec_tree)[_]
	kind := object.get(row.interface, "kind", "")
	is_string(kind)
	not kind in spec.interface_kinds
	v := violation.build(
		policy_id,
		"interface-kind-invalid",
		violation.interface_location(row.context, row.path, row.index),
		sprintf("interface %s declares kind %q; the observer reports one of the declared kinds", [object.get(row.interface, "name", "?"), kind]),
		{"interface": object.get(row.interface, "name", ""), "kind": kind},
	)
}

violations contains v if {
	row := spec.all_interfaces(input.spec_tree)[_]
	name := object.get(row.interface, "name", null)
	not is_string(name)
	v := violation.build(
		policy_id,
		"interface-name-missing",
		violation.interface_location(row.context, row.path, row.index),
		sprintf("interface at index %d of %s names nothing", [row.index, row.path]),
		{"interface_index": row.index},
	)
}

violations contains v if {
	some key in duplicate_interface_keys
	rows := [row | some row in spec.all_interfaces(input.spec_tree); interface_key(row) == key]
	row := rows[0]
	v := violation.build(
		policy_id,
		"interface-name-duplicate",
		violation.interface_location(row.context, row.path, row.index),
		sprintf("context %s declares interface %s %d times", [row.context, row.interface.name, count(rows)]),
		{"interface": row.interface.name, "count": count(rows), "indices": [r.index | some r in rows]},
	)
}

violations contains v if {
	row := spec.all_interfaces(input.spec_tree)[_]
	signature := object.get(row.interface, "signature", null)
	is_string(signature)
	signature == ""
	v := violation.build(
		policy_id,
		"interface-signature-missing",
		violation.interface_location(row.context, row.path, row.index),
		sprintf("interface %s declares an empty signature", [row.interface.name]),
		{"interface": row.interface.name},
	)
}
