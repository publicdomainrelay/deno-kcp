# Domain brief — what a spec change is, and what its rules are

Everything here was read out of `../hydradb` (the specd implementation), out of
the spec tree in this repository, and out of the real change under review. It is
the shared context for every policy set. Read `opa/README.md` for the library
API and the violation pattern; this file is the domain.

## 1. The repository and the two branches that matter

Everything lives in the repo `publicdomainrelay/deno-kcp`. `$PWD` is a checkout
of it whose working tree is on an orphan branch that carries the spec tree.

| branch | what it is |
| --- | --- |
| `main` @ `25d10f9` | the code before the change |
| `open-architecture/deno-kcp` | the base **spec tree** (checked out here) |
| `open-architecture/deno-kcp--spec-bidder-and-bob-pds` | the spec tree after the change |
| `spec/bidder-and-bob-pds` @ `6c1bbe4` | the **code** that realizes it, 10 files |

Input documents are already generated:

```bash
python3 opa/tools/load_spec_tree.py --root . \
  --code-root ../deno-kcp --out /tmp/input-base.json

python3 opa/tools/load_spec_tree.py --root . \
  --ref origin/open-architecture/deno-kcp--spec-bidder-and-bob-pds \
  --change deploy-examples-atproto-market-s2c-834078074eaa \
  --code-root ../deno-kcp \
  --diff-base origin/main --diff-head origin/spec/bidder-and-bob-pds \
  --out /tmp/input-change.json
```

`/tmp/input-base.json` has 17 contexts, 17 changes, no diff.
`/tmp/input-change.json` has 590 contexts (573 are `third-party-*`, out of scope
by default), 52 changes, the one change under review, and a 10-file diff.

## 2. The wire model

Field names are exactly the `json` tags specd serializes: lowerCamelCase.

### Repository — `repository.yaml`

```yaml
apiVersion: specs.publicdomainrelay.dev/v1alpha1
kind: Repository
metadata: {name, namespace}
spec:
  branch: <the CODE branch this spec tree describes>
  populate: {partition: directory|package, summarize: bool, include, exclude, arch, root, agent}
  source: {}                      # {} or {path} or {git: {url, ref}}
  verify: [go, test, ./...]       # argv run in the worktree; must exit 0
  acceptance:                     # optional; runs AFTER verify
  - {name, command: [argv...], timeoutSeconds, gate: bool, env: {k: v}}
  agent: {kind: ""|claude|claude-mod|pi|"scripted:<file>"}
status:
  contexts: {total, summarized, failed}
  headCommit: <40 hex>
  indexedCommit: <40 hex>
  phase: Cloning|Indexing|Populating|Populated|Failed
```

### SystemContext — `specs/<context>.yaml`

```yaml
apiVersion: specs.publicdomainrelay.dev/v1alpha1
kind: SystemContext
metadata: {name: <DNS-1123 subdomain>, namespace: default}
spec:
  repository: deno-kcp            # required
  upstream: self                  # required; a ref
  overlay: []                     # refs, sc./ov. prefixed
  orchestrator: ""                # ref
  dependsOn: []                   # refs, never self
  introduces: []                  # refs, never self
  intent: <prose>                 # the single authority; not in the CLM yaml block
  requirements: [Requirement]
  interfaces:   [Interface]
  codeRefs: []                    # context-level refs
  arch: {id, kind: node|document, section, form, position, parent, slot,
         upstream, overlay, orchestrator, dependsOn, introduces, code,
         sections, node: {}, document: {}}

Requirement = {id: "r.<kebab>", level: MUST|SHOULD|MAY, text, codeRefs?: [ref]}
Interface   = {name, kind, signature, file}      # name unique per context
```

`upstream` and every ref must satisfy `IsRef`: literal `self`, or one of
`sc.`, `up.`, `ov.`, `orch.` followed by a DNS-1123 subdomain.

### Status — `status/<context>.yaml` (no wrapper; keys are top level)

```yaml
conditions:                        # metav1.Condition
- {type: SpecValid|CodeSynced|Drifted|Indexed|Populated|BranchMismatch,
   status: "True"|"False", reason: <Reason>, message: <str>,
   lastTransitionTime, observedGeneration}
observed:
  files: [<repo-relative path>]
  treeFiles: []
  interfaces: [{name, kind, signature, file, line, codegraphId}]
  fingerprint: <sha256 hex over {files, interfaces}>
observedCommit: <40 hex>
realizedSpecHash: <sha256 hex>     # the spec hash the code was realized from
syncedCommit: <40 hex>
syncedFingerprint: <sha256 hex>
syncedObserved: {files, treeFiles, interfaces, fingerprint}
```

Reasons: `ValidatorPassed|ValidatorFailed`, `InterfacesObserved|InterfacesMissing`,
`CodeRefsUnresolved`, `FingerprintEqual|FingerprintChanged`, `NotSyncedYet`,
`Indexed`, `HeadUnavailable`, `IndexFailed`, `PathMissing`, `SourceInvalid`,
`CloneFailed`, `Populated`, `Populating`, `PopulateFailed`,
`BranchMismatch|BranchMatches`.

### SpecChange — `changes/<name>.yaml`

```yaml
apiVersion: specs.publicdomainrelay.dev/v1alpha1
kind: SpecChange
metadata: {name, namespace}
spec:
  systemContext: <bare context name, no sc. prefix>
  direction: SpecToCode | CodeToSpec
  fromSpecHash: <hash>            # SpecToCode
  toSpecHash:   <hash>            # SpecToCode, required, sha256 hex
  fromCommit:   <40 hex>          # CodeToSpec
  toCommit:     <40 hex>          # CodeToSpec
  delta:
    intent: {from, to}
    upstream: {from, to}
    orchestrator: {from, to}
    overlay:     {added: [], removed: []}
    dependsOn:   {added: [], removed: []}
    introduces:  {added: [], removed: []}
    codeRefs:    {added: [], removed: []}
    requirements: [{op: added|removed|changed, id, from: Requirement, to: Requirement, fields: [level|text|codeRefs]}]
    interfaces:   [{op, name, from: Interface, to: Interface, fields}]
    observed: {files: {added, removed}, interfaces: [...], fingerprint: {from, to}}
status:
  phase: Pending|Running|Succeeded|Failed
  branch: spec/<context>/<first 8 of toSpecHash>
  commit: <40 hex>
  verifyExitCode: <int>
  filesTouched: [<repo-relative path>]
  agentLog: <str>
  message: <str>
  acceptance: [{name, exitCode, durationSeconds, passed: bool, outputTail}]
  progress: [{turn, tool, files, note, at}]      # capped at 128, oldest evicted
```

Change names: `<context>-c2s-<from12>-<to12>` and `<context>-s2c-<hash12>`, with
`-a`, `-a2`, ... appended for a retry episode.

### Graph — `graph/vertices.jsonl`, `graph/edges.jsonl`

```
vertex: {"id": <int53>, "label": SpecRepo|SpecContext|SpecRequirement|SpecInterface
                     |CodeRef|SpecChange|SpecProgress|PiMemory, ...props..., "scope": ""}
edge:   {"from": <id>, "to": <id>, "fromLabel": <label>, "toLabel": <label>, "type": <TYPE>}
```

Edge types: `HAS_CONTEXT` (Repo->Context), `UPSTREAM`, `OVERLAY`, `ORCHESTRATOR`,
`DEPENDS_ON`, `INTRODUCES` (Context->Context), `REQUIRES` (Context->Requirement),
`DECLARES` (Context->Interface), `REFERENCES` (Context->CodeRef and
Requirement->CodeRef), `TOUCHED` (Change->CodeRef), `OCCURRED`
(Change->Progress), `SPECIFIES` (PiMemory->Requirement).

### CLM context document — `context/<context>.md`

```markdown
# Context: <name>

Repository: `<repo>`

<intent prose>                       <- model-editable

_Write the prose above and the fields in the spec block. `codeRefs` and the
 resolved references below are maintained by the tool; an edit there is lost._

## spec
```yaml spec
upstream: self
requirements: [...]
interfaces: [...]
```
<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references
- `<id>` <kind> <name> (<path>)
<!-- SPECD_MANAGED_END -->
```

The model may edit the prose and the seven fields of the `yaml spec` block
(`upstream`, `overlay`, `orchestrator`, `dependsOn`, `introduces`,
`requirements`, `interfaces`). `repository`, `codeRefs` and `arch` are
tool-owned and stripped. The managed region is tool-owned.

## 3. The rules specd itself enforces

These are the invariants the implementation asserts. A policy that restates one
is checking that the change did not smuggle something past them.

**Identity.** Every `metadata.name` is a DNS-1123 subdomain. Change names match
`<context>-(c2s-<12hex>-<12hex>|s2c-<12hex>)(-a<N>)?`.

**References.** `upstream`, `overlay`, `orchestrator`, `dependsOn`,
`introduces`, `arch.*` refs satisfy `IsRef`. `dependsOn`/`introduces` are never
`self` and are unique.

**Code refs.** `kind:payload`, kind from `file, package, module, function,
method, constructor, struct, interface, class, type_alias, enum, type, variable,
constant, import`; payload non-empty and whitespace-free; unique within a
requirement and a context; `file:` refs resolve against observed files, symbol
refs against observed interfaces or a codegraph id.

**Requirements.** id required, unique per context, kebab-case `r.<name>`; level
exactly `MUST`/`SHOULD`/`MAY`; text required; **no absolute machine path** in the
text (`/(?:home|Users|root|tmp|mnt|opt|srv)/[A-Za-z0-9._@+-]+`).

**Interfaces.** name required and unique per context; the name must exist in the
observed interfaces; generated (`zz_generated*`, `DeepCopy*`) and test symbols
are not interfaces; a method is named receiver-first (`Type.Method`).

**Hashes.** Any hash is a sha256 hex digest, 64 characters. A `SpecToCode`
change requires `toSpecHash`. `status.realizedSpecHash` is a hash when present.

**Commits.** A `CodeToSpec` change sets `fromCommit` and `toCommit` together or
neither; both non-empty and unequal before the change is due.

**Delta.** Every delta entry has an `id`/`name` and an op in
`added|removed|changed`. An empty delta is no work.

**Acceptance.** Steps have a name (unique, no newline), a non-empty command, and
a non-negative timeout. Verify runs first and must exit 0. Every acceptance step
runs even after an earlier failure. The first failing `gate: true` step fails
the change. A gating acceptance that cannot pass freezes the repository: every
realization ends `Failed` until it is relaxed.

**Phases.** SpecChange phase in `Pending|Running|Succeeded|Failed`; Repository
phase in `Cloning|Indexing|Populating|Populated`.

**Concurrency.** One context may not have two running changes (lexicographic
admission on the change name). The branch must match `Repository.spec.branch`
before anything is written.

**Portability.** `resolvedPath` and local paths are stripped before persisting
so two machines render identical bytes.

## 4. What a spec change must not do, in this project

Read `/home/johnandersen777/src/publicdomainrelay-kcp/CLAUDE.md`. The
non-negotiables that a code diff realizing a spec change must not break:

- **Never hand-provision.** A guest is born from cloud-init `user_data` produced
  by the RFP flow (`runComputeContract`), never from `container run`,
  `docker run`, `container exec ... apt-get install`, a mounted binary, or a
  hand-written `authorized_keys`.
- **Never cross-compile or mount a guest agent** to skip cloud-init. A guest-side
  transport is a `UserDataModule` in `cloud-init-common` or a sibling
  `user_data` builder; the RFP cloud-init is the only way a guest comes up.
- **Never add a second SSH or tunnel transport** the RFP cloud-init does not
  deploy.
- **Nothing talks to a guest except through the relay.** The relay is the
  registry; ssh reaches a guest through a `ProxyCommand` over the websocket
  tunnel.
- **Never a "real ssh / real guest" e2e that stands up its own container.** It
  drives `runComputeContract(...)` against a real local bidder running a
  container-mode compute provider (`atproto-market/test/bidder_container_integration_test.ts`).
- Also, for TypeScript: no `Deno.env.get()` in a CLI, no hardcoded
  ports/hosts/paths in a CLI, no raw `Deno.serve()`, no subclassed Hono factory,
  no I/O in `lib/abc`, no `lib/common` importing project-local code, no cycles,
  no sub-module exports, no port-sniffing (`listen` then close then rebind).

## 5. The change under review

`deploy-examples-atproto-market-s2c-834078074eaa`, `direction: SpecToCode`,
`systemContext: deploy-examples-atproto-market`,
`fromSpecHash: 48cbbf77…`, `toSpecHash: 834078074eaa…`.

One delta entry: `r.live-acceptance-script`, `op: changed`, `fields: [text]`.
The text moves two host-side reachability checks from
`http://127.0.0.1:2585/xrpc/_health` and
`http://127.0.0.1:2586/oauth-client-metadata.json` to `https://`, states that
both host checks must use https because every service pod sets `SERVICE_TLS true`
so the listener the host reaches is the TLS one, that an `http://` fetch of a TLS
listener is not a check of anything, and that `http_code` reports the status curl
printed and prints `000` exactly once on failure.

Status: `phase: Succeeded`, `branch: spec/deploy-examples-atproto-market/83407807`,
`commit: 6c1bbe4c…`, `filesTouched: [deploy/examples/atproto/market/accept.sh]`,
`verifyExitCode` absent, and

```
acceptance: [{name: market-live-acceptance, passed: false, exitCode: 1,
              durationSeconds: 284.07, outputTail: "... five pods ready=false,
              verifier fetch failed ... accept: fail"}]
```

The specd `verify` vector (`go test ./...`) exited 0; the live acceptance gate
did not; the change was recorded `Succeeded` anyway. This is the single most
important thing the library has to be able to say something about.

The whole spec diff (base -> after) is larger than this one record: 9 requirements
added to `deploy-examples-atproto-market` (`r.apply-includes-bob-and-bidder`,
`r.arch-data-lists-bob`, `r.bidder-pod`, `r.bidder-supervisor-script`,
`r.bob-pds-pod`, `r.four-workspaces-at-root`, `r.live-acceptance-script`,
`r.rbac-covers-bob`, `r.readme-lists-bob-and-bidder`), `r.three-workspaces-at-root`
removed, `r.openbao-object-per-workspace` changed (codeRefs gain
`15-openbao-bob.yaml`, text gains `bob.default`); plus one requirement added to
`test-integration` (`r.market-examples-are-registered`); plus
`repository.yaml` gains a `spec.acceptance[0]` = `{name: market-live-acceptance,
command: [bash, deploy/examples/atproto/market/accept.sh], gate: true,
timeoutSeconds: 1200}`.

The code diff is 10 files: `.tools/open-architecture/arch.yaml`,
`deploy/examples/atproto/market/{00-workspaces.yaml,15-openbao-bob.yaml,
60-bob-pds.yaml,70-bidder.yaml,README.md,accept.sh,apply.sh}`,
`test/integration/{examples.go,offline_test.go}`.

## 6. Non-obvious traps

- **`metadata.name` vs the file name.** `specs/foo.yaml` declares
  `metadata.name: foo`. A mismatch is a rename that did not finish.
- **`systemContext` is the bare name.** `changes/…` says
  `systemContext: deploy-examples-atproto-market`, not `sc.deploy-…`.
- **`arch.yaml` context ids carry the prefix.** `system_contexts[].id` is
  `sc.<name>`, `name` is `<name>`. The graph and the directories use the bare
  name.
- **`status` is not wrapped.** The status file's keys are top level; in the
  loaded document they are `input.spec_tree.contexts.<name>.status`.
- **`specs/<ctx>.yaml` is a document, not a spec.** The loaded context has
  `document` (the whole file), `metadata`, and `spec` (the `.spec` block).
- **Empty `delta` is legal.** Every `CodeToSpec` record in the base tree has
  `delta: {}`; the delta lives in the observed facts, not the spec.
- **`toSpecHash` is not `toCommit`.** A `CodeToSpec` change carries commits, a
  `SpecToCode` change carries spec hashes.
- **The acceptance output is a tail**, bounded at 4000 bytes, and the changed
  file list at 100.
