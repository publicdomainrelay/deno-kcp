package provider

import (
	"context"
	"reflect"
	"time"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"

	"github.com/johnandersen777/deno-kcp/api/v1alpha1"
	"github.com/johnandersen777/deno-kcp/internal/denojob"
)

func (p *Provider) reconcileJob(ctx context.Context, ref Ref, job *v1alpha1.DenoJob, runs []v1alpha1.DenoRun) (time.Duration, bool, error) {
	ref.ResourceVersion = job.ResourceVersion
	observed := job.DeepCopy()
	allocated := p.jobAllocated(ref)
	observed.Status.Runs = mergeRunNames(observed.Status.Runs, allocatedRunNames(allocated))
	observedRuns := jobRuns(runs, job.Name)
	if !jobTerminalPhase(observed.Status.Phase) {
		observedRuns = mergeAllocatedActive(observedRuns, allocated, p.opts.Now())
	}
	o := denojob.Observed{Job: *observed, Runs: observedRuns, Now: p.opts.Now()}
	res, err := p.opts.JobDecider.Reconcile(ctx, o)
	if err != nil {
		return 0, false, err
	}
	terminal := jobTerminalPhase(res.Phase)
	if !p.opts.WriteStatus {
		return res.RequeueAfter, terminal, nil
	}
	for _, name := range res.CreateRuns {
		if err := p.opts.Runtime.CreateRun(ctx, ref.LogicalCluster, newRunForJob(job, name)); err != nil {
			return 0, false, err
		}
		p.wake(workRun, Ref{LogicalCluster: ref.LogicalCluster, Namespace: ref.Namespace, Name: name})
	}
	if len(res.CreateRuns) > 0 {
		p.jobAllocate(ref, res.CreateRuns)
	}
	if terminal || res.DeleteJob {
		p.jobForget(ref)
	}
	for _, name := range res.StopRuns {
		if err := p.opts.Runtime.DeleteRun(ctx, Ref{LogicalCluster: ref.LogicalCluster, Namespace: ref.Namespace, Name: name}); err != nil {
			return 0, false, err
		}
	}
	if res.DeleteJob {
		if err := p.opts.Runtime.DeleteJob(ctx, ref); err != nil {
			return 0, false, err
		}
	}
	status := v1alpha1.DenoJobStatus{
		Phase:          res.Phase,
		RunName:        res.RunName,
		Runs:           res.RunNames,
		StartTime:      res.StartTime,
		CompletionTime: res.CompletionTime,
		Active:         res.Active,
		Ready:          res.Ready,
		Succeeded:      res.Succeeded,
		Failed:         res.Failed,
		Retries:        res.Retries,
		ExitCode:       res.ExitCode,
		Outputs:        res.Outputs,
		Conditions:     res.Conditions,
	}
	if !reflect.DeepEqual(status, job.Status) {
		if p.jobWriteAllowed(ref, job, res, terminal) {
			if err := p.opts.Runtime.WriteJobStatus(ctx, ref, status); err != nil {
				return 0, false, err
			}
		} else if res.RequeueAfter <= 0 || res.RequeueAfter > jobStatusCooldown {
			res.RequeueAfter = jobStatusCooldown
		}
	}
	return res.RequeueAfter, terminal, nil
}

// ponytail: created run names live in memory until the next status write, so allocation does not force a write; phase, start and terminal writes stay immediate.
func (p *Provider) jobWriteAllowed(ref Ref, job *v1alpha1.DenoJob, res denojob.Result, terminal bool) bool {
	if terminal || res.Phase != job.Status.Phase ||
		(job.Status.StartTime == nil && res.StartTime != nil) {
		return true
	}
	key := ref.key()
	p.jobWriteMu.Lock()
	defer p.jobWriteMu.Unlock()
	now := p.opts.Now()
	if last, ok := p.jobWriteAt[key]; ok && now.Sub(last) < jobStatusCooldown {
		return false
	}
	p.jobWriteAt[key] = now
	return true
}

func (p *Provider) jobAllocated(ref Ref) []allocatedRun {
	p.jobAllocMu.Lock()
	defer p.jobAllocMu.Unlock()
	return append([]allocatedRun(nil), p.jobAlloc[jobAllocKey(ref)]...)
}

func (p *Provider) jobAllocate(ref Ref, names []string) {
	if len(names) == 0 {
		return
	}
	p.jobAllocMu.Lock()
	defer p.jobAllocMu.Unlock()
	key := jobAllocKey(ref)
	now := p.opts.Now()
	kept := p.jobAlloc[key][:0]
	for _, a := range p.jobAlloc[key] {
		if now.Sub(a.at) < allocatedRunTTL {
			kept = append(kept, a)
		}
	}
	for _, name := range names {
		kept = append(kept, allocatedRun{name: name, at: now})
	}
	p.jobAlloc[key] = kept
}

func allocatedRunNames(allocated []allocatedRun) []string {
	out := make([]string, 0, len(allocated))
	for _, a := range allocated {
		out = append(out, a.name)
	}
	return out
}

func mergeAllocatedActive(observed []denojob.RunObservation, allocated []allocatedRun, now time.Time) []denojob.RunObservation {
	seen := make(map[string]bool, len(observed))
	for i := range observed {
		seen[observed[i].Name] = true
	}
	for _, a := range allocated {
		if seen[a.name] || now.Sub(a.at) >= allocatedRunTTL {
			continue
		}
		seen[a.name] = true
		observed = append(observed, denojob.RunObservation{Name: a.name})
	}
	return observed
}

func (p *Provider) jobForget(ref Ref) {
	p.jobAllocMu.Lock()
	defer p.jobAllocMu.Unlock()
	delete(p.jobAlloc, jobAllocKey(ref))
}

func jobAllocKey(ref Ref) string {
	return ref.key()
}

func mergeRunNames(existing, extra []string) []string {
	seen := make(map[string]bool, len(existing)+len(extra))
	out := make([]string, 0, len(existing)+len(extra))
	for _, group := range [][]string{existing, extra} {
		for _, name := range group {
			if name == "" || seen[name] {
				continue
			}
			seen[name] = true
			out = append(out, name)
		}
	}
	return out
}

func jobRuns(runs []v1alpha1.DenoRun, jobName string) []denojob.RunObservation {
	var out []denojob.RunObservation
	for i := range runs {
		if runs[i].Labels[JobRunLabel] != jobName {
			continue
		}
		out = append(out, denojob.RunObservation{
			Name:     runs[i].Name,
			Phase:    runs[i].Status.Phase,
			ExitCode: runs[i].Status.ExitCode,
			Message:  runs[i].Status.Message,
			Outputs:  runs[i].Status.Outputs,
		})
	}
	return out
}

func newJobForTrigger(tr *v1alpha1.RunTrigger, name string) *v1alpha1.DenoJob {
	spec := v1alpha1.DenoJobSpec{}
	tr.Spec.JobTemplate.DeepCopyInto(&spec)
	return &v1alpha1.DenoJob{
		TypeMeta: metav1.TypeMeta{APIVersion: v1alpha1.GroupVersion.String(), Kind: "DenoJob"},
		ObjectMeta: metav1.ObjectMeta{
			Name:            name,
			Namespace:       tr.Namespace,
			Labels:          map[string]string{"deno.computer/trigger": tr.Name},
			OwnerReferences: []metav1.OwnerReference{ownerRef("RunTrigger", tr.Name, tr.UID)},
		},
		Spec: spec,
	}
}
