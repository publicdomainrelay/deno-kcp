package deno_kcp.lib.spec

import rego.v1

# Accessors over the spec tree. Every one of them tolerates a missing field and
# returns the empty value for its type, so a policy never has to guard a chain
# of object.get calls before it can ask a question.

requirement_levels := {"MUST", "SHOULD", "MAY"}

level_rank := {"MUST": 3, "SHOULD": 2, "MAY": 1}

interface_kinds := {
	"method",
	"struct",
	"function",
	"type_alias",
	"interface",
	"type",
	"variable",
	"constant",
	"field",
}

# Scope. A tree that was populated on top of a vendored submodule grows a
# context per directory of it. Those are real spec content but they are not the
# repository's own spec, so the default scope is the repository's own contexts
# and `scope: all` widens it.
scope := scope if {
	scope := object.get(object.get(input, "options", {}), "scope", "own")
}

is_vendored_context(name) if startswith(name, "third-party-")

in_scope(_) if scope == "all"

in_scope(name) if {
	scope == "own"
	not is_vendored_context(name)
}

context_names(tree) := names if {
	names := [name |
		some name, ctx in object.get(tree, "contexts", {})
		is_object(object.get(ctx, "spec", null))
		in_scope(name)
	]
}

# Every context the tree holds a spec for, in scope, as {name, context, path}.
contexts_in_scope(tree) := rows if {
	rows := [
	{"name": name, "context": ctx, "path": ctx.spec_path} |
		some name, ctx in object.get(tree, "contexts", {})
		is_object(object.get(ctx, "spec", null))
		in_scope(name)
	]
}

# Every context the tree knows at all, including one a change named but the
# tree holds no spec for.
all_contexts(tree) := rows if {
	rows := [{"name": name, "context": ctx, "path": ctx.spec_path} |
		some name, ctx in object.get(tree, "contexts", {})
	]
}

# The whole parsed specs/<context>.yaml.
document_of(ctx) := document if {
	document := object.get(ctx, "document", {})
	is_object(document)
}

document_metadata(ctx) := metadata if {
	metadata := object.get(ctx, "metadata", {})
	is_object(metadata)
}

# The `spec` block of that document: intent, repository, upstream,
# requirements, interfaces.
spec_of(ctx) := spec if {
	spec := object.get(ctx, "spec", {})
	is_object(spec)
}

requirements(ctx) := reqs if {
	reqs := object.get(spec_of(ctx), "requirements", [])
	is_array(reqs)
}

interfaces(ctx) := ifaces if {
	ifaces := object.get(spec_of(ctx), "interfaces", [])
	is_array(ifaces)
}

intent(ctx) := text if {
	text := object.get(spec_of(ctx), "intent", "")
	is_string(text)
}

repository_of(ctx) := name if {
	name := object.get(spec_of(ctx), "repository", "")
}

upstream_of(ctx) := upstream if {
	upstream := object.get(spec_of(ctx), "upstream", "")
}

requirement_id(req) := id if {
	id := object.get(req, "id", "")
}

requirement_level(req) := level if {
	level := object.get(req, "level", "")
}

requirement_text(req) := text if {
	text := object.get(req, "text", "")
}

requirement_code_refs(req) := refs if {
	refs := object.get(req, "codeRefs", [])
	is_array(refs)
}

interface_file(iface) := file if {
	file := object.get(iface, "file", "")
}

interface_kind(iface) := kind if {
	kind := object.get(iface, "kind", "")
}

interface_name(iface) := name if {
	name := object.get(iface, "name", "")
}

interface_signature(iface) := signature if {
	signature := object.get(iface, "signature", "")
}

# Every requirement in the tree, as {context, index, requirement}.
all_requirements(tree) := rows if {
	rows := [
	{"context": name, "index": index, "requirement": req, "path": ctx.spec_path} |
		some name, ctx in object.get(tree, "contexts", {})
		is_object(object.get(ctx, "spec", null))
		in_scope(name)
		some index, req in requirements(ctx)
	]
}

# Every interface in the tree, as {context, index, interface}.
all_interfaces(tree) := rows if {
	rows := [
	{"context": name, "index": index, "interface": iface, "path": ctx.spec_path} |
		some name, ctx in object.get(tree, "contexts", {})
		is_object(object.get(ctx, "spec", null))
		in_scope(name)
		some index, iface in interfaces(ctx)
	]
}

all_code_refs(tree) := rows if {
	rows := [
	{"context": row.context, "requirement": row.requirement.id, "index": row.index, "ref": ref} |
		some row in all_requirements(tree)
		some ref in requirement_code_refs(row.requirement)
	]
}

all_interface_files(tree) := rows if {
	rows := [
	{"context": row.context, "interface": row.interface.name, "index": row.index, "file": row.interface.file} |
		some row in all_interfaces(tree)
	]
}

requirement_ids(ctx) := ids if {
	ids := {requirement_id(req) | some req in requirements(ctx)}
}

duplicated(values) := dupes if {
	dupes := {value |
		some value in values
		count([v | some v in values; v == value]) > 1
	}
}

# The contexts the tree says exist but holds no spec for. A change that names
# one of these names a context the tree cannot resolve.
dangling_contexts(tree) := names if {
	names := {name |
		some name, ctx in object.get(tree, "contexts", {})
		not is_object(object.get(ctx, "spec", null))
	}
}

observed_files(tree) := paths if {
	paths := object.get(tree, "observed_files", [])
}

file_present(tree, path) if {
	entry := object.get(object.get(tree, "files", {}), path, null)
	is_object(entry)
	entry.present == true
}

file_known(tree, path) if {
	object.get(object.get(tree, "files", {}), path, null) != null
}

text_of(tree, path) := text if {
	text := object.get(object.get(tree, "texts", {}), path, "")
}

context_doc(ctx) := doc if {
	doc := object.get(ctx, "context_doc", null)
	is_object(doc)
}

changes_of(ctx) := changes if {
	changes := object.get(ctx, "changes", {})
}

all_changes(tree) := rows if {
	rows := [change | some _, change in object.get(tree, "changes", {})]
}

change_spec(change) := spec if {
	spec := object.get(object.get(change, "document", {}), "spec", {})
	is_object(spec)
}

change_status(change) := status if {
	status := object.get(object.get(change, "document", {}), "status", {})
	is_object(status)
}

change_direction(change) := direction if {
	direction := object.get(change_spec(change), "direction", "")
}

change_context(change) := context if {
	context := object.get(change_spec(change), "systemContext", "")
}

change_delta_requirements(change) := reqs if {
	reqs := object.get(object.get(change_spec(change), "delta", {}), "requirements", [])
	is_array(reqs)
}

change_files_touched(change) := files if {
	files := object.get(change_status(change), "filesTouched", [])
	is_array(files)
}

change_acceptance(change) := rows if {
	rows := object.get(change_status(change), "acceptance", [])
	is_array(rows)
}

status_of(ctx) := status if {
	status := object.get(ctx, "status", {})
	is_object(status)
}

conditions(ctx) := rows if {
	rows := object.get(status_of(ctx), "conditions", [])
	is_array(rows)
}

condition_of_type(ctx, type) := cond if {
	some cond in conditions(ctx)
	cond.type == type
}

observed(ctx) := obs if {
	obs := object.get(status_of(ctx), "observed", {})
	is_object(obs)
}

observed_fingerprint(ctx) := fp if {
	fp := object.get(observed(ctx), "fingerprint", "")
}

realized_spec_hash(ctx) := hash if {
	hash := object.get(status_of(ctx), "realizedSpecHash", "")
}

synced_fingerprint(ctx) := fp if {
	fp := object.get(status_of(ctx), "syncedFingerprint", "")
}

contexts_of_arch(arch) := rows if {
	rows := object.get(arch, "system_contexts", [])
	is_array(rows)
}

arch_requirement_ids(entry) := ids if {
	ids := {id | some req in object.get(entry, "requirements", []); id := req.id}
}

arch_context_id(entry) := id if {
	id := object.get(entry, "id", "")
}

arch_context_name(entry) := name if {
	name := object.get(entry, "name", "")
}

# "sc.foo-bar" -> "foo-bar", the name the specs/ and status/ directories use.
arch_id_to_name(id) := name if {
	name := trim_prefix(id, "sc.")
}

arch_name_to_id(name) := id if {
	id := sprintf("sc.%s", [name])
}
