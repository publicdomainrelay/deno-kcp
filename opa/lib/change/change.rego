package deno_kcp.lib.change

import rego.v1

import data.deno_kcp.lib.paths

# Accessors shared by the change-facing policies. A spec change is judged
# against three documents at once: the repository manifest (its verify vector
# and its acceptance steps), the SpecChange record (its delta and its status),
# and the code diff (the paths it touched). Each accessor tolerates a missing
# document and returns the empty value for its type, so a policy states the
# question rather than guarding every field on the way to it.

failure_markers := ["FAIL", "fail", "error", "not ok", "panic:"]

trivial_commands := {"echo", "true", ":", "printf"}

shells := {"sh", "bash", "zsh", "dash"}

compound_operators := [";", "&&", "||", "|", "`", "$("]

skip_tokens := {"--no-verify", "-short", "-run=^$", "--passWithNoTests"}

# --- repository manifest ------------------------------------------------

repository(tree) := r if {
	r := object.get(tree, "repository", null)
	is_object(r)
}

repository(tree) := {} if {
	not is_object(object.get(tree, "repository", null))
}

repository_spec(tree) := s if {
	s := object.get(repository(tree), "spec", null)
	is_object(s)
}

repository_spec(tree) := {} if {
	not is_object(object.get(repository(tree), "spec", null))
}

acceptance_steps(tree) := steps if {
	steps := object.get(repository_spec(tree), "acceptance", null)
	is_array(steps)
}

acceptance_steps(tree) := [] if {
	not is_array(object.get(repository_spec(tree), "acceptance", null))
}

has_acceptance(tree) if count(acceptance_steps(tree)) > 0

verify_vector(tree) := v if {
	v := object.get(repository_spec(tree), "verify", null)
	is_array(v)
}

verify_vector(tree) := null if {
	not is_array(object.get(repository_spec(tree), "verify", null))
}

# --- acceptance steps ---------------------------------------------------

step_name(step) := n if {
	n := object.get(step, "name", null)
	is_string(n)
}

step_name(step) := "" if {
	not is_string(object.get(step, "name", null))
}

step_command(step) := c if {
	c := object.get(step, "command", null)
	is_array(c)
}

step_command(step) := null if {
	not is_array(object.get(step, "command", null))
}

step_gate(step) if object.get(step, "gate", false) == true

step_timeout(step) := t if {
	t := object.get(step, "timeoutSeconds", null)
	is_number(t)
}

step_names(steps) := names if {
	names := [n | some step in steps; n := step_name(step); n != ""]
}

gated_steps(steps) := gs if {
	gs := [step | some step in steps; step_gate(step)]
}

is_trivial_command(cmd) if {
	is_array(cmd)
	count(cmd) == 0
}

is_trivial_command(cmd) if {
	is_array(cmd)
	count(cmd) > 0
	first := cmd[0]
	is_string(first)
	first in trivial_commands
}

is_shell_argv(argv) if {
	is_array(argv)
	count(argv) >= 2
	first := argv[0]
	is_string(first)
	paths.basename(first) in shells
	some arg in argv
	arg == "-c"
	script := argv[count(argv) - 1]
	is_string(script)
	some op in compound_operators
	contains(script, op)
}

verify_has_skip(v) if {
	is_array(v)
	some token in v
	is_string(token)
	token in skip_tokens
}

verify_has_skip(v) if {
	is_array(v)
	joined := concat(" ", [t | some t in v; is_string(t)])
	contains(joined, "|| true")
}

verify_has_skip(v) if {
	is_array(v)
	joined := concat(" ", [t | some t in v; is_string(t)])
	contains(joined, "||true")
}

# --- acceptance results -------------------------------------------------

result_name(result) := n if {
	n := object.get(result, "name", null)
	is_string(n)
}

result_name(result) := "" if {
	not is_string(object.get(result, "name", null))
}

result_names(results) := names if {
	names := {n | some result in results; n := result_name(result); n != ""}
}

result_for(results, name) := result if {
	some result in results
	result_name(result) == name
}

result_passed(result) if object.get(result, "passed", null) == true

result_unpassed(result) if object.get(result, "passed", null) == false

result_exit_code(result) := code if {
	code := object.get(result, "exitCode", null)
	is_number(code)
}

result_duration(result) := d if {
	d := object.get(result, "durationSeconds", null)
	is_number(d)
}

result_output(result) := out if {
	out := object.get(result, "outputTail", null)
	is_string(out)
}

output_contradicts_pass(out) if {
	is_string(out)
	some marker in failure_markers
	contains(out, marker)
}

# --- the change record --------------------------------------------------

change_document(change) := d if {
	is_object(change)
	d := object.get(change, "document", {})
	is_object(d)
}

change_document(change) := {} if not is_object(change)

change_spec_block(change) := s if {
	is_object(change)
	s := object.get(change_document(change), "spec", {})
	is_object(s)
}

change_spec_block(change) := {} if not is_object(change)

change_status_block(change) := s if {
	is_object(change)
	s := object.get(change_document(change), "status", {})
	is_object(s)
}

change_status_block(change) := {} if not is_object(change)

delta_requirements(change) := reqs if {
	delta := object.get(change_spec_block(change), "delta", null)
	is_object(delta)
	reqs := object.get(delta, "requirements", null)
	is_array(reqs)
}

delta_requirements(change) := [] if {
	not is_array(object.get(object.get(change_spec_block(change), "delta", null), "requirements", null))
}

acceptance_results(change) := rows if {
	rows := object.get(change_status_block(change), "acceptance", null)
	is_array(rows)
}

acceptance_results(change) := [] if {
	not is_array(object.get(change_status_block(change), "acceptance", null))
}

files_touched(change) := files if {
	files := object.get(change_status_block(change), "filesTouched", null)
	is_array(files)
}

files_touched(change) := [] if {
	not is_array(object.get(change_status_block(change), "filesTouched", null))
}

change_phase(change) := p if {
	p := object.get(change_status_block(change), "phase", null)
	is_string(p)
}

change_phase(change) := "" if {
	not is_string(object.get(change_status_block(change), "phase", null))
}

change_context_name(change) := c if {
	c := object.get(change_spec_block(change), "systemContext", null)
	is_string(c)
}

change_context_name(change) := "" if {
	not is_string(object.get(change_spec_block(change), "systemContext", null))
}

change_to_spec_hash(change) := h if {
	h := object.get(change_spec_block(change), "toSpecHash", null)
	is_string(h)
}

change_to_spec_hash(change) := "" if {
	not is_string(object.get(change_spec_block(change), "toSpecHash", null))
}

change_commit(change) := c if {
	c := object.get(change_status_block(change), "commit", null)
	is_string(c)
}

change_commit(change) := "" if {
	not is_string(object.get(change_status_block(change), "commit", null))
}

change_branch(change) := b if {
	b := object.get(change_status_block(change), "branch", null)
	is_string(b)
}

change_branch(change) := "" if {
	not is_string(object.get(change_status_block(change), "branch", null))
}

# --- the code diff ------------------------------------------------------

diff(doc) := d if {
	d := object.get(doc, "diff", null)
	is_object(d)
}

diff(doc) := {} if {
	not is_object(object.get(doc, "diff", null))
}

has_diff(doc) if is_object(object.get(doc, "diff", null))

diff_paths(doc) := p if {
	p := object.get(diff(doc), "paths", null)
	is_array(p)
}

diff_paths(doc) := [] if {
	not is_array(object.get(diff(doc), "paths", null))
}

diff_path_set(doc) := s if {
	s := {p | some p in diff_paths(doc)}
}

diff_commits(doc) := c if {
	c := object.get(diff(doc), "commits", null)
	is_array(c)
}

diff_commits(doc) := [] if {
	not is_array(object.get(diff(doc), "commits", null))
}

diff_head(doc) := h if {
	h := object.get(diff(doc), "head", null)
	is_string(h)
}

diff_head(doc) := "" if {
	not is_string(object.get(diff(doc), "head", null))
}

commit_shas(doc) := shas if {
	shas := {s | some c in diff_commits(doc); s := object.get(c, "sha", ""); is_string(s)}
}

# --- tree contexts ------------------------------------------------------

contexts(tree) := c if {
	c := object.get(tree, "contexts", null)
	is_object(c)
}

contexts(tree) := {} if {
	not is_object(object.get(tree, "contexts", null))
}

context_of(tree, name) := ctx if {
	ctx := object.get(contexts(tree), name, null)
	is_object(ctx)
}

context_of(tree, name) := {} if {
	not is_object(object.get(contexts(tree), name, null))
}

context_spec(tree, name) := s if {
	s := object.get(context_of(tree, name), "spec", null)
	is_object(s)
}

context_spec(tree, name) := {} if {
	not is_object(object.get(context_of(tree, name), "spec", null))
}

context_requirements(tree, name) := reqs if {
	reqs := object.get(context_spec(tree, name), "requirements", null)
	is_array(reqs)
}

context_requirements(tree, name) := [] if {
	not is_array(object.get(context_spec(tree, name), "requirements", null))
}

context_status(tree, name) := s if {
	s := object.get(context_of(tree, name), "status", null)
	is_object(s)
}

context_status(tree, name) := {} if {
	not is_object(object.get(context_of(tree, name), "status", null))
}

context_observed(tree, name) := obs if {
	obs := object.get(context_status(tree, name), "observed", null)
	is_object(obs)
}

context_observed(tree, name) := {} if {
	not is_object(object.get(context_status(tree, name), "observed", null))
}

context_observed_files(tree, name) := files if {
	files := object.get(context_observed(tree, name), "files", null)
	is_array(files)
}

context_observed_files(tree, name) := [] if {
	not is_array(object.get(context_observed(tree, name), "files", null))
}

context_observed_commit(tree, name) := c if {
	c := object.get(context_status(tree, name), "observedCommit", null)
	is_string(c)
}

context_observed_commit(tree, name) := "" if {
	not is_string(object.get(context_status(tree, name), "observedCommit", null))
}

context_synced_commit(tree, name) := c if {
	c := object.get(context_status(tree, name), "syncedCommit", null)
	is_string(c)
}

context_synced_commit(tree, name) := "" if {
	not is_string(object.get(context_status(tree, name), "syncedCommit", null))
}

context_realized_spec_hash(tree, name) := h if {
	h := object.get(context_status(tree, name), "realizedSpecHash", null)
	is_string(h)
}

context_realized_spec_hash(tree, name) := "" if {
	not is_string(object.get(context_status(tree, name), "realizedSpecHash", null))
}

# Every repo-relative file the context names: the requirements' file refs, at
# the requirement level only. Symbol refs (a codegraph id) are not paths and
# are never fed to a path predicate.
context_file_refs(tree, name) := files if {
	files := {p |
		some req in context_requirements(tree, name)
		some ref in object.get(req, "codeRefs", [])
		paths.is_file_ref(ref)
		p := paths.code_ref_file(ref)
	}
}

# The files one requirement names. A symbol ref (kind:<32 hex>) is a codegraph
# id, not a path, and is dropped before any path predicate sees it.
requirement_file_refs(req) := files if {
	is_object(req)
	files := [p |
		some ref in object.get(req, "codeRefs", [])
		paths.is_file_ref(ref)
		p := paths.code_ref_file(ref)
	]
}

requirement_file_refs(req) := [] if not is_object(req)

is_script_path(path) if {
	is_string(path)
	endswith(path, ".sh")
}

is_script_path(path) if {
	is_string(path)
	endswith(path, ".bash")
}

# --- arch.yaml overlay --------------------------------------------------

arch(tree) := a if {
	a := object.get(tree, "arch", null)
	is_object(a)
}

arch(tree) := {} if {
	not is_object(object.get(tree, "arch", null))
}

arch_entries(tree) := es if {
	es := object.get(arch(tree), "system_contexts", null)
	is_array(es)
}

arch_entries(tree) := [] if {
	not is_array(object.get(arch(tree), "system_contexts", null))
}

# The overlay entry the arch.yaml holds for one context. The entry names the
# context by its id, sc.<context>, and by its bare name; either resolves.
arch_entry_for(tree, context) := entry if {
	context != ""
	some entry in arch_entries(tree)
	object.get(entry, "id", "") == sprintf("sc.%s", [context])
}

arch_entry_for(tree, context) := entry if {
	context != ""
	expected := sprintf("sc.%s", [context])
	some entry in arch_entries(tree)
	object.get(entry, "name", "") == context
	object.get(entry, "id", "") != expected
}

arch_requirement_by_id(tree, context, id) := req if {
	some req in object.get(arch_entry_for(tree, context), "requirements", [])
	object.get(req, "id", "") == id
}

# The files the arch overlay names for one requirement. The overlay is the
# context's own requirement list, so a file the head tree adds to a requirement
# is visible here even before the diff is read.
arch_requirement_file_refs(tree, context, id) := files if {
	files := requirement_file_refs(arch_requirement_by_id(tree, context, id))
}

# --- acceptance script prose --------------------------------------------

script_path_pattern := `(?:[A-Za-z0-9_.-]+/)*[A-Za-z0-9_.-]+\.(?:sh|bash)`

script_paths(text) := found if {
	found := [p |
		some match in regex.find_all_string_submatch_n(script_path_pattern, text, -1)
		p := match[0]
		paths.is_repo_relative(p)
	]
}

# An http:// URL whose host is a real host rather than a <placeholder>.
real_http_url(text) := url if {
	some url in regex.find_n(`http://[^\s"'\)\]]+`, text, -1)
	regex.match(`^http://[A-Za-z0-9\[]`, url)
}

declares_service_tls(text) if {
	is_string(text)
	regex.match(`(?i)SERVICE_TLS[^\n]{0,8}true`, text)
}
