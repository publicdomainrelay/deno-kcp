package deno_kcp.policies.arch_consistency_test

import rego.v1

import data.deno_kcp.policies.arch_consistency as policy

demo_intent := "This context exists so the provider writes the facts it observed for every workspace it watches, so that drift between the declared spec and the running code is decided from those facts rather than from a reread of the tree."

demo_requirement := {
	"id": "r.reconcile-writes-facts",
	"level": "MUST",
	"text": "The provider writes the observed fingerprint of every workspace it watches after each reconcile, so drift is decided from the facts the last reconcile observed.",
	"codeRefs": ["file:internal/provider/watch.go"],
}

demo_interface := {"file": "internal/provider/watch.go", "kind": "struct", "name": "Watcher", "signature": "struct{}"}

demo_spec_body := {
	"intent": demo_intent,
	"repository": "deno-kcp",
	"upstream": "self",
	"requirements": [demo_requirement],
	"interfaces": [demo_interface],
}

demo_status := {
	"conditions": [{"type": "CodeSynced", "status": "True"}],
	"observed": {"files": ["internal/provider/watch.go"], "fingerprint": "aa11"},
	"realizedSpecHash": "dad5f9ab3f04080c9fccf5a7d469fead020624d83e77b1933e346156c9ff2e85",
}

demo_context := {
	"name": "demo",
	"spec_path": "specs/demo.yaml",
	"status_path": "status/demo.yaml",
	"context_doc_path": "context/demo.md",
	"document": {"apiVersion": "specs.publicdomainrelay.dev/v1alpha1", "kind": "SystemContext", "metadata": {"name": "demo", "namespace": "default"}, "spec": demo_spec_body},
	"metadata": {"name": "demo", "namespace": "default"},
	"spec": demo_spec_body,
	"status": demo_status,
	"context_doc": {"path": "context/demo.md", "text": "# Context: demo\n", "headings": [], "sha256": "bb"},
	"changes": {},
}

demo_arch_entry := {
	"id": "sc.demo",
	"name": "demo",
	"intent": demo_intent,
	"upstream": "self",
	"requirements": [demo_requirement],
	"interfaces": [demo_interface],
	"code": ["internal/provider/watch.go"],
}

demo_vertices := [
	{"id": 1, "label": "SpecRepo", "name": "deno-kcp"},
	{"id": 2, "label": "SpecContext", "name": "demo"},
	{"id": 3, "label": "SpecRequirement", "context": "demo", "reqId": "r.reconcile-writes-facts"},
	{"id": 4, "label": "SpecInterface", "context": "demo", "name": "Watcher"},
]

demo_edges := [
	{"from": 1, "to": 2, "fromLabel": "SpecRepo", "toLabel": "SpecContext", "type": "HAS_CONTEXT"},
	{"from": 2, "to": 3, "fromLabel": "SpecContext", "toLabel": "SpecRequirement", "type": "REQUIRES"},
	{"from": 2, "to": 4, "fromLabel": "SpecContext", "toLabel": "SpecInterface", "type": "DECLARES"},
]

demo_graph := {"vertices": demo_vertices, "edges": demo_edges}

tree(arch_entries, graph) := {
	"root": "/tmp/tree",
	"ref": null,
	"repository": {"spec": {"branch": "spec/demo"}, "status": {"phase": "Populated"}},
	"arch": {"system_contexts": arch_entries},
	"contexts": {"demo": demo_context},
	"changes": {},
	"graph": graph,
	"files": {},
	"texts": {},
	"observed_files": [],
	"context_names": ["demo"],
}

with_arch(entries) := {"spec_tree": tree(entries, demo_graph), "options": {"scope": "own"}}

with_graph(graph) := {"spec_tree": tree([demo_arch_entry], graph), "options": {"scope": "own"}}

ids(violations) := {v.id | some v in violations}

valid_input := with_arch([demo_arch_entry])

test_valid_tree_raises_nothing if {
	violations := policy.violations with input as valid_input
	count(violations) == 0
}

test_arch_context_missing if {
	result := policy.violations with input as with_arch([])
	"arch_consistency/arch-context-missing" in ids(result)
}

test_arch_context_extra if {
	ghost := {"id": "sc.ghost", "name": "ghost", "intent": "", "upstream": "self", "requirements": [], "interfaces": [], "code": []}
	result := policy.violations with input as with_arch([demo_arch_entry, ghost])
	"arch_consistency/arch-context-extra" in ids(result)
}

test_arch_context_id_not_prefixed if {
	entry := object.union(demo_arch_entry, {"id": "demo"})
	result := policy.violations with input as with_arch([entry])
	"arch_consistency/arch-context-id-not-prefixed" in ids(result)
}

test_arch_name_mismatch if {
	entry := object.union(demo_arch_entry, {"id": "sc.other"})
	result := policy.violations with input as with_arch([entry])
	"arch_consistency/arch-name-mismatch" in ids(result)
}

test_arch_context_id_duplicate if {
	result := policy.violations with input as with_arch([demo_arch_entry, demo_arch_entry])
	"arch_consistency/arch-context-id-duplicate" in ids(result)
}

test_arch_intent_differs if {
	entry := object.union(demo_arch_entry, {"intent": "A different intent that says something else entirely about what this context is for."})
	result := policy.violations with input as with_arch([entry])
	"arch_consistency/arch-intent-differs" in ids(result)
}

test_arch_requirement_missing if {
	entry := object.union(demo_arch_entry, {"requirements": []})
	result := policy.violations with input as with_arch([entry])
	"arch_consistency/arch-requirement-missing" in ids(result)
}

test_arch_requirement_extra if {
	extra := {"id": "r.extra", "level": "SHOULD", "text": "An extra requirement that appears only in arch.yaml and nowhere in the spec."}
	entry := object.union(demo_arch_entry, {"requirements": [demo_requirement, extra]})
	result := policy.violations with input as with_arch([entry])
	"arch_consistency/arch-requirement-extra" in ids(result)
}

test_arch_requirement_text_differs if {
	req := object.union(demo_requirement, {"text": "A different text, of about the same length, for the very same requirement id."})
	entry := object.union(demo_arch_entry, {"requirements": [req]})
	result := policy.violations with input as with_arch([entry])
	"arch_consistency/arch-requirement-text-differs" in ids(result)
}

test_arch_requirement_level_differs if {
	req := object.union(demo_requirement, {"level": "SHOULD"})
	entry := object.union(demo_arch_entry, {"requirements": [req]})
	result := policy.violations with input as with_arch([entry])
	"arch_consistency/arch-requirement-level-differs" in ids(result)
}

test_arch_interface_missing if {
	entry := object.union(demo_arch_entry, {"interfaces": []})
	result := policy.violations with input as with_arch([entry])
	"arch_consistency/arch-interface-missing" in ids(result)
}

test_arch_interface_extra if {
	extra := {"file": "internal/provider/x.go", "kind": "struct", "name": "Extra", "signature": "struct{}"}
	entry := object.union(demo_arch_entry, {"interfaces": [demo_interface, extra]})
	result := policy.violations with input as with_arch([entry])
	"arch_consistency/arch-interface-extra" in ids(result)
}

test_arch_interface_signature_differs if {
	iface := object.union(demo_interface, {"signature": "struct{ X int }"})
	entry := object.union(demo_arch_entry, {"interfaces": [iface]})
	result := policy.violations with input as with_arch([entry])
	"arch_consistency/arch-interface-signature-differs" in ids(result)
}

test_arch_code_list_differs if {
	entry := object.union(demo_arch_entry, {"code": ["internal/provider/other.go"]})
	result := policy.violations with input as with_arch([entry])
	"arch_consistency/arch-code-list-differs" in ids(result)
}

test_graph_edge_dangling if {
	dangling := {"from": 2, "to": 99, "fromLabel": "SpecContext", "toLabel": "SpecRequirement", "type": "REQUIRES"}
	graph := object.union(demo_graph, {"edges": array.concat(demo_edges, [dangling])})
	result := policy.violations with input as with_graph(graph)
	"arch_consistency/graph-edge-dangling" in ids(result)
}

test_graph_vertex_id_duplicate if {
	graph := object.union(demo_graph, {"vertices": array.concat(demo_vertices, [{"id": 2, "label": "SpecContext", "name": "demo"}])})
	result := policy.violations with input as with_graph(graph)
	"arch_consistency/graph-vertex-id-duplicate" in ids(result)
}

test_graph_context_without_vertex if {
	graph := {"vertices": [{"id": 1, "label": "SpecRepo", "name": "deno-kcp"}, {"id": 3, "label": "SpecRequirement", "context": "demo", "reqId": "r.reconcile-writes-facts"}], "edges": []}
	result := policy.violations with input as with_graph(graph)
	"arch_consistency/graph-context-without-vertex" in ids(result)
}

test_graph_vertex_without_context if {
	graph := object.union(demo_graph, {"vertices": array.concat(demo_vertices, [{"id": 5, "label": "SpecContext", "name": "ghost"}])})
	result := policy.violations with input as with_graph(graph)
	"arch_consistency/graph-vertex-without-context" in ids(result)
}

test_graph_edge_label_mismatch if {
	edges := [
		{"from": 1, "to": 2, "fromLabel": "SpecRepo", "toLabel": "SpecContext", "type": "HAS_CONTEXT"},
		{"from": 2, "to": 3, "fromLabel": "SpecInterface", "toLabel": "SpecRequirement", "type": "REQUIRES"},
		{"from": 2, "to": 4, "fromLabel": "SpecContext", "toLabel": "SpecInterface", "type": "DECLARES"},
	]
	result := policy.violations with input as with_graph({"vertices": demo_vertices, "edges": edges})
	"arch_consistency/graph-edge-label-mismatch" in ids(result)
}

test_graph_requirement_vertex_missing if {
	graph := {"vertices": [{"id": 1, "label": "SpecRepo", "name": "deno-kcp"}, {"id": 2, "label": "SpecContext", "name": "demo"}, {"id": 4, "label": "SpecInterface", "context": "demo", "name": "Watcher"}], "edges": []}
	result := policy.violations with input as with_graph(graph)
	"arch_consistency/graph-requirement-vertex-missing" in ids(result)
}

test_graph_edge_type_unknown if {
	bad := {"from": 2, "to": 4, "fromLabel": "SpecContext", "toLabel": "SpecInterface", "type": "BOGUS"}
	result := policy.violations with input as with_graph({"vertices": demo_vertices, "edges": [bad]})
	"arch_consistency/graph-edge-type-unknown" in ids(result)
}

test_metadata_names_every_violation_the_policy_can_raise if {
	some id, meta in policy.metadata
	count(object.keys(meta)) == 3
	meta.severity in {"error", "warning", "info"}
	meta.level in {"MUST", "SHOULD", "MAY"}
	is_string(meta.title)
	startswith(id, "")
}
