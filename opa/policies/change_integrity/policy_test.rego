package deno_kcp.policies.change_integrity_test

import rego.v1

import data.deno_kcp.policies.change_integrity as policy

to_hash := "834078074eaa9fd7e9914fd2e2849b0c6aed8421541e51a79acb09c81c6a11f8"

from_hash := "48cbbf77ef57ffb1d6c4461b92df1dcbea6828e6e742494ca432cd5f17716c22"

commit := "6c1bbe4c3ba95ce6f9d4c78dead4b6c359358c8d"

from_requirement := {
	"id": "r.the-thing",
	"level": "MUST",
	"text": "The provider writes the observed fingerprint of every workspace it watches after each reconcile completes, so drift is decided from those facts.",
	"codeRefs": ["file:internal/provider/watch.go"],
}

to_requirement := object.union(from_requirement, {
	"text": "The provider writes the observed fingerprint of every workspace it watches after each reconcile completes, so drift is decided from those facts and never from a fresh read of the tree.",
})

valid_delta := {"requirements": [{"op": "changed", "id": "r.the-thing", "fields": ["text"], "from": from_requirement, "to": to_requirement}]}

valid_change := {
	"name": "demo-s2c-834078074eaa",
	"path": "changes/demo-s2c-834078074eaa.yaml",
	"system_context": "demo",
	"direction": "SpecToCode",
	"document": {
		"apiVersion": "specs.publicdomainrelay.dev/v1alpha1",
		"kind": "SpecChange",
		"metadata": {"name": "demo-s2c-834078074eaa", "namespace": "default"},
		"spec": {
			"systemContext": "demo",
			"direction": "SpecToCode",
			"fromSpecHash": from_hash,
			"toSpecHash": to_hash,
			"delta": valid_delta,
		},
		"status": {
			"phase": "Succeeded",
			"branch": "spec/demo/83407807",
			"commit": commit,
			"verifyExitCode": 0,
			"filesTouched": ["internal/provider/watch.go"],
			"message": "realized demo on spec/demo/83407807",
			"agentLog": "edited the watcher and ran the verify vector",
			"acceptance": [{"name": "gate", "passed": true, "exitCode": 0, "durationSeconds": 1.5}],
			"progress": [{"at": "2026-01-01T00:00:00Z", "tool": "Edit", "files": ["internal/provider/watch.go"]}],
		},
	},
}

demo_spec_body := {
	"intent": "This context exists so the provider writes the facts it observed for every workspace it watches, so that drift between the declared spec and the running code is decided from those facts rather than from a reread of the tree, and so that a reconcile that fails leaves the previous facts in place rather than clearing them.",
	"repository": "deno-kcp",
	"upstream": "self",
	"requirements": [to_requirement],
}

demo_status := {
	"conditions": [{"type": "CodeSynced", "status": "True", "reason": "InterfacesObserved", "message": "ok"}],
	"observed": {"files": ["internal/provider/watch.go"], "fingerprint": "aa11"},
	"observedCommit": commit,
	"realizedSpecHash": to_hash,
	"syncedCommit": commit,
	"syncedFingerprint": "aa11",
}

tree := {
	"root": "/tmp/tree",
	"repository": {"kind": "Repository", "spec": {"branch": "spec/demo", "verify": ["go", "test", "./..."]}},
	"arch": {"system_contexts": []},
	"contexts": {"demo": {
		"name": "demo",
		"spec_path": "specs/demo.yaml",
		"status_path": "status/demo.yaml",
		"context_doc_path": "context/demo.md",
		"document": {"apiVersion": "specs.publicdomainrelay.dev/v1alpha1", "kind": "SystemContext", "metadata": {"name": "demo", "namespace": "default"}, "spec": demo_spec_body},
		"metadata": {"name": "demo", "namespace": "default"},
		"spec": demo_spec_body,
		"status": demo_status,
		"context_doc": {"path": "context/demo.md", "text": "# Context: demo\n", "headings": []},
		"changes": {},
	}},
	"changes": {},
	"graph": {"vertices": [{"id": 1, "label": "SpecContext", "name": "demo", "scope": "", "repo": "deno-kcp", "specHash": to_hash, "intent": "x"}], "edges": []},
	"files": {"internal/provider/watch.go": {"path": "internal/provider/watch.go", "kind": "go", "size": 1, "sha256": "cc", "present": true}},
	"texts": {},
	"observed_files": ["internal/provider/watch.go"],
	"context_names": ["demo"],
}

document(change) := {"spec_tree": tree, "change": change, "diff": null, "options": {"scope": "own"}}

ids_for(change) := ids if {
	found := policy.violations with input as document(change)
	ids := {v.id | some v in found}
}

with_spec(change, patch) := out if {
	out := object.union(change, {"document": object.union(change.document, {"spec": object.union(change.document.spec, patch)})})
}

with_status(change, patch) := out if {
	out := object.union(change, {"document": object.union(change.document, {"status": object.union(change.document.status, patch)})})
}

test_valid_change_raises_nothing if {
	count(ids_for(valid_change)) == 0
}

test_no_change_raises_nothing if {
	count(ids_for(null)) == 0
}

test_name_malformed if "change_integrity/change-name-malformed" in ids_for(object.union(valid_change, {"name": "not a change name"}))

test_name_context_mismatch if "change_integrity/change-name-context-mismatch" in ids_for(object.union(valid_change, {"name": "other-s2c-834078074eaa"}))

test_metadata_missing if {
	change := object.union(valid_change, {"document": object.union(valid_change.document, {"metadata": {"name": null}})})
	"change_integrity/change-metadata-missing" in ids_for(change)
}

test_system_context_missing if {
	change := with_spec(valid_change, {"systemContext": null})
	"change_integrity/change-system-context-missing" in ids_for(change)
}

test_system_context_unknown if {
	change := with_spec(valid_change, {"systemContext": "somewhere-else"})
	"change_integrity/change-system-context-unknown" in ids_for(change)
}

test_direction_missing if {
	change := with_spec(valid_change, {"direction": null})
	"change_integrity/change-direction-missing" in ids_for(change)
}

test_direction_invalid if {
	change := with_spec(valid_change, {"direction": "Sideways"})
	"change_integrity/change-direction-invalid" in ids_for(change)
}

test_phase_missing if {
	change := with_status(valid_change, {"phase": null})
	"change_integrity/change-phase-missing" in ids_for(change)
}

test_phase_invalid if {
	change := with_status(valid_change, {"phase": "Nearly"})
	"change_integrity/change-phase-invalid" in ids_for(change)
}

test_hash_missing if {
	change := with_spec(valid_change, {"toSpecHash": null})
	"change_integrity/change-hash-missing" in ids_for(change)
}

test_hash_invalid if {
	change := with_spec(valid_change, {"toSpecHash": "not-a-hash"})
	"change_integrity/change-hash-invalid" in ids_for(change)
}

test_from_hash_invalid if {
	change := with_spec(valid_change, {"fromSpecHash": "nope"})
	"change_integrity/change-from-hash-invalid" in ids_for(change)
}

test_to_hash_equals_from_hash if {
	change := with_spec(valid_change, {"fromSpecHash": to_hash})
	"change_integrity/change-to-hash-equals-from-hash" in ids_for(change)
}

test_to_spec_hash_not_in_tree if {
	change := with_spec(valid_change, {"toSpecHash": from_hash, "fromSpecHash": to_hash})
	"change_integrity/change-to-spec-hash-not-in-tree" in ids_for(change)
}

test_code_to_spec_commits_unpaired if {
	change := with_spec(with_status(valid_change, {}), {"direction": "CodeToSpec", "fromCommit": "", "toCommit": commit})
	"change_integrity/change-code-to-spec-commits-unpaired" in ids_for(change)
}

test_commits_equal if {
	change := with_spec(valid_change, {"direction": "CodeToSpec", "fromCommit": commit, "toCommit": commit})
	"change_integrity/change-commits-equal" in ids_for(change)
}

test_commit_invalid if {
	change := with_spec(valid_change, {"direction": "CodeToSpec", "fromCommit": commit, "toCommit": "HEAD"})
	"change_integrity/change-commit-invalid" in ids_for(change)
}

test_delta_op_invalid if {
	change := with_spec(valid_change, {"delta": {"requirements": [{"op": "modified", "id": "r.x", "from": from_requirement, "to": to_requirement}]}})
	"change_integrity/change-delta-op-invalid" in ids_for(change)
}

test_delta_entry_missing_op if {
	change := with_spec(valid_change, {"delta": {"requirements": [{"id": "r.x", "from": from_requirement, "to": to_requirement}]}})
	"change_integrity/change-delta-entry-missing-op" in ids_for(change)
}

test_delta_entry_missing_id if {
	change := with_spec(valid_change, {"delta": {"requirements": [{"op": "changed", "from": from_requirement, "to": to_requirement}]}})
	"change_integrity/change-delta-entry-missing-id" in ids_for(change)
}

test_delta_changed_needs_both_sides if {
	change := with_spec(valid_change, {"delta": {"requirements": [{"op": "changed", "id": "r.x", "to": to_requirement}]}})
	"change_integrity/change-delta-changed-needs-both-sides" in ids_for(change)
}

test_delta_added_needs_only_to if {
	change := with_spec(valid_change, {"delta": {"requirements": [{"op": "added", "id": "r.x", "from": from_requirement, "to": to_requirement}]}})
	"change_integrity/change-delta-added-needs-only-to" in ids_for(change)
}

test_delta_removed_needs_only_from if {
	change := with_spec(valid_change, {"delta": {"requirements": [{"op": "removed", "id": "r.x", "from": from_requirement, "to": to_requirement}]}})
	"change_integrity/change-delta-removed-needs-only-from" in ids_for(change)
}

test_delta_field_unknown if {
	change := with_spec(valid_change, {"delta": {"requirements": [{"op": "changed", "id": "r.x", "fields": ["colour"], "from": from_requirement, "to": to_requirement}]}})
	"change_integrity/change-delta-field-unknown" in ids_for(change)
}

test_delta_entry_identical if {
	change := with_spec(valid_change, {"delta": {"requirements": [{"op": "changed", "id": "r.x", "fields": ["text"], "from": from_requirement, "to": from_requirement}]}})
	"change_integrity/change-delta-entry-identical" in ids_for(change)
}

test_branch_missing if {
	change := with_status(valid_change, {"branch": null})
	"change_integrity/change-branch-missing" in ids_for(change)
}

test_branch_malformed if {
	change := with_status(valid_change, {"branch": "main"})
	"change_integrity/change-branch-malformed" in ids_for(change)
}

test_branch_hash_mismatch if {
	change := with_status(valid_change, {"branch": "spec/demo/deadbeef"})
	"change_integrity/change-branch-hash-mismatch" in ids_for(change)
}

test_files_touched_missing if {
	change := with_status(valid_change, {"filesTouched": null})
	"change_integrity/change-files-touched-missing" in ids_for(change)
}

test_files_touched_empty if {
	change := with_status(valid_change, {"filesTouched": []})
	"change_integrity/change-files-touched-empty" in ids_for(change)
}

test_files_touched_path_absolute if {
	change := with_status(valid_change, {"filesTouched": ["/etc/passwd"]})
	"change_integrity/change-files-touched-path-absolute" in ids_for(change)
}

test_message_empty if {
	change := with_status(valid_change, {"message": "   "})
	"change_integrity/change-message-empty" in ids_for(change)
}

test_agent_log_empty if {
	change := with_status(valid_change, {"agentLog": ""})
	"change_integrity/change-agent-log-empty" in ids_for(change)
}

test_progress_over_cap if {
	rows := [{"at": "2026-01-01T00:00:00Z"} | some i in numbers.range(1, 129)]
	change := with_status(valid_change, {"progress": rows})
	"change_integrity/change-progress-over-cap" in ids_for(change)
}

test_acceptance_name_missing if {
	change := with_status(valid_change, {"acceptance": [{"passed": true, "exitCode": 0, "durationSeconds": 1}]})
	"change_integrity/change-acceptance-name-missing" in ids_for(change)
}

test_acceptance_negative_exit_code if {
	change := with_status(valid_change, {"acceptance": [{"name": "gate", "passed": false, "exitCode": -9, "durationSeconds": 1}]})
	"change_integrity/change-acceptance-negative-exit-code" in ids_for(change)
}

test_succeeded_with_failed_acceptance if {
	change := with_status(valid_change, {"acceptance": [{"name": "market-live-acceptance", "passed": false, "exitCode": 1, "durationSeconds": 284.07, "outputTail": "accept: fail"}]})
	"change_integrity/change-succeeded-with-failed-acceptance" in ids_for(change)
}

test_succeeded_with_nonzero_verify if {
	change := with_status(valid_change, {"verifyExitCode": 1})
	"change_integrity/change-succeeded-with-nonzero-verify" in ids_for(change)
}

test_metadata_covers_every_violation_id if {
	raised := {id |
		some change in [
			object.union(valid_change, {"name": "bad"}),
			with_spec(valid_change, {"direction": "Sideways"}),
			with_status(valid_change, {"phase": "Nearly"}),
		]
		some id in ids_for(change)
	}
	known := {sprintf("%s/%s", [policy.policy_id, violation]) | some violation, _ in policy.metadata}
	count(raised - known) == 0
}

test_metadata_entries_are_complete if {
	some violation, meta in policy.metadata
	count(object.keys(meta)) == 3
	meta.severity in {"error", "warning", "info"}
	meta.level in {"MUST", "SHOULD", "MAY"}
	is_string(meta.title)
}
