package deno_kcp.policies.code_safety

import rego.v1

import data.deno_kcp.lib.code

# The TypeScript ABC layering. Every capability is split into common, abc,
# implementation, Hono factory and CLI, and dependencies flow one way. A CLI
# reads no env and hardcodes no port; a library serves nothing; the abc layer is
# pure; common imports nothing project-local; a transport is a sibling package,
# never a flag; a package exports one mod.ts. The project also forbids comments
# in its TypeScript.

violations contains v if {
	row := code.added_rows(diff)[_]
	code.is_cli_path(row.path)
	contains(row.text, "Deno.env.get(")
	v := finding(
		"ts-deno-env-get-in-cli",
		row,
		sprintf("added line reads an environment variable in a CLI: %q; a CLI declares every option in cli-args-env.json and reads it through Command, never Deno.env.get", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	contains(row.text, "Deno.serve(")
	not contains(row.path, "typescript-helpers")
	v := finding(
		"ts-raw-deno-serve",
		row,
		sprintf("added line serves directly with Deno.serve: %q; every server is built through createServe, which owns the relay, the unix and tcp listeners and the shutdown hooks", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	code.is_ts_path(row.path)
	regex.match(`(?i)\b(port|host|hostname|addr|address)\b\s*[:=]\s*["']?\d{2,5}`, row.text)
	v := finding(
		"ts-hardcoded-port",
		row,
		sprintf("added line hardcodes a port or host in code: %q; a port or host is declared in cli-args-env.json or config.json, never written into the source", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	code.is_ts_path(row.path)
	regex.match(`\bextends\s+[A-Za-z0-9_.]*[Ff]actory\b`, row.text)
	v := finding(
		"ts-subclassed-hono-factory",
		row,
		sprintf("added line subclasses a Hono factory: %q; a factory is composed -- add options or a sibling factory -- never extended", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	code.is_abc_path(row.path)
	text_has_io(row.text)
	v := finding(
		"ts-io-in-abc",
		row,
		sprintf("added line performs I/O in the lib/abc layer: %q; lib/abc holds interfaces and pure state only, so timers, fetch, Deno.* and file reads live in an implementation package", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	code.is_common_path(row.path)
	imported := code.imported_package(row.text)
	imported != ""
	project_local_import(imported)
	v := finding(
		"ts-common-imports-project-local",
		row,
		sprintf("added line makes lib/common import project-local code: %q imports %s; lib/common imports external packages only, so shared types live here and nothing points up the layer arrow", [trim_space(row.text), imported]),
		{"imported": imported},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	code.is_deno_json(row.path)
	regex.match(`"\./[^"]+"\s*:`, row.text)
	not contains(row.text, `"./mod.ts"`)
	v := finding(
		"ts-submodule-export",
		row,
		sprintf("added line gives a package a sub-module export: %q; one package exports exactly one ./mod.ts, so a caller never reaches past the entrypoint", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	own := code.concept_package(row.path)
	imported := code.imported_package(row.text)
	code.is_impl_package(own)
	code.is_impl_package(imported)
	imported != own
	v := finding(
		"ts-cross-concept-import",
		row,
		sprintf("added line imports another concept's implementation: %s imports %s; a concept never imports a sibling concept, so the shared piece moves to lib/common", [own, imported]),
		{"from_package": own, "imported": imported},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	contains(row.text, "Deno.listen(")
	siblings := [r | some r in code.added_rows(diff); r.path == row.path]
	some closed in siblings
	contains(closed.text, ".close()")
	some rebound in siblings
	contains(rebound.text, "Deno.serve(")
	v := finding(
		"ts-port-sniffing-toctou",
		row,
		sprintf("added line sniffs a port with Deno.listen, then closes it and rebinds it: %q; the file closes a listener and serves on the same port, which races another process -- pass port 0 to Deno.serve and read the bound port from onListen", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	contains(row.text, "Deno.addSignalListener(")
	not code.is_cli_path(row.path)
	v := finding(
		"ts-signal-handler-outside-cli",
		row,
		sprintf("added line installs a signal handler outside a CLI: %q; Deno.addSignalListener belongs in the CLI entrypoint, never in a library the CLI imports", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	code.is_deno_json(row.path)
	regex.match(`"name"\s*:\s*"(@publicdomainrelay/)?common"`, row.text)
	v := finding(
		"ts-bare-common-package-name",
		row,
		sprintf("added line names a package bare common: %q; a common package is named ${concept}-common or a qualifier, because bare common collides with every concept's common layer", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	code.is_ts_path(row.path)
	regex.match(`(?i)(--transport\b|transport\s*===?\s*["']|kind\s*===?\s*["'](xrpc|grpc|ws|websocket)["'])`, row.text)
	v := finding(
		"ts-new-transport-as-flag",
		row,
		sprintf("added line selects a transport with a flag inside an existing implementation: %q; a new transport is a sibling package ${concept}-${transport}, never an if-branch inside the current one", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	code.is_ts_path(row.path)
	ts_source(row.path)
	regex.match(`^\s*(//|/\*|\*)`, row.text)
	v := finding(
		"ts-comments-in-code",
		row,
		sprintf("added line is a comment in a TypeScript file: %q; names and types carry the meaning in this project, and a comment in code is not allowed", [trim_space(row.text)]),
		{},
	)
}

# ts_source reports whether a path is the project's own TypeScript: a file under
# lib/ or under a hono-* package.
ts_source(path) if {
	code.is_lib_path(path)
}

ts_source(path) if {
	code.is_cli_path(path)
}

# text_has_io reports whether a line performs I/O the abc layer must not.
text_has_io(text) if {
	regex.match(`\bDeno\.|\bfetch\s*\(|\bsetInterval\s*\(|\bsetTimeout\s*\(|\breadTextFile\b|\breadFile\b|\bwriteTextFile\b|\bWebSocket\b`, text)
}

# project_local_import reports whether a workspace package is project-local code
# that lib/common must not depend on: an abc package, an implementation package
# or a Hono factory.
project_local_import(name) if {
	endswith(name, "-abc")
}

project_local_import(name) if {
	startswith(name, "hono-factory")
}

project_local_import(name) if {
	code.is_impl_package(name)
}
