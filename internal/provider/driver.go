package provider

import (
	"time"

	"github.com/publicdomainrelay/kcp-libs/common/denocomputer"

	"github.com/johnandersen777/deno-kcp/api/v1alpha1"
)

// workKind and workKey are the dispatch vocabulary. kcp-libs carries the same
// shape as abc/reconcile.Key with abc/reconcile.Handler, and the deciders under
// internal/{denorun,denopod,denojob,policyengine,policyworkflowpod,
// policyworkflowrun,trigger} carry their own Result and Op types where the
// library has reconcile.Result[Status] and reconcile.Operation. Re-expressing
// the seven deciders on that seam is a rewrite of their domains, not a
// substitution like the packages this refactor already swapped, so it is left
// as its own piece of work; nothing else in the provider depends on which
// vocabulary the deciders use.
type workKind string

const (
	workPolicyRun   workKind = "policyworkflowrun"
	workEngine      workKind = "policyengine"
	workWorkflowPod workKind = "policyworkflowpod"
	workTrigger     workKind = "runtrigger"
	workJob         workKind = "denojob"
	workRun         workKind = "denorun"
	workPod         workKind = "denopod"
	workOpenBao     workKind = "openbao"
)

type workKey struct {
	kind workKind
	ref  Ref
}

// ponytail: a run mid-transition is re-checked faster than its own RequeueAfter, because a running process is only visible by asking it: the observation is a sample, not a report. Sweep on the drain harness at 1000 runs and parallelism 20 through ExecPod: 250ms 17.147s, 50ms 7.633s, 25ms 7.115s, 10ms 7.100s with 22 percent more reconciles, so the knee is here. It applies only to a runner that cannot report completion itself; the worker host is woken by its own terminal event, so clamping it there was measured as pure added cost.
const minTransitionPoll = 25 * time.Millisecond

func runTerminalPhase(p v1alpha1.DenoRunPhase) bool {
	return denocomputer.TerminalDenoRun(string(p))
}

func podTerminalPhase(p v1alpha1.DenoPodPhase) bool {
	return denocomputer.TerminalDenoPod(string(p))
}

func jobTerminalPhase(p v1alpha1.DenoJobPhase) bool {
	return denocomputer.TerminalDenoJob(string(p))
}
