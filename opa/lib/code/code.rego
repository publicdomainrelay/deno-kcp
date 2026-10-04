package deno_kcp.lib.code

import rego.v1

# Helpers over the code diff a policy set reads as input.diff. A diff is a list
# of files; each file carries a unified `patch`, the full file at the head as
# `head_text`, and the full file at the base as `base_text`. A rule cares about
# the lines the change ADDS, and about where in the head file each added line
# lands, so it can point at a line number and quote the line. Everything here
# tolerates a null diff and a missing patch.

# diff_files returns the files of a diff, and the empty list when there is no
# diff at all.
diff_files(diff) := files if {
	is_object(diff)
	raw := object.get(diff, "files", [])
	is_array(raw)
	files := raw
}

diff_files(diff) := [] if {
	not is_object(diff)
}

file_path(file) := path if {
	path := object.get(file, "path", "")
	is_string(path)
}

file_patch(file) := patch if {
	patch := object.get(file, "patch", "")
	is_string(patch)
}

file_head_text(file) := text if {
	text := object.get(file, "head_text", "")
	is_string(text)
}

file_head_text(file) := "" if {
	raw := object.get(file, "head_text", "")
	not is_string(raw)
}

file_base_text(file) := text if {
	text := object.get(file, "base_text", "")
	is_string(text)
}

file_base_text(file) := "" if {
	raw := object.get(file, "base_text", "")
	not is_string(raw)
}

head_lines(text) := lines if {
	is_string(text)
	lines := split(text, "\n")
}

head_lines(text) := [] if {
	not is_string(text)
}

# A unified diff line starts with + (added), - (removed) or a space (context);
# the +++ and --- headers are not content.
is_added_line(line) if {
	is_string(line)
	startswith(line, "+")
	not startswith(line, "+++")
}

is_removed_line(line) if {
	is_string(line)
	startswith(line, "-")
	not startswith(line, "---")
}

is_context_line(line) if {
	is_string(line)
	startswith(line, " ")
}

# advances_new_file reports whether a diff line moves the new-file line counter
# forward: an added line and a context line do; a removed line does not.
advances_new_file(line) if {
	is_added_line(line)
}

advances_new_file(line) if {
	is_context_line(line)
}

advances_old_file(line) if {
	is_removed_line(line)
}

advances_old_file(line) if {
	is_context_line(line)
}

# new_hunk returns the starting line number in the head file a `@@ -a,b +c,d @@`
# header names, or null when the line is not a hunk header.
new_hunk(line) := n if {
	m := regex.find_all_string_submatch_n(`^@@ -\d+(?:,\d+)? \+(\d+)(?:,\d+)? @@`, line, 1)
	count(m) == 1
	n := to_number(m[0][1])
}

new_hunk(line) := null if {
	m := regex.find_all_string_submatch_n(`^@@ -\d+(?:,\d+)? \+(\d+)(?:,\d+)? @@`, line, 1)
	count(m) == 0
}

old_hunk(line) := n if {
	m := regex.find_all_string_submatch_n(`^@@ -(\d+)(?:,\d+)? \+\d+(?:,\d+)? @@`, line, 1)
	count(m) == 1
	n := to_number(m[0][1])
}

old_hunk(line) := null if {
	m := regex.find_all_string_submatch_n(`^@@ -(\d+)(?:,\d+)? \+\d+(?:,\d+)? @@`, line, 1)
	count(m) == 0
}

# new_line_number returns the line number in the head file of lines[i], by
# finding the last hunk header at or before i and counting the added and context
# lines between that header and i.
new_line_number(lines, i) := n if {
	headers := sort([j | some j in numbers.range(0, i - 1); new_hunk(lines[j]) != null])
	count(headers) > 0
	j := headers[count(headers) - 1]
	base := new_hunk(lines[j])
	advanced := [k | some k in numbers.range(0, i - 1); k > j; advances_new_file(lines[k])]
	n := base + count(advanced)
}

old_line_number(lines, i) := n if {
	headers := sort([j | some j in numbers.range(0, i - 1); old_hunk(lines[j]) != null])
	count(headers) > 0
	j := headers[count(headers) - 1]
	base := old_hunk(lines[j])
	advanced := [k | some k in numbers.range(0, i - 1); k > j; advances_old_file(lines[k])]
	n := base + count(advanced)
}

# added_lines returns every added line of a patch as {line, text}, where line is
# the line number in the head file and text is the line without its leading +.
added_lines(patch) := rows if {
	is_string(patch)
	lines := split(patch, "\n")
	rows := [{"line": new_line_number(lines, i), "text": trim_prefix(lines[i], "+")} |
		some i in numbers.range(0, count(lines) - 1)
		is_added_line(lines[i])
	]
}

added_lines(patch) := [] if {
	not is_string(patch)
}

# removed_lines returns every removed line of a patch as {line, text}, where line
# is the line number in the base file and text is the line without its leading -.
removed_lines(patch) := rows if {
	is_string(patch)
	lines := split(patch, "\n")
	rows := [{"line": old_line_number(lines, i), "text": trim_prefix(lines[i], "-")} |
		some i in numbers.range(0, count(lines) - 1)
		is_removed_line(lines[i])
	]
}

removed_lines(patch) := [] if {
	not is_string(patch)
}

# added_rows returns every added line across a diff as
# {path, line, text, head_text, base_text}, which is the shape a rule points at.
added_rows(diff) := rows if {
	rows := [{
		"path": file_path(file),
		"line": row.line,
		"text": row.text,
		"head_text": file_head_text(file),
		"base_text": file_base_text(file),
	} |
		some file in diff_files(diff)
		some row in added_lines(file_patch(file))
	]
}

removed_rows(diff) := rows if {
	rows := [{
		"path": file_path(file),
		"line": row.line,
		"text": row.text,
		"head_text": file_head_text(file),
		"base_text": file_base_text(file),
	} |
		some file in diff_files(diff)
		some row in removed_lines(file_patch(file))
	]
}

# contains_ci reports whether text contains needle, ignoring case.
contains_ci(text, needle) if {
	is_string(text)
	is_string(needle)
	contains(lower(text), lower(needle))
}

# service_tls_declared reports whether a file declares SERVICE_TLS true, either
# in a manifest (`SERVICE_TLS: "true"`) or in prose (`SERVICE_TLS true`).
service_tls_declared(text) if {
	is_string(text)
	regex.match(`(?i)SERVICE_TLS\s*:?\s*["']?true`, text)
}

# A line whose first non-space characters open a comment. A rule that reads code
# should not read a comment as code.
is_comment(text) if {
	is_string(text)
	regex.match(`^\s*(#|//|/\*|\*)`, text)
}

is_echo(text) if {
	is_string(text)
	regex.match(`(?i)(^|\s)echo\s`, text)
}

is_printf(text) if {
	is_string(text)
	regex.match(`(?i)(^|\s)printf\s`, text)
}

# is_manifest_path reports whether a path is a manifest a machine reads: a YAML
# or JSON document.
is_manifest_path(path) if {
	is_string(path)
	endswith(path, ".yaml")
}

is_manifest_path(path) if {
	is_string(path)
	endswith(path, ".yml")
}

is_manifest_path(path) if {
	is_string(path)
	endswith(path, ".json")
}

# machine_paths returns the absolute machine paths in text: a directory that
# exists on one machine only, so a file carrying one is not reproducible.
machine_paths(text) := found if {
	is_string(text)
	found := regex.find_n(`/(?:home|Users|root|tmp|mnt|opt|srv)/[A-Za-z0-9._@+-]+`, text, -1)
}

is_test_file(path) if {
	is_string(path)
	endswith(path, "_test.go")
}

is_test_file(path) if {
	is_string(path)
	endswith(path, "_test.ts")
}

is_test_file(path) if {
	is_string(path)
	endswith(path, ".test.ts")
}

is_test_file(path) if {
	is_string(path)
	contains(path, "/test/")
}

is_test_file(path) if {
	is_string(path)
	startswith(path, "test/")
}

is_ts_path(path) if {
	is_string(path)
	endswith(path, ".ts")
}

is_ts_path(path) if {
	is_string(path)
	endswith(path, ".tsx")
}

is_js_path(path) if {
	is_string(path)
	endswith(path, ".js")
}

is_js_path(path) if {
	is_string(path)
	endswith(path, ".mjs")
}

is_deno_json(path) if {
	is_string(path)
	endswith(path, "deno.json")
}

is_abc_path(path) if {
	is_string(path)
	contains(path, "lib/abc/")
}

is_common_path(path) if {
	is_string(path)
	contains(path, "lib/common/")
}

is_lib_path(path) if {
	is_string(path)
	contains(path, "lib/")
}

is_cli_path(path) if {
	is_string(path)
	contains(path, "hono-")
}

# concept_package returns the workspace package name an implementation or factory
# file under lib/ belongs to, and "" for abc, common or anything else.
concept_package(path) := name if {
	parts := split(path, "/")
	count(parts) >= 3
	parts[0] == "lib"
	parts[1] != ""
	parts[1] != "abc"
	parts[1] != "common"
	name := parts[1]
}

# imported_package returns the @publicdomainrelay package a line imports, and ""
# when the line names no workspace package.
imported_package(line) := name if {
	m := regex.find_all_string_submatch_n(`@publicdomainrelay/([a-z0-9][a-z0-9-]*)`, line, 1)
	count(m) == 1
	name := m[0][1]
}

imported_package(line) := "" if {
	m := regex.find_all_string_submatch_n(`@publicdomainrelay/([a-z0-9][a-z0-9-]*)`, line, 1)
	count(m) == 0
}

# is_impl_package reports whether a package name is a transport implementation
# rather than an abc, a common, a Hono factory or a shared helper.
is_impl_package(name) if {
	is_string(name)
	name != ""
	not endswith(name, "-abc")
	not endswith(name, "-common")
	not startswith(name, "hono-factory")
	name != "cli-args-env"
	name != "typescript-helpers"
}
