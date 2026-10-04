# Round 1 — Foundation: input contract, violation object, `spec_structure`

## What was established before this round

**Branches** (all in the repo `publicdomainrelay/deno-kcp`; `$PWD` is a second
checkout of it):

| branch | role |
| --- | --- |
| `main` @ `25d10f9` | code before the change |
| `open-architecture/deno-kcp` | **the serialized spec tree** (checked out here, `$PWD`) — base |
| `open-architecture/deno-kcp--spec-bidder-and-bob-pds` | **the spec changes** — spec tree after the change |
| `spec/bidder-and-bob-pds` @ `6c1bbe4` | **the code changes resulting** — 10 files |

**The change under review**: `SpecChange` `deploy-examples-atproto-market-s2c-834078074eaa`,
`direction: SpecToCode`, one delta entry, `r.live-acceptance-script`, `op: changed`,
`fields: [text]`. The text moves the two host-side reachability checks from
`http://127.0.0.1:2585|2586/...` to `https://...`, because every service pod sets
`SERVICE_TLS true` and the provider issues it a leaf, so an `http://` fetch of a
TLS listener asserts nothing. `toSpecHash 834078074eaa…`. Code side adds the
whole bob/bidder topology plus `deploy/examples/atproto/market/accept.sh`.

**Live finding that motivates a policy**: the record carries
`status.phase: Succeeded` while `status.acceptance[0].passed: false` and
`exitCode: 1` (five long-running pods `ready=false`, verifier `fetch failed`).
The specd `verify` vector (`go test ./...`) passed, the acceptance gate did not,
and the change was still recorded Succeeded.

## Input contract

`opa/tools/load_spec_tree.py` normalizes a spec tree into the document every
policy reads:

```
input.spec_tree.repository      repository.yaml, as parsed
input.spec_tree.arch            arch.yaml, as parsed
input.spec_tree.contexts[name]  {spec, status, context_doc, changes, *_path}
input.spec_tree.changes[name]   {name, path, document, system_context, direction}
input.spec_tree.graph           {vertices, edges, vertices_by_id, vertex_kinds, edge_types}
input.spec_tree.files[path]     {path, kind, size, sha256, present}
input.spec_tree.texts[path]     file text, for content policies
input.spec_tree.observed_files  union of status.observed.files, codeRefs, interface files
input.change                    the SpecChange under review, or null
input.diff                      {files[], commits[], paths, added, modified, deleted, renamed}
input.options                   {code_root, diff_base, diff_head}
```

## Layout

```
opa/
  .manifest                     bundle roots
  lib/                          reusable packages, no entrypoints
    violation/                  the violation object and the report
    paths/                      repo-relative path predicates
    spec/                       spec-tree accessors (requirements, interfaces, hashes)
    text/                       requirement prose analysis
  policies/<policy_name>/        one directory per policy set
    policy.rego                  package deno_kcp.policies.<policy_name>
    metadata.rego                violation id -> {title, description, severity, level}
    violations/<violation>.rego  one rule per violation
    policy_test.rego
  violations.rego               aggregator: every policy's violations, the report, the gate
  tools/load_spec_tree.py       the loader
  data/                         generated input documents (gitignored)
```

## Violation object

Keyed off the violation id, carrying the policy id, the location, and extra info:

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
    "pointer": "/spec/requirements/3/level",
    "file": "",
    "line": 0
  },
  "message": "requirement r.pds-pod declares level \"MUST-ISH\"",
  "details": {"requirement": "r.pds-pod", "level": "MUST-ISH"}
}
```

`severity` and `title` come from the policy's `metadata`, joined in by the
aggregator, so a violation rule states only what it found.

Report shape at `data.deno_kcp.report`:

```json
{
  "violations": [...],
  "count": 12,
  "by_severity": {"error": 7, "warning": 5},
  "by_policy": {...},
  "by_violation": {...},
  "errors": 7, "warnings": 5,
  "passed": false,
  "gate": false
}
```

## Round 1 deliverable

1. `lib/violation`, `lib/paths`, `lib/spec`, `lib/text`.
2. Policy set `spec_structure`: shape of contexts, requirements, interfaces.
3. `violations.rego` aggregator + `report` + `gate`.
4. Fixtures from the real tree: base and change input documents.
5. `opa fmt`, `opa check --strict`, `opa test` green.

## Policy sets planned for later rounds

| round | policy set | concern |
| --- | --- | --- |
| 2 | `spec_references` | codeRefs resolve, interfaces exist, no dangling refs |
| 2 | `arch_consistency` | arch.yaml vs specs/ one-to-one, graph integrity |
| 3 | `change_integrity` | delta shape, op semantics, hashes, phase, branch, commit |
| 3 | `change_impact` | weakening, removal, blast radius, downstream consumers |
| 4 | `acceptance_integrity` | acceptance verdict vs phase, verify vector, traceability |
| 4 | `traceability` | spec change <-> code change, filesTouched, fingerprint |
| 5 | `code_safety` | the project's NON-NEGOTIABLE provisioning and layering rules |
| 5 | `change_security` | secrets in specs, TLS downgrade, RBAC widening |
| 6 | `change_quality` | requirement prose quality, level/text agreement |
| 6 | polish | README, runner, CI, Regal config, coverage |
