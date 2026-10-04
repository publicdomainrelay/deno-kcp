package deno_kcp.policies.change_integrity

import rego.v1

# change_integrity asks whether a SpecChange record is well formed and whether
# it tells the truth about itself. It reads input.change, the one record under
# review, and never the tree's other records: a policy that judged every record
# in a tree would report the tree's history rather than this change.
#
# The direction decides which fields are required. A SpecToCode change moves the
# spec to a hash, so it carries fromSpecHash and toSpecHash. A CodeToSpec change
# moves the code between commits, so it carries fromCommit and toCommit. A
# record that carries the wrong pair is a record whose direction is a lie.

policy_id := "change_integrity"

change_phases := {"Pending", "Running", "Succeeded", "Failed"}

change_directions := {"SpecToCode", "CodeToSpec"}

delta_ops := {"added", "removed", "changed"}

delta_fields := {
	"id",
	"level",
	"text",
	"codeRefs",
	"intent",
	"upstream",
	"orchestrator",
	"overlay",
	"dependsOn",
	"introduces",
	"kind",
	"signature",
	"file",
	"name",
}

max_progress_records := 128

branch_pattern := `^spec/[a-z0-9]([-a-z0-9]*[a-z0-9])?/[0-9a-f]{8}$`

commit_pattern := `^[0-9a-f]{40}$`

has_change if is_object(object.get(input, "change", null))

change_doc(change) := doc if {
	doc := object.get(change, "document", {})
	is_object(doc)
}

change_spec(change) := spec if {
	spec := object.get(change_doc(change), "spec", {})
	is_object(spec)
}

change_status(change) := status if {
	status := object.get(change_doc(change), "status", {})
	is_object(status)
}

change_metadata(change) := metadata if {
	metadata := object.get(change_doc(change), "metadata", {})
	is_object(metadata)
}

context_of(change) := name if {
	name := object.get(change_spec(change), "systemContext", "")
}

delta(change) := d if {
	d := object.get(change_spec(change), "delta", {})
	is_object(d)
}

delta_requirements(change) := reqs if {
	reqs := object.get(delta(change), "requirements", [])
	is_array(reqs)
}

acceptance_results(change) := rows if {
	rows := object.get(change_status(change), "acceptance", [])
	is_array(rows)
}

files_touched(change) := files if {
	files := object.get(change_status(change), "filesTouched", [])
	is_array(files)
}

progress(change) := rows if {
	rows := object.get(change_status(change), "progress", [])
	is_array(rows)
}

phase(change) := p if {
	p := object.get(change_status(change), "phase", "")
}

# Every spec hash the tree already knows for the context this change names: the
# hash the code was realized from, and the hash the context's graph vertex
# carries. A SpecToCode change whose toSpecHash is neither is a change pointing
# at a spec state the tree has never seen.
known_spec_hashes(tree, context) := hashes if {
	ctx := object.get(object.get(tree, "contexts", {}), context, {})
	realized := object.get(object.get(ctx, "status", {}), "realizedSpecHash", "")
	graph_hashes := {h |
		some vertex in object.get(object.get(tree, "graph", {}), "vertices", [])
		vertex.label == "SpecContext"
		vertex.name == context
		h := object.get(vertex, "specHash", "")
		is_string(h)
		h != ""
	}
	realized_hashes := {h | some h in [realized]; is_string(h); h != ""}
	hashes := realized_hashes | graph_hashes
}

metadata := {
	"change-name-malformed": {"severity": "error", "level": "MUST", "title": "A change name is not <context>-s2c-<hash> or <context>-c2s-<from>-<to>"},
	"change-name-context-mismatch": {"severity": "error", "level": "MUST", "title": "A change name does not begin with its own context"},
	"change-metadata-missing": {"severity": "error", "level": "MUST", "title": "A change record has no metadata.name"},
	"change-system-context-missing": {"severity": "error", "level": "MUST", "title": "A change names no system context"},
	"change-system-context-unknown": {"severity": "error", "level": "MUST", "title": "A change names a context the tree does not hold"},
	"change-direction-missing": {"severity": "error", "level": "MUST", "title": "A change declares no direction"},
	"change-direction-invalid": {"severity": "error", "level": "MUST", "title": "A change direction is neither SpecToCode nor CodeToSpec"},
	"change-phase-missing": {"severity": "error", "level": "MUST", "title": "A change records no phase"},
	"change-phase-invalid": {"severity": "error", "level": "MUST", "title": "A change phase is not Pending, Running, Succeeded or Failed"},
	"change-hash-missing": {"severity": "error", "level": "MUST", "title": "A SpecToCode change carries no toSpecHash"},
	"change-hash-invalid": {"severity": "error", "level": "MUST", "title": "A change hash is not a sha256 digest"},
	"change-from-hash-invalid": {"severity": "error", "level": "MUST", "title": "fromSpecHash is not a sha256 digest"},
	"change-to-hash-equals-from-hash": {"severity": "error", "level": "MUST", "title": "A change moves the spec to where it already was"},
	"change-code-to-spec-commits-unpaired": {"severity": "error", "level": "MUST", "title": "A CodeToSpec change sets one commit and not the other"},
	"change-commits-equal": {"severity": "error", "level": "MUST", "title": "A CodeToSpec change names the same commit twice"},
	"change-commit-invalid": {"severity": "error", "level": "MUST", "title": "A change names a commit that is not a 40 character sha"},
	"change-to-spec-hash-not-in-tree": {"severity": "error", "level": "MUST", "title": "A SpecToCode change points at a spec state the tree has never seen"},
	"change-delta-op-invalid": {"severity": "error", "level": "MUST", "title": "A delta entry op is not added, removed or changed"},
	"change-delta-entry-missing-id": {"severity": "error", "level": "MUST", "title": "A delta entry names no requirement"},
	"change-delta-entry-missing-op": {"severity": "error", "level": "MUST", "title": "A delta entry declares no op"},
	"change-delta-changed-needs-both-sides": {"severity": "error", "level": "MUST", "title": "A changed delta entry carries only one side"},
	"change-delta-added-needs-only-to": {"severity": "error", "level": "MUST", "title": "An added delta entry carries a from side"},
	"change-delta-removed-needs-only-from": {"severity": "error", "level": "MUST", "title": "A removed delta entry carries a to side"},
	"change-delta-field-unknown": {"severity": "error", "level": "MUST", "title": "A delta entry names a field that does not exist"},
	"change-delta-entry-identical": {"severity": "error", "level": "MUST", "title": "A changed delta entry's two sides are identical, so the op is a lie"},
	"change-branch-missing": {"severity": "error", "level": "MUST", "title": "A realized change records no branch"},
	"change-branch-malformed": {"severity": "error", "level": "MUST", "title": "A change branch is not spec/<context>/<8 hex>"},
	"change-branch-hash-mismatch": {"severity": "error", "level": "MUST", "title": "A change branch's hash is not the head of its toSpecHash"},
	"change-files-touched-missing": {"severity": "error", "level": "MUST", "title": "A realized change records no filesTouched list"},
	"change-files-touched-empty": {"severity": "error", "level": "MUST", "title": "A realized change touched no file"},
	"change-files-touched-path-absolute": {"severity": "error", "level": "MUST", "title": "A filesTouched entry is not a repo-relative path"},
	"change-message-empty": {"severity": "warning", "level": "SHOULD", "title": "A change records no message"},
	"change-agent-log-empty": {"severity": "warning", "level": "SHOULD", "title": "A change records no agent log"},
	"change-progress-over-cap": {"severity": "warning", "level": "SHOULD", "title": "A change carries more progress records than the cap allows"},
	"change-acceptance-name-missing": {"severity": "error", "level": "MUST", "title": "An acceptance result names no step"},
	"change-acceptance-negative-exit-code": {"severity": "error", "level": "MUST", "title": "An acceptance result carries a negative exit code"},
	"change-succeeded-with-failed-acceptance": {"severity": "error", "level": "MUST", "title": "A change is Succeeded while an acceptance step failed"},
	"change-succeeded-with-nonzero-verify": {"severity": "error", "level": "MUST", "title": "A change is Succeeded while verify exited non-zero"},
}
