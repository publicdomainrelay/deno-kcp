package deno_kcp.lib.refs

import rego.v1

# The reference grammar specd enforces. A reference either names the context
# itself, `self`, or is a prefix and a name: sc. for a system context, up. for
# an upstream, ov. for an overlay, orch. for an orchestrator. The name is a
# DNS-1123 subdomain.

ref_prefixes := ["sc.", "up.", "ov.", "orch."]

non_self_prefixes := ["sc.", "ov."]

is_dns1123_subdomain(name) if {
	is_string(name)
	count(name) <= 253
	regex.match(`^[a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*$`, name)
}

is_dns1123_label(name) if {
	is_string(name)
	count(name) <= 63
	regex.match(`^[a-z0-9]([-a-z0-9]*[a-z0-9])?$`, name)
}

is_ref(ref) if ref == "self"

is_ref(ref) if {
	some prefix in ref_prefixes
	startswith(ref, prefix)
	is_dns1123_subdomain(trim_prefix(ref, prefix))
}

ref_prefix(ref) := prefix if {
	some prefix in ref_prefixes
	startswith(ref, prefix)
}

ref_name(ref) := name if {
	prefix := ref_prefix(ref)
	name := trim_prefix(ref, prefix)
}

# An arch id is a dotted name, at least two segments, and never the word self.
is_arch_id(id) if {
	is_string(id)
	id != "self"
	regex.match(`^[A-Za-z][A-Za-z0-9_-]*\.[A-Za-z0-9][A-Za-z0-9._-]*$`, id)
}

# Requirement ids, interface names and change names are kebab-case and the
# prefixed ones carry their prefix.
requirement_id_pattern := `^r\.[a-z0-9]+(-[a-z0-9]+)*$`

change_name_pattern := `^[a-z0-9]([-a-z0-9]*[a-z0-9])?-(c2s-[0-9a-f]{12}-[0-9a-f]{12}|s2c-[0-9a-f]{12})(-a[0-9]+)?$`

is_change_name(name) if regex.match(change_name_pattern, name)

is_change_name_for(name, context) if {
	is_change_name(name)
	startswith(name, sprintf("%s-", [context]))
}

# A hash in this system is a sha256 digest, lower or upper hex, 64 characters.
is_hash(value) if {
	is_string(value)
	regex.match(`^[0-9a-fA-F]{64}$`, value)
}

short_hash(value) := short if {
	is_hash(value)
	short := substring(value, 0, 12)
}

# An absolute machine path is a path that names a directory on one machine and
# so cannot be reproduced anywhere else.
machine_path_pattern := `/(?:home|Users|root|tmp|mnt|opt|srv)/[A-Za-z0-9._@+-]+`

machine_paths(text) := found if {
	found := regex.find_n(machine_path_pattern, text, -1)
}

has_machine_path(text) if count(machine_paths(text)) > 0
