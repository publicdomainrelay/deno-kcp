# Results — what the library found, and how it was calibrated

238 violations across 10 policy sets. `opa check --strict` clean, `opa fmt`
clean, `opa test -b .` 247/247. `test/integration.py` holds 14 expectations
against the two real documents and passes.

## The run

```
opa/run.sh --spec-root . --code-root ../deno-kcp \
  --ref origin/open-architecture/deno-kcp--spec-bidder-and-bob-pds \
  --base-ref origin/open-architecture/deno-kcp \
  --change deploy-examples-atproto-market-s2c-834078074eaa \
  --diff-base origin/main --diff-head origin/spec/bidder-and-bob-pds
```

| document | violations | error | warning | info | passed |
| --- | --- | --- | --- | --- | --- |
| base spec tree | 54 | 8 | 40 | 6 | false |
| change + diff | 74 | 18 | 50 | 6 | false |

26 distinct violation ids fire across the two documents. The other 212 never
fire on either, because neither carries the shape they guard against; every one
of them has a unit test that makes it fire on a mutated fixture.

## What the change under review actually gets wrong

The change is `deploy-examples-atproto-market-s2c-834078074eaa`, a `SpecToCode`
change that adds bob's workspace, a second PDS, a market bidder, and a live
acceptance script to the AT Protocol market example.

1. **The record lies about its outcome.** `status.phase` is `Succeeded` while
   `status.acceptance[0]` is `{name: market-live-acceptance, passed: false,
   exitCode: 1, durationSeconds: 284.07}`. specd's own gate semantics say a
   failing gating step fails the change; here the gate ran, failed, was
   recorded, and the change was marked Succeeded anyway.
   Raised by `change_integrity/change-succeeded-with-failed-acceptance`,
   `acceptance_integrity/acceptance-gate-failed` and
   `acceptance_integrity/acceptance-frozen-repository`.

2. **The change disables certificate verification while claiming to strengthen
   it.** `accept.sh:141` runs `curl -skS`. The change exists to move two host
   checks from `http://` to `https://` because every service pod sets
   `SERVICE_TLS true`; `-k` means the certificate is trusted without being
   verified, so the fetch proves no more than it did over http. Found
   independently by two builders, and raised twice:
   `code_safety/safety-insecure-tls-flag` (warning) and
   `change_security/security-disabled-verification` (error).

3. **A requirement's text carries a path that exists on one machine.**
   `r.bidder-pod` reads "apply.sh rewrites the
   `/home/johnandersen777/src/publicdomainrelay-kcp` prefix". specd's own
   draft-time validator rejects an absolute machine path in a requirement
   (`hydradb/abc/spec/agent/draft.go:77`), and this one was recorded anyway.
   Raised by `spec_structure/requirement-text-has-machine-path`.

4. **Two example manifests embed absolute machine paths.** `60-bob-pds.yaml:14-15`
   and `70-bidder.yaml:14-15` put `/home/johnandersen777/...` into `SERVICE_ENTRY`
   and `SERVICE_CWD`, so the manifests run on one machine only. Raised by
   `code_safety/safety-absolute-machine-path-in-manifest` (4 findings).

5. **Printed guidance tells a reader to make the non-check the change removed.**
   `apply.sh:203` still echoes `curl http://127.0.0.1:2585/xrpc/_health` for pods
   that declare `SERVICE_TLS true`. Raised by
   `code_safety/safety-stale-tls-guidance`.

6. **Five code refs point at files the context never observed.** The three
   requirements naming `apply.sh`, `arch.yaml` and `README.md` are exactly the
   ones specd's own `CodeSynced` condition message calls "unresolved"; the
   context records `CodeSynced False (InterfacesMissing)` while the change is
   `Succeeded`. Raised by `spec_references/code-ref-file-not-observed`.

7. **A requirement is removed whose replacement is not anchored.** The branch
   removes `r.three-workspaces-at-root` and adds `r.four-workspaces-at-root`;
   the two share a code ref, so it is a supersession rather than a loss, and the
   library says so by raising only the two informational rows
   (`change_impact/impact-removes-requirement`,
   `impact-removes-must-requirement`) and not the error one.

8. **The status file does not know about the new script.** The change touches
   `deploy/examples/atproto/market/accept.sh`, and
   `status.observed.files` lists only the twelve YAML manifests. Raised by
   `traceability/trace-status-observed-files-stale`. Relatedly,
   `trace-arch-overlay-file-untouched` notes that `r.rbac-covers-bob` adds
   `10-rbac.yaml` to the arch overlay while the diff never touches it.

## What is standing, not this change's fault

The base tree carries 54 violations of its own, and they are the tree's state
rather than the change's defect:

- `spec_structure/requirement-text-too-short` 8 and `requirement-text-terse` 14
  over 214 hand-written requirements.
- `spec_references/status-code-synced-false` 4, `interface-file-not-observed` 6,
  `interface-not-observed` 2.
- `change_quality` 20, every rule under 5% of the corpus.

## How the thresholds were chosen

- **Requirement length.** From the distribution of the 214 real requirements:
  min 9 words, p05 11, p10 14, median 23.5, p90 40, max 67. So: error under 10,
  warning under 15, warning above 150. A first draft at 20 fired on 68 of 214 —
  a third of a hand-written spec — and was wrong.
- **`implied_level`.** "may not" was read as a permission because it contains
  "may ". A prohibition is a MUST. Then "can" was removed from the permission
  list entirely: in this corpus it is almost always a capability ("a client can
  verify it"), so reading it as a permission made MUST requirements look like
  MAY.
- **Code refs.** 231 of 460 are `file:<path>`; the other 229 are
  `<kind>:<32 hex>` codegraph ids, not names. A symbol rule matching on
  interface `name` fired 229 times on a well-formed tree.
- **Unmeasurable is not wrong.** Seven of seventeen contexts have no
  `status.observed.interfaces`, so a rule that needs observed facts stays silent
  rather than reporting every declaration as unobserved.
- **`code-ref-duplicate-in-context`** counts a context's own `codeRefs` list, not
  a ref reused across requirements, which fired 217 times.
- **`quality-enumerates-without-structure`** required the whole text to be
  comma-separated bare identifiers, specd's own `EnumeratesNames` reading; the
  loose reading fired on 14% of the corpus.

## What is deliberately not a policy

- **Recomputing `toSpecHash`.** It is a sha256 over a canonical form specd owns.
  The library checks the shape (64 hex) and the agreement (the hash is the one
  the status file and the graph vertex carry), never the derivation.
- **Judging whether a requirement is true of the code.** That is the observer's
  job and the acceptance gate's job. The library judges the record, the delta,
  the references and the diff.
- **Reading the cluster.** Every rule reads the documents it was given.
