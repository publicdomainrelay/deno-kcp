package runner

import (
	"context"
	"fmt"
	"sync"
	"sync/atomic"
	"time"
)

type MemoryEngineOptions struct {
	ExitsAfterPolls int
}

type MemoryEngine struct {
	opts MemoryEngineOptions

	mu   sync.Mutex
	runs map[string]*memoryEngineRun

	seq atomic.Int64
}

type memoryEngineRun struct {
	polls int

	status EngineStatus
}

func NewMemoryEngine(opts MemoryEngineOptions) *MemoryEngine {
	return &MemoryEngine{opts: opts, runs: map[string]*memoryEngineRun{}}
}

func (m *MemoryEngine) Start(_ context.Context, req EngineRequest) (string, error) {
	id := fmt.Sprintf("mengine-%d", m.seq.Add(1))
	m.mu.Lock()
	defer m.mu.Unlock()
	m.runs[id] = &memoryEngineRun{status: EngineStatus{State: StateRunning}}
	return id, nil
}

func (m *MemoryEngine) Observe(_ context.Context, runID string) (EngineStatus, error) {
	m.mu.Lock()
	defer m.mu.Unlock()
	run, ok := m.runs[runID]
	if !ok {
		return EngineStatus{}, fmt.Errorf("runner: unknown engine run %s", runID)
	}
	run.polls++
	if run.status.State == StateRunning && m.opts.ExitsAfterPolls > 0 && run.polls >= m.opts.ExitsAfterPolls {
		run.status = EngineStatus{State: StateFailed, Message: "exited"}
	}
	return run.status, nil
}

func (m *MemoryEngine) Stop(_ context.Context, runID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	if run, ok := m.runs[runID]; ok && run.status.State == StateRunning {
		run.status = EngineStatus{State: StateFailed, Message: "stopped"}
	}
	return nil
}

func (m *MemoryEngine) Probe(_ context.Context, _ string, _ []string, _ time.Duration) (bool, error) {
	return true, nil
}
