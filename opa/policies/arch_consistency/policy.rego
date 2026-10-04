package deno_kcp.policies.arch_consistency

import rego.v1

# arch_consistency asks whether arch.yaml, specs/ and the graph are three
# renderings of the same thing. Every spec context has one arch entry and one
# SpecContext vertex; the entry's id, name, intent, requirements, interfaces and
# code list agree with the context; every requirement has a SpecRequirement
# vertex; and no edge dangles, duplicates an id, carries a label that disagrees
# with its vertex, or names an edge type the schema does not.

policy_id := "arch_consistency"

metadata := {
	"arch-context-missing": {"severity": "error", "level": "MUST", "title": "A spec context has no arch.yaml system_contexts entry"},
	"arch-context-extra": {"severity": "error", "level": "MUST", "title": "An arch.yaml entry names a context specs/ does not hold"},
	"arch-context-id-not-prefixed": {"severity": "error", "level": "MUST", "title": "An arch context id does not carry the sc. prefix"},
	"arch-name-mismatch": {"severity": "error", "level": "MUST", "title": "An arch context id disagrees with its name"},
	"arch-context-id-duplicate": {"severity": "error", "level": "MUST", "title": "Two arch entries share a context id"},
	"arch-intent-differs": {"severity": "error", "level": "MUST", "title": "The arch intent is not the spec intent"},
	"arch-requirement-missing": {"severity": "error", "level": "MUST", "title": "A spec requirement is absent from the arch entry"},
	"arch-requirement-extra": {"severity": "error", "level": "MUST", "title": "An arch requirement is absent from the spec"},
	"arch-requirement-text-differs": {"severity": "warning", "level": "SHOULD", "title": "The arch requirement text is not the spec requirement text"},
	"arch-requirement-level-differs": {"severity": "error", "level": "MUST", "title": "The arch requirement level is not the spec requirement level"},
	"arch-interface-missing": {"severity": "error", "level": "MUST", "title": "A spec interface is absent from the arch entry"},
	"arch-interface-extra": {"severity": "error", "level": "MUST", "title": "An arch interface is absent from the spec"},
	"arch-interface-signature-differs": {"severity": "warning", "level": "SHOULD", "title": "The arch interface signature is not the spec interface signature"},
	"arch-code-list-differs": {"severity": "warning", "level": "SHOULD", "title": "The arch code list is not the files the context observed"},
	"graph-edge-dangling": {"severity": "error", "level": "MUST", "title": "A graph edge names a vertex id that does not exist"},
	"graph-vertex-id-duplicate": {"severity": "error", "level": "MUST", "title": "Two graph vertices share an id"},
	"graph-context-without-vertex": {"severity": "error", "level": "MUST", "title": "A spec context has no SpecContext vertex"},
	"graph-vertex-without-context": {"severity": "error", "level": "MUST", "title": "A SpecContext vertex names a context specs/ does not hold"},
	"graph-edge-label-mismatch": {"severity": "error", "level": "MUST", "title": "A graph edge label disagrees with its vertex label"},
	"graph-requirement-vertex-missing": {"severity": "error", "level": "MUST", "title": "A requirement has no SpecRequirement vertex"},
	"graph-edge-type-unknown": {"severity": "error", "level": "MUST", "title": "A graph edge carries a type the schema does not name"},
}
