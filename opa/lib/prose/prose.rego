package deno_kcp.lib.prose

import rego.v1

# Helpers shared by the prose-facing policies. Each answers one question a
# policy asks about a sentence rather than about the tree: does a requirement
# repeat its own id, does a text enumerate bare names (the heuristic specd's
# EnumeratesNames uses), does a signature fit its kind, does a text name a verb
# an observer could check, do two texts share a long verbatim run, and does an
# edit to a text change anything but its punctuation.

# --- id echoed back ------------------------------------------------------

id_words(id) := words if {
	words := split(trim_prefix(id, "r."), "-")
}

# A requirement repeats its own id when its text carries a run of three
# consecutive id words, in order and adjacent, so the text says what the id
# already said instead of what would satisfy it.
repeats_identifier(body, id) if {
	is_string(body)
	is_string(id)
	words := id_words(id)
	count(words) >= 3
	some i in numbers.range(0, count(words) - 3)
	run := array.slice(words, i, i + 3)
	pattern := sprintf(`(?i)\b%s\b`, [concat(`[^A-Za-z0-9]+`, run)])
	regex.match(pattern, body)
}

# --- bare enumeration (specd's EnumeratesNames) --------------------------

# An identifier as specd reads one: a letter, underscore, dot or star first,
# then letters, digits, underscores, dots and stars.
identifier_like(value) if {
	is_string(value)
	value != ""
	regex.match(`^[A-Za-z_.*][A-Za-z0-9_.*]*$`, value)
}

# The whole text is a comma-separated list of bare identifiers: every part is
# one identifier and nothing else. A sentence with a comma in it is not one.
enumerates_names(body) if {
	is_string(body)
	parts := split(trim_space(body), ",")
	count(parts) >= 3
	every part in parts {
		trimmed := trim(trim_suffix(trim(part, " \t"), "."), " \t")
		trimmed != ""
		not regex.match(`[ \t]`, trimmed)
		identifier_like(trimmed)
	}
}

# --- a signature that fits its kind --------------------------------------

# A function or method signature carries a parameter list, so it has a paren.
signature_fits_kind(kind, signature) if {
	kind in {"function", "method"}
	contains(signature, "(")
}

# A struct or type alias reports an empty parameter list, () , or the type
# declaration itself, as the observer writes it: type Name struct { ... }, or
# the bare struct Name form.
signature_fits_kind(kind, signature) if {
	kind in {"struct", "type_alias"}
	signature == "()"
}

signature_fits_kind(kind, signature) if {
	kind in {"struct", "type_alias"}
	startswith(trim_space(signature), "type ")
}

signature_fits_kind(kind, signature) if {
	kind in {"struct", "type_alias"}
	regex.match(`^\s*struct\s+[A-Za-z_]`, signature)
}

# Any other kind has no shape to violate.
signature_fits_kind(kind, _) if {
	is_string(kind)
	not kind in {"function", "method", "struct", "type_alias"}
}

# --- a verb an observer could check --------------------------------------

# The verbs an engineer can watch happen. A MUST whose text names none of them
# states a wish, not a requirement. Each stem carries the inflections a third
# person, past or continuous form adds.
observable_verb_pattern := `(?i)\b(?:write|read|set|return|creat|remov|exit|report|resolv|reject|emit|requir|be|is|are|was|were|ha(?:ve|s)|run|start|stop|implement|register|convert|map|carr(?:y|ies|ied)|decod|encod|produc|expos|verif|cover|match|contain|populat|validat|inject|deriv|build|appl(?:y|ies|ied)|accept|serv|listen|mount|bind|record|store|load|pars|render|hold|us(?:e|es|ed|ing)|call|invok|cop(?:y|ies|ied)|alias|generat|declar|name|reflect|keep|leav|turn|reconcil|watch|observ|instantiat|suppl(?:y|ies|ied)|list|publish|extend|default|express|replac|mint|wait|agree|fill|honou?r|restart|delet|updat|patch|send|receiv|fail|pass|includ|exclud|point|refer|exist|remain|becom|allow|enabl|disabl|prevent|ensur|mark|install|provision|schedul|queu|drain|shutdown|clos|open|begin|end|continu|retr|skip|signal|forward|proxy|rout|authenticat|authoriz|encrypt|decrypt|sign|hash|compar|sort|filter|reduc|append|prepend|truncat|split|join|trim|format|bootstrap)(?:s|es|ed|ing|d)?\b`

is_observable(body) if {
	is_string(body)
	regex.match(observable_verb_pattern, body)
}

# --- a verbatim run two texts share --------------------------------------

tokens(body) := toks if {
	toks := regex.find_n(`[a-z0-9]+`, lower(body), -1)
}

# shares_run reports whether two texts carry the same run of n consecutive
# words. The intent restating a requirement it governs is the case this
# answers: a long shared run means the intent copied the requirement.
shares_run(a, b, n) if {
	aw := tokens(a)
	bw := tokens(b)
	count(aw) >= n
	count(bw) >= n
	some i in numbers.range(0, count(aw) - n)
	some j in numbers.range(0, count(bw) - n)
	array.slice(aw, i, i + n) == array.slice(bw, j, j + n)
}

# --- an edit that changes nothing but the punctuation ---------------------

alnum_signature(body) := signature if {
	signature := concat("", regex.find_n(`[a-z0-9]`, lower(body), -1))
}

text_adds_nothing(from, to) if {
	is_string(from)
	is_string(to)
	from != ""
	to != ""
	alnum_signature(from) == alnum_signature(to)
}
