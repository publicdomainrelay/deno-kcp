package deno_kcp.policies.spec_references_test

import rego.v1

import data.deno_kcp.policies.spec_references as policy

demo_intent := "This context exists so the provider writes the facts it observed for every workspace it watches, so that drift between the declared spec and the running code is decided from those facts rather than from a reread of the tree."

demo_codegraph_id := "e23b6c675e266e96e349726b82e81264"

demo_requirement := {
	"id": "r.reconcile-writes-facts",
	"level": "MUST",
	"text": "The provider writes the observed fingerprint of every workspace it watches after each reconcile, so drift is decided from the facts the last reconcile observed.",
	"codeRefs": ["file:internal/provider/watch.go", "struct:e23b6c675e266e96e349726b82e81264"],
}

demo_interface := {"file": "internal/provider/watch.go", "kind": "struct", "name": "Watcher", "signature": "struct{}"}

demo_spec_body := {
	"intent": demo_intent,
	"repository": "deno-kcp",
	"upstream": "self",
	"requirements": [demo_requirement],
	"interfaces": [demo_interface],
}

demo_observed := {
	"files": ["internal/provider/watch.go"],
	"interfaces": [{"name": "Watcher", "kind": "struct", "signature": "struct{}", "file": "internal/provider/watch.go", "codegraphId": "struct:e23b6c675e266e96e349726b82e81264"}],
	"fingerprint": "aa11",
}

demo_status := {
	"conditions": [{"type": "CodeSynced", "status": "True", "reason": "InterfacesObserved", "message": "every declared interface is observed"}],
	"observed": demo_observed,
	"realizedSpecHash": "dad5f9ab3f04080c9fccf5a7d469fead020624d83e77b1933e346156c9ff2e85",
}

demo_context(spec_body, status) := {
	"name": "demo",
	"spec_path": "specs/demo.yaml",
	"status_path": "status/demo.yaml",
	"context_doc_path": "context/demo.md",
	"document": {"apiVersion": "specs.publicdomainrelay.dev/v1alpha1", "kind": "SystemContext", "metadata": {"name": "demo", "namespace": "default"}, "spec": spec_body},
	"metadata": {"name": "demo", "namespace": "default"},
	"spec": spec_body,
	"status": status,
	"context_doc": {"path": "context/demo.md", "text": "# Context: demo\n", "headings": [], "sha256": "bb"},
	"changes": {},
}

demo_file := {"path": "internal/provider/watch.go", "kind": "go", "size": 10, "sha256": "cc", "present": true}

tree(contexts) := {
	"root": "/tmp/tree",
	"ref": null,
	"repository": {"spec": {"branch": "spec/demo"}, "status": {"phase": "Populated"}},
	"arch": {"system_contexts": []},
	"contexts": contexts,
	"changes": {},
	"graph": {"vertices": [], "edges": []},
	"files": {"internal/provider/watch.go": demo_file},
	"texts": {},
	"observed_files": ["internal/provider/watch.go"],
	"context_names": ["demo"],
}

inputs(contexts) := {"spec_tree": tree(contexts), "change": null, "diff": null, "options": {"scope": "own"}}

inputs_with_files(contexts, files) := {"spec_tree": object.union(tree(contexts), {"files": files}), "change": null, "diff": null, "options": {"scope": "own"}}

ids(violations) := {v.id | some v in violations}

with_requirement_refs(refs) := inputs({"demo": demo_context(object.union(demo_spec_body, {"requirements": [object.union(demo_requirement, {"codeRefs": refs})]}), demo_status)})

with_interfaces(ifaces) := inputs({"demo": demo_context(object.union(demo_spec_body, {"interfaces": ifaces}), demo_status)})

test_valid_tree_raises_nothing if {
	violations := policy.violations with input as inputs({"demo": demo_context(demo_spec_body, demo_status)})
	count(violations) == 0
}

test_code_ref_malformed if {
	result := policy.violations with input as with_requirement_refs(["not-a-ref"])
	"spec_references/code-ref-malformed" in ids(result)
}

test_code_ref_unknown_kind if {
	result := policy.violations with input as with_requirement_refs(["banana:xyz"])
	"spec_references/code-ref-unknown-kind" in ids(result)
}

test_code_ref_empty_payload if {
	result := policy.violations with input as with_requirement_refs(["file:"])
	"spec_references/code-ref-empty-payload" in ids(result)
}

test_code_ref_whitespace_in_payload if {
	result := policy.violations with input as with_requirement_refs(["function:Two Words"])
	"spec_references/code-ref-whitespace-in-payload" in ids(result)
}

test_code_ref_duplicate_in_requirement if {
	result := policy.violations with input as with_requirement_refs(["file:internal/provider/watch.go", "file:internal/provider/watch.go"])
	"spec_references/code-ref-duplicate-in-requirement" in ids(result)
}

test_code_ref_duplicate_in_context if {
	body := object.union(demo_spec_body, {"codeRefs": ["file:internal/provider/watch.go", "file:internal/provider/watch.go"]})
	result := policy.violations with input as inputs({"demo": demo_context(body, demo_status)})
	"spec_references/code-ref-duplicate-in-context" in ids(result)
}

test_code_ref_path_absolute if {
	result := policy.violations with input as with_requirement_refs(["file:/etc/passwd"])
	"spec_references/code-ref-path-absolute" in ids(result)
}

test_code_ref_path_escaping if {
	result := policy.violations with input as with_requirement_refs(["file:../outside.go"])
	"spec_references/code-ref-path-escaping" in ids(result)
}

test_code_ref_path_not_repo_relative if {
	result := policy.violations with input as with_requirement_refs(["file:internal\\provider\\watch.go"])
	"spec_references/code-ref-path-not-repo-relative" in ids(result)
}

test_code_ref_file_missing if {
	result := policy.violations with input as with_requirement_refs(["file:internal/provider/gone.go"])
	"spec_references/code-ref-file-missing" in ids(result)
}

test_code_ref_file_not_observed if {
	other := {"path": "internal/provider/other.go", "kind": "go", "size": 3, "sha256": "dd", "present": true}
	contexts := {"demo": demo_context(object.union(demo_spec_body, {"requirements": [object.union(demo_requirement, {"codeRefs": ["file:internal/provider/other.go"]})]}), demo_status)}
	result := policy.violations with input as inputs_with_files(contexts, {"internal/provider/watch.go": demo_file, "internal/provider/other.go": other})
	"spec_references/code-ref-file-not-observed" in ids(result)
}

test_code_ref_symbol_unobserved if {
	result := policy.violations with input as with_requirement_refs(["struct:deadbeefdeadbeefdeadbeefdeadbeef"])
	"spec_references/code-ref-symbol-unobserved" in ids(result)
}

test_interface_file_missing_on_disk if {
	bad := {"file": "internal/provider/nope.go", "kind": "struct", "name": "Nope", "signature": "struct{}"}
	result := policy.violations with input as with_interfaces([demo_interface, bad])
	"spec_references/interface-file-missing-on-disk" in ids(result)
}

test_interface_file_not_observed if {
	other := {"path": "internal/provider/other.go", "kind": "go", "size": 3, "sha256": "dd", "present": true}
	bad := {"file": "internal/provider/other.go", "kind": "struct", "name": "Other", "signature": "struct{}"}
	contexts := {"demo": demo_context(object.union(demo_spec_body, {"interfaces": [demo_interface, bad]}), demo_status)}
	result := policy.violations with input as inputs_with_files(contexts, {"internal/provider/watch.go": demo_file, "internal/provider/other.go": other})
	"spec_references/interface-file-not-observed" in ids(result)
}

test_interface_not_observed if {
	bad := {"file": "internal/provider/watch.go", "kind": "struct", "name": "Absent", "signature": "struct{}"}
	result := policy.violations with input as with_interfaces([demo_interface, bad])
	"spec_references/interface-not-observed" in ids(result)
}

test_observed_interface_undeclared if {
	status := object.union(demo_status, {"observed": object.union(demo_observed, {"interfaces": array.concat(demo_observed.interfaces, [{"name": "Stray", "kind": "function", "signature": "()", "file": "internal/provider/watch.go", "codegraphId": "function:11111111111111111111111111111111"}])})})
	result := policy.violations with input as inputs({"demo": demo_context(demo_spec_body, status)})
	"spec_references/observed-interface-undeclared" in ids(result)
}

test_status_code_synced_false if {
	status := object.union(demo_status, {"conditions": [{"type": "CodeSynced", "status": "False", "reason": "InterfacesMissing", "message": "missing interfaces"}]})
	changes := {"demo-c2s-25d10f922ec7-25d10f922ec7": {"document": {"spec": {"systemContext": "demo", "direction": "CodeToSpec"}, "status": {"phase": "Succeeded"}}}}
	t := object.union(tree({"demo": demo_context(demo_spec_body, status)}), {"changes": changes})
	result := policy.violations with input as {"spec_tree": t, "options": {"scope": "own"}}
	"spec_references/status-code-synced-false" in ids(result)
}

test_context_reference_unknown if {
	body := object.union(demo_spec_body, {"overlay": ["sc.ghost"]})
	result := policy.violations with input as inputs({"demo": demo_context(body, demo_status)})
	"spec_references/context-reference-unknown" in ids(result)
}

test_metadata_names_every_violation_the_policy_can_raise if {
	some id, meta in policy.metadata
	count(object.keys(meta)) == 3
	meta.severity in {"error", "warning", "info"}
	meta.level in {"MUST", "SHOULD", "MAY"}
	is_string(meta.title)
	startswith(id, "")
}
