package deno_kcp.policies.arch_consistency

import rego.v1

import data.deno_kcp.lib.arch
import data.deno_kcp.lib.spec
import data.deno_kcp.lib.violation

vertices_path := "graph/vertices.jsonl"

edges_path := "graph/edges.jsonl"

vertices := arch.vertices(input.spec_tree)

edges := arch.edges(input.spec_tree)

vertex_ids := arch.vertex_ids(input.spec_tree)

vertex_label_by_id := arch.vertex_label_by_id(input.spec_tree)

context_vertices := arch.vertices_of_label(input.spec_tree, "SpecContext")

context_vertex_names := names if {
	names := {name |
		some v in context_vertices
		name := object.get(v, "name", "")
		is_string(name)
	}
}

requirement_vertex_keys := keys if {
	keys := {sprintf("%s|%s", [object.get(v, "context", ""), object.get(v, "reqId", "")]) |
		some v in arch.vertices_of_label(input.spec_tree, "SpecRequirement")
	}
}

dangling_edge_indices contains index if {
	some index, edge in edges
	not object.get(edge, "from", null) in vertex_ids
}

dangling_edge_indices contains index if {
	some index, edge in edges
	not object.get(edge, "to", null) in vertex_ids
}

violations contains v if {
	some index in dangling_edge_indices
	edge := edges[index]
	v := violation.build(
		policy_id,
		"graph-edge-dangling",
		violation.location("graph", "", edges_path, sprintf("/edges/%d", [index])),
		sprintf("graph edge %d (%v -> %v, type %s) names a vertex id that is not in the graph", [index, object.get(edge, "from", null), object.get(edge, "to", null), object.get(edge, "type", "")]),
		{"edge": edge, "index": index},
	)
}

duplicate_vertex_ids := {id |
	some vertex in vertices
	id := object.get(vertex, "id", null)
	id != null
	count([x | some x in vertices; object.get(x, "id", null) == id]) > 1
}

violations contains v if {
	some id in duplicate_vertex_ids
	rows := [vertex | some vertex in vertices; object.get(vertex, "id", null) == id]
	labels := [object.get(vertex, "label", "") | some vertex in rows]
	v := violation.build(
		policy_id,
		"graph-vertex-id-duplicate",
		violation.location("graph", "", vertices_path, sprintf("/vertices/%v", [id])),
		sprintf("graph vertex id %v is carried by %d vertices: %v", [id, count(rows), labels]),
		{"id": id, "labels": labels, "count": count(rows)},
	)
}

violations contains v if {
	row := spec.contexts_in_scope(input.spec_tree)[_]
	not row.name in context_vertex_names
	v := violation.build(
		policy_id,
		"graph-context-without-vertex",
		violation.location("graph", row.name, vertices_path, "/vertices"),
		sprintf("context %s has no SpecContext vertex in the graph", [row.name]),
		{"context": row.name},
	)
}

violations contains v if {
	vertex := context_vertices[_]
	name := object.get(vertex, "name", "")
	is_string(name)
	name != ""
	spec.in_scope(name)
	not name in arch.all_context_names(input.spec_tree)
	v := violation.build(
		policy_id,
		"graph-vertex-without-context",
		violation.location("graph", name, vertices_path, sprintf("/vertices/%v", [object.get(vertex, "id", null)])),
		sprintf("graph carries a SpecContext vertex %s with no specs/%s.yaml", [name, name]),
		{"context": name, "id": object.get(vertex, "id", null)},
	)
}

label_mismatch_edge_indices contains index if {
	some index, edge in edges
	from := object.get(edge, "from", null)
	to := object.get(edge, "to", null)
	from in vertex_ids
	to in vertex_ids
	object.get(edge, "fromLabel", "") != vertex_label_by_id[from]
}

label_mismatch_edge_indices contains index if {
	some index, edge in edges
	from := object.get(edge, "from", null)
	to := object.get(edge, "to", null)
	from in vertex_ids
	to in vertex_ids
	object.get(edge, "toLabel", "") != vertex_label_by_id[to]
}

violations contains v if {
	some index in label_mismatch_edge_indices
	edge := edges[index]
	from := object.get(edge, "from", null)
	to := object.get(edge, "to", null)
	v := violation.build(
		policy_id,
		"graph-edge-label-mismatch",
		violation.location("graph", "", edges_path, sprintf("/edges/%d", [index])),
		sprintf("graph edge %d labels its ends %s/%s but the vertices are %s/%s", [index, object.get(edge, "fromLabel", ""), object.get(edge, "toLabel", ""), vertex_label_by_id[from], vertex_label_by_id[to]]),
		{"edge": edge, "index": index},
	)
}

violations contains v if {
	row := spec.all_requirements(input.spec_tree)[_]
	key := sprintf("%s|%s", [row.context, spec.requirement_id(row.requirement)])
	not key in requirement_vertex_keys
	v := violation.build(
		policy_id,
		"graph-requirement-vertex-missing",
		violation.requirement_location(row.context, row.path, row.index),
		sprintf("requirement %s of context %s has no SpecRequirement vertex in the graph", [spec.requirement_id(row.requirement), row.context]),
		{"context": row.context, "requirement": spec.requirement_id(row.requirement)},
	)
}

violations contains v if {
	some index, edge in edges
	edge_type := object.get(edge, "type", "")
	is_string(edge_type)
	edge_type != ""
	not edge_type in arch.known_edge_types
	v := violation.build(
		policy_id,
		"graph-edge-type-unknown",
		violation.location("graph", "", edges_path, sprintf("/edges/%d/type", [index])),
		sprintf("graph edge %d carries type %q, which is not one the schema names", [index, edge_type]),
		{"edge": edge, "index": index, "type": edge_type},
	)
}
