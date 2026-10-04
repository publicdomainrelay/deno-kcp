package deno_kcp.policies.change_impact_test

import rego.v1

import data.deno_kcp.policies.change_impact as policy

must_requirement := {
	"id": "r.the-thing",
	"level": "MUST",
	"text": "The provider writes the observed fingerprint of every workspace it watches after each reconcile completes, so drift is decided from those facts.",
	"codeRefs": ["file:deploy/thing.yaml"],
}

weaker_requirement := object.union(must_requirement, {"level": "SHOULD"})

forcey_requirement := object.union(must_requirement, {
	"text": "The verifier must not treat relay frames as text, and it must decode ArrayBuffer and Blob payloads with TextDecoder before searching for its own DID.",
})

quieter_requirement := object.union(must_requirement, {
	"text": "The verifier reads relay frames and decodes ArrayBuffer and Blob payloads with TextDecoder before searching for its own DID.",
})

other_requirement := {
	"id": "r.something-else",
	"level": "MUST",
	"text": "The example creates exactly the four workspaces global, relay, alice and bob, each with spec.type.name denoruntime.",
	"codeRefs": ["file:deploy/other.yaml"],
}

base_context := {
	"name": "demo",
	"spec_path": "specs/demo.yaml",
	"status_path": "status/demo.yaml",
	"context_doc_path": "context/demo.md",
	"document": {"apiVersion": "x", "kind": "SystemContext", "metadata": {"name": "demo", "namespace": "default"}, "spec": {"intent": "i", "repository": "deno-kcp", "upstream": "self", "requirements": [must_requirement]}},
	"metadata": {"name": "demo", "namespace": "default"},
	"spec": {"intent": "i", "repository": "deno-kcp", "upstream": "self", "requirements": [must_requirement]},
	"status": {"conditions": [], "observed": {"files": [], "fingerprint": "aa"}},
	"context_doc": {"path": "context/demo.md", "text": "# Context: demo\n", "headings": []},
	"changes": {},
}

tree(contexts, repository) := {
	"root": "/tmp/tree",
	"repository": repository,
	"arch": {"system_contexts": []},
	"contexts": contexts,
	"changes": {},
	"graph": {"vertices": [], "edges": []},
	"files": {},
	"texts": {},
	"observed_files": [],
	"context_names": ["demo"],
}

with_requirements(tree_doc, requirements) := out if {
	out := object.union(tree_doc, {"contexts": {"demo": object.union(tree_doc.contexts.demo, {
		"spec": object.union(tree_doc.contexts.demo.spec, {"requirements": requirements}),
		"document": object.union(tree_doc.contexts.demo.document, {"spec": object.union(tree_doc.contexts.demo.spec, {"requirements": requirements})}),
	})}})
}

plain_repository := {"kind": "Repository", "spec": {"branch": "spec/demo", "verify": ["go", "test", "./..."]}}

gated_repository := object.union(plain_repository, {"spec": object.union(plain_repository.spec, {"acceptance": [{"name": "live", "command": ["bash", "accept.sh"], "gate": true, "timeoutSeconds": 600}]})})

document(base, head, change, diff) := {"base_tree": base, "spec_tree": head, "change": change, "diff": diff, "options": {"scope": "own"}}

ids_for(base, head, change, diff) := ids if {
	found := policy.violations with input as document(base, head, change, diff)
	ids := {v.id | some v in found}
}

valid_base := tree({"demo": base_context}, gated_repository)

valid_head := with_requirements(tree({"demo": base_context}, gated_repository), [must_requirement])

test_unchanged_tree_raises_nothing if {
	count(ids_for(valid_base, valid_head, null, null)) == 0
}

test_removes_requirement if {
	head := with_requirements(valid_head, [other_requirement])
	ids := ids_for(valid_base, head, null, null)
	"change_impact/impact-removes-requirement" in ids
	"change_impact/impact-removes-must-requirement" in ids
}

test_replacement_by_code_ref_is_not_dropped if {
	replacement := object.union(other_requirement, {"id": "r.other", "codeRefs": ["file:deploy/thing.yaml"]})
	head := with_requirements(valid_head, [replacement])
	ids := ids_for(valid_base, head, null, null)
	not "change_impact/impact-removes-requirement-without-replacement" in ids
}

test_removes_requirement_without_replacement if {
	head := with_requirements(valid_head, [other_requirement])
	ids := ids_for(valid_base, head, null, null)
	"change_impact/impact-removes-requirement-without-replacement" in ids
}

test_downgrades_level if {
	head := with_requirements(valid_head, [weaker_requirement])
	"change_impact/impact-downgrades-level" in ids_for(valid_base, head, null, null)
}

test_upgrades_level if {
	base := with_requirements(valid_base, [weaker_requirement])
	head := with_requirements(valid_head, [must_requirement])
	"change_impact/impact-upgrades-level" in ids_for(base, head, null, null)
}

test_drops_code_ref if {
	head := with_requirements(valid_head, [object.union(must_requirement, {"codeRefs": []})])
	ids := ids_for(valid_base, head, null, null)
	"change_impact/impact-drops-code-ref" in ids
	"change_impact/impact-empties-code-refs" in ids
}

test_text_loses_force if {
	base := with_requirements(valid_base, [forcey_requirement])
	head := with_requirements(valid_head, [quieter_requirement])
	"change_impact/impact-text-loses-force" in ids_for(base, head, null, null)
}

test_text_loses_tls if {
	secure := object.union(must_requirement, {"text": "The host proves the listener answers by fetching https://127.0.0.1:2585/xrpc/_health and reading the status curl printed."})
	insecure := object.union(secure, {"text": "The host proves the listener answers by fetching http://127.0.0.1:2585/xrpc/_health and reading the status curl printed."})
	base := with_requirements(valid_base, [secure])
	head := with_requirements(valid_head, [insecure])
	"change_impact/impact-text-loses-tls" in ids_for(base, head, null, null)
}

test_must_change_without_gating_acceptance if {
	base := tree({"demo": base_context}, plain_repository)
	head := with_requirements(tree({"demo": base_context}, plain_repository), [other_requirement, must_requirement])
	"change_impact/impact-must-change-without-acceptance" in ids_for(base, head, null, null)
}

test_removes_gating_acceptance if {
	head := tree({"demo": base_context}, plain_repository)
	"change_impact/impact-removes-gating-acceptance" in ids_for(valid_base, head, null, null)
}

test_narrows_acceptance_timeout if {
	narrowed := object.union(gated_repository, {"spec": object.union(gated_repository.spec, {"acceptance": [{"name": "live", "command": ["bash", "accept.sh"], "gate": true, "timeoutSeconds": 60}]})})
	head := tree({"demo": base_context}, narrowed)
	"change_impact/impact-narrows-acceptance-timeout" in ids_for(valid_base, head, null, null)
}

test_removes_interface if {
	base := object.union(valid_base, {"contexts": {"demo": object.union(base_context, {
		"spec": object.union(base_context.spec, {"interfaces": [{"name": "Watch", "kind": "function", "signature": "() error", "file": "internal/watch.go"}]}),
	})}})
	ids := ids_for(base, valid_head, null, null)
	"change_impact/impact-removes-interface" in ids
}

test_requirement_removed_but_code_unchanged if {
	head := with_requirements(valid_head, [other_requirement])
	diff := {"paths": ["deploy/other.yaml"], "files": []}
	"change_impact/impact-requirement-removed-but-code-unchanged" in ids_for(valid_base, head, null, diff)
}

test_metadata_entries_are_complete if {
	some violation, meta in policy.metadata
	count(object.keys(meta)) == 3
	meta.severity in {"error", "warning", "info"}
	meta.level in {"MUST", "SHOULD", "MAY"}
	is_string(meta.title)
	startswith(violation, "impact-")
}
