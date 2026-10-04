package deno_kcp.policies.spec_references

import rego.v1

import data.deno_kcp.lib.arch
import data.deno_kcp.lib.refs
import data.deno_kcp.lib.spec
import data.deno_kcp.lib.violation

# upstream, orchestrator, overlay, dependsOn and introduces are references to
# other contexts. Every one names a context the tree holds.

context_member_refs contains row if {
	some ctx in spec.contexts_in_scope(input.spec_tree)
	body := spec.spec_of(ctx.context)
	some field in ["upstream", "orchestrator"]
	value := object.get(body, field, null)
	is_string(value)
	row := {"context": ctx.name, "path": ctx.path, "field": field, "index": -1, "ref": value}
}

context_member_refs contains row if {
	some ctx in spec.contexts_in_scope(input.spec_tree)
	body := spec.spec_of(ctx.context)
	some field in ["overlay", "dependsOn", "introduces"]
	value := object.get(body, field, null)
	is_array(value)
	some index, ref in value
	row := {"context": ctx.name, "path": ctx.path, "field": field, "index": index, "ref": ref}
}

violations contains v if {
	row := context_member_refs[_]
	ref := row.ref
	is_string(ref)
	ref != "self"
	refs.is_ref(ref)
	name := refs.ref_name(ref)
	not name in arch.all_context_names(input.spec_tree)
	v := violation.build(
		policy_id,
		"context-reference-unknown",
		violation.context_location(row.context, row.path),
		sprintf("context %s declares %s %q, which names %s; the tree holds no context %s", [row.context, row.field, ref, name, name]),
		{"context": row.context, "field": row.field, "ref": ref, "name": name},
	)
}
