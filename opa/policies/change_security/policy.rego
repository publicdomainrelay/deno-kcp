package deno_kcp.policies.change_security

import rego.v1

# change_security asks whether a spec or a code diff moves a secret, weakens a
# transport, or widens authority. It reads the prose a spec carries (requirement
# texts, intents, code refs), the facts a change records (its agent log, the
# output its acceptance steps printed), and the lines a diff adds. A secret in
# any of those, a move from https to http, a verb list that gains star or a
# write verb, a workload that gains privilege, or a verification step that is
# turned off is a change that should not apply.

policy_id := "change_security"

# A path or flag that names key material, so a chmod on it is a chmod on a
# secret.
sensitive_markers := ["key", "token", "secret", "pem", "credential", "password"]

# The verbs a read-only role carries, and the verbs that make it a writer.
read_only_verbs := {"get", "list", "watch"}

widening_verbs := {"create", "update", "patch", "delete", "deletecollection", "impersonate", "escalate", "bind"}

# A workload that asks the kernel for more than its namespace grants.
privileged_pattern := `(?i)\b(?:privileged|hostNetwork|hostPID|allowPrivilegeEscalation)\s*:\s*true\b`

hostpath_pattern := `(?i)\bhostPath\s*:`

# A 64-character hex literal on the right of an assignment is key material or a
# secret written into code.
high_entropy_pattern := `(?i)[A-Za-z_][A-Za-z0-9_]*\s*[:=]\s*["']?(?:0x)?[0-9a-f]{64}\b`

private_key_pattern := `-----BEGIN [A-Z ]*PRIVATE KEY-----`

# A command that fetches a body and hands it to a shell, or evals a fetched
# body, runs code the spec never reviewed.
remote_exec_pattern := `(?i)(?:curl|wget)[^\n|]*\|\s*(?:sudo\s+)?(?:ba|z|da)?sh\b|eval\s*[(\s]\s*["']?\$?\((?:curl|wget)`

# A transport check that is turned off rather than satisfied.
disabled_verification_pattern := `(?i)--validate=false|--insecure\b|InsecureSkipVerify|rejectUnauthorized\s*:\s*false|\bcurl\b[^\n]*\s-[A-Za-z]*k[A-Za-z]*(?:\s|$)`

widened_permission_pattern := `(?:^|\s)(?:--allow-all|-A)(?:\s|$)`

restricted_permission_pattern := `--allow-[a-z]`

world_writable_pattern := `(?i)\bchmod\s+(?:777|666)\b`

# metadata names, for every violation this policy can raise, the severity it
# carries, the requirement level it corresponds to, and a one-line title. The
# aggregator joins it into each violation by id.
metadata := {
	"security-secret-in-requirement-text": {"severity": "error", "level": "MUST", "title": "A requirement text carries a secret by value"},
	"security-secret-in-intent": {"severity": "error", "level": "MUST", "title": "A context intent carries a secret by value"},
	"security-secret-in-agent-log": {"severity": "error", "level": "MUST", "title": "A change agent log carries a secret by value"},
	"security-secret-in-acceptance-output": {"severity": "error", "level": "MUST", "title": "An acceptance output carries a secret by value"},
	"security-secret-in-code-ref": {"severity": "error", "level": "MUST", "title": "A code ref carries a secret by value"},
	"security-private-key-in-spec": {"severity": "error", "level": "MUST", "title": "A spec file carries a private key block"},
	"security-token-in-diff": {"severity": "error", "level": "MUST", "title": "An added line carries a secret by value"},
	"security-high-entropy-literal-in-diff": {"severity": "warning", "level": "SHOULD", "title": "An added line assigns a 64-character hex literal"},
	"security-tls-downgrade-in-requirement": {"severity": "error", "level": "MUST", "title": "A requirement delta moves a check from https to http"},
	"security-tls-downgrade-in-diff": {"severity": "error", "level": "MUST", "title": "A diff replaces an https call with an http one"},
	"security-rbac-verb-widened": {"severity": "error", "level": "MUST", "title": "A role gains a verb that writes or a wildcard"},
	"security-cluster-admin-binding": {"severity": "error", "level": "MUST", "title": "A diff binds a subject to cluster-admin"},
	"security-privileged-workload": {"severity": "error", "level": "MUST", "title": "A workload gains a privileged field"},
	"security-hostpath-mount": {"severity": "error", "level": "MUST", "title": "A workload mounts a host path"},
	"security-acceptance-runs-remote-code": {"severity": "error", "level": "MUST", "title": "A command or requirement pipes a fetched body to a shell"},
	"security-remote-source-added": {"severity": "warning", "level": "SHOULD", "title": "The repository manifest gains a remote git source"},
	"security-disabled-verification": {"severity": "error", "level": "MUST", "title": "An added line turns off certificate verification"},
	"security-widened-permission-set": {"severity": "error", "level": "MUST", "title": "A command widens a restricted permission set to allow-all"},
	"security-world-writable-secret-file": {"severity": "error", "level": "MUST", "title": "A secret file is made world writable"},
}
