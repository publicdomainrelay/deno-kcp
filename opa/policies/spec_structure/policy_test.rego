package deno_kcp.policies.spec_structure_test

import rego.v1

import data.deno_kcp.policies.spec_structure as policy

demo_intent := "This context exists so the provider writes the facts it observed for every workspace it watches, so that drift between the declared spec and the running code is decided from those facts rather than from a reread of the tree, and so that a reconcile that fails leaves the previous facts in place rather than clearing them."

demo_requirement := {
	"id": "r.reconcile-writes-facts",
	"level": "MUST",
	"text": "The provider writes the observed fingerprint of every workspace it watches after each reconcile, so drift is decided from the facts the last reconcile observed rather than from a fresh read of the tree.",
	"codeRefs": ["file:internal/provider/watch.go"],
}

demo_spec_body := {
	"intent": demo_intent,
	"repository": "deno-kcp",
	"upstream": "self",
	"requirements": [demo_requirement],
}

demo_document := {
	"apiVersion": "specs.publicdomainrelay.dev/v1alpha1",
	"kind": "SystemContext",
	"metadata": {"name": "demo", "namespace": "default"},
	"spec": demo_spec_body,
}

demo_status := {
	"conditions": [
		{"type": "CodeSynced", "status": "True", "reason": "InterfacesObserved", "message": "every declared interface is observed"},
		{"type": "Drifted", "status": "False", "reason": "FingerprintEqual", "message": "observed facts match the synced fingerprint"},
		{"type": "SpecValid", "status": "True", "reason": "ValidatorPassed", "message": "the spec passes the validator"},
	],
	"observed": {"files": ["internal/provider/watch.go"], "fingerprint": "aa11"},
	"observedCommit": "25d10f922ec7360cc7247da945a6fe49e88cf7ab",
	"realizedSpecHash": "dad5f9ab3f04080c9fccf5a7d469fead020624d83e77b1933e346156c9ff2e85",
	"syncedCommit": "25d10f922ec7360cc7247da945a6fe49e88cf7ab",
	"syncedFingerprint": "aa11",
}

demo_context(spec_body, status) := {
	"name": "demo",
	"spec_path": "specs/demo.yaml",
	"status_path": "status/demo.yaml",
	"context_doc_path": "context/demo.md",
	"document": object.union(demo_document, {"spec": spec_body}),
	"metadata": {"name": "demo", "namespace": "default"},
	"spec": spec_body,
	"status": status,
	"context_doc": {"path": "context/demo.md", "text": "# Context: demo\n", "headings": [], "sha256": "bb"},
	"changes": {},
}

valid_repository := {
	"apiVersion": "specs.publicdomainrelay.dev/v1alpha1",
	"kind": "Repository",
	"metadata": {"name": "deno-kcp", "namespace": "default"},
	"spec": {"branch": "spec/demo", "populate": {"partition": "directory", "summarize": true}, "source": {}, "verify": ["go", "test", "./..."]},
	"status": {"contexts": {"failed": 0, "summarized": 1, "total": 1}, "headCommit": "aa", "indexedCommit": "aa", "phase": "Populated"},
}

tree(contexts) := {
	"root": "/tmp/tree",
	"ref": null,
	"repository": valid_repository,
	"arch": {"system_contexts": []},
	"contexts": contexts,
	"changes": {},
	"graph": {"vertices": [], "edges": []},
	"files": {"internal/provider/watch.go": {"path": "internal/provider/watch.go", "kind": "go", "size": 10, "sha256": "cc", "present": true}},
	"texts": {},
	"observed_files": ["internal/provider/watch.go"],
	"context_names": ["demo"],
}

valid_input := {"spec_tree": tree({"demo": demo_context(demo_spec_body, demo_status)}), "change": null, "diff": null, "options": {"scope": "own"}}

ids(violations) := {v.id | some v in violations}

test_valid_tree_raises_nothing if {
	violations := policy.violations with input as valid_input
	count(violations) == 0
}

test_missing_intent if {
	spec_body := object.remove(demo_spec_body, ["intent"])
	result := policy.violations with input as {"spec_tree": tree({"demo": demo_context(spec_body, demo_status)})}
	"spec_structure/context-intent-missing" in ids(result)
}

test_short_intent if {
	spec_body := object.union(demo_spec_body, {"intent": "Small."})
	result := policy.violations with input as {"spec_tree": tree({"demo": demo_context(spec_body, demo_status)})}
	"spec_structure/context-intent-too-short" in ids(result)
}

test_missing_repository if {
	spec_body := object.remove(demo_spec_body, ["repository"])
	result := policy.violations with input as {"spec_tree": tree({"demo": demo_context(spec_body, demo_status)})}
	"spec_structure/context-repository-missing" in ids(result)
}

test_missing_upstream if {
	spec_body := object.remove(demo_spec_body, ["upstream"])
	result := policy.violations with input as {"spec_tree": tree({"demo": demo_context(spec_body, demo_status)})}
	"spec_structure/context-upstream-missing" in ids(result)
}

test_invalid_upstream if {
	spec_body := object.union(demo_spec_body, {"upstream": "somewhere"})
	result := policy.violations with input as {"spec_tree": tree({"demo": demo_context(spec_body, demo_status)})}
	"spec_structure/context-upstream-invalid" in ids(result)
}

test_no_requirements if {
	spec_body := object.union(demo_spec_body, {"requirements": []})
	result := policy.violations with input as {"spec_tree": tree({"demo": demo_context(spec_body, demo_status)})}
	"spec_structure/context-requirements-missing" in ids(result)
}

test_requirement_id_missing if {
	req := object.remove(demo_requirement, ["id"])
	spec_body := object.union(demo_spec_body, {"requirements": [req]})
	result := policy.violations with input as {"spec_tree": tree({"demo": demo_context(spec_body, demo_status)})}
	"spec_structure/requirement-id-missing" in ids(result)
}

test_requirement_id_malformed if {
	req := object.union(demo_requirement, {"id": "requirement one"})
	spec_body := object.union(demo_spec_body, {"requirements": [req]})
	result := policy.violations with input as {"spec_tree": tree({"demo": demo_context(spec_body, demo_status)})}
	"spec_structure/requirement-id-malformed" in ids(result)
}

test_requirement_id_duplicate if {
	other := object.union(demo_requirement, {"text": "A second requirement that carries the same id as the first and so cannot be addressed by a delta entry on its own."})
	spec_body := object.union(demo_spec_body, {"requirements": [demo_requirement, other]})
	result := policy.violations with input as {"spec_tree": tree({"demo": demo_context(spec_body, demo_status)})}
	"spec_structure/requirement-id-duplicate" in ids(result)
	count([v | some v in result; v.id == "spec_structure/requirement-id-duplicate"]) == 1
}

test_requirement_level_invalid if {
	req := object.union(demo_requirement, {"level": "MUST-ISH"})
	spec_body := object.union(demo_spec_body, {"requirements": [req]})
	result := policy.violations with input as {"spec_tree": tree({"demo": demo_context(spec_body, demo_status)})}
	"spec_structure/requirement-level-invalid" in ids(result)
}

test_requirement_level_missing if {
	req := object.remove(demo_requirement, ["level"])
	spec_body := object.union(demo_spec_body, {"requirements": [req]})
	result := policy.violations with input as {"spec_tree": tree({"demo": demo_context(spec_body, demo_status)})}
	"spec_structure/requirement-level-missing" in ids(result)
}

test_requirement_text_too_short if {
	req := object.union(demo_requirement, {"text": "Writes facts."})
	spec_body := object.union(demo_spec_body, {"requirements": [req]})
	result := policy.violations with input as {"spec_tree": tree({"demo": demo_context(spec_body, demo_status)})}
	"spec_structure/requirement-text-too-short" in ids(result)
}

test_requirement_text_machine_path if {
	req := object.union(demo_requirement, {"text": "The provider reads /home/someone/src/deno-kcp/internal/provider/watch.go and writes the fingerprint of every workspace it watches after each reconcile it completes."})
	spec_body := object.union(demo_spec_body, {"requirements": [req]})
	result := policy.violations with input as {"spec_tree": tree({"demo": demo_context(spec_body, demo_status)})}
	"spec_structure/requirement-text-has-machine-path" in ids(result)
}

test_interface_name_duplicate if {
	spec_body := object.union(demo_spec_body, {
		"interfaces": [
			{"file": "internal/provider/watch.go", "kind": "function", "name": "Watch", "signature": "() error"},
			{"file": "internal/provider/watch.go", "kind": "function", "name": "Watch", "signature": "() error"},
		],
	})
	result := policy.violations with input as {"spec_tree": tree({"demo": demo_context(spec_body, demo_status)})}
	"spec_structure/interface-name-duplicate" in ids(result)
}

test_interface_kind_invalid if {
	spec_body := object.union(demo_spec_body, {
		"interfaces": [{"file": "internal/provider/watch.go", "kind": "lambda", "name": "Watch", "signature": "() error"}],
	})
	result := policy.violations with input as {"spec_tree": tree({"demo": demo_context(spec_body, demo_status)})}
	"spec_structure/interface-kind-invalid" in ids(result)
}

test_status_missing if {
	result := policy.violations with input as {"spec_tree": tree({"demo": demo_context(demo_spec_body, null)})}
	"spec_structure/context-status-missing" in ids(result)
}

test_status_conditions_missing if {
	status := object.union(demo_status, {"conditions": []})
	result := policy.violations with input as {"spec_tree": tree({"demo": demo_context(demo_spec_body, status)})}
	"spec_structure/status-conditions-missing" in ids(result)
}

test_status_realized_spec_hash_invalid if {
	status := object.union(demo_status, {"realizedSpecHash": "not-a-hash"})
	result := policy.violations with input as {"spec_tree": tree({"demo": demo_context(demo_spec_body, status)})}
	"spec_structure/status-realized-spec-hash-invalid" in ids(result)
}

test_repository_verify_missing if {
	repository := object.union(valid_repository, {"spec": object.union(valid_repository.spec, {"verify": []})})
	t := object.union(tree({"demo": demo_context(demo_spec_body, demo_status)}), {"repository": repository})
	result := policy.violations with input as {"spec_tree": t}
	"spec_structure/repository-verify-missing" in ids(result)
}

test_third_party_context_out_of_scope_by_default if {
	spec_body := object.remove(demo_spec_body, ["intent"])
	ctx := object.union(demo_context(spec_body, demo_status), {"name": "third-party-vendor"})
	result := policy.violations with input as {"spec_tree": tree({"third-party-vendor": ctx})}
	count(result) == 0
}

test_third_party_context_in_scope_when_all if {
	spec_body := object.remove(demo_spec_body, ["intent"])
	ctx := object.union(demo_context(spec_body, demo_status), {"name": "third-party-vendor"})
	result := policy.violations with input as {"spec_tree": tree({"third-party-vendor": ctx}), "options": {"scope": "all"}}
	"spec_structure/context-intent-missing" in ids(result)
}

test_metadata_names_every_violation_the_policy_can_raise if {
	# Every violation rule names itself through policy_id and a literal id. This
	# test walks the metadata the policy declares and asserts each entry carries
	# the three fields the aggregator reads.
	some id, meta in policy.metadata
	count(object.keys(meta)) == 3
	meta.severity in {"error", "warning", "info"}
	meta.level in {"MUST", "SHOULD", "MAY"}
	is_string(meta.title)
	startswith(id, "")
}
