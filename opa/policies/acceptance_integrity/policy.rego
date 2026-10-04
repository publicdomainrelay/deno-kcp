package deno_kcp.policies.acceptance_integrity

import rego.v1

# acceptance_integrity asks whether the acceptance the repository declares, the
# results a change recorded for it, and the verdict the change reports agree
# with one another. A gate the repository declares must actually block; a
# result must match the step it names; a step that failed must not be reported
# as success; and a change that records a failed gate must not be Succeeded.
# The same question is asked of the repository's verify vector, which runs
# before acceptance and must not be shaped to pass without testing anything.

policy_id := "acceptance_integrity"

# metadata names, for every violation this policy can raise, the severity it
# carries, the requirement level it corresponds to, and a one-line title. The
# aggregator joins it into each violation by id.
metadata := {
	"acceptance-step-name-missing": {"severity": "error", "level": "MUST", "title": "An acceptance step has no name"},
	"acceptance-step-name-duplicate": {"severity": "error", "level": "MUST", "title": "Two acceptance steps share a name"},
	"acceptance-step-name-has-newline": {"severity": "error", "level": "MUST", "title": "An acceptance step name carries a newline"},
	"acceptance-step-command-empty": {"severity": "error", "level": "MUST", "title": "An acceptance step runs no command"},
	"acceptance-step-command-not-a-list": {"severity": "error", "level": "MUST", "title": "An acceptance step command is not an argv list"},
	"acceptance-step-timeout-negative": {"severity": "error", "level": "MUST", "title": "An acceptance step declares a negative timeout"},
	"acceptance-no-gate": {"severity": "error", "level": "MUST", "title": "The repository declares acceptance but nothing gates"},
	"acceptance-gate-is-a-report": {"severity": "error", "level": "MUST", "title": "Every gating step only prints a report"},
	"verify-empty": {"severity": "error", "level": "MUST", "title": "The repository declares no verify vector"},
	"verify-not-a-list": {"severity": "error", "level": "MUST", "title": "The verify vector is not an argv list"},
	"verify-contains-skip": {"severity": "error", "level": "MUST", "title": "The verify vector contains an option that skips the tests"},
	"verify-command-is-a-shell": {"severity": "warning", "level": "SHOULD", "title": "The verify vector hides a compound command behind a shell"},
	"acceptance-result-without-step": {"severity": "error", "level": "MUST", "title": "An acceptance result names no declared step"},
	"acceptance-step-without-result": {"severity": "error", "level": "MUST", "title": "A gating acceptance step recorded no result"},
	"acceptance-result-passed-inconsistent": {"severity": "error", "level": "MUST", "title": "An acceptance result passed flag disagrees with its exit code"},
	"acceptance-result-missing-exit-code": {"severity": "warning", "level": "SHOULD", "title": "An acceptance result records no exit code"},
	"acceptance-result-zero-duration": {"severity": "warning", "level": "SHOULD", "title": "A passed acceptance result took no time"},
	"acceptance-output-contradicts-passed": {"severity": "error", "level": "MUST", "title": "A passed acceptance result output carries a failure"},
	"acceptance-gate-failed": {"severity": "error", "level": "MUST", "title": "A gating acceptance step failed"},
	"acceptance-frozen-repository": {"severity": "error", "level": "MUST", "title": "A change is Succeeded though its gate failed"},
	"acceptance-output-tail-empty-on-failure": {"severity": "warning", "level": "SHOULD", "title": "A failed acceptance recorded no output to diagnose it"},
	"acceptance-http-check-on-tls-listener": {"severity": "error", "level": "MUST", "title": "An http fetch checks a listener the spec says is TLS"},
}
