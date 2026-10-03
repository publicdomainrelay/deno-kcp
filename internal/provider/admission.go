package provider

import (
	"context"
	"fmt"
	"sort"
	"sync"
	"time"

	"github.com/johnandersen777/deno-kcp/api/v1alpha1"
	"github.com/johnandersen777/deno-kcp/internal/policyworkflowpod"
	"github.com/johnandersen777/deno-kcp/internal/policyworkflowrun"
)

type runAdmission struct {
	gated bool

	allowed bool

	reason string

	message string

	endpoint string

	workflow []byte

	inputs map[string]string

	ttl *int64

	preempt []Ref
}

func (a runAdmission) admission() *policyworkflowrun.Admission {
	if !a.gated {
		return nil
	}
	return &policyworkflowrun.Admission{Allowed: a.allowed, Reason: a.reason, Message: a.message}
}

type admissionLease struct {
	pod string

	admitted time.Time
}

type admissionLeases struct {
	mu sync.Mutex

	m map[Ref]admissionLease
}

func newAdmissionLeases() *admissionLeases {
	return &admissionLeases{m: map[Ref]admissionLease{}}
}

func (l *admissionLeases) forPod(lc, pod string, observed map[string]v1alpha1.PolicyWorkflowPhase, now time.Time) int32 {
	l.mu.Lock()
	defer l.mu.Unlock()
	var n int32
	for ref, lease := range l.m {
		if ref.LogicalCluster != lc || lease.pod != pod {
			continue
		}
		if now.Sub(lease.admitted) > leaseTTL {
			delete(l.m, ref)
			continue
		}
		if phase, ok := observed[ref.Name]; ok && (phase == v1alpha1.PolicyWorkflowRunning || terminalWorkflowPhase(phase)) {
			delete(l.m, ref)
			continue
		}
		n++
	}
	return n
}

func (l *admissionLeases) grant(ref Ref, pod string, now time.Time) {
	l.mu.Lock()
	l.m[ref] = admissionLease{pod: pod, admitted: now}
	l.mu.Unlock()
}

const leaseTTL = 2 * time.Minute

func (p *Provider) admit(ctx context.Context, ref Ref, run *v1alpha1.PolicyWorkflowRun) (runAdmission, error) {
	podName := runPodName(run)
	if podName == "" {
		return runAdmission{}, nil
	}
	pod, err := p.readWorkflowPod(ctx, Ref{LogicalCluster: ref.LogicalCluster, Namespace: ref.Namespace, Name: podName})
	if err != nil {
		return runAdmission{}, err
	}
	runs, err := p.listWorkflowRunsForPod(ctx, ref.LogicalCluster, ref.Namespace, podName)
	if err != nil {
		return runAdmission{}, err
	}
	var pods []v1alpha1.PolicyWorkflowPod
	if pod != nil {
		pods = append(pods, *pod)
	}
	now := p.opts.Now()
	observed := make(map[string]v1alpha1.PolicyWorkflowPhase, len(runs))
	for i := range runs {
		observed[runs[i].Name] = runs[i].Status.Phase
	}
	reserved := p.leases.forPod(ref.LogicalCluster, podName, observed, now)
	out := buildRunAdmissions(ref.LogicalCluster, runs, pods, p.opts.DefaultRunTTLSeconds, map[string]int32{podName: reserved})
	a := out[Ref{LogicalCluster: ref.LogicalCluster, Namespace: ref.Namespace, Name: ref.Name}]
	if a.gated && a.allowed && a.endpoint != "" {
		p.leases.grant(Ref{LogicalCluster: ref.LogicalCluster, Namespace: ref.Namespace, Name: ref.Name}, podName, now)
	}
	return a, nil
}

func buildRunAdmissions(lc string, runs []v1alpha1.PolicyWorkflowRun, pods []v1alpha1.PolicyWorkflowPod, defaultTTL *int64, reserved map[string]int32) map[Ref]runAdmission {
	podByName := make(map[string]*v1alpha1.PolicyWorkflowPod, len(pods))
	for i := range pods {
		podByName[pods[i].Name] = &pods[i]
	}
	byPod := map[string][]int{}
	var order []string
	for i := range runs {
		name := runPodName(&runs[i])
		if name == "" {
			continue
		}
		if _, ok := byPod[name]; !ok {
			order = append(order, name)
		}
		byPod[name] = append(byPod[name], i)
	}
	out := make(map[Ref]runAdmission, len(runs))
	for _, name := range order {
		buildPodAdmissions(lc, runs, byPod[name], podByName[name], defaultTTL, reserved[name], out)
	}
	return out
}

func buildPodAdmissions(lc string, runs []v1alpha1.PolicyWorkflowRun, idxs []int, pod *v1alpha1.PolicyWorkflowPod, defaultTTL *int64, reserved int32, out map[Ref]runAdmission) {
	sort.SliceStable(idxs, func(a, b int) bool {
		ra, rb := runs[idxs[a]], runs[idxs[b]]
		if !ra.CreationTimestamp.Equal(&rb.CreationTimestamp) {
			return ra.CreationTimestamp.Before(&rb.CreationTimestamp)
		}
		return ra.Name < rb.Name
	})

	active := int32(0)
	var pending []int
	for _, i := range idxs {
		switch {
		case terminalWorkflowPhase(runs[i].Status.Phase):
		case runs[i].Status.Phase == v1alpha1.PolicyWorkflowRunning:
			active++
		default:
			pending = append(pending, i)
		}
	}
	active += reserved

	policy := v1alpha1.ConcurrencyForbid
	var maxConcurrent *int32
	if pod != nil {
		if pod.Spec.ConcurrencyPolicy != "" {
			policy = pod.Spec.ConcurrencyPolicy
		}
		maxConcurrent = pod.Spec.MaxConcurrent
	}

	base := runAdmission{ttl: policyworkflowpod.RunTTL(pod, defaultTTL)}
	if pod != nil {
		base.endpoint = pod.Status.Endpoint
		base.workflow = pod.Spec.Workflow.Raw
		base.inputs = pod.Spec.Inputs
	}

	newestPending := -1
	if policy == v1alpha1.ConcurrencyReplace && len(pending) > 0 {
		newestPending = pending[len(pending)-1]
	}

	for pos, i := range pending {
		a := base
		a.gated = true
		switch {
		case pod == nil:
			a.reason = "PolicyWorkflowPodMissing"
			a.message = fmt.Sprintf("the policy workflow pod %q does not exist", runPodName(&runs[i]))
		case pod.Status.Endpoint == "":
			a.reason = "EngineNotReady"
			a.message = "the referenced policy engine has no endpoint yet"
		case policy == v1alpha1.ConcurrencyReplace:
			if i == newestPending {
				a.allowed = true
				for _, j := range idxs {
					if j == i || terminalWorkflowPhase(runs[j].Status.Phase) {
						continue
					}
					a.preempt = append(a.preempt, Ref{LogicalCluster: lc, Namespace: runs[j].Namespace, Name: runs[j].Name})
				}
			} else {
				a.reason = "Superseded"
				a.message = "a newer run supersedes this one under concurrencyPolicy=Replace"
			}
		default:
			a.allowed, a.reason, a.message = policyworkflowpod.QueueDecision(policy, maxConcurrent, active, int32(pos))
		}
		out[Ref{LogicalCluster: lc, Namespace: runs[i].Namespace, Name: runs[i].Name}] = a
	}

	for _, i := range idxs {
		ref := Ref{LogicalCluster: lc, Namespace: runs[i].Namespace, Name: runs[i].Name}
		if _, ok := out[ref]; ok {
			continue
		}
		a := base
		a.gated = false
		out[ref] = a
	}
}

func (p *Provider) wakeQueuedRuns(ctx context.Context, logicalCluster, namespace, podName string) {
	if podName == "" {
		return
	}
	pod, err := p.readWorkflowPod(ctx, Ref{LogicalCluster: logicalCluster, Namespace: namespace, Name: podName})
	if err != nil || pod == nil {
		return
	}
	runs, err := p.listWorkflowRunsForPod(ctx, logicalCluster, namespace, podName)
	if err != nil {
		return
	}
	limit, unlimited := policyworkflowpod.Capacity(pod.Spec.ConcurrencyPolicy, pod.Spec.MaxConcurrent)
	var pending []v1alpha1.PolicyWorkflowRun
	for i := range runs {
		phase := runs[i].Status.Phase
		if phase == v1alpha1.PolicyWorkflowRunning || terminalWorkflowPhase(phase) {
			continue
		}
		pending = append(pending, runs[i])
	}
	sort.SliceStable(pending, func(a, b int) bool {
		if !pending[a].CreationTimestamp.Equal(&pending[b].CreationTimestamp) {
			return pending[a].CreationTimestamp.Before(&pending[b].CreationTimestamp)
		}
		return pending[a].Name < pending[b].Name
	})
	n := len(pending)
	if !unlimited && int(limit) < n {
		n = int(limit)
	}
	for i := 0; i < n; i++ {
		p.wake(workPolicyRun, Ref{LogicalCluster: logicalCluster, Namespace: pending[i].Namespace, Name: pending[i].Name})
	}
	p.wake(workWorkflowPod, Ref{LogicalCluster: logicalCluster, Namespace: namespace, Name: podName})
}

func runPodName(run *v1alpha1.PolicyWorkflowRun) string {
	if run.Spec.PolicyWorkflowPod != "" {
		return run.Spec.PolicyWorkflowPod
	}
	return run.Labels[v1alpha1.PolicyWorkflowPodLabel]
}

func runningRunsFor(runs []v1alpha1.PolicyWorkflowRun, podName string) []string {
	var running []string
	for i := range runs {
		run := runs[i]
		if runPodName(&run) != podName {
			continue
		}
		if run.Status.Phase == v1alpha1.PolicyWorkflowRunning {
			running = append(running, run.Name)
		}
	}
	return running
}
