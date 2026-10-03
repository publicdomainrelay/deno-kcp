package runner

import (
	"context"
	"encoding/json"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"time"
)

func newFakeExecEngine(t *testing.T, opts ExecEngineOptions, body string) (*ExecEngine, fakeDenoLogs) {
	t.Helper()
	logs := newFakeDenoLogs(t)
	opts.DenoBin = fakeDeno(t, body)
	opts.ExtraEnv = append(opts.ExtraEnv, logs.envVars()...)
	if opts.ServerDir == "" {
		opts.ServerDir = t.TempDir()
	}
	if opts.RunsDir == "" {
		opts.RunsDir = t.TempDir()
	}
	e, err := NewExecEngine(opts)
	if err != nil {
		t.Fatal(err)
	}
	return e, logs
}

func waitExecEngineState(t *testing.T, e *ExecEngine, id string, want State) EngineStatus {
	t.Helper()
	deadline := time.Now().Add(15 * time.Second)
	for {
		st, err := e.Observe(context.Background(), id)
		if err != nil {
			t.Fatal(err)
		}
		if st.State == want {
			return st
		}
		if time.Now().After(deadline) {
			t.Fatalf("engine %s stayed in %s message %q, want %s", id, st.State, st.Message, want)
		}
		time.Sleep(10 * time.Millisecond)
	}
}

func TestNewExecEngineDefaultsAndRequiresBothDirs(t *testing.T) {
	if _, err := NewExecEngine(ExecEngineOptions{RunsDir: t.TempDir()}); err == nil {
		t.Fatal("an engine runner without ServerDir should fail to build")
	}
	if _, err := NewExecEngine(ExecEngineOptions{ServerDir: t.TempDir()}); err == nil {
		t.Fatal("an engine runner without RunsDir should fail to build")
	}
	root := filepath.Join(t.TempDir(), "runs")
	e, err := NewExecEngine(ExecEngineOptions{ServerDir: t.TempDir(), RunsDir: root})
	if err != nil {
		t.Fatal(err)
	}
	if e.opts.DenoBin != "deno" {
		t.Fatalf("DenoBin = %q", e.opts.DenoBin)
	}
	if e.opts.Timeout != 24*time.Hour {
		t.Fatalf("Timeout = %s", e.opts.Timeout)
	}
	abs, err := filepath.Abs(root)
	if err != nil {
		t.Fatal(err)
	}
	if e.opts.RunsDir != abs {
		t.Fatalf("RunsDir = %q, want %q", e.opts.RunsDir, abs)
	}
}

func TestExecEngineStartBindsTheEngineServer(t *testing.T) {
	serverDir := t.TempDir()
	e, logs := newFakeExecEngine(t, ExecEngineOptions{ServerDir: serverDir, Timeout: time.Hour}, "sleep 60\n")
	id, err := e.Start(context.Background(), EngineRequest{Port: 47821, Env: map[string]string{"A": "1"}})
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { _ = e.Stop(context.Background(), id) })
	runDir := filepath.Join(e.opts.RunsDir, id)
	if _, err := os.Stat(runDir); err != nil {
		t.Fatalf("the engine run dir was not created: %v", err)
	}
	for _, name := range []string{"stdout.txt", "stderr.txt", "state.json"} {
		if _, err := os.Stat(filepath.Join(runDir, name)); err != nil {
			t.Fatalf("missing artifact %s: %v", name, err)
		}
	}
	var state runState
	body, err := os.ReadFile(filepath.Join(runDir, "state.json"))
	if err != nil {
		t.Fatal(err)
	}
	if err := json.Unmarshal(body, &state); err != nil {
		t.Fatal(err)
	}
	if state.PID <= 0 {
		t.Fatalf("state.json pid = %d", state.PID)
	}

	dir, args := waitArgv(t, logs)
	if dir != e.opts.ServerDir {
		t.Fatalf("the engine ran in %q, want the server dir %q", dir, e.opts.ServerDir)
	}
	want := []string{"run", "--allow-all", "--unstable-worker-options", "main.ts", "api", "--bind", "127.0.0.1:47821"}
	if !equalArgs(args, want) {
		t.Fatalf("args = %v, want %v", args, want)
	}
	if got := fakeEnv(t, logs, "DENO_DIR"); got != filepath.Join(runDir, ".deno") {
		t.Fatalf("DENO_DIR = %q", got)
	}
	if got := fakeEnv(t, logs, "A"); got != "1" {
		t.Fatalf("A = %q", got)
	}

	st, err := e.Observe(context.Background(), id)
	if err != nil {
		t.Fatal(err)
	}
	if st.State != StateRunning {
		t.Fatalf("a live engine reported %s", st.State)
	}
	if err := e.Stop(context.Background(), id); err != nil {
		t.Fatal(err)
	}
	if st := waitExecEngineState(t, e, id, StateFailed); st.Message == "" {
		t.Fatalf("a killed engine should carry a message: %+v", st)
	}
}

func TestExecEngineObserveTreatsEveryExitAsFailure(t *testing.T) {
	e, _ := newFakeExecEngine(t, ExecEngineOptions{Timeout: time.Hour}, "exit 1\n")
	id, err := e.Start(context.Background(), EngineRequest{Port: 1})
	if err != nil {
		t.Fatal(err)
	}
	st := waitExecEngineState(t, e, id, StateFailed)
	if !strings.Contains(st.Message, "exit status 1") {
		t.Fatalf("message = %q, want the process error", st.Message)
	}

	clean, _ := newFakeExecEngine(t, ExecEngineOptions{Timeout: time.Hour}, "exit 0\n")
	cleanID, err := clean.Start(context.Background(), EngineRequest{Port: 1})
	if err != nil {
		t.Fatal(err)
	}
	if st := waitExecEngineState(t, clean, cleanID, StateFailed); st.State != StateFailed {
		t.Fatalf("an engine that exited 0 reported %+v, the engine protocol has no success state", st)
	}
}

func TestExecEngineStopKillsTheProcessGroup(t *testing.T) {
	e, logs := newFakeExecEngine(t, ExecEngineOptions{Timeout: time.Hour}, fakeDenoTicker)
	id, err := e.Start(context.Background(), EngineRequest{Port: 1})
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() {
		killRecordedChild(logs.child)
		_ = e.Stop(context.Background(), id)
	})
	waitForTicks(t, logs.tick, 3)
	st, err := e.Observe(context.Background(), id)
	if err != nil || st.State != StateRunning {
		t.Fatalf("state = %+v err = %v", st, err)
	}
	if err := e.Stop(context.Background(), id); err != nil {
		t.Fatal(err)
	}
	waitExecEngineState(t, e, id, StateFailed)
	before := tickCount(t, logs.tick)
	time.Sleep(300 * time.Millisecond)
	after := tickCount(t, logs.tick)
	if after != before {
		t.Fatalf("a descendant of the engine kept running after stop: %d ticks became %d", before, after)
	}
}

func TestExecEngineStopAfterExitIsANoOp(t *testing.T) {
	e, _ := newFakeExecEngine(t, ExecEngineOptions{Timeout: time.Hour}, "exit 1\n")
	id, err := e.Start(context.Background(), EngineRequest{Port: 1})
	if err != nil {
		t.Fatal(err)
	}
	waitExecEngineState(t, e, id, StateFailed)
	if err := e.Stop(context.Background(), id); err != nil {
		t.Fatalf("stopping a finished engine = %v", err)
	}
	if err := e.Stop(context.Background(), "engine-missing"); err != nil {
		t.Fatalf("stopping an unknown engine should be a no-op, got %v", err)
	}
}

func TestExecEngineProbeRunsInTheRunDir(t *testing.T) {
	e, _ := newFakeExecEngine(t, ExecEngineOptions{Timeout: time.Hour}, "sleep 60\n")
	id, err := e.Start(context.Background(), EngineRequest{Port: 1})
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { _ = e.Stop(context.Background(), id) })
	ctx := context.Background()
	if ok, err := e.Probe(ctx, id, nil, 0); err != nil || !ok {
		t.Fatalf("an empty probe = %v err = %v, want pass", ok, err)
	}
	marker := filepath.Join(e.opts.RunsDir, id, "stdout.txt")
	if ok, err := e.Probe(ctx, id, []string{"sh", "-c", "test -f " + marker}, time.Second); err != nil || !ok {
		t.Fatalf("a probe of the run dir = %v err = %v, want pass", ok, err)
	}
	if ok, err := e.Probe(ctx, id, []string{"sh", "-c", "exit 4"}, time.Second); err != nil || ok {
		t.Fatalf("a failing probe = %v err = %v, want a clean false", ok, err)
	}
	if _, err := e.Probe(ctx, "engine-missing", []string{"sh", "-c", "exit 0"}, time.Second); err == nil {
		t.Fatal("probing an unknown engine should fail")
	}
	if _, err := e.Observe(ctx, "engine-missing"); err == nil {
		t.Fatal("observing an unknown engine should fail")
	}
}

func TestExecEngineObserveRecoversFromDisk(t *testing.T) {
	e, err := NewExecEngine(ExecEngineOptions{ServerDir: t.TempDir(), RunsDir: t.TempDir(), Timeout: time.Hour})
	if err != nil {
		t.Fatal(err)
	}
	liveDir := filepath.Join(e.opts.RunsDir, "engine-live")
	if err := os.MkdirAll(liveDir, 0o755); err != nil {
		t.Fatal(err)
	}
	live, err := json.Marshal(runState{PID: os.Getpid()})
	if err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(filepath.Join(liveDir, "state.json"), live, 0o644); err != nil {
		t.Fatal(err)
	}
	st, err := e.Observe(context.Background(), "engine-live")
	if err != nil {
		t.Fatal(err)
	}
	if st.State != StateRunning {
		t.Fatalf("a recovered engine with a live pid reported %s", st.State)
	}

	deadDir := filepath.Join(e.opts.RunsDir, "engine-dead")
	if err := os.MkdirAll(deadDir, 0o755); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(filepath.Join(deadDir, "state.json"), []byte(`{"pid":0}`), 0o644); err != nil {
		t.Fatal(err)
	}
	st, err = e.Observe(context.Background(), "engine-dead")
	if err != nil {
		t.Fatal(err)
	}
	if st.State != StateFailed {
		t.Fatalf("a recovered engine with a dead pid reported %s", st.State)
	}
}
