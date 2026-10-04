package deno_kcp.policies.spec_structure

import rego.v1

# spec_structure asks whether a spec tree is shaped the way the schema says it
# must be. Every context has a name, an intent, a repository, an upstream and at
# least one requirement; every requirement has a well-formed unique id, a level
# from MUST, SHOULD, MAY, and text an engineer could check; every interface has
# a file, a known kind, a unique name and a signature; every context has a
# status file and a context document beside it; the repository manifest names
# the code branch and a verify vector.
#
# Every rule under violations/ contributes to `violations`. The metadata rule
# names the severity, the level it belongs to, and a title for each violation
# id, once, so a violation rule states only what it found.

policy_id := "spec_structure"

min_intent_words := 20

min_requirement_words := 10

terse_requirement_words := 15

max_requirement_words := 150

document_api_version := "specs.publicdomainrelay.dev/v1alpha1"

# metadata names, for every violation this policy can raise, the severity it
# carries, the requirement level it corresponds to, and a one-line title. The
# aggregator joins it into each violation by id.
metadata := {
	"context-api-version-invalid": {"severity": "error", "level": "MUST", "title": "A context document carries the wrong apiVersion"},
	"context-kind-invalid": {"severity": "error", "level": "MUST", "title": "A context document is not kind SystemContext"},
	"context-metadata-missing": {"severity": "error", "level": "MUST", "title": "A context document has no metadata.name"},
	"context-metadata-name-mismatch": {"severity": "error", "level": "MUST", "title": "metadata.name disagrees with the file name"},
	"context-namespace-missing": {"severity": "warning", "level": "SHOULD", "title": "A context document has no metadata.namespace"},
	"context-intent-missing": {"severity": "error", "level": "MUST", "title": "A context states no intent"},
	"context-intent-too-short": {"severity": "warning", "level": "SHOULD", "title": "A context intent is too short to say what the context is for"},
	"context-repository-missing": {"severity": "error", "level": "MUST", "title": "A context names no repository"},
	"context-upstream-missing": {"severity": "error", "level": "MUST", "title": "A context declares no upstream"},
	"context-upstream-invalid": {"severity": "error", "level": "MUST", "title": "A context upstream is not a valid reference"},
	"context-requirements-missing": {"severity": "error", "level": "MUST", "title": "A context declares no requirements"},
	"context-status-missing": {"severity": "error", "level": "MUST", "title": "A context has no status file"},
	"context-document-missing": {"severity": "warning", "level": "SHOULD", "title": "A context has no CLM context document"},
	"status-conditions-missing": {"severity": "error", "level": "MUST", "title": "A status file carries no conditions"},
	"status-condition-type-unknown": {"severity": "warning", "level": "SHOULD", "title": "A status condition has a type the schema does not name"},
	"status-fingerprint-missing": {"severity": "error", "level": "MUST", "title": "A status file carries no observed fingerprint"},
	"status-realized-spec-hash-invalid": {"severity": "error", "level": "MUST", "title": "realizedSpecHash is not a sha256 digest"},
	"requirement-id-missing": {"severity": "error", "level": "MUST", "title": "A requirement has no id"},
	"requirement-id-malformed": {"severity": "error", "level": "MUST", "title": "A requirement id is not r.<kebab-case>"},
	"requirement-id-duplicate": {"severity": "error", "level": "MUST", "title": "Two requirements in one context share an id"},
	"requirement-level-missing": {"severity": "error", "level": "MUST", "title": "A requirement declares no level"},
	"requirement-level-invalid": {"severity": "error", "level": "MUST", "title": "A requirement level is not MUST, SHOULD or MAY"},
	"requirement-text-missing": {"severity": "error", "level": "MUST", "title": "A requirement has no text"},
	"requirement-text-too-short": {"severity": "error", "level": "MUST", "title": "A requirement text is too short to act on"},
	"requirement-text-terse": {"severity": "warning", "level": "SHOULD", "title": "A requirement states less than a reader needs to check it"},
	"requirement-text-too-long": {"severity": "warning", "level": "SHOULD", "title": "A requirement text carries several requirements under one id"},
	"requirement-text-has-machine-path": {"severity": "error", "level": "MUST", "title": "A requirement text names a path that exists on one machine only"},
	"requirement-code-refs-not-a-list": {"severity": "error", "level": "MUST", "title": "codeRefs is not a list"},
	"requirement-code-ref-not-a-string": {"severity": "error", "level": "MUST", "title": "A codeRef is not a string"},
	"interface-file-missing": {"severity": "error", "level": "MUST", "title": "An interface names no file"},
	"interface-kind-invalid": {"severity": "error", "level": "MUST", "title": "An interface kind is not one the observer can see"},
	"interface-name-missing": {"severity": "error", "level": "MUST", "title": "An interface has no name"},
	"interface-name-duplicate": {"severity": "error", "level": "MUST", "title": "Two interfaces in one context share a name"},
	"interface-signature-missing": {"severity": "warning", "level": "SHOULD", "title": "An interface has no signature"},
	"repository-verify-missing": {"severity": "error", "level": "MUST", "title": "The repository manifest names no verify command"},
	"repository-branch-missing": {"severity": "error", "level": "MUST", "title": "The repository manifest names no code branch"},
	"repository-phase-invalid": {"severity": "warning", "level": "SHOULD", "title": "The repository phase is not one of the four"},
}
