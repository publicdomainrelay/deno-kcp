# Deno embedding research: many isolated workloads without a process per run

Status: research / decision input. No code in `deno-kcp` was changed by this
document. Everything marked "ran" below was executed on this host
(`deno 2.9.3`, `go 1.26.2`, Linux x86_64) with throwaway `deno eval` snippets
that did not touch the repo. Everything else is doc-verified with a URL, or is
explicitly marked as needing a spike.

**Status: withdrawn.** Option (C) was built, ran as the default for a period, and
was then removed: the provider forks one `deno run` per workload again. The
measurements below are what the spike produced and they were not the reason for
the removal, which was a decision about which runtime to carry. Read this as the
record of a decision, not as a description of the code.

---

## 1. TL;DR

Recommended: **(B)/(C) - one long-lived "worker host" process per provider,
written in TypeScript, spawned once, that runs each workload as an in-process
Deno `Worker` (one V8 isolate on its own OS thread) and drives them over a
stdio NDJSON control protocol.** The Go provider supervises the one host and
sends `start` / `status` / `stop` commands; the host maps each command to
`new Worker(...)` and `worker.terminate()`.

- The host is spawned **once**, not per pod/run/engine. One OS process holds
  N workloads as N isolates.
- Per-workload isolation is the Deno Worker permission table (`deno:
  { permissions: ... }`) plus a host-injected shim for env, virtual cwd,
  log attribution, and `Deno.exit`. This is the same mechanism
  `../policy-engine` already uses in `action_worker.ts` and
  `../deno-worker-sandbox` uses in `persistent-worker.ts`.
- The Go side already speaks `os/exec` + pipes and already has a `DENO_BIN`
  flag, so a host is a small change to `impl/execrunner` in `kcp-libs` and
  `cmd/deno-kcp-provider/main.go`.

Not recommended now: **(A) embedding Deno inside the Go process via a Rust
`cdylib` + cgo.** It is the only true in-process path, but Deno publishes no C
ABI, `deno_core` is an op-level runtime with no TypeScript/web APIs,
`deno_runtime` says its API is "subject to rapid and breaking changes", and the
work is a custom per-platform Rust bridge. High effort, permanent maintenance,
no payoff over the host process.

`deno compile` is orthogonal: it is a delivery/pinning option for the host
binary, not a different execution model. Do not `--bundle` the host.

---

## 2. Current state (grounding)

`impl/execrunner` in `kcp-libs` spawns one `deno` OS process per workload:

- `ExecPod.Start` writes `deno.json`, `deno.lock`, `main.ts`, `ca.pem`,
  `stdout.txt`, `stderr.txt` into `runs/<id>/`, then
  `exec.Command(deno, "run", <PermissionArgs>, "main.ts")` with `cmd.Dir = dir`
  and env (`DENO_DIR=dir/.deno`, `DENO_CERT`, `KCP_TOKEN`, `KCP_SERVER`,
  `KCP_WORKSPACE`). `Stop` is `syscall.Kill(-pid, SIGKILL)`.
- `ExecEngine.Start` runs
  `deno run --allow-all --unstable-worker-options main.ts api --bind 127.0.0.1:<port>`
  in the policy-engine directory. `Stop` is the same SIGKILL.
- Permission flags come from `common/denospec` `Args()` in `kcp-libs`, reached
  through `DenoPermissions.DenoSpec()` in `api/v1alpha1/denospec.go`; it maps the
  CR `DenoPermissions` struct to `--allow-*` / `--deny-*`.
- Reconcile is driven by the event-driven watch driver (informers over the
  APIExport virtual workspace). `Observe` reads `done.json` (`exitCode`) and
  `result.json` (outputs). `Probe` runs an exec command in the run dir.

So the isolation unit today is the OS process, and the count is one process per
DenoPod / DenoRun / DenoJob child / PolicyEngine.

Prior art in the org root that already does in-process Workers:

- `../policy-engine/lib/policy-engine-server-gha-lite/src/action_worker.ts`
  builds a worker from a `Blob` URL with `deno: { permissions: {...} }`, shims
  `console`, `Deno.exit`, `Deno.env`, and a virtual FS for `GITHUB_*` writes,
  streams log lines to the host via `postMessage`, and calls
  `worker.terminate()` on completion. Its header comment says it replaces
  `deno run --allow-all <action>` with an in-process permission-restricted
  worker. Its file comment: "Requires the `--unstable-worker-options` flag".
- `../deno-worker-sandbox/lib/sandbox-deno/persistent-worker.ts`
  (`createPersistentDenoWorker`) and `mod.ts` (`createDenoSandbox`).
- `../deno-worker-sandbox/README.md` states the requirement plainly:
  "Deno >= 2. Permissions: `--allow-env --allow-read --allow-write
  --allow-run --allow-net --unstable-worker-options`".

This is the pattern to generalize; no new sandbox primitive has to be invented.

---

## 3. Option comparison

| | (A) Embed Deno via Rust cdylib + cgo | (B) Long-lived TS worker host, `deno compile`d | (C) Long-lived TS worker host, `deno run` | (D) Other |
|---|---|---|---|---|
| Process count | 0 extra; Deno inside provider | 1 host total (or per tier) | 1 host total | fork-per-run = no win; node:worker_threads host |
| Isolation unit | V8 isolate inside Go process | V8 isolate + Deno permission table | same as (B) | isolate (node:worker_threads) |
| Hard cancel | Rust bridge must implement it | `worker.terminate()` | `worker.terminate()` | `worker.terminate()` |
| Deno API surface | `deno_core` = no TS/npm/web APIs; `deno_runtime` = unstable API; `deno` = no lib API | full Deno runtime | full Deno runtime | full Deno runtime |
| Go integration | cgo + C ABI shim + per-platform cdylib | pipe to a child process (today's pattern) | pipe | pipe |
| Build/deploy cost | Rust toolchain, V8 link, cross-build per target | `deno compile` per target or ship `deno` | ship `deno` | ship `deno` |
| Runtime pinning | compile-time | baked into the binary | pinned by the `deno` on PATH | pinned by `deno` |
| Risk | high, permanent | low-medium | low | medium |
| Recommendation | no (now) | yes, second step | yes, first step | no |

(B) and (C) are the same architecture. Ship (C) first (no compile step, reuses
`DENO_BIN`), add (B) when a host without `deno` on PATH is wanted.

Option (D) worth noting: `node:worker_threads` in Deno is real and its
`resourceLimits` gives a per-worker memory cap that the Web Worker API lacks
(see section 6). It is a possible host base, but it does not expose the
per-worker `deno.permissions` option, so the permission model in (B)/(C) is
lost. Keep it as a fallback if the memory cap becomes mandatory.

---

## 4. Findings by question

### 4.1 Does Deno support being embedded as a library?

Deno publishes several crates; none is a stable embedding library with a C ABI.
Versions and license below were read from the crates.io API and docs.rs on the
research date; the repo for all three is `https://github.com/denoland/deno`
and the license is **MIT**.

| Crate | Version | What it is | Stability signal |
|---|---|---|---|
| `deno_core` | 0.412.0 | "This Rust crate contains the essential V8 bindings for Deno's command-line interface (Deno CLI). The main abstraction here is the `JsRuntime` which provides a way to execute JavaScript." | "TypeScript support and lots of other functionality are not available at this layer. See the CLI for that." |
| `deno_runtime` | 0.267.0 | "This is a slim version of the Deno CLI which removes typescript integration and various tooling (like lint and doc). Basically only JavaScript execution with Deno's operating system bindings (ops)." | "the API of this crate is subject to rapid and breaking changes." |
| `deno` | 2.9.7 | "This provides the actual deno executable and the user-facing APIs. The deno crate uses the deno_core to provide the executable." | executable crate, no documented library API |

- `deno_core` docs: https://docs.rs/deno_core
- `deno_runtime` docs: https://docs.rs/deno_runtime
- `deno` crate docs: https://docs.rs/deno
- `JsRuntime` docs describe it as "A single execution context of JavaScript.
  Corresponds roughly to the 'Web Worker' concept in the DOM." So the
  isolate-per-workload model maps cleanly onto `deno_core` - if one writes the
  Rust host.

The key distinction: **`deno_core` is an op-level JavaScript runtime, not a
Deno runtime.** It has no `Deno` namespace, no TypeScript, no npm/JSR, no
`fetch`/`Deno.serve` unless you register the extensions yourself.
`deno_runtime` adds the `Deno` ops and a `MainWorker`, but with an unstable
API. There is no C ABI and no `cdylib` published.

A cgo/FFI path from Go therefore does **not exist off the shelf**. It would
require a custom Rust `cdylib` that wraps `deno_core`/`deno_runtime`, exports a
C ABI (`host_create`, `host_start_worker`, `host_terminate`, ...), drives the
V8/Tokio event loop in Rust, and is loaded from Go with cgo. That is option
(A); it is buildable but it is a new product to own, not a library call.

### 4.2 What does `deno compile` produce?

Docs: https://docs.deno.com/runtime/reference/cli/compile/

- It produces a single self-contained executable. "`deno compile` embeds your
  program into `denort` ('Deno runtime'): a stripped build of Deno that
  contains only what's needed to run a compiled program, with none of the
  tooling subcommands. Using `denort` as the base instead of the full `deno`
  binary is what keeps compiled executables smaller."
- **Workers are not embedded by default.** "code for workers is not included in
  the compiled executable by default. There are two ways to include workers:
  1. Use the `--include <path>` flag ... 2. Import worker module using a
  statically analyzable import."
- **Computed-URL workers are dropped by `--bundle`.** "Workers spawned with
  computed URLs, or spawned from transitive dependencies rather than your own
  source." require `--include`, or compile without `--bundle`.
- Permissions are baked at compile time. "the runtime flags used to execute the
  script must be specified at compilation time. This includes permission
  flags."
- Cross-compilation to all targets regardless of host: `x86_64`/`aarch64` for
  Linux (gnu), macOS (darwin), Windows (msvc).
- `--self-extracting` extracts embedded files to disk on first run; trade-offs
  are extra startup cost, disk, memory, and tamper risk.
- `--engine quickjs` is experimental, smaller, no JIT, and "does not receive
  the same security updates as V8. Don't use it for programs that run untrusted
  input."

Consequence for us: a **compiled worker host is viable and useful** (it pins
the runtime and removes the `deno` dependency), but it must be compiled
**without `--bundle`** so the per-workload `main.ts` can still be loaded from
disk at runtime. With `--bundle`, the static worker discovery would conflict
with dynamically spawned per-run workers. The host binary is compiled with
`--allow-all --unstable-worker-options`; the individual workloads are then
scoped down inside the process by the Worker permission table.

This is delivery of (B), not a different execution model.

### 4.3 Workers on threads

Docs: https://docs.deno.com/runtime/reference/web_platform_apis/#web-workers
and https://docs.deno.com/api/web/~/Worker

- Real OS threads, one per worker: "Workers can be used to run code on
  multiple threads. Each instance of `Worker` is run on a separate thread,
  dedicated only to that worker." And the API reference: "Workers run in a
  separate thread, allowing for parallel execution without blocking the main
  thread."
- Module workers only: "Currently Deno supports only `module` type workers;
  thus it's essential to pass the `type: "module"` option when creating a new
  worker."
- Construction: `new Worker(new URL("./worker.ts", import.meta.url).href, {
  type: "module" })`. A `Blob`/`data:` URL also works, which is what
  `action_worker.ts` uses to inject a generated module.
- Message passing: `worker.postMessage(msg)` and `worker.onmessage` on the
  host; `self.onmessage` and `self.postMessage` inside the worker. Messages are
  structured-clone values; `Transferable` objects can be transferred.
  `MessageChannel`/`MessagePort` are available globally (verified).
- Errors: `worker.onerror` receives an `ErrorEvent`; `worker.onmessageerror`
  fires when a message cannot be deserialized. A thrown error inside a worker
  printed `Uncaught (in worker "") Error: ...` to stderr and fired `onerror` on
  the host in a run test.
- Termination: `worker.terminate()` exists on the Worker interface. This is the
  hard-cancel primitive.
- Per-worker permissions: an **unstable** Deno extension. The `deno.permissions`
  option is documented as "This is an unstable Deno feature." Semantics:
  "By default a worker will inherit permissions from the thread it was created
  in", `"none"` removes all, a per-capability object (`net`, `read`, `write`,
  `env`, `run`, `ffi`, `sys`, `import`, `hrtime`) takes `true`/`false`, a list
  of resources, or `"inherit"`. Crucially: "the permissions of a worker can't
  be extended beyond its parent's permissions reach." The `read`/`write` lists
  are resolved relative to the module that instantiates the worker, so pass
  absolute run-dir paths.
- Resource limits: the Web Worker API exposes **no** per-worker memory cap.
  `node:worker_threads` does (`ResourceLimits.maxOldGenerationSizeMb`,
  https://docs.deno.com/api/node/worker_threads/). This is the one real gap
  (section 6).

Ran on Deno 2.9.3 to confirm the risky parts:

- Without `--unstable-worker-options`, constructing a worker with
  `deno: { permissions: ... }` fails with exactly:
  `Unstable API 'Worker.deno.permissions'. The --unstable-worker-options flag must be provided.`
- Two workers each running a 300ms CPU-bound loop finished in **321ms** total
  (sequential would be ~600ms): they are concurrent threads, not a shared event
  loop.
- `worker.terminate()` against a worker stuck in `while (true) {}` returned
  immediately and the host exited cleanly: hard cancel works.
- Per-worker `read: ["/tmp/opencode"]` allowed a read inside that path and
  denied `/etc/hosts` with
  `NotCapable: Requires read access to "/etc/hosts", run again with the --allow-read flag`.
- `console.log` in a worker writes to the **host process stdout**, unattributed.
  Log attribution must be shimmed per worker.
- `Deno.exit(7)` called inside a worker did **not** kill the host process.
- Overriding `Deno.writeTextFile` inside the worker to prepend a root path
  successfully virtualized a relative write.
- `new Worker("file:///abs/path.ts", { type: "module" })` works: the host can
  load per-run `main.ts` from disk.
- A live worker does **not** keep the host process alive: the host must hold
  itself open (await a never-resolving promise, or serve on a socket).

### 4.4 FFI direction sanity

Docs: https://docs.deno.com/runtime/fundamentals/ffi/

`Deno.dlopen` is **Deno calling native code**. The documented pattern loads a
`.so`/`.dylib`/`.dll` and calls its C symbols; the canonical example compiles a
Rust `cdylib` with `rustc --crate-type cdylib lib.rs` and loads it with
`Deno.dlopen`. `Deno.UnsafeCallback` passes JS callbacks into native code. This
is Deno -> C, not C/Go -> Deno.

So:

- **Go hosting Deno in-process** requires a native library that *exports* a C
  ABI wrapping the runtime, i.e. a custom Rust `cdylib` over
  `deno_core`/`deno_runtime`, loaded from Go with cgo. `deno`/`deno_core` do not
  provide such a library. This is possible but is option (A).
- **Deno hosting Go in-process** is possible (`Deno.dlopen` a Go
  `-buildmode=c-shared` library), but it is the wrong direction for us: the Go
  provider is the controller; it does not need to be called from inside a
  workload. It also adds a per-workload FFI handle to untrusted code, which is
  a security downgrade.
- **Verdict:** `Deno.dlopen` is not a shortcut to embedding. The only
  realistic in-process option is the Rust `cdylib` bridge. The realistic
  full-runtime option is the worker host process.

---

## 5. Recommended architecture

### 5.1 Shape

```
  +-------------------------------------------------------------+
  |  Go provider process (cmd/deno-kcp-provider)                |
  |                                                             |
  |  reconcile loop -- podRequest/engineRequest --> WorkerHost   |
  |                                                 client       |
  +--------------------------------|----------------------------+
                                   | stdio
                      newline-delimited JSON (NDJSON)
                                   |
  +--------------------------------v----------------------------+
  |  Deno worker host (one OS process; TS; optional deno compile)|
  |                                                             |
  |  stdin reader -> dispatch table                             |
  |    start  -> new Worker(blobUrl, {type:"module",             |
  |             deno:{permissions}})  ---- V8 isolate on thread  |
  |    status -> worker registry                                |
  |    stop   -> worker.terminate()                             |
  |                                                             |
  |  worker onmessage -> stdout/stderr/state frames -> stdout    |
  |                                                             |
  |  workload A (isolate)   workload B (isolate)   ...           |
  +-------------------------------------------------------------+
```

The host is one process for the whole provider (or one per trust tier; see
5.5). This replaces N `deno run` processes with 1 host + N isolates/threads.

### 5.2 Dispatch / monitor / terminate protocol (stdio NDJSON)

One JSON object per line. Go writes commands to host stdin; the host writes
events and replies to host stdout. Host diagnostics go to stderr. Per-workload
stdout/stderr are **framed**, never raw, so attribution is exact.

Go -> host:

```
{"id":1,"op":"start","runId":"pod-20260925T...","kind":"pod",
 "dir":"/abs/runs/pod-...","entry":"main.ts",
 "permissions":{"read":["/abs/runs/pod-..."],"write":["/abs/runs/pod-..."],
                "net":["example.com"],"env":["KCP_TOKEN"],"run":false},
 "env":{"KCP_TOKEN":"...","KCP_SERVER":"...","KCP_WORKSPACE":"..."},
 "timeoutMs":300000}
{"id":2,"op":"status","runId":"pod-..."}
{"id":3,"op":"stop","runId":"pod-..."}
{"id":4,"op":"ping"}
```

Host -> Go:

```
{"id":1,"ok":true,"runId":"pod-..."}                        start ack
{"event":"stdout","runId":"pod-...","line":"..."}           streamed
{"event":"stderr","runId":"pod-...","line":"..."}           streamed
{"event":"state","runId":"pod-...","state":"succeeded",
 "exitCode":0,"message":""}                                terminal
{"id":2,"ok":true,"state":"running"}                       status reply
{"id":3,"ok":true}                                         stop ack
{"id":4,"ok":true,"workers":3,"deno":"2.9.3"}              ping reply
```

`start` writes `stdout.txt` / `stderr.txt` / `done.json` / `state.json` in the
run dir exactly as `ExecPod` does today, so the provider's file-based
`Observe` path is unchanged if desired; alternatively the host emits a terminal
`state` frame and the client records it in memory. `exitCode` comes from the
shim (5.4), not from a process exit.

Why stdio over HTTP/Unix socket: one pipe pair, no port, no bearer token, no
reconnection logic, and the host lifetime is naturally tied to the provider
(EOF on the pipe is a clean shutdown signal). It matches the existing
`os/exec` pattern. A loopback HTTP or Unix-socket API (like the
`PolicyWorkflowPod` fire endpoint, since retired - see ADR 0002 decision 4 - or
`hono-compute-deno`'s optional `UNIX_SOCKET`) is the upgrade path if the host
must outlive the provider or be shared by several providers. Loopback HTTP is
the easiest to debug with `curl`; it costs a token and a port. Recommend stdio
first.

### 5.3 Permission model

- The **host** runs with the union of what any workload may need
  (`--allow-all --unstable-worker-options` for the pod-and-engine host, or a
  narrower set for a pods-only host).
- Each **worker** gets a permission table translated from the CR
  `DenoPermissions` by a new `denoperm.Options(p) map[string]any` next to the
  existing `denoperm.Args(p) []string`. Mapping: `all` -> `-A` equivalent
  (host-level; a worker cannot exceed the parent, so `all` is the host table),
  `read`/`write`/`net`/`env`/`run`/`ffi`/`sys`/`import`/`hrtime` ->
  `true`/`false`/allowList, `noPrompt` -> irrelevant (no TTY). `read`/`write`
  lists get the absolute run dir prepended.
- Workers can only narrow the host envelope ("can't be extended beyond its
  parent's permissions reach"), which is the intended semantics.
- Deno still enforces permissions per isolate, so a pod cannot read another
  pod's run dir even though both live in one process (verified:
  `NotCapable` on a path outside the allowList).

Gaps to resolve in the spike: `ignoreEnv`, `allowScripts`, `noPrompt`, and
`hrtime` may have no Worker-permission equivalent (`hrtime` does, per the
docs' example; the others are CLI-level). Where there is no equivalent, apply
them at the host process level or drop them with a documented ceiling.

### 5.4 Per-workload shim (env, virtual cwd, logs, exit)

`Deno.cwd()` is process-global (`Deno.chdir` exists and is process-wide,
verified), so per-workload absolute paths and relative-path writes cannot be
achieved with real chdir when workloads run concurrently. The host builds a
per-run wrapper module (Blob URL, as `action_worker.ts` does) whose prelude:

1. Replaces `Deno.env` with the run's `env` map (`Object.defineProperty`, as
   `action_worker.ts` already does), so no `env` permission and no host env
   leakage.
2. Overrides `Deno.cwd()` to return the run dir.
3. Overrides the file ops that take a path (`readTextFile[Sync]`,
   `writeTextFile[Sync]`, `readFile[Sync]`, `writeFile[Sync]`, `open[Sync]`,
   `mkdir[Sync]`, `readDir[Sync]`, `stat[Sync]`, `lstat[Sync]`, `remove[Sync]`,
   `rename[Sync]`, `copyFile[Sync]`, `chmod[Sync]`, `realPath[Sync]`) so a
   relative path resolves against the run dir. Verified feasible for
   `writeTextFile`; the full list is the main spike risk.
4. Replaces `console.log/error/warn/info/debug` with `postMessage` frames so
   logs are attributed and streamed. (Verified: worker `console.log` otherwise
   goes to the shared host stdout.)
5. Replaces `Deno.exit(code)` with a `postMessage({kind:"exit",code})` plus
   `self.close()` so exit codes are reported without depending on worker-exit
   observability. (Verified: worker `Deno.exit` does not kill the host, but it
   is also not directly observable from the parent, so the shim is still
   needed for the code.)
6. `await import(<runDir>/main.ts)`.

Because the wrapper's prelude is inline and the user entry is imported from
disk, the host itself needs no read access to its own directory; the worker's
`read` allowList covers the run dir. This preserves the current
`result.json`-in-the-run-dir contract without changing workload scripts.

### 5.5 Supplying `deno.json` / `deno.lock` / TS per workload

Unchanged from today: `WorkerHost.Start` writes `deno.json`, `deno.lock`,
`main.ts`, `ca.pem` into `runs/<id>/`, and the worker entry is that
`main.ts`. Deno resolves `deno.json`/`deno.lock` from the entry module's
directory, so each workload keeps its own pinned config and lockfile. Set
`DENO_DIR` per run (as `ExecPod.env` does today) so the per-run module cache
and `v8_code_cache` stay isolated; the host process exports the per-run
`DENO_DIR` via the env shim (or, if the shim cannot reach the Deno cache
configuration, the run-scoped cache is a documented gap).

Trust tiers: if untrusted pods and the warm engine share a host, a host-level
compromise or a Worker sandbox escape reaches both. Run two hosts - a
permissive engine host and a scoped pod host - or place the pod host in its own
OS sandbox. This is a small change to the provider (two host clients).

### 5.6 Replacing `execrunner`

- Add `impl/execrunner/host.go` in `kcp-libs`: a `WorkerHost` client (spawn
  once, NDJSON reader/writer, request ids, `Start/Observe/Stop/Probe`).
- Add `impl/execrunner/host_exec.go`: a `Pod`-compatible `runner.PodRunner` that
  writes the run files and sends `start`/`status`/`stop`; `Stop` maps to
  `terminate`. `Probe` can stay a local `exec.Command` in the run dir (it is
  cheap and not a Deno run), or move into the host later.
- Add an engine path: the engine is a long-lived server, so run it as a
  long-lived worker (the host keeps the worker alive; `Observe` maps a worker
  that ended to `Failed`). The engine's `--bind` port is passed through the env
  shim because a worker has no argv; `main.ts api` reads it from env, or the
  host changes the engine invocation to a wrapper that reads env. If changing
  the engine is out of scope, keep the engine as a single `deno run` process
  (already one per PolicyEngine, not per run) and migrate only pods.
- `cmd/deno-kcp-provider/main.go`: reuse `DenoBin`; add `--worker-host` (mode
  `exec` | `worker`), `--worker-host-path`, `--worker-host-args`. `internal/
  runner/pod_exec.go` and `engine_exec.go` stay as the `exec` implementation
  for fallback, exactly as `pod_memory.go`/`engine_memory.go` already provide
  alternate `PodRunner`/`EngineRunner` implementations.
- The `PodRequest` struct gains a permissions object (or a precomputed options
  map) alongside `PermissionArgs`, populated by `provider.podRequest`.

### 5.7 Tie to the cancel ADR

`docs/adrs/0001-cancel-policy-workflow-runs.md` records that the engine has no
cancel route and its `TaskManager` never evicts, so cancel is logical, not
physical. `worker.terminate()` is the physical primitive that ADR lacks.

- For `DenoPod`/`DenoRun`/`DenoJob`, the host gives a genuinely physical stop
  immediately (replacing SIGKILL with isolate termination).
- For engine tasks, terminate only helps if the **engine** runs each
  `RequestTask` workflow in its own worker and keeps the handle. That is a
  change in `../policy-engine` (outside this repo; the ADR says it "lives
  outside `$PWD`. Needs explicit go-ahead"). The host we build here supplies
  the mechanism and the protocol (`stop`); the engine must adopt it to expose
  `POST /request/cancel/:id`. State this limit honestly: the deno-kcp worker
  host alone does not fix engine cancellation.

---

## 6. Maturity, license, cross-platform, risk

Maturity / license:

- `deno_core` 0.412.0, `deno_runtime` 0.267.0, `deno` 2.9.7; all MIT, all from
  `github.com/denoland/deno`, all published 2026-09-16. `deno_core` has ~8.0M
  crate downloads; `deno_runtime` ~627k.
- Web Workers are a stable Deno feature on all platforms. Per-worker
  permissions (`deno.permissions`) are **unstable** and gated by
  `--unstable-worker-options`; pin the Deno version.
- `deno_runtime` explicitly warns its API is "subject to rapid and breaking
  changes" - relevant only to option (A).

Cross-platform:

- Worker threads: Linux, macOS, Windows. `deno compile` cross-compiles to all
  six targets.
- stdio host protocol is portable. A Unix-socket variant is not (Windows named
  pipes); prefer stdio.
- Path shims must handle Windows separators; absolute allowList entries use
  `file:` URLs or OS paths consistently.

Risks:

1. **No per-worker memory cap in the Web Worker API.** A runaway pod can grow
   the shared host's RSS. Mitigations: an aggregate RSS watchdog in the host
   that `terminate()`s the largest worker, a process-wide V8 heap cap, or a
   `node:worker_threads` host (which has `resourceLimits`). Spike needed to
   pick.
2. **Shared process permission envelope.** The host must hold the union of all
   workload permissions; a worker can only narrow. Blast radius of a host-level
   bug is larger than one-per-process today. Mitigate with trust-tiered hosts
   (5.5) and OS sandboxing of the pod host.
3. **Relative-path FS shim is a compatibility surface.** Unshimmed Deno APIs
   resolve against the host cwd, not the run dir. Scoped `read`/`write`
   allowLists make escapes fail closed with `NotCapable`, but the shim list
   must be enumerated and tested.
4. **Unstable worker permissions.** Flag and API can change across minors.
5. **Log attribution** requires the console shim; without it all workers share
   stdout (verified).
6. **Host is a single point of failure.** A host crash kills all live
   workloads. The Go supervisor must respawn it; long-running pods restart per
   `restartPolicy`, the warm engine loses state.
7. **`deno compile` + `--bundle` breaks dynamic workers.** Compile the host
   without `--bundle`.
8. **Engine cancel needs an engine-side change.** See 5.7.
9. **Permission-mapping gaps** (`ignoreEnv`, `allowScripts`, `noPrompt`).
10. **Startup cost and throughput** of a worker vs `deno run` need measurement;
    expectation is lower (no process fork, shared runtime), but unproven.

---

## 7. Verified vs needs a spike

Verified by running on this host (Deno 2.9.3):

- Two CPU-bound workers run concurrently on separate threads (321ms for two
  300ms loops).
- `worker.terminate()` hard-stops a `while(true)` worker; host stays healthy.
- Worker throw fires host `onerror` and prints to stderr.
- Worker `console.log` goes to shared host stdout.
- Worker `Deno.exit(7)` does not kill the host.
- Per-worker `read` allowList allows inside, denies outside with `NotCapable`.
- Overriding `Deno.writeTextFile` in a worker virtualizes a relative write.
- `new Worker("file:///abs/path.ts", ...)` loads from disk at runtime.
- Without `--unstable-worker-options`, `deno.permissions` fails with the exact
  unstable-API message.
- A live worker does not keep the host process alive.

Verified from docs (URL cited inline): deno compile behavior/size/cross-compile,
deno_core/deno_runtime/deno roles and stability, worker permission semantics
and instability, FFI direction.

Needs a spike (not run):

- Full FS/cwd shim covering the file-op list; `Deno.open` handles.
- Memory cap approach (aggregate watchdog vs node:worker_threads
  `resourceLimits`).
- Worker startup latency and steady-state throughput vs `deno run`.
- Per-run `DENO_DIR` isolation from inside a worker.
- Permission-mapping gaps (`ignoreEnv`, `allowScripts`, `hrtime`).
- Engine-in-a-worker with an env-supplied bind port, and whether the engine can
  run each task in a worker for physical cancel.
- A `deno compile`d host (no `--bundle`) loading runtime workers from disk.

---

## 8. Spike plan and effort

Smallest experiment that proves or kills the recommendation (about half a
day):

1. `host.ts` (~120 lines): reads NDJSON from stdin; `start` builds a Blob
   worker from a per-run wrapper with a permissions table, env shim, console
   shim, `Deno.exit` shim, and relative-path write shim, then
   `await import(runDir/main.ts)`; streams stdout/stderr/state frames; `stop`
   calls `terminate()`; `ping` replies.
2. A Go test (~60 lines) that spawns the host once, issues three `start`s
   (one normal, one permission-denied read outside its dir, one `while(true)`),
   asserts terminal states and the denied error, then `stop`s the spinner and
   asserts it terminates and the host still answers `ping`.
3. Measure: host startup time, worker start latency, RSS with 1 vs 16 workers.

Pass = all three workloads are attributed, isolated, individually terminable,
and the host survives. Fail = the FS shim cannot be made safe, or memory grows
unbounded, or worker start latency is worse than `deno run`.

Effort estimate:

- Spike: 0.5-1 day.
- Phase 1 (pod runner on the worker host, flag-gated, `exec` retained):
  3-5 days including tests.
- Phase 2 (engine on the worker host; env-supplied bind; physical cancel
  requires the engine to per-task workers): engine work is in `../policy-engine`,
  a separate repo, estimate 3-7 days plus review and explicit go-ahead per the
  ADR.
- Phase 3 optional: `deno compile` the host for hosts without `deno`:
  0.5-1 day.
