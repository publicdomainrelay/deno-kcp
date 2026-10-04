package deno_kcp.policies.spec_references

import rego.v1

# spec_references asks whether everything a spec declares resolves. Every code
# ref is a well-formed kind:payload; a file ref names a path the tree knows and
# the context observed; a symbol ref names an observed interface; every declared
# interface has a file on disk and was seen by the observer; no observed
# interface floats undeclared; an upstream, overlay, dependsOn or introduces
# member names a context the tree holds; and a context whose CodeSynced
# condition is False is not also carried by a change recorded Succeeded.

policy_id := "spec_references"

# A context that was never observed for interfaces cannot have its symbol refs
# judged, so the symbol rules only run against a context that has observed
# interfaces. The same holds for files.
metadata := {
	"code-ref-malformed": {"severity": "error", "level": "MUST", "title": "A code ref is not kind:payload"},
	"code-ref-unknown-kind": {"severity": "error", "level": "MUST", "title": "A code ref names a kind the observer cannot see"},
	"code-ref-empty-payload": {"severity": "error", "level": "MUST", "title": "A code ref names nothing after the kind"},
	"code-ref-whitespace-in-payload": {"severity": "error", "level": "MUST", "title": "A code ref payload carries whitespace"},
	"code-ref-duplicate-in-requirement": {"severity": "warning", "level": "SHOULD", "title": "A requirement declares the same code ref twice"},
	"code-ref-duplicate-in-context": {"severity": "warning", "level": "SHOULD", "title": "A context declares the same code ref twice on itself"},
	"code-ref-path-absolute": {"severity": "error", "level": "MUST", "title": "A file ref names an absolute path"},
	"code-ref-path-escaping": {"severity": "error", "level": "MUST", "title": "A file ref escapes the repository root"},
	"code-ref-path-not-repo-relative": {"severity": "error", "level": "MUST", "title": "A file ref is not a repo-relative path"},
	"code-ref-file-missing": {"severity": "error", "level": "MUST", "title": "A file ref names a path the tree does not hold"},
	"code-ref-file-not-observed": {"severity": "error", "level": "MUST", "title": "A file ref names a path the context never observed"},
	"code-ref-symbol-unobserved": {"severity": "error", "level": "MUST", "title": "A symbol ref names no interface the context observed"},
	"interface-file-missing-on-disk": {"severity": "error", "level": "MUST", "title": "A declared interface names a file the tree does not hold"},
	"interface-file-not-observed": {"severity": "warning", "level": "SHOULD", "title": "A declared interface names a file the context never observed"},
	"interface-not-observed": {"severity": "warning", "level": "SHOULD", "title": "A declared interface is absent from the observed interfaces"},
	"observed-interface-undeclared": {"severity": "warning", "level": "SHOULD", "title": "An observed interface no requirement or interface declaration names"},
	"status-code-synced-false": {"severity": "warning", "level": "SHOULD", "title": "CodeSynced is False while a change for the context is recorded Succeeded"},
	"context-reference-unknown": {"severity": "error", "level": "MUST", "title": "A context reference names a context the tree does not hold"},
}
