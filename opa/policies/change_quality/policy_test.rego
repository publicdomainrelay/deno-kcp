package deno_kcp.policies.change_quality_test

import rego.v1

import data.deno_kcp.policies.change_quality as policy

demo_intent := "This context exists so drift between the declared spec and the running code is decided from the facts the last reconcile observed, and so a failed reconcile leaves the previous facts in place."

demo_requirement := {
	"id": "r.reconcile-writes-facts",
	"level": "MUST",
	"text": "After each reconcile the provider writes the observed fingerprint of every workspace it watches, so drift is decided from the facts that reconcile observed rather than from a fresh read of the tree.",
	"codeRefs": ["file:internal/provider/watch.go"],
}

demo_interface := {
	"name": "Watch",
	"kind": "function",
	"signature": "() error",
	"file": "internal/provider/watch.go",
}

demo_spec := {
	"intent": demo_intent,
	"repository": "deno-kcp",
	"upstream": "self",
	"requirements": [demo_requirement],
	"interfaces": [demo_interface],
	"codeRefs": [],
}

demo_document := {
	"apiVersion": "specs.publicdomainrelay.dev/v1alpha1",
	"kind": "SystemContext",
	"metadata": {"name": "demo", "namespace": "default"},
	"spec": demo_spec,
}

demo_status := {
	"conditions": [{"type": "CodeSynced", "status": "True", "reason": "InterfacesObserved", "message": "every declared interface is observed"}],
	"observed": {"files": ["internal/provider/watch.go"], "fingerprint": "aa11"},
}

demo_context(spec, status) := {
	"name": "demo",
	"spec_path": "specs/demo.yaml",
	"status_path": "status/demo.yaml",
	"context_doc_path": "context/demo.md",
	"document": object.union(demo_document, {"spec": spec}),
	"metadata": {"name": "demo", "namespace": "default"},
	"spec": spec,
	"status": status,
	"context_doc": {"path": "context/demo.md", "text": "# Context: demo\n", "headings": [], "sha256": "bb"},
	"changes": {},
}

valid_repository := {
	"apiVersion": "specs.publicdomainrelay.dev/v1alpha1",
	"kind": "Repository",
	"metadata": {"name": "deno-kcp", "namespace": "default"},
	"spec": {"branch": "spec/demo", "populate": {"partition": "directory", "summarize": true}, "source": {}, "verify": ["go", "test", "./..."], "acceptance": []},
	"status": {"contexts": {"failed": 0, "summarized": 1, "total": 1}, "headCommit": "aa", "indexedCommit": "aa", "phase": "Populated"},
}

tree(contexts, changes) := {
	"root": "/tmp/tree",
	"ref": null,
	"repository": valid_repository,
	"arch": {"system_contexts": []},
	"contexts": contexts,
	"changes": changes,
	"graph": {"vertices": [], "edges": []},
	"files": {},
	"texts": {},
	"observed_files": [],
	"context_names": ["demo"],
}

with_spec(spec) := {"spec_tree": tree({"demo": demo_context(spec, demo_status)}, {}), "change": null, "diff": null, "options": {"scope": "own"}}

with_changes(changes) := {"spec_tree": tree({"demo": demo_context(demo_spec, demo_status)}, changes), "change": null, "diff": null, "options": {"scope": "own"}}

valid_input := with_spec(demo_spec)

change_of(spec, status) := {
	"name": "demo-s2c-0123456789ab",
	"path": "changes/demo-s2c-0123456789ab.yaml",
	"system_context": "demo",
	"direction": "SpecToCode",
	"document": {
		"apiVersion": "specs.publicdomainrelay.dev/v1alpha1",
		"kind": "SpecChange",
		"metadata": {"name": "demo-s2c-0123456789ab", "namespace": "default"},
		"spec": spec,
		"status": status,
	},
}

ids(violations) := {v.id | some v in violations}

test_valid_tree_raises_nothing if {
	violations := policy.violations with input as valid_input
	count(violations) == 0
}

test_level_text_disagreement if {
	spec := object.union(demo_spec, {"requirements": [object.union(demo_requirement, {"level": "MAY", "text": "The provider must write the observed fingerprint of every workspace it watches after each reconcile it completes."})]})
	result := policy.violations with input as with_spec(spec)
	"change_quality/quality-level-text-disagreement" in ids(result)
}

test_vague_term if {
	spec := object.union(demo_spec, {"requirements": [object.union(demo_requirement, {"text": "The provider is robust and writes the observed fingerprint of every workspace it watches after each reconcile it completes."})]})
	result := policy.violations with input as with_spec(spec)
	"change_quality/quality-vague-term" in ids(result)
}

test_non_normative_phrase if {
	spec := object.union(demo_spec, {"requirements": [object.union(demo_requirement, {"level": "SHOULD", "text": "The provider should consider writing the observed fingerprint of every workspace it watches after each reconcile it completes."})]})
	result := policy.violations with input as with_spec(spec)
	"change_quality/quality-non-normative-phrase" in ids(result)
}

test_placeholder if {
	spec := object.union(demo_spec, {"requirements": [object.union(demo_requirement, {"text": "The provider writes the observed fingerprint of every workspace it watches after each reconcile TODO."})]})
	result := policy.violations with input as with_spec(spec)
	"change_quality/quality-placeholder" in ids(result)
}

test_not_a_sentence if {
	spec := object.union(demo_spec, {"requirements": [object.union(demo_requirement, {"text": "writes the observed fingerprint of every workspace it watches after each reconcile"})]})
	result := policy.violations with input as with_spec(spec)
	"change_quality/quality-not-a-sentence" in ids(result)
}

test_many_sentences if {
	spec := object.union(demo_spec, {"requirements": [object.union(demo_requirement, {"text": "The provider writes the fingerprint. It watches every workspace. It observes the facts. It decides drift. It leaves the previous facts in place. It reports the result."})]})
	result := policy.violations with input as with_spec(spec)
	"change_quality/quality-many-sentences" in ids(result)
}

test_echoes_identifier if {
	spec := object.union(demo_spec, {"requirements": [object.union(demo_requirement, {"id": "r.policy-workflow-run-kind", "text": "The policy workflow run kind writes the observed fingerprint of every workspace it watches after each reconcile it completes."})]})
	result := policy.violations with input as with_spec(spec)
	"change_quality/quality-echoes-identifier" in ids(result)
}

test_enumerates_without_structure if {
	spec := object.union(demo_spec, {"requirements": [object.union(demo_requirement, {"text": "Get, List, Watch, Create, Update, Delete"})]})
	result := policy.violations with input as with_spec(spec)
	"change_quality/quality-enumerates-without-structure" in ids(result)
}

test_interface_signature_not_a_signature if {
	spec := object.union(demo_spec, {"interfaces": [object.union(demo_interface, {"kind": "struct", "signature": "no parameter list at all"})]})
	result := policy.violations with input as with_spec(spec)
	"change_quality/quality-interface-signature-not-a-signature" in ids(result)
}

test_interface_signature_missing if {
	spec := object.union(demo_spec, {"interfaces": [object.remove(demo_interface, ["signature"])]})
	result := policy.violations with input as with_spec(spec)
	"change_quality/quality-interface-signature-missing" in ids(result)
}

test_intent_restates_a_requirement if {
	spec := object.union(demo_spec, {"intent": demo_requirement.text})
	result := policy.violations with input as with_spec(spec)
	"change_quality/quality-intent-restates-a-requirement" in ids(result)
}

test_requirement_not_observable if {
	body := "The intent of each context and the requirements it governs."
	spec := object.union(demo_spec, {"requirements": [object.union(demo_requirement, {"text": body})]})
	result := policy.violations with input as with_spec(spec)
	"change_quality/quality-requirement-not-observable" in ids(result)
}

test_change_message_names_no_context if {
	change := change_of({"systemContext": "demo"}, {"phase": "Succeeded", "message": "realized the context on its branch", "agentLog": "ran"})
	result := policy.violations with input as with_changes({"demo-s2c-0123456789ab": change})
	"change_quality/quality-change-message-names-no-context" in ids(result)
}

test_agent_log_empty if {
	change := change_of({"systemContext": "demo"}, {"phase": "Succeeded", "message": "realized demo", "agentLog": ""})
	result := policy.violations with input as with_changes({"demo-s2c-0123456789ab": change})
	"change_quality/quality-agent-log-empty" in ids(result)
}

test_delta_text_change_adds_nothing if {
	entry := {"op": "changed", "id": "r.live-check", "fields": ["text"], "from": {"id": "r.live-check", "level": "MUST", "text": "The check fetches the health endpoint and fails unless it answers."}, "to": {"id": "r.live-check", "level": "MUST", "text": "The check fetches the health endpoint, and fails unless it answers"}}
	change := change_of({"systemContext": "demo", "delta": {"requirements": [entry]}}, {"phase": "Succeeded", "message": "realized demo", "agentLog": "ran"})
	result := policy.violations with input as with_changes({"demo-s2c-0123456789ab": change})
	"change_quality/quality-delta-text-change-adds-nothing" in ids(result)
}

test_metadata_names_every_violation_the_policy_can_raise if {
	some id, meta in policy.metadata
	count(object.keys(meta)) == 3
	meta.severity in {"error", "warning", "info"}
	meta.level in {"MUST", "SHOULD", "MAY"}
	is_string(meta.title)
	startswith(id, "")
}
