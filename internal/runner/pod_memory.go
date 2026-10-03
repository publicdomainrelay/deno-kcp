package runner

import (
	"context"
	"fmt"
	"sync"
	"sync/atomic"
	"time"
)

type MemoryPodOptions struct {
	Outcome PodStatus

	PollsBeforeDone int

	ProbeResult bool
}

type MemoryPod struct {
	opts MemoryPodOptions

	mu   sync.Mutex
	runs map[string]*memoryPodRun

	seq atomic.Int64
}

type memoryPodRun struct {
	req    PodRequest
	polls  int
	status PodStatus
}

func NewMemoryPod(opts MemoryPodOptions) *MemoryPod {
	if opts.Outcome.State == "" {
		opts.Outcome = PodStatus{State: StateSucceeded}
	}
	if opts.PollsBeforeDone == 0 {
		opts.PollsBeforeDone = 1
	}
	return &MemoryPod{opts: opts, runs: map[string]*memoryPodRun{}}
}

func (m *MemoryPod) Start(_ context.Context, req PodRequest) (string, error) {
	id := fmt.Sprintf("mempod-%d", m.seq.Add(1))
	m.mu.Lock()
	defer m.mu.Unlock()
	m.runs[id] = &memoryPodRun{req: req, status: PodStatus{State: StateRunning}}
	return id, nil
}

func (m *MemoryPod) Observe(_ context.Context, runID string) (PodStatus, error) {
	m.mu.Lock()
	defer m.mu.Unlock()
	run, ok := m.runs[runID]
	if !ok {
		return PodStatus{}, fmt.Errorf("runner: unknown pod run %s", runID)
	}
	run.polls++
	if run.status.State == StateRunning && run.polls >= m.opts.PollsBeforeDone {
		run.status = m.opts.Outcome
	}
	return run.status, nil
}

func (m *MemoryPod) Stop(_ context.Context, runID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	run, ok := m.runs[runID]
	if !ok {
		return nil
	}
	if run.status.State == StateRunning {
		run.status = PodStatus{State: StateFailed, Message: "stopped"}
	}
	return nil
}

func (m *MemoryPod) Probe(_ context.Context, _ string, _ []string, _ time.Duration) (bool, error) {
	return m.opts.ProbeResult, nil
}
