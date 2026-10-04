package deno_kcp.lib.arch

import rego.v1

import data.deno_kcp.lib.spec

# Accessors shared by the reference and consistency policy sets: a context's
# observed facts, every code ref a context declares, and the spec graph and arch
# document a context is rendered into.

# A context that was never observed has no facts at all. That is unmeasurable,
# not wrong, so each observed accessor is paired with a predicate that says
# whether the observer recorded anything to judge against.

observed(ctx) := obs if {
	obs := object.get(spec.status_of(ctx), "observed", {})
	is_object(obs)
}

has_observed_files(ctx) if {
	is_array(object.get(observed(ctx), "files", null))
}

has_observed_interfaces(ctx) if {
	is_array(object.get(observed(ctx), "interfaces", null))
}

observed_files(ctx) := files if {
	files := object.get(observed(ctx), "files", [])
	is_array(files)
}

observed_interfaces(ctx) := ifaces if {
	ifaces := object.get(observed(ctx), "interfaces", [])
	is_array(ifaces)
}

observed_interface_names(ctx) := names if {
	names := {name |
		some iface in observed_interfaces(ctx)
		name := object.get(iface, "name", "")
		is_string(name)
	}
}

observed_interface_ids(ctx) := ids if {
	ids := {id |
		some iface in observed_interfaces(ctx)
		id := object.get(iface, "codegraphId", "")
		is_string(id)
	}
}

declared_interface_names(ctx) := names if {
	names := {name |
		some iface in spec.interfaces(ctx)
		name := object.get(iface, "name", "")
		is_string(name)
	}
}

context_level_refs(ctx) := refs if {
	refs := object.get(spec.spec_of(ctx), "codeRefs", [])
	is_array(refs)
}

# Every ref a context declares, on its requirements and on itself, with where it
# was declared.
code_ref_rows(tree) := rows if {
	rows := array.concat(requirement_ref_rows(tree), context_ref_rows(tree))
}

requirement_ref_rows(tree) := rows if {
	rows := [row |
		some ctx in spec.contexts_in_scope(tree)
		reqs := spec.requirements(ctx.context)
		some index, req in reqs
		refs := spec.requirement_code_refs(req)
		some ref in refs
		row := {
			"context": ctx.name,
			"context_data": ctx.context,
			"path": ctx.path,
			"index": index,
			"requirement": spec.requirement_id(req),
			"ref": ref,
			"scope": "requirement",
		}
	]
}

context_ref_rows(tree) := rows if {
	rows := [row |
		some ctx in spec.contexts_in_scope(tree)
		refs := context_level_refs(ctx.context)
		some index, ref in refs
		row := {
			"context": ctx.name,
			"context_data": ctx.context,
			"path": ctx.path,
			"index": index,
			"requirement": "",
			"ref": ref,
			"scope": "context",
		}
	]
}

# The arch document and its system_contexts entries.
arch(tree) := doc if {
	doc := object.get(tree, "arch", {})
	is_object(doc)
}

arch_entries(tree) := rows if {
	rows := object.get(arch(tree), "system_contexts", [])
	is_array(rows)
}

arch_entry_by_name(tree) := entries if {
	entries := {name: entry |
		some entry in arch_entries(tree)
		name := object.get(entry, "name", "")
		is_string(name)
		name != ""
	}
}

all_context_names(tree) := names if {
	names := {name | some name, _ in object.get(tree, "contexts", {})}
}

# The graph and its vertices and edges.
graph(tree) := g if {
	g := object.get(tree, "graph", {})
	is_object(g)
}

vertices(tree) := vs if {
	vs := object.get(graph(tree), "vertices", [])
	is_array(vs)
}

edges(tree) := es if {
	es := object.get(graph(tree), "edges", [])
	is_array(es)
}

vertices_of_label(tree, label) := rows if {
	rows := [v | some v in vertices(tree); object.get(v, "label", "") == label]
}

vertex_ids(tree) := ids if {
	ids := {object.get(v, "id", null) | some v in vertices(tree)}
}

vertex_label_by_id(tree) := labels if {
	labels := {object.get(v, "id", null): object.get(v, "label", "") | some v in vertices(tree)}
}

known_vertex_labels := {
	"SpecRepo",
	"SpecContext",
	"SpecRequirement",
	"SpecInterface",
	"CodeRef",
	"SpecChange",
	"SpecProgress",
	"PiMemory",
}

known_edge_types := {
	"HAS_CONTEXT",
	"UPSTREAM",
	"OVERLAY",
	"ORCHESTRATOR",
	"DEPENDS_ON",
	"INTRODUCES",
	"REQUIRES",
	"DECLARES",
	"REFERENCES",
	"TOUCHED",
	"OCCURRED",
	"SPECIFIES",
}
