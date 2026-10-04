package deno_kcp.policies.code_safety

import rego.v1

import data.deno_kcp.lib.code
import data.deno_kcp.lib.text

# The class of defect this repository's real change contains: a host-side check
# that fetches `http://` a listener whose pod declares SERVICE_TLS true, so the
# request never reaches the TLS listener the workload actually serves, and the
# check proves nothing. A fetch of a TLS listener has to be `https://`, and a
# check that disables verification -- `-k`, `--insecure`, a trust-all CA -- has
# to be argued for rather than added quietly. A secret or a private key added to
# a diff is the same family: something safety-relevant slipped into the change.

violations contains v if {
	row := code.added_rows(diff)[_]
	contains(row.text, "http://")
	text.contains_any(row.text, ["curl", "wget", "http.get", "http.request", "axios", "fetch("])
	code.service_tls_declared(row.head_text)
	not code.is_comment(row.text)
	not code.is_echo(row.text)
	v := finding(
		"safety-http-fetch-of-tls-listener",
		row,
		sprintf("added line fetches http:// a host whose file declares SERVICE_TLS true: %q; every service pod sets SERVICE_TLS true, so the listener is the TLS one and the fetch must be https:// -- an http:// fetch of a TLS listener is not a check of anything", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	text.contains_any(row.text, ["InsecureSkipVerify"])
	v := finding(
		"safety-insecure-tls-flag",
		row,
		sprintf("added line disables certificate verification: %q; a TLS client must verify the leaf, and a bypass belongs in a written argument, not in the code", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	regex.match(`(?i)--insecure(\s|$)`, row.text)
	v := finding(
		"safety-insecure-tls-flag",
		row,
		sprintf("added line disables certificate verification: %q; a TLS client must verify the leaf, and a bypass belongs in a written argument, not in the code", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	regex.match(`(?i)\bcurl\b[^\n]*\s-\w*k`, row.text)
	v := finding(
		"safety-insecure-tls-flag",
		row,
		sprintf("added curl invocation carries -k, which skips certificate verification: %q; the check should verify the leaf against the workspace authority, and a deliberate bypass (the leaf is not SAN'd to the fetched name) belongs in the requirement text rather than silent in the script", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	regex.match(`(?i)rejectUnauthorized\s*:\s*false`, row.text)
	v := finding(
		"safety-insecure-tls-flag",
		row,
		sprintf("added line disables certificate verification: %q; a TLS client must verify the leaf, and a bypass belongs in a written argument, not in the code", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	regex.match(`(?i)(--validate=false|--no-verify|--skip-tls-verify|--insecure-skip-tls-verify|--tls-no-verify\b)`, row.text)
	v := finding(
		"safety-verification-disabled",
		row,
		sprintf("added line disables a verification step: %q; a verification runs and gates the change, and a flag that turns it off defeats the gate", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	regex.match(`(?i)(NODE_TLS_REJECT_UNAUTHORIZED\s*=\s*0|GIT_SSL_NO_VERIFY\s*=\s*true|SSL_VERIFY\s*=\s*false|CURL_CA_BUNDLE\s*=\s*/dev/null|trust[_ -]?all[_ -]?ca)`, row.text)
	v := finding(
		"safety-trust-all-ca",
		row,
		sprintf("added line trusts every certificate: %q; the trust bundle is the workspace's OpenBao authority, and a setting that accepts any certificate disables the check it was meant to make", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	regex.match(`(?i)\b(curl|wget)\b[^|]*\|\s*(sudo\s+)?(sh|bash|zsh|dash|python3?|node|perl|ruby)\b`, row.text)
	v := finding(
		"safety-shell-pipe-to-interpreter",
		row,
		sprintf("added line pipes a download straight into an interpreter: %q; a downloaded script runs only after its checksum is verified against a pin, never piped into sh", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	text.contains_any(row.text, ["curl", "wget"])
	regex.match(`https?://`, row.text)
	regex.match(`(?i)(-o\s|-O\b|--output|\.tar\.gz\b|\.tgz\b|\.zip\b|\.deb\b|\.rpm\b|\.sh\b)`, row.text)
	not regex.match(`(?i)(sha256|sha512|sha1sum|sha256sum|--hash|checksum|md5sum)`, row.text)
	v := finding(
		"safety-unpinned-remote-fetch",
		row,
		sprintf("added line downloads a remote artifact with no checksum or version pin: %q; a download is pinned to a version and verified against a sha256 before it is used", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	text.secret_like(row.text)
	v := finding(
		"safety-secret-literal",
		row,
		sprintf("added line commits something that looks like a key, token or password: %q; a secret is injected at run time and never written into source", [trim_space(row.text)]),
		{"matches": text.secret_matches(row.text)},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	regex.match(`-----BEGIN [A-Z ]*PRIVATE KEY-----`, row.text)
	v := finding(
		"safety-private-key-in-diff",
		row,
		sprintf("added line is a PEM private key: %q; a private key never enters a diff, it is generated on the host and injected into the guest", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.added_rows(diff)[_]
	regex.match(`(\bt\.Skip\(|\.Skip\(|\bxit\(|\bxdescribe\(|test\.todo\(|\bit\.skip\(|\bdescribe\.skip\()`, row.text)
	v := finding(
		"safety-disabled-test",
		row,
		sprintf("added line skips a test: %q; a test is fixed or its behaviour is argued, never skipped, because a skipped test hides a regression", [trim_space(row.text)]),
		{},
	)
}

violations contains v if {
	row := code.removed_rows(diff)[_]
	regex.match(`(?i)(assert|require\.|expect\()`, row.text)
	replacements := [r |
		some r in code.added_rows(diff)
		r.path == row.path
		regex.match(`(?i)(assert|require\.|expect\()`, r.text)
	]
	count(replacements) == 0
	v := finding(
		"safety-weakened-assertion",
		row,
		sprintf("removed line is an assertion with no replacement in the same file: %q; an assertion is replaced by a stronger one or a citation, never deleted to make a change pass", [trim_space(row.text)]),
		{},
	)
}

# A printed instruction is followed by a human, so guidance that tells a reader
# to fetch http:// a TLS listener is a defect of its own: the executed check was
# moved to https:// and the printed one was left behind. One finding per file,
# at its first such line.
violations contains v if {
	tls_in_change
	row := code.added_rows(diff)[_]
	http_guidance(row)
	urls := text.urls(row.text)
	count(urls) > 0
	matches := [r |
		some r in code.added_rows(diff)
		r.path == row.path
		http_guidance(r)
		count(text.urls(r.text)) > 0
	]
	row.line == min([r.line | some r in matches])
	v := finding(
		"safety-stale-tls-guidance",
		row,
		sprintf("added line prints an http:// check as operator guidance: %q; it names %s, and the change's manifests declare SERVICE_TLS true, so the listener is the TLS one and the printed check asserts nothing -- the guidance should print https://", [trim_space(row.text), urls[0]]),
		{"url": urls[0], "service_tls": true},
	)
}

# safety-absolute-machine-path-in-manifest: a path that names a directory on one
# machine only, written into a manifest a machine reads. The manifest has to be
# reproducible, so the path is repo-relative or injected by the apply script.
violations contains v if {
	row := code.added_rows(diff)[_]
	code.is_manifest_path(row.path)
	paths := code.machine_paths(row.text)
	count(paths) > 0
	v := finding(
		"safety-absolute-machine-path-in-manifest",
		row,
		sprintf("added line writes an absolute machine path into a manifest: %q names %s; an example manifest must be portable, so the path is repo-relative or injected by the apply script", [trim_space(row.text), paths[0]]),
		{"paths": paths},
	)
}

# tls_in_change reports whether any file in the diff declares SERVICE_TLS true,
# so a listener the change touches is the TLS one.
tls_in_change if {
	some file in code.diff_files(diff)
	code.service_tls_declared(code.file_head_text(file))
}

# http_guidance reports whether an added line is text a human reads: an echo, a
# printf, a comment, or the body of a heredoc.
http_guidance(row) if {
	code.is_echo(row.text)
}

http_guidance(row) if {
	code.is_printf(row.text)
}

http_guidance(row) if {
	code.is_comment(row.text)
}

http_guidance(row) if {
	heredoc_body(row)
}

# heredoc_open returns the terminator a line opens (`<<EOF`, `<<-'EOF'`), or ""
# when the line opens none.
heredoc_open(line) := term if {
	m := regex.find_all_string_submatch_n(`<<-?\s*['"]?([A-Za-z_][A-Za-z0-9_]*)['"]?`, line, 1)
	count(m) == 1
	term := m[0][1]
}

heredoc_open(line) := "" if {
	m := regex.find_all_string_submatch_n(`<<-?\s*['"]?([A-Za-z_][A-Za-z0-9_]*)['"]?`, line, 1)
	count(m) == 0
}

# heredoc_body reports whether a line sits inside a heredoc opened earlier in the
# head file and not yet terminated.
heredoc_body(row) if {
	row.line > 1
	lines := code.head_lines(row.head_text)
	openers := sort([i | some i in numbers.range(0, row.line - 2); heredoc_open(lines[i]) != ""])
	count(openers) > 0
	i := openers[count(openers) - 1]
	term := heredoc_open(lines[i])
	between := numbers.range(i + 1, row.line - 2)
	count([j | some j in between; trim_space(lines[j]) == term]) == 0
}
