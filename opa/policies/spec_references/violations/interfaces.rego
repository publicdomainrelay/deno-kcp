package deno_kcp.policies.spec_references

import rego.v1

import data.deno_kcp.lib.arch
import data.deno_kcp.lib.spec
import data.deno_kcp.lib.violation

context_symbol_refs(context_name) := refs_set if {
	refs_set := {row.ref | some row in ref_rows; row.context == context_name; is_symbol_ref(row.ref)}
}

context_symbol_payloads(context_name) := payloads if {
	payloads := {ref_payload(row.ref) | some row in ref_rows; row.context == context_name; is_symbol_ref(row.ref)}
}

violations contains v if {
	row := spec.all_interfaces(input.spec_tree)[_]
	file := object.get(row.interface, "file", "")
	is_string(file)
	file != ""
	not spec.file_known(input.spec_tree, file)
	v := violation.build(
		policy_id,
		"interface-file-missing-on-disk",
		violation.interface_location(row.context, row.path, row.index),
		sprintf("interface %s of context %s names file %q, which is in no file index; the observer has nothing to read", [object.get(row.interface, "name", "?"), row.context, file]),
		{"context": row.context, "interface": object.get(row.interface, "name", ""), "file": file},
	)
}

violations contains v if {
	row := spec.all_interfaces(input.spec_tree)[_]
	file := object.get(row.interface, "file", "")
	is_string(file)
	file != ""
	ctx := context_of(row.context)
	arch.has_observed_files(ctx)
	not file in arch.observed_files(ctx)
	v := violation.build(
		policy_id,
		"interface-file-not-observed",
		violation.interface_location(row.context, row.path, row.index),
		sprintf("interface %s of context %s names file %q, which the context did not observe among its files", [object.get(row.interface, "name", "?"), row.context, file]),
		{"context": row.context, "interface": object.get(row.interface, "name", ""), "file": file},
	)
}

violations contains v if {
	row := spec.all_interfaces(input.spec_tree)[_]
	name := object.get(row.interface, "name", "")
	is_string(name)
	name != ""
	ctx := context_of(row.context)
	arch.has_observed_interfaces(ctx)
	not name in arch.observed_interface_names(ctx)
	v := violation.build(
		policy_id,
		"interface-not-observed",
		violation.interface_location(row.context, row.path, row.index),
		sprintf("interface %s of context %s is declared but not among the interfaces the context observed", [name, row.context]),
		{"context": row.context, "interface": name, "file": object.get(row.interface, "file", "")},
	)
}

violations contains v if {
	ctx := spec.contexts_in_scope(input.spec_tree)[_]
	arch.has_observed_interfaces(ctx.context)
	some index, iface in arch.observed_interfaces(ctx.context)
	name := object.get(iface, "name", "")
	is_string(name)
	name != ""
	id := object.get(iface, "codegraphId", "")
	not name in arch.declared_interface_names(ctx.context)
	not name in context_symbol_payloads(ctx.name)
	not id in context_symbol_refs(ctx.name)
	v := violation.build(
		policy_id,
		"observed-interface-undeclared",
		violation.status_location(ctx.name, object.get(ctx.context, "status_path", ""), sprintf("/observed/interfaces/%d", [index])),
		sprintf("context %s observed interface %s, which no requirement codeRef and no declared interface names; the spec does not account for it", [ctx.name, name]),
		{"context": ctx.name, "interface": name, "codegraphId": id},
	)
}
