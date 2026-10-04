# opa — policies over a spec tree

Open Policy Agent policies that decide whether a **spec change** is safe to
apply. A spec change is what specd (HydraDB) produces when a `system_context`
spec is edited, or when the code under a context drifts far enough that the spec
has to be rewritten: one `SpecChange` record under `changes/`, carrying a
direction, a delta, and the outcome of realizing it.

This tree holds Rego. It reads a normalized JSON view of a spec tree produced by
`tools/load_spec_tree.py`, and it emits violations keyed off the violation, the
policy that raised it, and the location it was found at.

## Layout

```
opa/
  .manifest                      bundle roots
  lib/                           reusable packages, no entrypoints
    violation/                   the violation object, the report
    paths/                       path and code-ref predicates
    refs/                        the specd reference grammar, hashes, change names
    spec/                        spec-tree accessors
    text/                        requirement prose analysis
  policies/<policy_name>/        one directory per policy set
    policy.rego                  package deno_kcp.policies.<policy_name>
    metadata.rego                violation id -> {severity, level, title}   (in policy.rego)
    violations/<family>.rego     one rule per violation
    policy_test.rego
  violations.rego                the aggregator: every policy, joined, reported
  tools/load_spec_tree.py        the loader
  plans/                         the round-by-round design record
  run.sh                         load, evaluate, exit non-zero on an error
```

A policy set is one concern. It owns one `violations` set and one `metadata`
object. It never reads another policy's internals; it reads `lib/`.

## The input document

Every policy reads `input.spec_tree`, and optionally `input.change` (the
`SpecChange` under review) and `input.diff` (the code change under review).

```json
{
  "base_tree": { ...the same shape as spec_tree, read from --base-ref, or null... },
  "spec_tree": {
    "repository": { ...repository.yaml... },
    "arch":       { ...arch.yaml... },
    "contexts":   { "<name>": { "document": ..., "metadata": ..., "spec": ...,
                                "status": ..., "context_doc": ..., "changes": {...},
                                "spec_path": ..., "status_path": ..., "context_doc_path": ... } },
    "changes":    { "<name>": { "name", "path", "document", "system_context", "direction" } },
    "graph":      { "vertices": [...], "edges": [...], "vertices_by_id": {...} },
    "files":      { "<path>": { "path", "kind", "size", "sha256", "present" } },
    "texts":      { "<path>": "<file text>" },
    "observed_files": [...]
  },
  "change": { ...the SpecChange under review, or null... },
  "diff":   { "base", "head", "files": [{"path","status","patch","base_text","head_text",...}],
              "commits", "paths", "added", "modified", "deleted", "renamed" },
  "options": { "scope": "own" | "all", "code_root", "diff_base", "diff_head" }
}
```

`scope` defaults to `own`, which drops the `third-party-*` contexts a tree grows
when it is populated on top of a vendored submodule. `scope: all` keeps them.

**`base_tree` is why the whole spec delta is visible.** A `SpecChange` record
carries only the delta of the edit that produced it. The branch's real spec work
— nine requirements added, one removed, one changed — is invisible in the one
record `deploy-examples-atproto-market-s2c-834078074eaa` carries. Passing
`--base-ref` loads the earlier tree too, and `lib/spec.requirement_diff(base, head)`
returns the `{context, op, id, from, to, fields}` rows that record cannot show.
Without a base tree those rules stay quiet rather than guessing.

`input.spec_tree.files` is the union of the working tree under `--code-root` and,
when a diff is present, every file at the diff head (marked
`"source": "diff_head"`), because the tree a diff head lives in is not the
working tree a walk can see.

## The violation object

```json
{
  "id": "spec_structure/requirement-level-invalid",
  "policy": "spec_structure",
  "violation": "requirement-level-invalid",
  "severity": "error",
  "level": "MUST",
  "title": "A requirement level is not MUST, SHOULD or MAY",
  "location": {
    "kind": "spec_requirement",
    "context": "deploy-examples-atproto-market",
    "path": "specs/deploy-examples-atproto-market.yaml",
    "pointer": "/spec/requirements/3",
    "file": "",
    "line": 0
  },
  "message": "requirement r.pds-pod declares level \"MUST-ISH\"; a level is MUST, SHOULD or MAY",
  "details": { "requirement": "r.pds-pod", "level": "MUST-ISH" }
}
```

`severity`, `level` and `title` are not set by the rule that found the thing.
The rule states what it found; the policy's `metadata` states how bad it is; the
aggregator joins them by id. Two violations of the same rule at two locations
both survive — a report groups by id, never collapses.

## How to write a violation

```rego
package deno_kcp.policies.spec_structure

import rego.v1

import data.deno_kcp.lib.spec
import data.deno_kcp.lib.violation

violations contains v if {
	row := spec.all_requirements(input.spec_tree)[_]
	level := object.get(row.requirement, "level", "")
	is_string(level)
	level != ""
	not level in spec.requirement_levels
	v := violation.build(
		policy_id,
		"requirement-level-invalid",
		violation.requirement_location(row.context, row.path, row.index),
		sprintf("requirement %s declares level %q; a level is MUST, SHOULD or MAY", [row.requirement.id, level]),
		{"requirement": row.requirement.id, "level": level},
	)
}
```

Rules to hold to:

- `violations contains v if { ... }`. Never a complete rule; a violation set is
  a set.
- Every guard is explicit. An undefined reference inside a partial rule makes
  the element vanish, and a vanished violation is a missed one. Use
  `object.get(x, "k", default)` and `is_string`/`is_array` rather than trusting
  a chain.
- The message says what was found and what would be right, with the values in
  it. A reader should not have to open the file.
- `details` carries the machine-readable extras. Anything a caller might gate on
  goes there, not into the message.
- `metadata` in `policy.rego` gets an entry for every id the rules can raise,
  with `severity` (`error`/`warning`/`info`), `level` (`MUST`/`SHOULD`/`MAY`) and
  a one-line `title`. `opa test` asserts the three fields are present.

## The report

`data.deno_kcp.report`:

```json
{
  "violations": [ ... sorted by id, then location, then message ... ],
  "by_id": { "spec_structure/requirement-level-invalid": [ ... ] },
  "count": 12, "errors": 7, "warnings": 5, "infos": 0,
  "by_severity": {"error": 7, "warning": 5},
  "by_policy": {"spec_structure": 12},
  "by_violation": {"requirement-level-invalid": 7},
  "passed": false
}
```

`data.deno_kcp.passed` is true when no violation of severity `error` was raised.

## Running

```bash
# every policy over a spec tree
opa/run.sh --spec-root . --code-root ../deno-kcp

# one spec change and the code that realizes it
opa/run.sh --code-root ../deno-kcp \
  --ref origin/open-architecture/deno-kcp--spec-bidder-and-bob-pds \
  --change deploy-examples-atproto-market-s2c-834078074eaa \
  --diff-base origin/main --diff-head origin/spec/bidder-and-bob-pds

# the policies themselves
opa test -b opa/

# format and lint
opa fmt -w opa/
opa check --strict opa/
```

## What is checked

| policy set | concern |
| --- | --- |
| `spec_structure` | shape of contexts, requirements, interfaces, status, the repository manifest |
| `spec_references` | every code ref resolves, every interface file exists, no dangling refs |
| `arch_consistency` | arch.yaml against specs/, graph integrity, one context one name |
| `change_integrity` | delta shape, op semantics, hashes, phase, branch, commit, filesTouched |
| `change_impact` | weakening, removal, blast radius, downstream consumers |
| `acceptance_integrity` | acceptance verdict against phase, verify vector, gate semantics |
| `traceability` | the spec change against the code change that realizes it |
| `code_safety` | the project's non-negotiable provisioning and layering rules, over the diff |
| `change_security` | secrets in specs, TLS downgrade, RBAC widening |
| `change_quality` | requirement prose, level against wording, id against text |

## A finding against the real change

`deploy-examples-atproto-market-s2c-834078074eaa` is a `SpecToCode` change that
moves two host-side reachability checks from `http://` to `https://`, because
every service pod sets `SERVICE_TLS true` and the provider issues it a leaf, so
an `http://` fetch of a TLS listener asserts nothing. The record carries
`status.phase: Succeeded` while `status.acceptance[0].passed: false` and
`exitCode: 1` — the specd `verify` vector (`go test ./...`) passed, the live
acceptance gate did not.

Its spec delta also puts `/home/johnandersen777/src/publicdomainrelay-kcp` into
the text of `r.bidder-pod`, which `spec_structure/requirement-text-has-machine-path`
raises: specd's own draft-time validator rejects an absolute machine path in a
requirement, and this one was recorded anyway.
