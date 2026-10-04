# Round 6 — integration, calibration, catalogue

Rounds 1 to 5 built the library and the ten policy sets. Round 6 makes them one
thing, and makes the whole thing gate a build.

## What round 6 does

1. **Aggregate.** `violations.rego` names all ten policy sets. It unions their
   `violations` sets, joins each violation with the severity, level and title
   its policy declared, and answers `data.deno_kcp.report` and
   `data.deno_kcp.passed`.

2. **Compile as one bundle.** `opa check --strict .` over every file. Rules in
   one policy package that collide with another file in the same package are a
   conflict; rules in two different packages that happen to share a name are
   not.

3. **Test.** `opa test -b .` over every policy's `policy_test.rego` plus the
   library's.

4. **Calibrate.** Evaluate over both real documents and look at the counts. A
   rule that fires hundreds of times on a well-formed tree is miscalibrated and
   gets narrowed; a rule that fires on nothing at all anywhere is either dead or
   guarding something that never happens, and gets either a fixture that makes
   it fire or a note.

5. **Assert.** `test/integration.py` holds the facts the two real documents are
   known to carry, and the quiet they are known to keep. It fails if an
   expectation is not met, and it fails if any of the ten policy sets never
   raised a violation across both documents — a rule that stopped existing is a
   rule that stopped guarding.

6. **Catalogue.** `tools/catalogue.py` renders `VIOLATIONS.md` from
   `data.deno_kcp.metadata`: every violation id, its severity, its level, and
   what it catches, grouped by policy set. CI fails if the catalogue is stale.

7. **Gate.** `ci/opa.yaml` is the workflow to drop at the repository root:
   format check, strict compile, tests with a coverage threshold, the
   integration gate, the catalogue freshness check, and Regal.

## The judgement calls round 6 has to make

- **Severity.** A finding that says "this record lies about itself" is an error.
  A finding that says "this prose is weaker than it could be" is a warning.
  Getting this wrong makes the gate either useless or unbearable.
- **Thresholds.** `spec_structure`'s requirement-length bounds came from the
  distribution of the 214 real requirements: 9 words minimum, 15 words for the
  weaker warning, 150 for the upper bound, median 23.5. Every bound in every
  policy should be defensible from the real corpus the same way, and the plan
  says where it came from.
- **State versus defect.** The base tree has `realizedSpecHash` differing from
  the graph `specHash` for all 17 contexts, and `CodeSynced: False` for four.
  Those are states of a tree mid-flight, not defects of a change. A rule that
  reports them on a document with no change under review is noise.
- **The one real defect.** The change's `r.bidder-pod` text carries
  `/home/johnandersen777/src/publicdomainrelay-kcp`, which specd's draft-time
  validator rejects, and the change was recorded `Succeeded` anyway. The library
  has to say so, and the integration gate has to keep saying so.

## What is deliberately not a policy

- **Recomputing `toSpecHash`.** It is `sha256` over a canonical form specd owns.
  A policy that reimplemented it would drift from specd and start lying. The
  library checks shape (64 hex) and agreement (the hash is the one the tree and
  the graph carry), not derivation.
- **Judging whether a requirement is true of the code.** That is what the
  observer and the acceptance gate are for. The library judges the record, the
  delta, the references and the diff.
- **Fetching the relay or the cluster.** Every rule reads the documents it was
  given.
