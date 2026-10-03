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

type ExecPodOptions struct {
	DenoBin string

	RunsDir string

	ExtraEnv []string

	Timeout time.Duration

	ResultFile string

	CAData []byte

	// TrustBundle answers the PEM written to ca.pem at each start, when what a
	// workload has to trust is not known until something has run. An OpenBao root
	// CA is generated at first use, so a value fixed at construction would be the
	// empty string for as long as no namespace had asked for a certificate.
	TrustBundle func() []byte
}

type ExecPod struct {
	opts ExecPodOptions

	mu   sync.Mutex
	runs map[string]*execPodRun

	seq atomic.Int64
}

type execPodRun struct {
	req PodRequest

	dir string

	cmd *exec.Cmd

	done chan struct{}

	waitErr error

	pid int

	started time.Time

	stopped bool

	exitCode int32
}

type podDone struct {
	ExitCode int32 `json:"exitCode"`
}

func NewExecPod(opts ExecPodOptions) (*ExecPod, error) {
	if opts.DenoBin == "" {
		opts.DenoBin = "deno"
	}
	if opts.RunsDir == "" {
		return nil, errors.New("runner: RunsDir is required")
	}
	if opts.ResultFile == "" {
		opts.ResultFile = "result.json"
	}
	if opts.Timeout == 0 {
		opts.Timeout = 5 * time.Minute
	}
	var err error
	if opts.RunsDir, err = filepath.Abs(opts.RunsDir); err != nil {
		return nil, fmt.Errorf("runner: resolve RunsDir: %w", err)
	}
	return &ExecPod{opts: opts, runs: map[string]*execPodRun{}}, nil
}

func (e *ExecPod) Start(_ context.Context, req PodRequest) (string, error) {
	id := fmt.Sprintf("pod-%s-%d", time.Now().UTC().Format("20060102T150405"), e.seq.Add(1))
	dir := filepath.Join(e.opts.RunsDir, id)
	if err := os.MkdirAll(dir, 0o755); err != nil {
		return "", fmt.Errorf("runner: create pod dir: %w", err)
	}
	if req.DenoJSON != "" {
		if err := os.WriteFile(filepath.Join(dir, "deno.json"), []byte(req.DenoJSON), 0o644); err != nil {
			return "", fmt.Errorf("runner: write deno.json: %w", err)
		}
	}
	if req.DenoLock != "" {
		if err := os.WriteFile(filepath.Join(dir, "deno.lock"), []byte(req.DenoLock), 0o644); err != nil {
			return "", fmt.Errorf("runner: write deno.lock: %w", err)
		}
	}
	if err := os.WriteFile(filepath.Join(dir, "main.ts"), []byte(req.Script), 0o644); err != nil {
		return "", fmt.Errorf("runner: write main.ts: %w", err)
	}
	if bundle := e.trustBundle(); len(bundle) > 0 {
		if err := os.WriteFile(filepath.Join(dir, "ca.pem"), bundle, 0o644); err != nil {
			return "", fmt.Errorf("runner: write ca.pem: %w", err)
		}
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

	args := append([]string{"run"}, req.PermissionArgs...)
	args = append(args, "main.ts")

	cmd := exec.Command(e.opts.DenoBin, args...)
	cmd.Dir = dir
	cmd.Env = append(os.Environ(), e.env(req, dir)...)
	cmd.Stdout = stdout
	cmd.Stderr = stderr
	cmd.SysProcAttr = &syscall.SysProcAttr{Setpgid: true}
	if err := cmd.Start(); err != nil {
		return "", fmt.Errorf("runner: start deno process: %w", err)
	}

	run := &execPodRun{
		req:     req,
		dir:     dir,
		cmd:     cmd,
		done:    make(chan struct{}),
		pid:     cmd.Process.Pid,
		started: time.Now(),
	}
	go func() {
		run.waitErr = cmd.Wait()
		if cmd.ProcessState != nil {
			run.exitCode = int32(cmd.ProcessState.ExitCode())
		}
		e.writeDone(run)
		close(run.done)
	}()
	e.writeState(run)

	e.mu.Lock()
	e.runs[id] = run
	e.mu.Unlock()
	return id, nil
}

func (e *ExecPod) Observe(_ context.Context, runID string) (PodStatus, error) {
	e.mu.Lock()
	run, ok := e.runs[runID]
	e.mu.Unlock()
	if !ok {
		recovered, err := e.recoverPod(runID)
		if err != nil {
			return PodStatus{}, fmt.Errorf("runner: unknown pod run %s", runID)
		}
		run = recovered
	}
	if !e.podFinished(run) {
		if !run.stopped && time.Since(run.started) > e.opts.Timeout {
			_ = e.Stop(context.Background(), runID)
			return PodStatus{State: StateFailed, Message: "the deno process exceeded the runner timeout"}, nil
		}
		return PodStatus{State: StateRunning}, nil
	}
	if run.stopped {
		return PodStatus{State: StateFailed, Message: "the deno process was stopped"}, nil
	}
	return e.readPodResult(run)
}

func (e *ExecPod) Stop(_ context.Context, runID string) error {
	e.mu.Lock()
	run, ok := e.runs[runID]
	e.mu.Unlock()
	if !ok {
		recovered, err := e.recoverPod(runID)
		if err != nil {
			return nil
		}
		run = recovered
	}
	if e.podFinished(run) {
		return nil
	}
	run.stopped = true
	if run.pid > 0 {
		_ = syscall.Kill(-run.pid, syscall.SIGKILL)
	}
	return nil
}

func (e *ExecPod) Probe(ctx context.Context, runID string, command []string, timeout time.Duration) (bool, error) {
	if len(command) == 0 {
		return true, nil
	}
	dir, err := e.runDir(runID)
	if err != nil {
		return false, err
	}
	if timeout <= 0 {
		timeout = 5 * time.Second
	}
	probeCtx, cancel := context.WithTimeout(ctx, timeout)
	defer cancel()
	cmd := exec.CommandContext(probeCtx, command[0], command[1:]...)
	cmd.Dir = dir
	// ponytail: the probe runs with the workload's environment, not the
	// provider's. A probe that resolves a service name needs the same table the
	// workload got, and inheriting the provider's env leaves it with none, which
	// shows up only as a readiness probe that never passes.
	if run := e.run(runID); run != nil {
		cmd.Env = append(os.Environ(), envPairs(run.req.Env)...)
	}
	if err := cmd.Run(); err != nil {
		return false, nil
	}
	return true, nil
}

func envPairs(env map[string]string) []string {
	out := make([]string, 0, len(env))
	for k, v := range env {
		out = append(out, k+"="+v)
	}
	return out
}

func (e *ExecPod) run(runID string) *execPodRun {
	e.mu.Lock()
	defer e.mu.Unlock()
	return e.runs[runID]
}

func (e *ExecPod) runDir(runID string) (string, error) {
	e.mu.Lock()
	run, ok := e.runs[runID]
	e.mu.Unlock()
	if ok {
		return run.dir, nil
	}
	recovered, err := e.recoverPod(runID)
	if err != nil {
		return "", err
	}
	return recovered.dir, nil
}

func (e *ExecPod) podFinished(run *execPodRun) bool {
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

func (e *ExecPod) recoverPod(runID string) (*execPodRun, error) {
	dir := filepath.Join(e.opts.RunsDir, runID)
	info, err := os.Stat(dir)
	if err != nil || !info.IsDir() {
		return nil, fmt.Errorf("runner: no pod run directory for %s", runID)
	}
	var state runState
	if body, err := os.ReadFile(filepath.Join(dir, "state.json")); err == nil {
		_ = json.Unmarshal(body, &state)
	}
	started := time.Now()
	if state.Started != "" {
		if parsed, err := time.Parse(time.RFC3339Nano, state.Started); err == nil {
			started = parsed
		}
	}
	return &execPodRun{dir: dir, pid: state.PID, started: started}, nil
}

func (e *ExecPod) writeState(run *execPodRun) {
	body, err := json.Marshal(runState{PID: run.pid, Started: run.started.Format(time.RFC3339Nano)})
	if err != nil {
		return
	}
	_ = os.WriteFile(filepath.Join(run.dir, "state.json"), body, 0o644)
}

func (e *ExecPod) writeDone(run *execPodRun) {
	body, err := json.Marshal(podDone{ExitCode: run.exitCode})
	if err != nil {
		return
	}
	_ = os.WriteFile(filepath.Join(run.dir, "done.json"), body, 0o644)
}

func (e *ExecPod) readPodResult(run *execPodRun) (PodStatus, error) {
	exit, err := e.readExitCode(run)
	if err != nil {
		outputs, oerr := e.readOutputs(run)
		if oerr == nil && len(outputs) > 0 {
			return PodStatus{State: StateSucceeded, Outputs: outputs}, nil
		}
		return PodStatus{State: StateFailed, Message: err.Error()}, nil
	}
	st := PodStatus{ExitCode: exit}
	if run.waitErr != nil {
		st.Message = fmt.Sprintf("the deno process failed: %v", run.waitErr)
	}
	if exit == 0 {
		st.State = StateSucceeded
	} else {
		st.State = StateFailed
		if st.Message == "" {
			st.Message = fmt.Sprintf("the deno process exited with code %d", exit)
		}
	}
	outputs, err := e.readOutputs(run)
	if err != nil {
		return PodStatus{State: StateFailed, ExitCode: exit, Message: err.Error()}, nil
	}
	st.Outputs = outputs
	return st, nil
}

func (e *ExecPod) readExitCode(run *execPodRun) (int32, error) {
	body, err := os.ReadFile(filepath.Join(run.dir, "done.json"))
	if err != nil {
		return 0, fmt.Errorf("the deno process did not report an exit code")
	}
	var done podDone
	if err := json.Unmarshal(body, &done); err != nil {
		return 0, fmt.Errorf("parsing the deno process exit code: %w", err)
	}
	return done.ExitCode, nil
}

func (e *ExecPod) readOutputs(run *execPodRun) (map[string]string, error) {
	body, err := os.ReadFile(filepath.Join(run.dir, e.opts.ResultFile))
	if err != nil {
		if errors.Is(err, os.ErrNotExist) {
			return nil, nil
		}
		return nil, fmt.Errorf("reading pod outputs: %w", err)
	}
	var raw map[string]any
	if err := json.Unmarshal(body, &raw); err != nil {
		return nil, fmt.Errorf("parsing pod outputs: %w", err)
	}
	return stringifyOutputs(raw), nil
}

func (e *ExecPod) trustBundle() []byte {
	if e.opts.TrustBundle != nil {
		return e.opts.TrustBundle()
	}
	return e.opts.CAData
}

func (e *ExecPod) env(req PodRequest, dir string) []string {
	env := append([]string{}, e.opts.ExtraEnv...)
	keys := make([]string, 0, len(req.Env))
	for k := range req.Env {
		keys = append(keys, k)
	}
	sort.Strings(keys)
	for _, k := range keys {
		env = append(env, k+"="+req.Env[k])
	}
	if req.Token != "" {
		env = append(env, "KCP_TOKEN="+req.Token)
	}
	if req.Server != "" {
		env = append(env, "KCP_SERVER="+req.Server)
	}
	if req.Workspace != "" {
		env = append(env, "KCP_WORKSPACE="+req.Workspace)
	}
	if !containsKey(env, "DENO_DIR") {
		env = append(env, "DENO_DIR="+filepath.Join(dir, ".deno"))
	}
	if len(e.trustBundle()) > 0 && !containsKey(env, "DENO_CERT") {
		env = append(env, "DENO_CERT="+filepath.Join(dir, "ca.pem"))
	}
	return env
}
