# deno-kcp Open Architecture - roadmap PLAN 6..25

Dispatcher plan. State after PLAN 5: `arch.yaml` = 228 ids, validator 0 errors
0 warnings, schema + validator + README intent in place. Every plan below was
dispatched as one subagent that executed all of its rounds and committed once
per round as `docs(open-architecture): PLAN.ROUND <what>`.

**Status: PLAN 6..25 complete.** `arch.yaml` is 309 ids, ~3150 lines;
`validate.py` enforces 25 structural rules; gate is `0 errors, 0 warnings` from
the repo, from `/tmp` and from the org root.

Verify this work:

```
python3 .tools/open-architecture/validate.py          # 309 ids, 0 errors, 0 warnings
python3 .tools/open-architecture/validate.py --outline # the shape, 373 lines
python3 .tools/open-architecture/validate.py --outline sc.deno-kcp-provider
```

What the twenty plans produced, in one line each: the kcp platform layer and the
workspace tree; the reconcile graph for all eight kinds with its wake model and
finalize passes; the runner's process model, injected environment and service
DNS; the OpenBao PKI chain and the fact that nothing renews a certificate; the
credential inventory with holders, TTLs and principals; a threat model of 41
crossings and 50-odd risks with evidence; both example trees; the data model;
the test tiers and the integration harness; the upstreams and the vendored
OpenBao boundary; the repo-to-sibling boundary; machine heaviness; addressing;
capacity and lifecycle; status, logs and failure surfaces; the secret lifecycle;
a 674-citation truth sweep; external identity; and consolidation.

Left open on purpose, with reasons:

- **No `domains` axis.** The domain lines are `api.group` (a single constant) and
  `api.export`, already carried by keys that exist. A fifth axis would restate
  them rather than name a slice.
- **No rule for crossing `carries` completeness.** PLAN 25.3 found the gap by
  hand; attributing overlays to crossings automatically would misfire on pattern
  overlays, so it stays a recommendation rather than speculative code.
- **`spec.selfDid` is ignored** by this repo and the workflow input `self-did` is
  forwarded to a sibling. Recorded as `unread` versus forwarded; the sibling's
  use of it is out of this document's scope.

## Rules every plan obeys

- Target is the architecture of *this repo*: the KCP platform as upstream, the
  `deno.computer` kinds and the provider as the overlay we are implementing,
  plus the examples. No section mapping this implementation onto DFFML/DFFML
  concepts. The DFFML document is only the format we write in.
- Machine heavy, description light. A condition, default, order, threshold or
  identity is a key or an enum, never a sentence.
- Facts only. Every `path`, `manifest`, `code`, `evidence` value MUST exist in
  the repo, every `path:Symbol` MUST occur in that file. The validator greps
  both. When the code does not say, omit - never guess.
- Light tooling. PLAN 2 (a 971 line Go fact extractor, mutation tests,
  check.sh) was reverted; do not reintroduce a code-parsing engine. Validator
  and schema changes stay small, structural and description-carrying.
- Schema first: a new key lands in `arch.schema.json` with a description and in
  `README.md` intent in the same round, else the validator rejects it.
- `python3 .tools/open-architecture/validate.py` MUST end `0 errors, 0
  warnings` at every commit, and YAML MUST stay ASCII.
- Never run the live test tiers, never start or stop kcp/kine/openbao, never
  kill processes by pattern: live tests share this machine with other sessions.

## PLAN 6 - kcp platform layer

- 6.1 Workspaces: workload workspace tree, logical cluster names, the two
  workspace types (`denoruntime`, `workflow`) as contexts.
- 6.2 API surface: APIResourceSchema per kind, APIExport + APIBinding, the
  identity/permissionClaims that let a consumer workspace see the kinds.
- 6.3 Identity: the `workspace:namespace:name` triple as object identity, the
  cluster identity a reconcile sees, service account tokens per workload.

## PLAN 7 - provider reconcile graph

- 7.1 One reconcile pass per kind: reads/writes/`unread` complete for all 8.
- 7.2 Wake model: informer event, label `fanout`, `direct` enqueue, `requeue`,
  each with code.
- 7.3 Finalize passes, ownerReference graph (`owns`/`owned_by`), teardown.

## PLAN 8 - runner layer

- 8.1 Process model: one `deno run` per workload, tempdir layout, restart and
  exit handling.
- 8.2 Injected environment as structured facts (key, source, who sets it).
- 8.3 Service DNS, the `.kcpdns` shim, CA bundle placement.

## PLAN 9 - OpenBao PKI

- 9.1 Server context: baoembed build, unseal, root token handling.
- 9.2 Per-namespace CA, intermediates, role/policy for leaf certs.
- 9.3 TTLs, renewal, and the complete `signs` chain top-down.

## PLAN 10 - credentials and principals

- 10.1 Credential inventory: holder, grants, where minted.
- 10.2 Principals per execution context.
- 10.3 Crossing auth: every `x.*` names a credential or `none`; `gate: []`
  consequences.

## PLAN 11 - threat model

- 11.1 Crossing coverage: every outbound call in the provider and examples.
- 11.2 Risk severity ordering and evidence accuracy.
- 11.3 Enforcement gaps: `enforced_by: []` inventory, what code would enforce.

## PLAN 12 - example: atproto market

- 12.1 Service contexts: plc, pds, relay, verifier (there is no reverse proxy
  manifest in `deploy/`; the relay is the closest thing and is already a
  context).
- 12.2 Flows, apply order, `depends_on` against `apply.sh`. Note the actual
  apply order is `00-workspaces`, `10-rbac`, `15-openbao-<ws>` (all workspaces)
  then plc, pds, relay, verifier - not numeric order: `apply.sh:136-142` applies
  `20-global-plc.yaml`, `40-alice-pds.yaml`, `30-relay-relay.yaml`,
  `50-verifier.yaml`.
- 12.3 Market credentials, crossings, risks.

## PLAN 13 - example: runtime, fire pod, policy workflow

- 13.1 `deno-runtime` example tree.
- 13.2 Policy engine integration: engine endpoint, policy client, verdict.
- 13.3 `RunTrigger` -> `DenoJob` verdict path.

## PLAN 14 - data model

- 14.1 `field_types` complete for every kind spec/status.
- 14.2 Defaults, validation, enums (`DenoPermissions`, `ExecProbe`).
- 14.3 Phases and conditions per kind.

## PLAN 15 - test tiers as orchestrators

- 15.1 Tier map: unit, race, integration, live; gates and prerequisites.
- 15.2 What each live harness exercises.
- 15.3 The integration fixture harness as a system context. Corrected by PLAN
  15: the harness runs the provider in-process (`provider.New` + `p.Run`), not a
  compiled binary, and never calls `kubectl` (verified: zero mentions in
  `test/integration/`); its state is `t.TempDir()`, not `.kcp-demo`. It shares
  `tb.host` and the code draws no separate line, so there is no test-only
  boundary to invent. The document already had all of this right.

## PLAN 16 - upstreams and supply chain

- 16.1 Upstream inventory: `executes`, `pin.how/ref`, `source` line.
- 16.2 Unpinned or overridable upstreams to risks.
- 16.3 Vendored OpenBao: module boundary and build path.

## PLAN 17 - cross-repo boundaries

- 17.1 Sibling repos: policy engine, market TypeScript, their contracts.
- 17.2 ConfigMap overlays: `deno.json`, scripts, policy bundles.
- 17.3 Data crossing the repo boundary.

## PLAN 18 - machine heaviness

- 18.1 Remaining prose values become enums or structured keys.
- 18.2 Uniform keys and order, enforced.
- 18.3 Ref hygiene: defined once, longest match.
- 18.4 Value check. `path:Symbol` is grepped but plain `data` scalars are not,
  so a wrong `short`, resource name or workspace name passes today. Add a
  bounded table of `(file, dotted path, document path)` assertions to
  `validate.py` - data only, no parser, no code model - covering the values
  mirrored from the deploy manifests and the two APIExport resource lists.

## Dispatcher notes

- PLAN 6 verified by hand: the eight `shortNames` in `deploy/*-apiresourceschema.yaml`
  match the document, and the market example workspaces (`global`, `relay`,
  `alice`) match `00-workspaces.yaml`.
- PLAN 7 verified: six document-vs-code contradictions fixed (a wide read not
  marked wide, a wake `code` naming a lookup instead of the enqueue, a missing
  OpenBao requeue floor, three wrong `writes: []` on finalize passes, one read
  of a status field the teardown never touches, and finalizer entries naming
  only the setter). The ownerReference graph is confirmed to be set in exactly
  two places.
- Open gaps carried forward:
  - values inside `overlay.data` that mirror a manifest are not machine-checked
    (PLAN 18.4 closes it). Until then, every plan's report must name the file
    each mirrored value came from.
  - non-teardown deletions have no home (PLAN 20.2).
  - the per-workload tempdir under `runs/` is never removed by any code path, so
    a stopped workload leaves its script and any secret it wrote on disk
    (PLAN 22.2 records it, PLAN 22.3 weighs it).
  - self-status reads inside a reconcile pass appear only where the pass has
    nothing else to say; PLAN 14.1 decides whether every pass carries them.
- PLAN 12 corrected the roadmap twice, not the document: there is no reverse
  proxy manifest under `deploy/`, and the market apply order is plc, pds, relay,
  verifier (the document already had it right). Two of four market pods set no
  `serviceAccount`, so they get no peer token - recorded as `serviceAccount: none`.
- Style question from PLAN 11 for a later round: `tb.provider-process.principals`
  is `{}` while `cred.admin-kubeconfig.holder` lists it. The two fields answer
  different questions (who presents a credential at a boundary vs where the
  secret sits); PLAN 25.2 decides whether to keep or align that.
- PLAN 15 refused a false premise in its own brief: `test/integration/` uses no
  kubectl and no compiled binary. Third time a plan has corrected the roadmap
  rather than the document (12.4, 15.1's livegate `unset` vs `other`, 15.3) -
  the document is holding up better than the plan text, which is the right way
  round.
- PLAN 18 (ran across a session restart; `18.4` was committed by the dispatcher
  after proving the check fires): prose became `{from, default}` pairs and
  enums, one fact now has one key (`outcome` not `state`, `pod_restart` in both
  places it appears, `file_mode` for every mode), the schema closes `detached`,
  `already_up`, `use` and `listen.protocol` to fixed sets, and the ref resolver
  now errors on a truncated ref tail rather than silently accepting it. `18.4`
  adds the bounded value table described above; mutation-proven.

## PLAN 19 - network and address model

- 19.1 Addressing: workspace DNS, service DNS, ingress, endpoint precedence.
- 19.2 Who may dial whom, as crossings plus gates.
- 19.3 `route`, `into`, `omits` complete for every crossing.

## PLAN 20 - capacity and lifecycle

- 20.1 `maxConcurrent`, native admission, backpressure.
- 20.2 Cancel and teardown semantics, plus the deletions that are neither: a job
  reaping its own runs, policy workflow run preemption of sibling runs, and the
  TTL paths that delete pod, run, engine and OpenBao objects.
- 20.3 Event driven loop and requeue timing.

## PLAN 21 - status and observability

- 21.1 Status fields to conditions, per kind. PLAN 14.3 already keyed every
  condition to its setter and reasons, so this round closes the loop the other
  way: for each `status` field, what writes it, when it changes, and which
  condition or phase a reader can decide from.
- 21.2 Log and artifact surfaces: the provider's own log, the OpenBao log, the
  per-workload run directory and the files the runner writes there
  (`stdout`/`stderr`/`state.json`/`done.json`/`result.json`), what each contains,
  who writes it, and what survives the workload exiting.
- 21.3 Failure surfaces: every way this system fails - a reconcile error, a
  crash-looping workload, a missing authority, an unreachable engine, a kcp
  object that never becomes Ready - and where a human sees it. A failure with no
  surface is a risk.

## PLAN 22 - secret lifecycle

- 22.1 Creation and rotation: SA token TTL, OpenBao renewal.
- 22.2 At rest: files written, modes, tempdir lifetime.
- 22.3 Exposure sweep against the risk list.

## PLAN 23 - truth sweep

- 23.1 Doc-vs-code for every `path:Symbol`.
- 23.2 Validator rule coverage against README intent. The validator today has 22
  functions and no structural check for: the `signs` walk (server ->
  intermediate -> leaf), `flows` endpoints, crossing `from`/`to` membership in
  the boundary tree, and `reconcile.runner`/`target` resolution. Add these as
  rules, not as prose. Add one more, from PLAN 13: a `data` value under a key
  naming a file (`script`, `entry`, `file`, `manifest`) must be a path that
  exists or a `path:Symbol`, never a bare identifier - PLAN 13 found
  `template.script: read_latest_policyworkflowrun`, an invented name that
  occurred nowhere in the repo.
- 23.3 Acyclic, orphan and warning-zero checks tightened.
- 23.5 Invariants that plans have been checking by hand, promoted to rules so
  they cannot regress: every crossing with `auth: none` or `gate: []` is named
  by a risk whose `crossing` is that crossing; every `credential.holder` context
  is consistent with that context's `principals` (or the exemption is written
  down); every `from`/`to` of a crossing is a `tb.*`; every `rec.*` `runner` and
  `target` resolves. These held at PLAN 11 and PLAN 14 by inspection, which is
  exactly why they belong in the validator.
- 23.4 Prose docs. A sweep of `docs/*.md` for identifiers that name this repo's
  own code found exactly one stale symbol (`openBaoFor` for `authorityFor`,
  fixed in 9.4); the rest are external or sibling-repo terms. Re-run the sweep
  and fix the docs that describe this repo's code - `docs/OPENBAO_PKI.md`,
  `docs/DENO_RUNTIME_KCP.md`, `docs/POLICY_ENGINE_KCP.md`, `docs/adrs/`. Keep it
  a manual sweep, not a validator rule: a word check on prose is mostly noise.

## PLAN 24 - external identity

- 24.1 `did:web` and PLC contexts in the examples. Sized by inspection: the DID
  appears in exactly three places in this repo's own files. (a) The examples
  carry a placeholder identity - `selfDid: did:plc:example` in
  `deploy/examples/policyworkflowpod.yaml:12,31` and
  `deploy/examples/policy-workflow-run.yaml:28`, which reaches the engine as
  `inputs: {self-did}`. (b) The market verifier resolves `PLC/<did>` against the
  PLC service and reads back `alsoKnownAs` and `service`
  (`50-verifier.yaml:94-107`), with `VERIFY_PLC` pointed at
  `https://plc.default.global.svc.kcp.local`. (c) `did:web` is only described in
  the market README (:117), where the PDS derives its identity from `Host`.
  Encode those three, and do not imply a DID anywhere the files do not show one.
- 24.2 Note the boundary: the RFP/bid market flow (requester, bidder) lives in
  the org-root market repo, not here. The market example in this repo is
  PLC/PDS/relay/verifier, so do not encode a bidder this repo does not run.
- 24.3 PKI chain against DID chain, as this repo's architecture: the two
  identity systems it touches, what each proves, and where they meet (the
  service DNS name in a leaf certificate, the DID in a PDS record, the
  placeholder that stands in for a tenant's own identity in the examples).

## PLAN 25 - consolidation

- 25.1 Tree ordering: upstream to downstream, top to bottom. The document is
  past 2000 lines, so add a way to read it without reading it: an outline mode
  in `validate.py` (print the tree of ids, keys and refs, no values) so a
  reader can see the shape in a screenful and jump to a subtree.
- 25.2 README intent, schema and document aligned. Include the four axes the
  document is asked to carry, so each is greppable rather than implicit: trust
  boundaries (`tb.*`), systems (`system_contexts`), services (the `.service`
  contexts) and concepts (the eight kinds plus `type.*`, with `axis` as their
  lifecycle). A `metadata.axes` map from axis name to the section that carries
  it, or an equivalent, so a reader does not have to infer the mapping.
- 25.3 Full lifecycle read-through as `flows`, final commit.
