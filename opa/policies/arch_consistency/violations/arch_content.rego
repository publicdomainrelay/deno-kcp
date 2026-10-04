package deno_kcp.policies.arch_consistency

import rego.v1

import data.deno_kcp.lib.arch
import data.deno_kcp.lib.spec
import data.deno_kcp.lib.violation

context_entry_pairs contains row if {
	ctx := spec.contexts_in_scope(input.spec_tree)[_]
	entry := arch.arch_entry_by_name(input.spec_tree)[ctx.name]
	row := {"context": ctx.name, "context_data": ctx.context, "path": ctx.path, "entry": entry}
}

spec_requirement_ids(row) := ids if {
	ids := {id | some req in spec.requirements(row.context_data); id := spec.requirement_id(req); id != ""}
}

arch_requirements(row) := reqs if {
	reqs := object.get(row.entry, "requirements", [])
	is_array(reqs)
}

arch_requirement_by_id(row) := mapping if {
	mapping := {id: req |
		some req in arch_requirements(row)
		id := object.get(req, "id", "")
		is_string(id)
		id != ""
	}
}

spec_interface_names(row) := names if {
	names := {name |
		some iface in spec.interfaces(row.context_data)
		name := object.get(iface, "name", "")
		is_string(name)
		name != ""
	}
}

arch_interfaces(row) := ifaces if {
	ifaces := object.get(row.entry, "interfaces", [])
	is_array(ifaces)
}

arch_interface_by_name(row) := mapping if {
	mapping := {name: iface |
		some iface in arch_interfaces(row)
		name := object.get(iface, "name", "")
		is_string(name)
		name != ""
	}
}

violations contains v if {
	row := context_entry_pairs[_]
	arch_intent := object.get(row.entry, "intent", "")
	spec_intent := spec.intent(row.context_data)
	arch_intent != spec_intent
	v := violation.build(
		policy_id,
		"arch-intent-differs",
		arch_location(row.context, sprintf("/system_contexts/%s/intent", [row.context])),
		sprintf("context %s carries an intent in %s that is not the intent in %s; the two renderings of one context disagree", [row.context, arch_path, row.path]),
		{"context": row.context, "arch_words": count(split(arch_intent, " ")), "spec_words": count(split(spec_intent, " "))},
	)
}

violations contains v if {
	row := context_entry_pairs[_]
	some index, req in spec.requirements(row.context_data)
	id := spec.requirement_id(req)
	id != ""
	not id in object.keys(arch_requirement_by_id(row))
	v := violation.build(
		policy_id,
		"arch-requirement-missing",
		violation.requirement_location(row.context, row.path, index),
		sprintf("requirement %s of context %s is in %s but has no entry in %s", [id, row.context, row.path, arch_path]),
		{"context": row.context, "requirement": id},
	)
}

violations contains v if {
	row := context_entry_pairs[_]
	some index, req in arch_requirements(row)
	id := object.get(req, "id", "")
	is_string(id)
	id != ""
	not id in spec_requirement_ids(row)
	v := violation.build(
		policy_id,
		"arch-requirement-extra",
		arch_location(row.context, sprintf("/system_contexts/%s/requirements/%d", [row.context, index])),
		sprintf("arch entry %s carries requirement %s, which %s does not declare", [row.context, id, row.path]),
		{"context": row.context, "requirement": id},
	)
}

violations contains v if {
	row := context_entry_pairs[_]
	some index, req in spec.requirements(row.context_data)
	id := spec.requirement_id(req)
	mapping := arch_requirement_by_id(row)
	id in object.keys(mapping)
	object.get(mapping[id], "text", "") != spec.requirement_text(req)
	v := violation.build(
		policy_id,
		"arch-requirement-text-differs",
		violation.requirement_location(row.context, row.path, index),
		sprintf("requirement %s of context %s carries different text in %s than in %s", [id, row.context, arch_path, row.path]),
		{"context": row.context, "requirement": id},
	)
}

violations contains v if {
	row := context_entry_pairs[_]
	some index, req in spec.requirements(row.context_data)
	id := spec.requirement_id(req)
	mapping := arch_requirement_by_id(row)
	id in object.keys(mapping)
	arch_level := object.get(mapping[id], "level", "")
	spec_level := spec.requirement_level(req)
	arch_level != spec_level
	v := violation.build(
		policy_id,
		"arch-requirement-level-differs",
		violation.requirement_location(row.context, row.path, index),
		sprintf("requirement %s of context %s is %q in %s and %q in %s", [id, row.context, arch_level, arch_path, spec_level, row.path]),
		{"context": row.context, "requirement": id, "arch_level": arch_level, "spec_level": spec_level},
	)
}

violations contains v if {
	row := context_entry_pairs[_]
	some index, iface in spec.interfaces(row.context_data)
	name := object.get(iface, "name", "")
	is_string(name)
	name != ""
	not name in object.keys(arch_interface_by_name(row))
	v := violation.build(
		policy_id,
		"arch-interface-missing",
		violation.interface_location(row.context, row.path, index),
		sprintf("interface %s of context %s is in %s but has no entry in %s", [name, row.context, row.path, arch_path]),
		{"context": row.context, "interface": name},
	)
}

violations contains v if {
	row := context_entry_pairs[_]
	some index, iface in arch_interfaces(row)
	name := object.get(iface, "name", "")
	is_string(name)
	name != ""
	not name in spec_interface_names(row)
	v := violation.build(
		policy_id,
		"arch-interface-extra",
		arch_location(row.context, sprintf("/system_contexts/%s/interfaces/%d", [row.context, index])),
		sprintf("arch entry %s carries interface %s, which %s does not declare", [row.context, name, row.path]),
		{"context": row.context, "interface": name},
	)
}

violations contains v if {
	row := context_entry_pairs[_]
	some index, iface in spec.interfaces(row.context_data)
	name := object.get(iface, "name", "")
	mapping := arch_interface_by_name(row)
	name in object.keys(mapping)
	object.get(mapping[name], "signature", "") != object.get(iface, "signature", "")
	v := violation.build(
		policy_id,
		"arch-interface-signature-differs",
		violation.interface_location(row.context, row.path, index),
		sprintf("interface %s of context %s carries a different signature in %s than in %s", [name, row.context, arch_path, row.path]),
		{"context": row.context, "interface": name, "arch_signature": object.get(mapping[name], "signature", ""), "spec_signature": object.get(iface, "signature", "")},
	)
}

violations contains v if {
	row := context_entry_pairs[_]
	arch.has_observed_files(row.context_data)
	arch_code := {code | some code in object.get(row.entry, "code", []); is_string(code)}
	observed := arch.observed_files(row.context_data)
	only_arch := arch_code - {file | some file in observed}
	only_spec := {file | some file in observed} - arch_code
	count(only_arch) + count(only_spec) > 0
	v := violation.build(
		policy_id,
		"arch-code-list-differs",
		arch_location(row.context, sprintf("/system_contexts/%s/code", [row.context])),
		sprintf("arch entry %s lists %d code files and the context observed %d; only in %s: %v; only observed: %v", [row.context, count(arch_code), count(observed), arch_path, sort(only_arch), sort(only_spec)]),
		{"context": row.context, "only_arch": sort(only_arch), "only_observed": sort(only_spec)},
	)
}
