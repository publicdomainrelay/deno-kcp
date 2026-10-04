package deno_kcp.policies.change_quality

import rego.v1

# change_quality asks whether requirement prose is something an engineer can
# check, and whether its wording matches the level it declares. A requirement
# that reads as a permission but declares MUST, that leans on a vague word, that
# restates its own id, that enumerates bare names instead of saying what to
# check, or whose interface carries no signature is prose a reviewer cannot act
# on. The rules here are calibrated against the hand-written spec tree: the
# thresholds are set so real prose passes and only outliers are raised.

policy_id := "change_quality"

# A run of words the intent and one of its own requirements share, long enough
# that the intent has copied the requirement rather than governed it.
min_shared_run := 8

# A requirement text with more sentences than this is several requirements
# sharing one id.
max_sentences := 4

# metadata names, for every violation this policy can raise, the severity it
# carries, the requirement level it corresponds to, and a one-line title. The
# aggregator joins it into each violation by id.
metadata := {
	"quality-level-text-disagreement": {"severity": "warning", "level": "SHOULD", "title": "A requirement's wording disagrees with its declared level"},
	"quality-vague-term": {"severity": "warning", "level": "SHOULD", "title": "A requirement text leans on a word that asserts nothing"},
	"quality-non-normative-phrase": {"severity": "warning", "level": "SHOULD", "title": "A requirement text states an intention, not a fact"},
	"quality-placeholder": {"severity": "warning", "level": "SHOULD", "title": "A requirement text still carries a placeholder marker"},
	"quality-not-a-sentence": {"severity": "info", "level": "MAY", "title": "A requirement text is neither capitalised nor ended"},
	"quality-many-sentences": {"severity": "warning", "level": "SHOULD", "title": "A requirement text carries several sentences under one id"},
	"quality-echoes-identifier": {"severity": "info", "level": "MAY", "title": "A requirement text repeats its own id words"},
	"quality-enumerates-without-structure": {"severity": "warning", "level": "SHOULD", "title": "A requirement text is a bare list of names"},
	"quality-interface-signature-not-a-signature": {"severity": "warning", "level": "SHOULD", "title": "An interface signature does not fit its kind"},
	"quality-interface-signature-missing": {"severity": "warning", "level": "SHOULD", "title": "An interface declares no signature"},
	"quality-intent-restates-a-requirement": {"severity": "warning", "level": "SHOULD", "title": "A context intent copies one of its own requirements"},
	"quality-requirement-not-observable": {"severity": "warning", "level": "SHOULD", "title": "A MUST requirement names nothing an observer could check"},
	"quality-change-message-names-no-context": {"severity": "warning", "level": "SHOULD", "title": "A change message does not name its context"},
	"quality-agent-log-empty": {"severity": "warning", "level": "SHOULD", "title": "A change records no agent log"},
	"quality-delta-text-change-adds-nothing": {"severity": "warning", "level": "SHOULD", "title": "A text delta differs only by punctuation or whitespace"},
}
