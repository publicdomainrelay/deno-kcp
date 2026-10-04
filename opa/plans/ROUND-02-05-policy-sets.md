# Rounds 2 to 5 — the policy sets

Round 1 built the input contract, the violation object and the first policy set.
Rounds 2 to 5 add the rest. Each row is a policy set, the round it belongs to,
and the concern it owns. The brief for each set — the exact violation ids, the
lib API, the calibration ground truth — was handed to a builder that wrote only
its own directory.

| round | policy set | concern |
| --- | --- | --- |
| 2 | `spec_references` | every declared reference resolves; nothing observed is undeclared |
| 2 | `arch_consistency` | `arch.yaml`, `specs/` and the graph are three renderings of one thing |
| 3 | `change_integrity` | the SpecChange record is well formed and tells the truth about itself |
| 3 | `change_impact` | what the delta does to the meaning of the spec |
| 4 | `acceptance_integrity` | the declared acceptance, the recorded verdict, and whether they agree |
| 4 | `traceability` | the code diff actually realizes the delta the record claims |
| 5 | `code_safety` | the project's non-negotiables, over the diff |
| 5 | `change_security` | secrets, transport downgrade, widened authority |
| 5 | `change_quality` | requirement prose, and wording against declared level |

## The ground truth every set is calibrated against

Two documents, both built by `tools/load_spec_tree.py`:

- **base** — the checked out spec tree at code commit `25d10f9`. 17 own
  contexts, 214 requirements, 375 interfaces, 17 `CodeToSpec` changes with empty
  deltas, no code diff. Well-formed prose.
- **change** — the spec tree on `open-architecture/deno-kcp--spec-bidder-and-bob-pds`,
  plus the `SpecChange` `deploy-examples-atproto-market-s2c-834078074eaa` and the
  10-file diff `origin/main..origin/spec/bidder-and-bob-pds`.

Facts the sets must reproduce, verified directly against the trees:

| fact | value |
| --- | --- |
| own contexts, base and change | 17 and 17 |
| requirements added to `deploy-examples-atproto-market` | 9 |
| requirements removed | 1, `r.three-workspaces-at-root` |
| requirements changed | 1, `r.openbao-object-per-workspace` (text, codeRefs) |
| requirements added to `test-integration` | 1, `r.market-examples-are-registered` |
| `repository.spec.acceptance` | absent in base; one gating step in change |
| change `toSpecHash` | `834078074eaa…`, equal to `status.realizedSpecHash` and the `SpecContext` vertex `specHash` |
| change `fromSpecHash` | `48cbbf77…`, which is **not** the base hash — the record captures the last delta only |
| change `filesTouched` | `[deploy/examples/atproto/market/accept.sh]`, which the diff touches |
| change acceptance | one result, `passed: false`, `exitCode: 1`, `durationSeconds: 284.07` |
| change phase | `Succeeded` |
| change `verifyExitCode` | absent |
| base `realizedSpecHash` vs graph `specHash` | differ for all 17 contexts |
| change `realizedSpecHash` vs graph `specHash` | agree for all 17 |
| contexts whose `CodeSynced` is `False` | 4, in both trees |
| graph edge types present | `HAS_CONTEXT`, `REQUIRES`, `DECLARES` only |

## What must fire, and what must stay quiet

- On the **change**, `spec_structure/requirement-text-has-machine-path` fires
  once: the change branch's `r.bidder-pod` text carries
  `/home/johnandersen777/src/publicdomainrelay-kcp`. specd's own draft-time
  validator rejects an absolute machine path in a requirement; this change was
  recorded `Succeeded` anyway.
- On the **change**, the acceptance rules fire: a gating step failed and the
  phase is `Succeeded`, which by specd's own gate semantics is a change that
  should have ended `Failed`.
- On the **base**, every code rule stays silent: there is no diff.
- On the **base**, `change_quality` must not drown 214 hand-written requirements.
  A rule that fires on a fifth of a real spec is miscalibrated.

## Constraints every set holds to

- One policy set, one package, one `violations` set, one `metadata` object.
- A violation rule states only what it found; severity, level and title come
  from `metadata`, joined by the aggregator.
- Every access guarded. An undefined reference in a partial rule makes the
  element vanish, and a vanished violation is a missed one.
- Two findings of the same rule at two locations both survive.
- The message carries the values, so a reader never has to open the file.
