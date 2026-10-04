package deno_kcp.lib.paths

import rego.v1

# The spec tree refers to code with code refs. A code ref is a kind, a colon,
# and a payload. The kinds are the ones specd's CodeRefKinds admits.
code_ref_schemes := {
	"file",
	"package",
	"module",
	"function",
	"method",
	"constructor",
	"struct",
	"interface",
	"class",
	"type_alias",
	"enum",
	"type",
	"variable",
	"constant",
	"import",
}

is_absolute(path) if startswith(path, "/")

has_parent_escape(path) if {
	some part in split(path, "/")
	part == ".."
}

is_repo_relative(path) if {
	not is_absolute(path)
	not has_parent_escape(path)
	path != ""
}

has_windows_separator(path) if contains(path, "\\")

is_code_ref(ref) if {
	is_string(ref)
	parts := split(ref, ":")
	count(parts) >= 2
	parts[0] in code_ref_schemes
	payload := concat(":", array.slice(parts, 1, count(parts)))
	payload != ""
	not regex.match(`\s`, payload)
}

code_ref_kind(ref) := kind if {
	parts := split(ref, ":")
	count(parts) >= 2
	kind := parts[0]
}

# A code ref that names a path on disk. Only these can be checked against the
# file index; a ref to a symbol is checked against the observed interfaces.
is_file_ref(ref) if {
	code_ref_kind(ref) == "file"
}

# The part after the kind. For a file ref it is a repo-relative path; for a
# symbol ref it is either a name (Type.Method) or a codegraph id.
code_ref_payload(ref) := payload if {
	payload := code_ref_path(ref)
}

# Every symbol ref in the real trees is a codegraph id: 32 hex characters, the
# id the observer assigned the symbol it saw. A symbol ref resolves when that id
# is one of the context's observed interfaces, not when it names a file.
codegraph_id_pattern := `^[0-9a-f]{32}$`

is_codegraph_id(payload) if {
	is_string(payload)
	regex.match(codegraph_id_pattern, payload)
}

is_codegraph_ref(ref) if {
	is_code_ref(ref)
	is_codegraph_id(code_ref_payload(ref))
}

code_ref_scheme(ref) := scheme if {
	parts := split(ref, ":")
	count(parts) >= 2
	scheme := parts[0]
}

# The path of a code ref, with the scheme removed. A path may itself contain a
# colon, so only the first one is the separator.
code_ref_path(ref) := path if {
	parts := split(ref, ":")
	count(parts) >= 2
	path := concat(":", array.slice(parts, 1, count(parts)))
}

# A ref that names a definition inside a file rather than the whole file, as
# file:internal/provider/watch.go:discoverWorkspaces does in arch.yaml.
code_ref_file(ref) := file if {
	path := code_ref_path(ref)
	parts := split(path, ":")
	file := parts[0]
}

code_ref_symbol(ref) := symbol if {
	path := code_ref_path(ref)
	parts := split(path, ":")
	count(parts) >= 2
	symbol := parts[1]
}

has_symbol(ref) if {
	code_ref_symbol(ref)
}

is_test_path(path) if endswith(path, "_test.go")

is_go_path(path) if endswith(path, ".go")

is_shell_path(path) if endswith(path, ".sh")

is_yaml_path(path) if {
	endswith(path, ".yaml")
}

is_yaml_path(path) if {
	endswith(path, ".yml")
}

is_markdown_path(path) if endswith(path, ".md")

is_rego_path(path) if endswith(path, ".rego")

is_manifest_path(path) if {
	some suffix in [".yaml", ".yml", ".json"]
	endswith(path, suffix)
}

# A path under third_party/ is vendored code. The spec tree grows a context per
# directory of it, and those contexts are not the repository's own spec.
is_vendored(path) if startswith(path, "third_party/")

is_dot_path(path) if startswith(path, ".")

basename(path) := name if {
	parts := split(path, "/")
	name := parts[count(parts) - 1]
}

dirname(path) := dir if {
	parts := split(path, "/")
	dir := concat("/", array.slice(parts, 0, count(parts) - 1))
}

# A path that a spec file may name: repo-relative, forward slashes, not
# absolute, no parent escape, not empty.
is_named_path(path) if {
	is_string(path)
	path != ""
	is_repo_relative(path)
	not has_windows_separator(path)
}

dedupe(items) := out if {
	out := [item | some item in {i | some i in items}]
}
