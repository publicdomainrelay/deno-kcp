package runner

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"sort"
	"sync"
	"sync/atomic"
	"syscall"
	"time"
)

type ExecEngineOptions struct {
	DenoBin string

	ServerDir string

	RunsDir string

	ExtraEnv []string

	// ponytail: not enforced. Observe has no timeout branch, unlike ExecPod.Observe, so a hung engine is not reaped by this runner; the provider's engine liveness probes cover that case instead. Wire it up only if an engine must be killed on a deadline, and note the per-run deadline already exists at the CRD level as spec.activeDeadlineSeconds.
	Timeout time.Duration
}

type ExecEngine struct {
	opts ExecEngineOptions

	mu   sync.Mutex
	runs map[string]*execEngineRun

	seq atomic.Int64
}

type execEngineRun struct {
	dir string

	cmd *exec.Cmd

	done chan struct{}

	waitErr error

	pid int

	started time.Time

	stopped bool
}

func NewExecEngine(opts ExecEngineOptions) (*ExecEngine, error) {
	if opts.DenoBin == "" {
		opts.DenoBin = "deno"
	}
	if opts.ServerDir == "" {
		return nil, errors.New("runner: ServerDir is required")
	}
	if opts.RunsDir == "" {
		return nil, errors.New("runner: RunsDir is required")
	}
	if opts.Timeout == 0 {
		opts.Timeout = 24 * time.Hour
	}
	var err error
	if opts.ServerDir, err = filepath.Abs(opts.ServerDir); err != nil {
		return nil, fmt.Errorf("runner: resolve ServerDir: %w", err)
	}
	if opts.RunsDir, err = filepath.Abs(opts.RunsDir); err != nil {
		return nil, fmt.Errorf("runner: resolve RunsDir: %w", err)
	}
	return &ExecEngine{opts: opts, runs: map[string]*execEngineRun{}}, nil
}

func (e *ExecEngine) Start(_ context.Context, req EngineRequest) (string, error) {
	id := fmt.Sprintf("engine-%s-%d", time.Now().UTC().Format("20060102T150405"), e.seq.Add(1))
	dir := filepath.Join(e.opts.RunsDir, id)
	if err := os.MkdirAll(dir, 0o755); err != nil {
		return "", fmt.Errorf("runner: create engine dir: %w", err)
	}
	stdout, err := os.Create(filepath.Join(dir, "stdout.txt"))
	if err != nil {
		return "", fmt.Errorf("runner: create stdout file: %w", err)
	}
	defer stdout.Close()
	stderr, err := os.Create(filepath.Join(dir, "stderr.txt"))
	if err != nil {
		return "", fmt.Errorf("runner: create stderr file: %w", err)
	}
	defer stderr.Close()

	bind := fmt.Sprintf("127.0.0.1:%d", req.Port)
	args := []string{"run", "--allow-all", "--unstable-worker-options", "main.ts", "api", "--bind", bind}
	cmd := exec.Command(e.opts.DenoBin, args...)
	cmd.Dir = e.opts.ServerDir
	cmd.Env = append(os.Environ(), e.env(req, dir)...)
	cmd.Stdout = stdout
	cmd.Stderr = stderr
	cmd.SysProcAttr = &syscall.SysProcAttr{Setpgid: true}
	if err := cmd.Start(); err != nil {
		return "", fmt.Errorf("runner: start engine: %w", err)
	}

	run := &execEngineRun{
		dir:     dir,
		cmd:     cmd,
		done:    make(chan struct{}),
		pid:     cmd.Process.Pid,
		started: time.Now(),
	}
	go func() {
		run.waitErr = cmd.Wait()
		close(run.done)
	}()
	e.writeState(run)

	e.mu.Lock()
	e.runs[id] = run
	e.mu.Unlock()
	return id, nil
}

func (e *ExecEngine) Observe(_ context.Context, runID string) (EngineStatus, error) {
	e.mu.Lock()
	run, ok := e.runs[runID]
	e.mu.Unlock()
	if !ok {
		recovered, err := e.recoverEngine(runID)
		if err != nil {
			return EngineStatus{}, fmt.Errorf("runner: unknown engine run %s", runID)
		}
		run = recovered
	}
	if e.engineFinished(run) {
		msg := ""
		if run.waitErr != nil {
			msg = run.waitErr.Error()
		}
		return EngineStatus{State: StateFailed, Message: msg}, nil
	}
	return EngineStatus{State: StateRunning}, nil
}

func (e *ExecEngine) Stop(_ context.Context, runID string) error {
	e.mu.Lock()
	run, ok := e.runs[runID]
	e.mu.Unlock()
	if !ok {
		recovered, err := e.recoverEngine(runID)
		if err != nil {
			return nil
		}
		run = recovered
	}
	if e.engineFinished(run) {
		return nil
	}
	run.stopped = true
	if run.pid > 0 {
		_ = syscall.Kill(-run.pid, syscall.SIGKILL)
	}
	return nil
}

func (e *ExecEngine) Probe(ctx context.Context, runID string, command []string, timeout time.Duration) (bool, error) {
	if len(command) == 0 {
		return true, nil
	}
	e.mu.Lock()
	run, ok := e.runs[runID]
	e.mu.Unlock()
	dir := ""
	if ok {
		dir = run.dir
	} else if recovered, err := e.recoverEngine(runID); err == nil {
		dir = recovered.dir
	} else {
		return false, err
	}
	if timeout <= 0 {
		timeout = 5 * time.Second
	}
	probeCtx, cancel := context.WithTimeout(ctx, timeout)
	defer cancel()
	cmd := exec.CommandContext(probeCtx, command[0], command[1:]...)
	cmd.Dir = dir
	if err := cmd.Run(); err != nil {
		return false, nil
	}
	return true, nil
}

func (e *ExecEngine) engineFinished(run *execEngineRun) bool {
	if run.cmd != nil {
		select {
		case <-run.done:
			return true
		default:
			return false
		}
	}
	return !processAlive(run.pid)
}

func (e *ExecEngine) recoverEngine(runID string) (*execEngineRun, error) {
	dir := filepath.Join(e.opts.RunsDir, runID)
	info, err := os.Stat(dir)
	if err != nil || !info.IsDir() {
		return nil, fmt.Errorf("runner: no engine run directory for %s", runID)
	}
	var state runState
	if body, err := os.ReadFile(filepath.Join(dir, "state.json")); err == nil {
		_ = json.Unmarshal(body, &state)
	}
	return &execEngineRun{dir: dir, pid: state.PID}, nil
}

func (e *ExecEngine) writeState(run *execEngineRun) {
	body, err := json.Marshal(runState{PID: run.pid, Started: run.started.Format(time.RFC3339Nano)})
	if err != nil {
		return
	}
	_ = os.WriteFile(filepath.Join(run.dir, "state.json"), body, 0o644)
}

func (e *ExecEngine) env(req EngineRequest, dir string) []string {
	env := append([]string{}, e.opts.ExtraEnv...)
	keys := make([]string, 0, len(req.Env))
	for k := range req.Env {
		keys = append(keys, k)
	}
	sort.Strings(keys)
	for _, k := range keys {
		env = append(env, k+"="+req.Env[k])
	}
	if !containsKey(env, "DENO_DIR") {
		env = append(env, "DENO_DIR="+filepath.Join(dir, ".deno"))
	}
	return env
}
