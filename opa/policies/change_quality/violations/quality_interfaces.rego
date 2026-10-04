package deno_kcp.policies.change_quality

import rego.v1

import data.deno_kcp.lib.prose
import data.deno_kcp.lib.spec
import data.deno_kcp.lib.violation

# The signature an interface declares: whether it is there at all, and whether
# its shape fits the kind of interface it names.

violations contains v if {
	row := spec.all_interfaces(input.spec_tree)[_]
	kind := object.get(row.interface, "kind", "")
	is_string(kind)
	signature := object.get(row.interface, "signature", null)
	is_string(signature)
	signature != ""
	not prose.signature_fits_kind(kind, signature)
	v := violation.build(
		policy_id,
		"quality-interface-signature-not-a-signature",
		violation.interface_location(row.context, row.path, row.index),
		sprintf(
			"interface %s of kind %s declares signature %q, which is not the shape that kind carries",
			[object.get(row.interface, "name", "?"), kind, signature],
		),
		{"interface": object.get(row.interface, "name", ""), "kind": kind, "signature": signature},
	)
}

violations contains v if {
	row := spec.all_interfaces(input.spec_tree)[_]
	signature := object.get(row.interface, "signature", null)
	not is_string(signature)
	v := violation.build(
		policy_id,
		"quality-interface-signature-missing",
		violation.interface_location(row.context, row.path, row.index),
		sprintf(
			"interface %s declares no signature; without one the observer cannot say what it observes",
			[object.get(row.interface, "name", "?")],
		),
		{"interface": object.get(row.interface, "name", "")},
	)
}

violations contains v if {
	row := spec.all_interfaces(input.spec_tree)[_]
	signature := object.get(row.interface, "signature", null)
	is_string(signature)
	signature == ""
	v := violation.build(
		policy_id,
		"quality-interface-signature-missing",
		violation.interface_location(row.context, row.path, row.index),
		sprintf(
			"interface %s declares an empty signature; without one the observer cannot say what it observes",
			[object.get(row.interface, "name", "?")],
		),
		{"interface": object.get(row.interface, "name", "")},
	)
}
