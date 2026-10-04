package deno_kcp.lib.violation

import rego.v1

# A violation is the one object every policy emits. It is keyed off the
# violation, so a report can be grouped by it, and it carries the policy that
# raised it, the location it was found at, and whatever extra info the finding
# needs. The severity, level and title are not set here: a policy declares them
# once in its metadata, and build_report joins them in, so a violation rule
# states only what it found.

build(policy, violation, location, message, details) := v if {
	v := {
		"id": sprintf("%s/%s", [policy, violation]),
		"policy": policy,
		"violation": violation,
		"location": location,
		"message": message,
		"details": details,
	}
}

# A location names where the violation was found. kind says what sort of thing
# it was found in, context and path say which document, pointer is a JSON
# pointer into it, and file and line are set when the finding is about a file
# on disk rather than a field of a document.
location(kind, context, path, pointer) := loc if {
	loc := {
		"kind": kind,
		"context": context,
		"path": path,
		"pointer": pointer,
		"file": "",
		"line": 0,
	}
}

location_at(kind, context, path, pointer, file, line) := loc if {
	loc := {
		"kind": kind,
		"context": context,
		"path": path,
		"pointer": pointer,
		"file": file,
		"line": line,
	}
}

spec_location(context, path, pointer) := location("spec", context, path, pointer)

requirement_location(context, path, index) := location(
	"spec_requirement",
	context,
	path,
	sprintf("/spec/requirements/%d", [index]),
)

interface_location(context, path, index) := location(
	"spec_interface",
	context,
	path,
	sprintf("/spec/interfaces/%d", [index]),
)

context_location(context, path) := location("spec_context", context, path, "/spec")

status_location(context, path, pointer) := location("status", context, path, pointer)

change_location(change_name, path, pointer) := location("spec_change", change_name, path, pointer)

file_location(context, file, line) := location_at("code_file", context, "", "", file, line)

# severity_of maps a requirement level to the severity a violation of it
# carries. A MUST is an error, a SHOULD a warning, a MAY only information.
severity_of("MUST") := "error"

severity_of("SHOULD") := "warning"

severity_of("MAY") := "info"

severity_of(_) := "error"

tally(rows, key) := t if {
	keys := {object.get(row, key, "") | some row in rows}
	t := {k: n |
		some k in keys
		n := count([row | some row in rows; object.get(row, key, "") == k])
	}
}

# enrich joins each violation with the metadata its policy declared for it.
enrich(items, metadata) := enriched if {
	enriched := [e |
		some item in items
		meta := object.get(object.get(metadata, item.policy, {}), item.violation, {})
		e := object.union(item, {
			"severity": object.get(meta, "severity", "error"),
			"level": object.get(meta, "level", "MUST"),
			"title": object.get(meta, "title", ""),
		})
	]
}

# Sort by id, then by where it was found, then by what it says. Two violations
# of the same rule at two locations both survive: a report groups by id but
# never collapses two findings into one.
sort_key(item, index) := key if {
	location := object.get(item, "location", {})
	key := [
		item.id,
		object.get(location, "context", ""),
		object.get(location, "path", ""),
		object.get(location, "file", ""),
		object.get(location, "pointer", ""),
		item.message,
		index,
	]
}

sort_by_id(items) := sorted if {
	keyed := [[sort_key(item, index), item] | some index, item in items]
	sorted := [pair[1] | some pair in sort(keyed)]
}

group_by_id(items) := grouped if {
	ids := {item.id | some item in items}
	grouped := {id: [item | some item in items; item.id == id] | some id in ids}
}

build_report(items, metadata) := report if {
	enriched := enrich(items, metadata)
	sorted := sort_by_id(enriched)
	errors := [v | some v in sorted; v.severity == "error"]
	warnings := [v | some v in sorted; v.severity == "warning"]
	infos := [v | some v in sorted; v.severity == "info"]
	report := {
		"violations": sorted,
		"by_id": group_by_id(sorted),
		"count": count(sorted),
		"errors": count(errors),
		"warnings": count(warnings),
		"infos": count(infos),
		"by_severity": tally(sorted, "severity"),
		"by_policy": tally(sorted, "policy"),
		"by_violation": tally(sorted, "violation"),
		"passed": count(errors) == 0,
	}
}
