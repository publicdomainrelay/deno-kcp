# ADR 0001: Cancel policy workflow runs

Status: deferred
Date: 2026-09-24

## Problem

Policy engine has no cancel route.

Routes: `/health`, `/rate_limit`, `/request/create`, `/request/status/:id`,
`/request/console_output/:id`, `/request/console_output_stream/:id`,
`/webhook/github`.

`TaskManager`: create, get, update. No delete. No cancel.

`executeWorkflowTask`: no AbortSignal. No handle kept.

`cancelled()` in `workflow.ts:670` returns false. Gha expression stub. Not a
control channel.

## Now

Cancel = `spec.cancel: true`, or delete.

KCP side: phase `Cancelled`, stop polling, set `completionTime`, release
finalizer.

Engine side: task runs to completion. Engine slot stays busy. Result dropped.

So cancel is logical, not physical.

## TODO

1. Engine: `POST /request/cancel/:id`. Mark task CANCELLED. Abort in-flight
   workflow: AbortController threaded through `WorkflowExecutor`, step
   subprocesses, workers. Lives outside `$PWD`. Needs explicit go-ahead.
2. Provider: `PolicyClient.Cancel(endpoint, id)`. Call on `OpStopRun`, before
   finalizer release.

## Effects

Cancelled run still executes engine-side. Does not count active. `maxConcurrent`
can admit more KCP runs than the engine runs at once.

Kill warm engine = kill all runs. Not per-run.

## Alternative

One engine process per run. Kill works. Lose warm server. Add per-run startup
cost. Rejected for now.

## Engine task retention

`TaskManager` is a map. Create, get, update. No delete. A submitted task stays
in the warm process forever. Cancel is logical (above), so even a cancelled run
leaves its task behind. KCP-side TTL reaps the `PolicyWorkflowRun`, not the
engine task.

Fix is engine-side: evict terminal tasks by TTL, or cap the map, or add
`DELETE /request/:id`. Lives outside `$PWD`. Needs explicit go-ahead.
