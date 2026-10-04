package deno_kcp.lib.text

import rego.v1

# Analysis over the prose a spec carries. A requirement is a sentence an
# engineer can check, so these are the predicates a requirement sentence has to
# satisfy.

placeholder_markers := ["TODO", "TBD", "FIXME", "XXX", "PLACEHOLDER", "HACK", "WIP"]

# Words that assert nothing an engineer could test against.
vague_terms := [
	"robust",
	"fast",
	"slow",
	"secure",
	"reliable",
	"scalable",
	"efficient",
	"reasonable",
	"appropriate",
	"adequate",
	"proper",
	"properly",
	"correctly",
	"sensible",
	"clean",
	"nice",
	"good",
	"bad",
	"better",
	"worse",
	"seamless",
	"flexible",
	"significant",
	"minimal",
	"optimal",
	"performant",
	"user-friendly",
	"easy",
	"simple",
	"complex",
	"various",
	"several",
	"some",
	"many",
	"few",
	"etc",
	"and so on",
	"and/or",
]

# Verbs that describe an intention rather than an observable fact.
non_normative := [
	"should consider",
	"may want",
	"might",
	"could",
	"would",
	"we should think about",
	"is expected to maybe",
	"if possible",
	"where feasible",
	"as needed",
	"as appropriate",
	"when convenient",
	"try to",
	"attempt to",
	"ideally",
	"hopefully",
	"prefer",
]

words(text) := out if {
	out := [word | some word in split(trim_space(text), " "); word != ""]
}

word_count(text) := n if {
	n := count(words(text))
}

normalized(text) := out if {
	out := lower(trim_space(text))
}

contains_any(text, needles) if {
	lowered := lower(text)
	some needle in needles
	contains(lowered, lower(needle))
}

has_placeholder(text) if contains_any(text, placeholder_markers)

vague_terms_in(text) := found if {
	found := [term | some term in vague_terms; contains_any(text, [term])]
}

non_normative_in(text) := found if {
	found := [phrase | some phrase in non_normative; contains_any(text, [phrase])]
}

has_vague_term(text) if count(vague_terms_in(text)) > 0

has_non_normative_phrase(text) if count(non_normative_in(text)) > 0

# The strength a sentence claims, read off its modal verbs. A prohibition is a
# MUST: "may not start" forbids, it does not permit. The MUST phrases are
# checked first and excluded from the weaker levels, so a prohibition is never
# read as a permission just because it contains the word may.
must_phrases := [
	"must not",
	"may not",
	"shall not",
	"must ",
	"shall ",
	"is required to",
	"is required",
	"are required",
	"is forbidden",
	"are forbidden",
	"never ",
	"only when",
	"under no circumstances",
]

should_phrases := [
	"should ",
	"should not",
	"ought to",
	"is recommended",
	"are recommended",
	"is encouraged",
	"are encouraged",
	"preferably",
]

# "can" is deliberately absent. In this corpus it is almost always a capability
# ("a client can verify it"), not a permission, and reading a capability as a
# permission made a MUST requirement whose text says "clients can decode" look
# like a MAY. A permission is written "may", "is allowed to" or "is optional".
may_phrases := [
	"may ",
	"is allowed to",
	"are allowed to",
	"is optional",
	"are optional",
	"at its discretion",
]

implied_level(text) := "MUST" if contains_any(text, must_phrases)

implied_level(text) := "SHOULD" if {
	not contains_any(text, must_phrases)
	contains_any(text, should_phrases)
}

implied_level(text) := "MAY" if {
	not contains_any(text, must_phrases)
	not contains_any(text, should_phrases)
	contains_any(text, may_phrases)
}

level_disagrees(declared, text) := implied if {
	implied := implied_level(text)
	implied != declared
}

mentions_identifier(text, identifier) if contains(text, identifier)

# Sentences: a requirement text is usually one sentence, and a text with many
# sentences is often several requirements wearing one id.
sentence_count(text) := n if {
	trimmed := trim_space(text)
	n := count([s | some s in split(trimmed, ". "); trim_space(s) != ""])
}

starts_upper(text) if {
	trimmed := trim_space(text)
	first := substring(trimmed, 0, 1)
	first == upper(first)
	first != lower(first)
}

ends_with_period(text) if endswith(trim_space(text), ".")

# Casing of an identifier: requirement ids are lower kebab-case, prefixed r.
is_kebab(text) if regex.match(`^[a-z0-9]+(-[a-z0-9]+)*$`, text)

is_requirement_id(text) if regex.match(`^r\.[a-z0-9]+(-[a-z0-9]+)*$`, text)

is_interface_name(text) if {
	count(trim_space(text)) > 0
}

# Prose that names a secret by value rather than by where it is injected. A
# spec that carries a literal key is a spec that leaks it.
secret_patterns := [
	`(?i)0x[0-9a-f]{64}`,
	`(?i)\b[0-9a-f]{64}\b`,
	`(?i)-----BEGIN [A-Z ]*PRIVATE KEY-----`,
	`(?i)\b(sk|pk|ghp|gho|glpat|xox[baprs])[-_][A-Za-z0-9_-]{16,}`,
	`(?i)\bAKIA[0-9A-Z]{16}\b`,
	`(?i)\beyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}`,
	`(?i)(password|passwd|secret|token|api[_-]?key)\s*[:=]\s*['"]?[A-Za-z0-9/+_-]{12,}`,
]

secret_like(text) if {
	some pattern in secret_patterns
	regex.match(pattern, text)
}

secret_matches(text) := found if {
	found := [match |
		some pattern in secret_patterns
		some match in regex.find_n(pattern, text, 5)
	]
}

urls(text) := found if {
	found := regex.find_n(`https?://[^\s"'\)\]]+`, text, -1)
}

http_urls(text) := found if {
	found := [url | some url in urls(text); startswith(url, "http://")]
}

https_urls(text) := found if {
	found := [url | some url in urls(text); startswith(url, "https://")]
}

mentions_tls(text) if contains_any(text, ["SERVICE_TLS", "TLS", "tls", "https", "certificate", "leaf"])

limits_curl_insecure(text) if contains_any(text, ["-k", "--insecure", "curl -k"])
