# Policy Engine How-To

Target: `policy-engine/` (Deno + TypeScript), with usage in `atproto-market/` and
`digitalocean-bidder/`. All paths below are relative to the org root
`/home/johnandersen777/src/publicdomainrelay-kcp/` unless noted.

This document describes the code as it exists on disk. Where behavior is not
implemented (for example, trigger enforcement), it is called out explicitly.

---

## TL;DR / mental model

A policy is **data, not code in the host**. It is an ATProto record referenced by
a strongRef. The record's `$type` names *how* it is executed. Two executor kinds
exist:

| `$type` | Executor | What executes |
|---|---|---|
| `computer.socialweb.temp.policy.ghalite` | `GhaLiteExecutor` | an inline GitHub Actions workflow (YAML) |
| `computer.socialweb.temp.policy.typescript` | `TypescriptExecutor` | a JS bundle from a `workerManifest` record, in a `deno-worker-sandbox` worker |

The verdict type is always:

```ts
interface PolicyResult { allow: boolean; violations: PolicyViolation[]; }
interface PolicyViolation { msg: string; policyId: string | StrongRef; }
```

Flow for one policy:

```
RFP.policies[] strongRef
  -> resolve(ref) -> value.$type
  -> EngineRegistry.get($type) -> executor
  -> executor.execute({ policyRecord, ctx, permissions })
  -> PolicyResult
```

For gha-lite: "the workflow IS the policy". The engine runs the workflow; a
completed run with `exit_status === "success"` allows, anything else denies. The
workflow's last steps are an allow-gate (`test "${{ steps.policy.outputs.allow }}" = "true"`),
so the policy action's `allow=false` output turns into a failing workflow.

For typescript: the manifest's `bundle` string must assign
`globalThis.__evaluatePolicy = async (input) => PolicyResult`. It runs with
deny-all permissions; every host read (record resolve, operator DID, vouch set,
logging) is an RPC back to the host `PolicyEvalCtx`.

Hot path: `scope()` is a trust-only lane (a workflow run with `mode: scope`, or an
in-process `decide()` for typescript) served from a host `ScopeCache`, keyed by
policy identity + counterparty DID + args.

---

## 1. Abstractions and the ABC

The single pluggability point is `PolicyEngineExecutor`. A new engine kind = a
sibling package plus one `EngineRegistry` entry. Never a branch inside an
existing executor.

Source: `policy-engine/lib/abc/policy-engine/mod.ts`

```ts
export interface PolicyEngineExecutor {
  readonly kind: string;
  execute(input: {
    policyRecord: PolicyRecord;      // {uri, cid, value}; value.$type === kind
    ctx: PolicyEvalCtx;
    permissions?: Record<string, unknown>;
  }): Promise<PolicyResult>;
  scope?(input: {
    policyRecord: PolicyRecord;
    scope: ScopeInput;
  }): Promise<PolicyResult | undefined>;
}

export interface EngineRegistry {
  get($type: string): PolicyEngineExecutor | undefined;
  kinds(): string[];
}

export interface PolicyEngineServer {
  evaluate(input: PolicyEvalRequest): Promise<PolicyResult>;
  describe(): Promise<DescribedPolicy[]>;
  checkScope(input: ScopeRequest): Promise<PolicyResult>;
  registry: EngineRegistry;
}

export interface PolicySeeder {
  ensure(): Promise<RecordRef[]>;
  startRefresh(intervalMs: number): RefreshHandle;
}
```

`scope()` returning `undefined` means "cannot decide from the scope snapshot";
the evaluator then escalates to full `execute()`.

Wire types and NSIDs live in `policy-engine/lib/common/policy-common/mod.ts`:

```ts
export const POLICY_GHA_LITE_NSID = "computer.socialweb.temp.policy.ghalite";
export const POLICY_TYPESCRIPT_NSID = "computer.socialweb.temp.policy.typescript";
export const MARKET_EVALUATE_POLICY_NSID = "com.publicdomainrelay.temp.market.evaluatePolicy";
export const RFP_NSID = "com.publicdomainrelay.temp.market.rfp";
export const VOUCH_NSID = "sh.tangled.graph.vouch";
export const BADGE_BLUE_KEYS_NSID = "com.publicdomainrelay.temp.badgeBlueKeys";
```

Key types: `StrongRef {uri,cid}`, `PolicyArgs {bidWindowSec?, firstFree?,
cacheTtlSec?, [k]:unknown}`, `PolicyRecord {uri,cid,value?,payload?}`,
`DemandSide {rfpRef,payloadRef,payloadNsid,payload?}`,
`OfferSide {bidRef,payloadRef,payloadNsid,payload?}`, and `PolicyEvalCtx`:

```ts
export interface PolicyEvalCtx {
  policyName: string;
  args: PolicyArgs;
  perspective: "bidder" | "requester";
  selfDid: string;
  counterpartyDid: string;
  subjectDid: string;
  rootRequesterDid: string;
  resolve: (ref: StrongRef) => Promise<Record<string, unknown>>;
  resolveOperatorDid: (did: string) => Promise<string | null>;
  getVouchedDids: (did: string) => Promise<Set<string>>;
  log: (level: string, msg: string, meta?: Record<string, unknown>) => void;
  policyRef?: StrongRef;
  demand?: DemandSide;
  offer?: OfferSide;
}
```

### The one import callers use: `policy-engine-evaluator`

Source: `policy-engine/lib/policy-engine-evaluator/mod.ts`

```ts
createPolicyEvaluator(opts: {
  registry: EngineRegistry;
  resolve: (ref: StrongRef) => Promise<Record<string, unknown>>;
  resolveOperatorDid?: (did: string) => Promise<string | null>;
  getVouchedDids?: (did: string) => Promise<Set<string>>;
  scopeCache?: ScopeCache;
  policies?: PolicyRegistry;
  log?: (level, msg, meta?) => void;
}): PolicyEvaluator
```

Returns:

- `evaluatePolicies({ refs, ctx, permissions? })` — resolve each ref, read
  `value.$type`, `registry.get($type)`, `executor.execute(...)`. Iterates the RFP
  `policies[]` set; **first deny short-circuits**, all-must-allow.
- `scope({ ref?, policyRecord?, perspective, selfDid, counterpartyDid, args })`
  — scope-cache lookup, then `executor.scope(...)`, else escalate to
  `executor.execute(...)`; caches the verdict.
- `buildPolicyRecord({ name, kind, workflow?|manifest?|policies?, args?,
  permissions?, requesterDid, perspective?, description? })` — returns
  `{ nsid, record }` ready to `createRecord`. A gha-lite record carries
  `workflow`; a typescript record carries `policies: [{name,args}]` and a
  `manifest` strongRef.
- Re-exports `resolvePolicyName` (legacy `only-me` -> `bidder-only-me` /
  `requester-only-me`).

### Scope cache

Source: `policy-engine/lib/policy-engine-scope-cache/mod.ts`

Key = `scopeCacheKey(policyIdentity, counterpartyDid, args)` where identity is a
policy strongRef or a name. `allow=true` entries live 5 min, `allow=false` 30 s;
LRU cap 1024. `applyEvent({ did, rkey })` drops every cached verdict touching
either DID — wired to firehose `badgeBlueKeys` / `vouch` / bidder-association
events.

### In-process policy registry (`deno-typescript`)

Source: `policy-engine/lib/policies/deno-typescript/registry.ts`. Nine builtins:
`open`, `bidder-only-me`, `requester-only-me`, `bidder-mutuals`,
`requester-mutuals`, `bidder-tangled-vouch`, `requester-tangled-vouch`,
`under-4-cpus`, `bid-payload`. The registry returns `Policy` objects
(`TrustPolicy` with `decide()` + `evaluate()`, or `WorkPolicy` with
`perspectives[]` + `evaluate()`). `createPolicyRegistry(extra?)` adds more.

---

## 2. Package layout and dependency direction

From `policy-engine/DESIGN.md`, enforced: `common <- abc <- impl <- factory <-
CLI`, one `mod.ts` export per package, no cycles.

```
policy-engine/
  lib/common/policy-common/                 wire types + NSIDs
  lib/abc/policy-engine/                    the interfaces above
  lib/policy-engine-executor-gha-lite/      GhaLiteExecutor
  lib/policy-engine-executor-typescript/    TypescriptExecutor
  lib/policy-engine-server-gha-lite/        the GHA workflow engine (WorkflowExecutor, models, eval, action_worker, server, main.ts)
  lib/policies/deno-typescript/             the 9 builtin policies + registry
  lib/policies/deno-typescript-shared/      createPolicyCtx, runPolicy, scopeDecide, cache, types
  lib/policies/gha-lite/                    action-common + WORKFLOWS + bundled actions + workflows/*.yml
  lib/policy-engine-evaluator/              evaluatePolicies / scope / buildPolicyRecord
  lib/policy-engine-scope-cache/            ScopeCache
  lib/policy-engine-cli-options/            --policy / --policy-args / exec gates
  lib/policy-seeder-atproto/                AtprotoPolicySeeder
  lib/hono-factory-policy-engine/           Hono XRPC surface
  hono-policy-engine/                       CLI entrypoint
  lexicons/computer/socialweb/temp/policy/  ghalite.json, typescript.json
```

The workspace is declared in `policy-engine/deno.json`; JSR package names are
`@publicdomainrelay/policy-engine-abc`, `@publicdomainrelay/policy-common`,
`@publicdomainrelay/policy-engine-evaluator`,
`@publicdomainrelay/policy-engine-executor-gha-lite`,
`@publicdomainrelay/policy-engine-executor-typescript`,
`@publicdomainrelay/policy-engine-scope-cache`,
`@publicdomainrelay/policy-engine-cli-options`,
`@publicdomainrelay/policy-deno-typescript`,
`@publicdomainrelay/policy-deno-typescript-shared`,
`@publicdomainrelay/policies-gha-lite`,
`@publicdomainrelay/hono-factory-policy-engine`,
`@publicdomainrelay/policy-seeder-atproto`.

---

## 3. Server and XRPC surface

Source: `policy-engine/lib/hono-factory-policy-engine/mod.ts`

```ts
createPolicyEngineServer(opts): PolicyEngineServer   // registry-dispatch evaluate/describe/checkScope
createPolicyEngineFactory(opts): { app: Hono; server: PolicyEngineServer }
```

Endpoints:

| Method | Path | Body | Response |
|---|---|---|---|
| GET | `/.well-known/did.json` | — | `did:web` doc with service `#market_policy_evaluate` (`PolicyEngineService`) |
| POST | `/xrpc/com.publicdomainrelay.temp.market.evaluatePolicy` | `PolicyEvalRequest` | `PolicyResult` |
| POST | `/xrpc/com.publicdomainrelay.temp.market.policy.describe` | `{}` | `{ policies: DescribedPolicy[] }` |
| POST | `/xrpc/com.publicdomainrelay.temp.market.policy.checkScope` | `ScopeRequest` | `PolicyResult` |

`evaluate` accepts either a resolved `policyRecord` or a `policyRef` it resolves
via the injected `resolve`. `checkScope` requires a `policyRef` (it runs the
record's scope lane). Unknown `$type` and missing refs fail closed (deny).

### CLI

Source: `policy-engine/hono-policy-engine/mod.ts`. `buildRegistry()` returns the
two-executor registry; `makeResolver()` resolves a strongRef via the repo DID's
PDS (`IdResolver` + `getPdsEndpoint` -> `com.atproto.repo.getRecord`). The CLI
composes the factory with `createPolicyRegistry()` for `describe()` and a live
`ScopeCache`, then serves with `createServe`.

Config comes from `hono-policy-engine/cli-args-env.json` (resolved flags -> env
-> `config.json` -> defaults): `port` (`PORT`, default 8080), `hostname`
(`HOSTNAME`, default `localhost`).

Note: the CLI does **not** wire the seeder. The seeder's `ensure()` is exercised
by the integration test; wiring it needs an atproto client + repo DID (see
the CLI file comment).

---

## 4. How the REQUESTER uses it

Source: `atproto-market/lib/requester-xrpc/mod.ts` (around lines 1252-1300 and
1476-1505).

1. Build a registry and evaluator directly (both executors in-process):

```ts
const policyRegistry = createPolicyRegistry();
const ghaLiteExecutor = new GhaLiteExecutor();
const typescriptExecutor = new TypescriptExecutor();
const evaluator = createPolicyEvaluator({
  registry: {
    get: ($t) => $t === POLICY_GHA_LITE_NSID ? ghaLiteExecutor
              : $t === POLICY_TYPESCRIPT_NSID ? typescriptExecutor : undefined,
    kinds: () => [POLICY_GHA_LITE_NSID, POLICY_TYPESCRIPT_NSID],
  },
  resolve: (ref) => resolveRecordForPolicy(ref),
  resolveOperatorDid: (did) => resolveOperatorDid(did),
  getVouchedDids: (did) => policyVouchResolver.getDelegatedTrustedDids(did),
  policies: policyRegistry,
  log: (level, msg, meta) => log(`policy_eval_${level}`, { msg, ...(meta ?? {}) }),
});
```

2. Mint the RFP's policy record and attach it:

```ts
const canonical = resolvePolicyName(policyRegistry, policySpec.name, "requester");
const workflow = WORKFLOWS[canonical];
const { nsid, record } = evaluator.buildPolicyRecord({
  name: policySpec.name,
  description: policySpec.description,
  args: policyArgs,
  requesterDid: marketDid,
  perspective: "requester",
  kind: workflow ? "gha-lite" : "typescript",
  workflow,
  policies: [{ name: canonical, args: policyArgs }],
});
policyRef = await pds.createRepoRecord(nsid, record);
rfpRecord.policies = [{ $type: "com.atproto.repo.strongRef", uri: policyRef.uri, cid: policyRef.cid }];
```

3. On bid collection, `evaluateCandidate(candidate)` runs
`evaluator.evaluatePolicies({ refs: [policyRef], ctx: {...} })` with
`perspective: "requester"`, `selfDid = marketDid`, `subjectDid =
counterpartyDid = candidate.did`, `rootRequesterDid = marketDid`, and `offer`
from the bid payload. It is the `allow` callback used by `BidCollector` (so the
`firstFree` early-winner path and the pre-accept re-check share one code path).
`PolicySpec`/`PolicyArgs` arrive via `@publicdomainrelay/policy-engine-cli-options`
(`--policy`, `--policy-args`).

RFP lexicon: `atproto-market/lexicons/com/publicdomainrelay/temp/market/rfp.json`
field `policies` is an array of strongRefs ("empty/absent means no
restriction").

---

## 5. How the BIDDER uses it

Two distinct jobs:

### 5a. Hot-path scope gate (before reading an RFP)

Source: `atproto-market/lib/market-bidder/mod.ts` (around lines 142-173,
341-375, 461-538).

The bidder canonicalizes its `--policy` to a bidder-side name and builds its own
in-memory gha-lite record (no ATProto write) with a stable synthetic URI/CID so
the scope cache keys predictably:

```ts
const canonical = resolvePolicyName(policyRegistry, config.policy, "bidder");
const scopeRecord = canonical && WORKFLOWS[canonical] ? {
  uri: `at://${atproto.did}/policy-gha-lite/${canonical}`,
  cid: canonical,
  value: { $type: POLICY_GHA_LITE_NSID, name: canonical,
           workflow: WORKFLOWS[canonical], createdAt: new Date().toISOString() },
} : undefined;

const scopeGate = async (counterpartyDid) => {
  if (!scopeRecord) return true;
  const r = await evaluator.scope({
    policyRecord: scopeRecord, perspective: "bidder",
    selfDid: atproto.did, counterpartyDid, args: policyArgs,
  });
  return r.allow;
};
```

`scopeGate` is used as `rfpScopeFilter` and as a firehose pre-filter for `rfp`
and `accept` events, so a denied counterparty is dropped before dispatch. Trust
events invalidate the cache:

```ts
eventStreams.watch({
  wantedCollections: [BADGE_BLUE_KEYS_NSID, VOUCH_NSID, BIDDER_ASSOCIATION_NSID],
  onEvent: (e) => scopeCache.applyEvent({ did: e.did, rkey: e.rkey }),
});
```

### 5b. Full evaluate of an RFP's attached policy (on receiving the RFP)

Source: `atproto-market/lib/market-bidder-compute/mod.ts` `onRfp` (lines 91-124).

The bidder iterates `rfp.policies` and calls the injected evaluator with
`perspective: "bidder"`, `selfDid = subjectDid = did`,
`rootRequesterDid = counterpartyDid = issuerDid`, and `demand` derived from the
RFP payload strongRef. On deny it returns `{ ok: false, error: "policy rejected",
violations }` and does not bid.

The evaluator is injected through `CallbackFactoryDeps.evaluator` (ABC type in
`atproto-market/lib/abc/market-bidder/mod.ts`), constructed in
`market-bidder/mod.ts` `beginServe()` with `resolveOperatorDid` (badgeBlueKeys
scan) and `getVouchedDids` (operator-delegated tangled vouch resolver).

`digitalocean-bidder` uses only the CLI-option + registry-name surface
(`parsePolicyArgs`, `policyNames`) for its policy-selection API; bidder
restarts pick up a new policy.

---

## 6. Defining policies as GitHub-Actions-like workflows

### 6.1 The record schema

`policy-engine/lexicons/computer/socialweb/temp/policy/ghalite.json`:

```json
{
  "lexicon": 1,
  "id": "computer.socialweb.temp.policy.ghalite",
  "defs": { "main": { "type": "record", "key": "tid",
    "record": { "type": "object", "required": ["name", "workflow", "createdAt"],
      "properties": {
        "name": { "type": "string" },
        "workflow": { "type": "string", "description": "GitHub Actions workflow YAML." },
        "permissions": { "type": "unknown" },
        "createdAt": { "type": "string", "format": "datetime" },
        "signatures": { "type": "ref", "ref": "network.attested.signature#signatures" }
      } } } }
}
```

`typescript.json` is the sibling: `name`, `policies: [{name, args?, description?}]`,
`manifest` (strongRef to `com.publicdomainrelay.temp.compute.deno.workerManifest`),
`permissions`, `createdAt`, `signatures`.

### 6.2 Supported workflow constructs

Parsed/executed by `policy-engine/lib/policy-engine-server-gha-lite/src/workflow.ts`
and typed in `src/models.ts`. Supported:

- Top-level: `name`, `on` (informational, see below), `env`, `defaults.run.shell`,
  `concurrency`, `jobs`.
- Job: `needs` (string or array; topologically ordered), `if`, `env`, `outputs`
  (expressions over the `needs`/`steps` context), `strategy.matrix`,
  `runs-on` (accepted, ignored), `defaults.run.{shell,working-directory}`,
  `concurrency`, `timeout-minutes`, `steps`.
- Step: `id`, `name`, `if`, `uses`, `run`, `shell`, `with`, `env`,
  `working-directory`, `continue-on-error`, `timeout-minutes`.
- Contexts available to `${{ }}`: `github`, `runner`, `steps`, `inputs`, `env`,
  `secrets`, `vars`, `needs`, `matrix`.
- Expression functions: `always()`, `success()`, `failure()`, `cancelled()`,
  `fromJSON`, `toJSON`, `contains`, `startsWith`, `endsWith`, `format`, `join`,
  `hashFiles`.
- Command files: `GITHUB_OUTPUT`, `GITHUB_ENV`, `GITHUB_PATH`, `GITHUB_STATE`,
  `GITHUB_CACHE`.
- Shells: `bash`/`sh`/`python` (default `bash -xe`); `pwsh`/`powershell`/`cmd`
  are refused.
- Error semantics track GitHub: after a failure, later steps are skipped unless
  `if: always()` / `failure()`; `continue-on-error` continues; missing/undefined
  conditions fail closed.

**Not enforced:** the `on:` triggers. The engine never gates on `push` /
`pull_request` / `workflow_dispatch`; it only surfaces `workflow_dispatch` inputs
via the `inputs` context. Trigger semantics exist only in the standalone HTTP
server's `/webhook/github` route (`src/server.ts`), which selects a workflow from
`event.sender.webhook_workflow` or a default.

`uses:` resolution order: local path (`./` or absolute) -> `ACTIONS_DIR`
(default `<workspace>/.tangled/actions`) -> `BUNDLED_ACTIONS_DIR` -> download
from GitHub (cached under `.cache/<org>/<repo>`; disabled in net-only). Action
`runs.using`: `node*` (Deno subprocess in full mode; permission-restricted
worker in net-only) or `composite`.

### 6.3 Real example workflow

The repository's canonical per-policy workflows are
`policy-engine/lib/policies/gha-lite/workflows/<name>.yml`; they are embedded
into `workflows.ts` (`WORKFLOWS`, name -> YAML) by
`scripts/gen-workflows.ts`. `policy-engine/lib/policies/gha-lite/workflows/requester-only-me.yml`:

```yaml
name: requester-only-me policy
on:
  workflow_dispatch:
    inputs:
      self-did: { description: DID running this evaluation, required: true }
      rfp: { description: 'JSON RFP record {uri,cid,value?}', required: false }
      bid: { description: 'JSON bid record {uri,cid,value?}', required: false }
      accept: { description: 'JSON accept record {uri,cid,value?}', required: false }
      policy-args: { description: JSON policy arguments, required: false }
      mode: { description: 'full or scope', required: false }
      counterparty-did: { description: DID of the other side (scope mode), required: false }
      perspective: { description: 'bidder or requester', required: false }
      subject-did: { description: subject DID override, required: false }
      root-requester-did: { description: root requester DID override, required: false }
jobs:
  evaluate:
    runs-on: self-hosted
    steps:
    - uses: tangy/policy-requester-only-me@v1
      id: policy
      with:
        self-did: ${{ inputs.self-did || '' }}
        rfp: ${{ inputs.rfp || '' }}
        bid: ${{ inputs.bid || '' }}
        accept: ${{ inputs.accept || '' }}
        policy-args: ${{ inputs.policy-args || '' }}
        mode: ${{ inputs.mode || '' }}
        counterparty-did: ${{ inputs.counterparty-did || '' }}
        perspective: ${{ inputs.perspective || '' }}
        subject-did: ${{ inputs.subject-did || '' }}
        root-requester-did: ${{ inputs.root-requester-did || '' }}
    - run: echo "allow=${{ steps.policy.outputs.allow }} violations=${{ steps.policy.outputs.violations }}"
    - run: test "${{ steps.policy.outputs.allow }}" = "true"
```

Every bundled workflow must carry that gate step; the integration test asserts
it. The action (`bundled-actions/tangy/policy-requester-only-me/action.yml`) is
`runs.using: node20`, `main: dist/index.js`, with `allow`, `violations`,
`cache-key` outputs. `dist/index.js` is committed (`deno task build`).

### 6.4 Two lanes in one workflow

`mode: scope` selects the trust-only lane. The shared action logic
(`lib/policies/gha-lite/action-common.ts`) reads `INPUT_*`, builds a
`PolicyEvalCtxImpl` via `createPolicyCtx`, and:

- `mode: scope` -> `scopeDecide(...)` over a trust snapshot built from the
  host-injected resolvers; on abstain it falls back to a full `runPolicy`.
- default `full` -> `runPolicy(store, policy, ctx, ...)`, memoized in the
  JSON-object cache.

Host trust data reaches the action through the request cache under
`trust/<counterpartyDid>` (see section 7), not through workflow inputs.

---

## 7. How a policy definition maps to execution

This is the end-to-end mapping, executor by executor.

### 7.1 gha-lite

`GhaLiteExecutor.execute()` (`lib/policy-engine-executor-gha-lite/mod.ts`):

1. Read `policyRecord.value.workflow` (YAML string). Missing/empty -> deny
   `"gha-lite record has no workflow"`.
2. Pre-resolve a `TrustInput { operatorOf, vouchedBy, trustedOperators }` for
   `selfDid` and `counterpartyDid` through the ctx resolvers
   (`buildTrustInput`).
3. Build `PolicyEngineRequest` (`buildRequest`):

```
inputs = {
  "self-did": ctx.selfDid,
  "subject-did": ctx.subjectDid,
  "root-requester-did": ctx.rootRequesterDid,
  "counterparty-did": ctx.counterpartyDid,
  "perspective": ctx.perspective,
  "policy-args": JSON.stringify(ctx.args),
  "permissions": JSON.stringify(record.permissions),   // if present
  "rfp": JSON.stringify({uri,cid,value})                // from ctx.demand if present
  "bid": JSON.stringify({uri,cid,value})                // from ctx.offer if present
}
context = {
  config: { env: { GITHUB_REPOSITORY: <repo of policy uri or selfDid>, GITHUB_ACTOR: selfDid } },
  cache:  { "trust/<counterpartyDid>": { "operatorOf.json", "vouchedBy.json", "trustedOperators.json" } },
}
```

4. `new WorkflowExecutor(...).executeWorkflow(request)` raced against
   `timeoutMs` (default `30_000`; overridable via `GhaLiteExecutorOptions`).
5. `statusToResult(status)`: allow **iff** `status.status === "complete"` and
   `detail.exit_status === "success"`; otherwise deny, with the first
   `annotations.error` as the message when present.

Inside the run, the `tangy/policy-*` action reads `INPUT_*`, runs the builtin
policy, and appends `allow=...`, `violations=...`, `from-cache=...`,
`cache-key=...` to `GITHUB_OUTPUT`. The next step echoes them; the gate step
fails the workflow when `allow != "true"`. Hence a policy deny becomes
`exit_status: "failure"` and the executor returns `allow: false`.

`GhaLiteExecutor.scope()` builds the same request with `mode: scope` plus
`self-did`, `counterparty-did`, `perspective`, `policy-args` and the trust
cache entry — no `rfp`/`bid`.

### 7.2 typescript

`TypescriptExecutor.execute()` (`lib/policy-engine-executor-typescript/mod.ts`):

1. Read `policyRecord.value.manifest` (strongRef). Missing -> deny.
2. `ctx.resolve(manifest)` -> workerManifest record; read its `bundle` string.
   Missing -> deny.
3. Merge permissions: record `value.permissions`, then manifest `permissions`,
   then caller `permissions`. Default deny-all.
4. Build a worker module = `bundle + WORKER_SHIM`, encoded as a `data:` URL, and
   spawn it via `createPersistentDenoWorker` (`@publicdomainrelay/sandbox-deno`).
   The shim owns `self.onmessage` and injects RPC stubs for `resolve`,
   `resolveOperatorDid`, `getVouchedDids`, `log`.
5. Post `{ type: "eval", id: 1, input: { policyName, args, perspective, selfDid,
   subjectDid, rootRequesterDid, counterpartyDid, policyRef, demand, offer } }`.
6. The bundle must set `globalThis.__evaluatePolicy = async (input) =>
   PolicyResult`. Settle on first terminal signal: `eval-result`, worker
   error/exit, or the 30 s timeout. `toPolicyResult` fails closed on any
   non-object / non-boolean / garbage result.
7. Host RPC methods are fulfilled by the real `PolicyEvalCtx`; `getVouchedDids`
   serializes the `Set` to a `string[]`.

`TypescriptExecutor.scope()` does not spawn a worker: it reads
`value.policies[]`, resolves names against `createPolicyRegistry()`, and runs
`scopeDecide(...)`. Returns `undefined` (escalate) when there are no named
registry trust policies or a `decide()` abstains.

### 7.3 Evaluator dispatch

`evaluatePolicies` resolves each ref, reads `value.$type` (falling back to the
URI's collection), gets the executor, and calls `execute`. `scope` checks the
scope cache, calls `executor.scope` if present, and — when that returns
`undefined` — escalates to `executor.execute` with a scope-derived ctx. Verdicts
are then cached.

---

## 8. Runtime, caching, error and timeout semantics

- **Timeout**: gha-lite `30_000` ms default (`GhaLiteExecutorOptions.timeoutMs`);
  typescript `30_000` ms default (`TypescriptExecutorOptions.timeoutMs`). On
  timeout the executor returns a deny; the gha-lite run is not cancelled (the
  race abandons it).
- **Retry**: none. There is no retry loop in either executor.
- **Errors**: every executor path fails closed (deny). `PolicyResult.violations`
  carries `msg` + `policyId`.
- **Sandbox**: `SandboxConfig` from `POLICY_ENGINE_NET_ONLY` / `POLICY_ENGINE_FS_API`
  or CLI `--net-only` / `--fs-api`. `full` (default): actions run as Deno
  subprocesses; ephemeral workspace/cache/home dirs. `net-only`: expression
  evaluation gets network only; `run` and composite steps are refused; JS/TS
  actions run in the permission-restricted worker with an in-memory virtual FS.
- **Verdict cache** (`deno-typescript-shared/cache.ts` + `evaluate.ts`):
  `runPolicy` memoizes under `policy/<name>/<rfp ref>|<bid ref>|<accept ref>[:argsHash]`
  with a default 30 s TTL (`cacheTtlSec` overrides). Record bodies cache under
  `rec/<uri>/<cid>` (immutable). LRU cap default 512. The map rides the
  `GITHUB_CACHE` command file and returns in `detail.cache`, so callers persist
  it across runs.
- **Scope cache**: see section 1.

---

## 9. Seeding policy records

`AtprotoPolicySeeder` (`lib/policy-seeder-atproto/mod.ts`) mirrors the bidder's
offering seeder: for each `PolicyDefinition { nsid, name, build(now), matches(existing) }`,
list records of the nsid, match on `name`, `updateRecord` in place (one canonical
rkey) or `createRecord`. `ensure()` returns the refs callers put into
`RFP.policies[]`. Helpers: `ghaLitePolicyDefinition`, `typescriptPolicyDefinition`,
`ghaLitePolicyDefinitions()` (one per `WORKFLOWS` entry),
`typescriptPolicyDefinitions(bundleRef)`.

---

## 10. Development environment and iteration

- **Deno**: 2.9.3 in this environment; CI pins `deno-version: v2.x`
  (`.github/workflows/build.yml`). Requires `--unstable-worker-options` for the
  permission-restricted expression/action workers.
- **Workspace**: `policy-engine/deno.json` lists the member packages and
  `nodeModulesDir: "auto"`. Deps are JSR (`@std/*`, `hono`) plus local paths to
  `../deno-worker-sandbox` and `../typescript-helpers`. `deno.lock` is committed.

Root tasks (`policy-engine/deno.json`):

```bash
deno task test    # deno test --allow-all --unstable-worker-options test/
deno task check   # deno check <every package mod.ts>
deno fmt          # formatting (lineWidth 100 in package configs)
deno lint
```

gha-lite workflow/action build and regeneration
(`policy-engine/lib/policies/gha-lite/deno.json`):

```bash
cd lib/policies/gha-lite
deno task gen-workflows   # workflows/*.yml -> workflows.ts
deno task build           # gen-workflows + deno bundle each action -> dist/index.js
deno task check
```

Iterate on a policy definition:

1. Edit `lib/policies/gha-lite/workflows/<name>.yml`.
2. `cd lib/policies/gha-lite && deno task build` (regenerates `workflows.ts` and
   the action bundles; `dist/` is committed).
3. Run it locally with the engine's `run` command (section 11).
4. `cd ../.. && deno task test`.

CI flags for this repo (`scripts/ci-discover.ts`): `-A --unstable-worker-options`,
`needsDocker: false`. Compiled binary: `deno compile --allow-all ... policy-engine/hono-policy-engine/mod.ts`.

---

## 11. Concrete copy-pasteable examples

### 11.1 Run the gha-lite engine on a workflow directly

Uses the engine package's own tasks (`lib/policy-engine-server-gha-lite/deno.json`).

```bash
cd policy-engine/lib/policy-engine-server-gha-lite

BUNDLED_ACTIONS_DIR=../policies/gha-lite/bundled-actions \
  deno task run --workflow ../policies/gha-lite/workflows/bidder-only-me.yml \
  --input self-did=did:plc:lpfuqerea3deuoyrn7ojser4 \
  --input 'rfp={"uri":"at://did:plc:5svqtrhheairglgiiyvutzik/com.publicdomainrelay.temp.market.rfp/3mm","cid":"bafyrei..."}'
```

```bash
# Scope lane, net-only sandbox — trust-only, no records, no fs.
BUNDLED_ACTIONS_DIR=../policies/gha-lite/bundled-actions \
  deno task run --workflow ../policies/gha-lite/workflows/bidder-only-me.yml --net-only \
  --input self-did=did:plc:lpfuqerea3deuoyrn7ojser4 \
  --input mode=scope \
  --input counterparty-did=did:plc:5svqtrhheairglgiiyvutzik
```

The command prints the status JSON; exit code is non-zero when
`detail.exit_status === "failure"`.

### 11.2 Start the HTTP policy engine

```bash
cd policy-engine/hono-policy-engine
deno run --allow-all --unstable-worker-options mod.ts
# PORT=9090 HOSTNAME=policy.example deno run --allow-all --unstable-worker-options mod.ts
```

```bash
curl -s localhost:8080/xrpc/com.publicdomainrelay.temp.market.policy.describe -X POST -d '{}' | jq
curl -s localhost:8080/xrpc/com.publicdomainrelay.temp.market.evaluatePolicy -X POST \
  -H 'content-type: application/json' \
  -d '{"policyRef":{"uri":"at://did:plc:.../computer.socialweb.temp.policy.ghalite/x","cid":"bafyrei..."},
       "name":"requester-only-me","perspective":"requester","selfDid":"did:plc:req",
       "subjectDid":"did:plc:bid","rootRequesterDid":"did:plc:req"}' | jq
```

### 11.3 Mint a gha-lite policy record in code (from the integration test)

Adapted from `policy-engine/test/policy_engine_integration_test.ts` (real code,
reformatted):

```ts
const workflow = ["name: gate", "on: push", "jobs:", "  j:",
  "    runs-on: self-hosted", "    steps:",
  "      - run: echo \"allow=true\" >> $GITHUB_OUTPUT",
  "        id: policy",
  "      - run: test \"${{ steps.policy.outputs.allow }}\" = \"true\""].join("\n");

const gha = new GhaLiteExecutor();
const ts = new TypescriptExecutor();
const evaluator = createPolicyEvaluator({
  registry: {
    get: ($type) => $type === POLICY_GHA_LITE_NSID ? gha
             : $type === POLICY_TYPESCRIPT_NSID ? ts : undefined,
    kinds: () => [POLICY_GHA_LITE_NSID, POLICY_TYPESCRIPT_NSID],
  },
  resolve: async (ref) => valueOf(ref),   // resolve strongRef -> record value
});

const { nsid, record } = evaluator.buildPolicyRecord({
  name: "open", kind: "gha-lite", workflow, requesterDid: "did:plc:op", perspective: "requester",
});
// record.$type === "computer.socialweb.temp.policy.ghalite"
```

### 11.4 Define a typescript policy bundle

The bundle contract is documented in `lib/policy-engine-executor-typescript/mod.ts`.
The following is a synthesized example (shaped after the RPC bundle in
`test/policy_engine_integration_test.ts`); it is not copied verbatim from the repo:

```js
globalThis.__evaluatePolicy = async (input) => {
  const rec = await input.resolve({ uri: "at://.../com.example.r/rec", cid: "..." });
  const op = await input.resolveOperatorDid(input.subjectDid);
  const vouched = await input.getVouchedDids(input.selfDid);
  input.log("info", "evaluated", { op, vouched: vouched.length });
  return rec.ok === true && op === "did:plc:operator"
    ? { allow: true, violations: [] }
    : { allow: false, violations: [{ msg: "not trusted", policyId: "typescript" }] };
};
```

Wrap it as a workerManifest (`bundle` string) and reference it from a
`computer.socialweb.temp.policy.typescript` record's `manifest` strongRef.

---

## 12. Existing lexicon / XRPC / atproto surface

- Policy records: `computer.socialweb.temp.policy.ghalite`,
  `computer.socialweb.temp.policy.typescript`
  (`policy-engine/lexicons/computer/socialweb/temp/policy/*.json`).
- Engine XRPC: `com.publicdomainrelay.temp.market.evaluatePolicy`,
  `com.publicdomainrelay.temp.market.policy.describe`,
  `com.publicdomainrelay.temp.market.policy.checkScope`, plus
  `/.well-known/did.json` (did:web `PolicyEngineService`).
- RFP: `com.publicdomainrelay.temp.market.rfp.policies` = array of strongRefs
  (`atproto-market/lexicons/com/publicdomainrelay/temp/market/rfp.json`).
- Worker bundle holder: `com.publicdomainrelay.temp.compute.deno.workerManifest`
  (`bundle`, `lock`, `json`, `permissions`, `signatures`).
- Trust inputs: `com.publicdomainrelay.temp.badgeBlueKeys`
  (`bidder_associate` / `requester_associate`), `sh.tangled.graph.vouch`.
- `scripts/build-actions.ts` and `deno task gen-workflows` are the only
  code-generation steps.

Legacy `com.publicdomainrelay.temp.market.policies.{builtin,service,denoWorker}`
records and the old atproto-market `market-policy-*` packages are documented as
superseded in `POLICY_ENGINE_RIP_OUT_PLAN.md`; the two new kinds replace them.

---

## 13. Gaps and ambiguities (stated, not invented)

- The gha-lite engine ignores `on:` triggers. Trigger dispatch is only in the
  standalone HTTP server's `/webhook/github` handler, not in the executor path.
- The `hono-policy-engine` CLI does not wire `AtprotoPolicySeeder`; only the
  integration test exercises it.
- `policy-engine/DESIGN.md` labels the package exports `@computer.socialweb.*`;
  `deno.json` files actually use `@publicdomainrelay/*`. Follow the `deno.json`
  names.
- `typescript.json`'s `policies[]` names are looked up only in the in-process
  `createPolicyRegistry()` for the scope lane; `execute()` always runs the
  bundle, whose own code decides what `policies[]` mean.
- No retry logic exists in either executor; failures deny immediately.
- `documented` (`docs/policy-stack.md`) describes an older three-kind model
  (`.builtin` / `.service` / `.denoWorker`); the current implementation is the
  two-kind gha-lite/typescript model.
