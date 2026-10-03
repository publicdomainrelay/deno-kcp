package runner

import (
	"context"
	"encoding/json"
	"os"
	"path/filepath"
	"strconv"
	"strings"
	"syscall"
	"testing"
	"time"
)

const fakeDenoPreamble = `#!/bin/sh
if [ -n "$FAKE_DENO_LOG" ]; then { pwd -P; printf '%s\n' "$@"; } > "$FAKE_DENO_LOG"; fi
if [ -n "$FAKE_DENO_ENV_LOG" ]; then env | sort > "$FAKE_DENO_ENV_LOG"; fi
`

const fakeDenoTicker = `( while :; do echo tick >> "$FAKE_DENO_TICK_LOG"; sleep 0.05; done ) &
echo $! > "$FAKE_DENO_CHILD_PID"
wait
`

type fakeDenoLogs struct {
	argv string

	env string

	tick string

	child string
}

func newFakeDenoLogs(t *testing.T) fakeDenoLogs {
	t.Helper()
	root := t.TempDir()
	return fakeDenoLogs{
		argv:  filepath.Join(root, "argv.log"),
		env:   filepath.Join(root, "env.log"),
		tick:  filepath.Join(root, "tick.log"),
		child: filepath.Join(root, "child.pid"),
	}
}

func (l fakeDenoLogs) envVars() []string {
	return []string{
		"FAKE_DENO_LOG=" + l.argv,
		"FAKE_DENO_ENV_LOG=" + l.env,
		"FAKE_DENO_TICK_LOG=" + l.tick,
		"FAKE_DENO_CHILD_PID=" + l.child,
	}
}

func fakeDeno(t *testing.T, body string) string {
	t.Helper()
	path := filepath.Join(t.TempDir(), "deno")
	if err := os.WriteFile(path, []byte(fakeDenoPreamble+body), 0o755); err != nil {
		t.Fatal(err)
	}
	return path
}

func newFakeExecPod(t *testing.T, opts ExecPodOptions, body string) (*ExecPod, fakeDenoLogs) {
	t.Helper()
	logs := newFakeDenoLogs(t)
	opts.DenoBin = fakeDeno(t, body)
	opts.ExtraEnv = append(opts.ExtraEnv, logs.envVars()...)
	if opts.RunsDir == "" {
		opts.RunsDir = t.TempDir()
	}
	p, err := NewExecPod(opts)
	if err != nil {
		t.Fatal(err)
	}
	return p, logs
}

func readArgv(t *testing.T, logs fakeDenoLogs) (string, []string) {
	t.Helper()
	body, err := os.ReadFile(logs.argv)
	if err != nil {
		t.Fatalf("the fake deno did not run: %v", err)
	}
	lines := strings.Split(strings.TrimSuffix(string(body), "\n"), "\n")
	if len(lines) > 1 && lines[len(lines)-1] == "" {
		lines = lines[:len(lines)-1]
	}
	return lines[0], lines[1:]
}

func waitArgv(t *testing.T, logs fakeDenoLogs) (string, []string) {
	t.Helper()
	deadline := time.Now().Add(5 * time.Second)
	for {
		if _, err := os.Stat(logs.argv); err == nil {
			return readArgv(t, logs)
		}
		if time.Now().After(deadline) {
			t.Fatal("the fake deno never ran")
		}
		time.Sleep(5 * time.Millisecond)
	}
}

// ponytail: a key that is not in the file yet is not a failure, it is a key that
// has not been written yet. The fake deno creates the file and then writes it,
// so a reader that arrives in between sees an empty file, and failing on the
// first read makes this the test that fails under load and passes alone.
func fakeEnv(t *testing.T, logs fakeDenoLogs, key string) string {
	t.Helper()
	deadline := time.Now().Add(5 * time.Second)
	for {
		body, err := os.ReadFile(logs.env)
		if err == nil {
			for _, line := range strings.Split(string(body), "\n") {
				if strings.HasPrefix(line, key+"=") {
					return strings.TrimPrefix(line, key+"=")
				}
			}
		}
		if time.Now().After(deadline) {
			t.Fatalf("%s was not set in the deno process env (reading %s: %v)", key, logs.env, err)
		}
		time.Sleep(5 * time.Millisecond)
	}
}

func equalArgs(got, want []string) bool {
	if len(got) != len(want) {
		return false
	}
	for i := range got {
		if got[i] != want[i] {
			return false
		}
	}
	return true
}

func tickCount(t *testing.T, path string) int {
	t.Helper()
	body, err := os.ReadFile(path)
	if err != nil {
		return 0
	}
	return strings.Count(string(body), "tick")
}

func waitForTicks(t *testing.T, path string, want int) {
	t.Helper()
	deadline := time.Now().Add(10 * time.Second)
	for {
		if tickCount(t, path) >= want {
			return
		}
		if time.Now().After(deadline) {
			t.Fatalf("the workload never reached %d ticks", want)
		}
		time.Sleep(5 * time.Millisecond)
	}
}

func killRecordedChild(pidFile string) {
	body, err := os.ReadFile(pidFile)
	if err != nil {
		return
	}
	pid, err := strconv.Atoi(strings.TrimSpace(string(body)))
	if err != nil {
		return
	}
	_ = syscall.Kill(pid, syscall.SIGKILL)
}

func waitExecPod(t *testing.T, p *ExecPod, id string) {
	t.Helper()
	deadline := time.Now().Add(60 * time.Second)
	for {
		st, err := p.Observe(context.Background(), id)
		if err != nil {
			t.Fatal(err)
		}
		if st.State != StateRunning {
			return
		}
		if time.Now().After(deadline) {
			t.Fatalf("exec pod %s did not finish", id)
		}
		time.Sleep(5 * time.Millisecond)
	}
}

func waitExecPodState(t *testing.T, p *ExecPod, id string, want State) PodStatus {
	t.Helper()
	deadline := time.Now().Add(15 * time.Second)
	for {
		st, err := p.Observe(context.Background(), id)
		if err != nil {
			t.Fatal(err)
		}
		if st.State == want {
			return st
		}
		if time.Now().After(deadline) {
			t.Fatalf("pod %s stayed in %s message %q, want %s", id, st.State, st.Message, want)
		}
		time.Sleep(10 * time.Millisecond)
	}
}

func TestNewExecPodDefaultsAndRequiresARunsDir(t *testing.T) {
	if _, err := NewExecPod(ExecPodOptions{}); err == nil {
		t.Fatal("a pod runner without RunsDir should fail to build")
	}
	root := filepath.Join(t.TempDir(), "runs")
	p, err := NewExecPod(ExecPodOptions{RunsDir: root})
	if err != nil {
		t.Fatal(err)
	}
	if p.opts.DenoBin != "deno" {
		t.Fatalf("DenoBin = %q", p.opts.DenoBin)
	}
	if p.opts.ResultFile != "result.json" {
		t.Fatalf("ResultFile = %q", p.opts.ResultFile)
	}
	if p.opts.Timeout != 5*time.Minute {
		t.Fatalf("Timeout = %s", p.opts.Timeout)
	}
	abs, err := filepath.Abs(root)
	if err != nil {
		t.Fatal(err)
	}
	if p.opts.RunsDir != abs {
		t.Fatalf("RunsDir = %q, want %q", p.opts.RunsDir, abs)
	}
}

func TestExecPodStartWritesArtifactsAndEnv(t *testing.T) {
	ca := []byte("-----BEGIN CERTIFICATE-----\nMIIB\n-----END CERTIFICATE-----\n")
	p, logs := newFakeExecPod(t, ExecPodOptions{CAData: ca, Timeout: 10 * time.Second}, "printf '{\"allow\":\"true\",\"n\":3}' > result.json\n")
	script := "console.log(\"pod\");\n"
	perm := "--allow-read=" + p.opts.RunsDir
	id, err := p.Start(context.Background(), PodRequest{
		Script:         script,
		DenoJSON:       `{"tasks":{}}`,
		DenoLock:       `{"version":"5"}`,
		PermissionArgs: []string{perm},
		Env:            map[string]string{"B": "2", "A": "1"},
		Token:          "tok",
		Server:         "https://kcp/clusters/root",
		Workspace:      "root:demo",
	})
	if err != nil {
		t.Fatal(err)
	}
	runDir := filepath.Join(p.opts.RunsDir, id)
	if _, err := os.Stat(runDir); err != nil {
		t.Fatalf("the run dir was not created: %v", err)
	}
	waitExecPod(t, p, id)

	for name, want := range map[string]string{
		"main.ts":   script,
		"deno.json": `{"tasks":{}}`,
		"deno.lock": `{"version":"5"}`,
		"ca.pem":    string(ca),
	} {
		body, err := os.ReadFile(filepath.Join(runDir, name))
		if err != nil || string(body) != want {
			t.Fatalf("%s = %q err = %v, want %q", name, body, err, want)
		}
	}
	for _, name := range []string{"stdout.txt", "stderr.txt", "state.json", "done.json"} {
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
	if _, err := time.Parse(time.RFC3339Nano, state.Started); err != nil {
		t.Fatalf("state.json started = %q: %v", state.Started, err)
	}

	st, err := p.Observe(context.Background(), id)
	if err != nil {
		t.Fatal(err)
	}
	if st.State != StateSucceeded || st.ExitCode != 0 {
		t.Fatalf("status = %+v", st)
	}
	if st.Outputs["allow"] != "true" || st.Outputs["n"] != "3" {
		t.Fatalf("outputs = %v", st.Outputs)
	}

	dir, args := waitArgv(t, logs)
	if dir != runDir {
		t.Fatalf("the deno process ran in %q, want %q", dir, runDir)
	}
	if want := []string{"run", perm, "main.ts"}; !equalArgs(args, want) {
		t.Fatalf("args = %v, want %v", args, want)
	}
	for key, want := range map[string]string{
		"DENO_DIR":      filepath.Join(runDir, ".deno"),
		"DENO_CERT":     filepath.Join(runDir, "ca.pem"),
		"KCP_TOKEN":     "tok",
		"KCP_SERVER":    "https://kcp/clusters/root",
		"KCP_WORKSPACE": "root:demo",
		"A":             "1",
		"B":             "2",
	} {
		if got := fakeEnv(t, logs, key); got != want {
			t.Fatalf("%s = %q, want %q", key, got, want)
		}
	}
}

func TestExecPodKeepsACallerSuppliedDenoDir(t *testing.T) {
	p, logs := newFakeExecPod(t, ExecPodOptions{Timeout: 10 * time.Second}, "exit 0\n")
	p.opts.ExtraEnv = append(p.opts.ExtraEnv, "DENO_DIR=/sdks/deno")
	id, err := p.Start(context.Background(), PodRequest{Script: "console.log(1);\n"})
	if err != nil {
		t.Fatal(err)
	}
	waitExecPod(t, p, id)
	if got := fakeEnv(t, logs, "DENO_DIR"); got != "/sdks/deno" {
		t.Fatalf("DENO_DIR = %q, the runner overwrote a caller supplied module cache", got)
	}
}

func TestExecPodNonZeroExitFails(t *testing.T) {
	p, _ := newFakeExecPod(t, ExecPodOptions{Timeout: 10 * time.Second}, "echo boom >&2\nexit 3\n")
	id, err := p.Start(context.Background(), PodRequest{Script: "throw new Error(\"boom\");\n"})
	if err != nil {
		t.Fatal(err)
	}
	waitExecPod(t, p, id)
	st, err := p.Observe(context.Background(), id)
	if err != nil {
		t.Fatal(err)
	}
	if st.State != StateFailed || st.ExitCode != 3 {
		t.Fatalf("status = %+v, want failed with exit code 3", st)
	}
	if !strings.Contains(st.Message, "exit status 3") {
		t.Fatalf("message = %q", st.Message)
	}
	if st.Outputs != nil {
		t.Fatalf("a failed run should carry no outputs: %v", st.Outputs)
	}
	body, err := os.ReadFile(filepath.Join(p.opts.RunsDir, id, "stderr.txt"))
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(string(body), "boom") {
		t.Fatalf("stderr.txt = %q", body)
	}
}

func TestExecPodStopAfterFinishKeepsSucceeded(t *testing.T) {
	p, _ := newFakeExecPod(t, ExecPodOptions{Timeout: 10 * time.Second}, "printf '{}' > result.json\n")
	id, err := p.Start(context.Background(), PodRequest{Script: "console.log(\"done\");\n"})
	if err != nil {
		t.Fatal(err)
	}
	waitExecPodState(t, p, id, StateSucceeded)
	if err := p.Stop(context.Background(), id); err != nil {
		t.Fatal(err)
	}
	st, err := p.Observe(context.Background(), id)
	if err != nil {
		t.Fatal(err)
	}
	if st.State != StateSucceeded {
		t.Fatalf("a stop after a natural finish flipped the state to %s", st.State)
	}
}

func TestExecPodStopKillsTheProcessGroup(t *testing.T) {
	p, logs := newFakeExecPod(t, ExecPodOptions{Timeout: 30 * time.Second}, fakeDenoTicker)
	id, err := p.Start(context.Background(), PodRequest{Script: "setInterval(() => {}, 1000);\n"})
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() {
		killRecordedChild(logs.child)
		_ = p.Stop(context.Background(), id)
	})
	waitForTicks(t, logs.tick, 3)
	st, err := p.Observe(context.Background(), id)
	if err != nil || st.State != StateRunning {
		t.Fatalf("state = %+v err = %v", st, err)
	}
	if err := p.Stop(context.Background(), id); err != nil {
		t.Fatal(err)
	}
	st = waitExecPodState(t, p, id, StateFailed)
	if st.Message == "" {
		t.Fatalf("a stopped run should carry a message: %+v", st)
	}
	before := tickCount(t, logs.tick)
	time.Sleep(300 * time.Millisecond)
	after := tickCount(t, logs.tick)
	if after != before {
		t.Fatalf("a descendant of the pod kept running after stop: %d ticks became %d", before, after)
	}
}

func TestExecPodTimeoutStopsTheRun(t *testing.T) {
	p, _ := newFakeExecPod(t, ExecPodOptions{Timeout: 300 * time.Millisecond}, "sleep 60\n")
	id, err := p.Start(context.Background(), PodRequest{Script: "await new Promise(() => {});\n"})
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { _ = p.Stop(context.Background(), id) })
	st := waitExecPodState(t, p, id, StateFailed)
	if !strings.Contains(st.Message, "exceeded the runner timeout") {
		t.Fatalf("message = %q, want the runner timeout", st.Message)
	}
	var state runState
	body, err := os.ReadFile(filepath.Join(p.opts.RunsDir, id, "state.json"))
	if err != nil {
		t.Fatal(err)
	}
	if err := json.Unmarshal(body, &state); err != nil {
		t.Fatal(err)
	}
	deadline := time.Now().Add(5 * time.Second)
	for processAlive(state.PID) {
		if time.Now().After(deadline) {
			t.Fatalf("the timed out deno process %d is still alive", state.PID)
		}
		time.Sleep(10 * time.Millisecond)
	}
}

func TestExecPodProbeRunsInTheRunDir(t *testing.T) {
	p, _ := newFakeExecPod(t, ExecPodOptions{Timeout: 30 * time.Second}, "sleep 60\n")
	id, err := p.Start(context.Background(), PodRequest{Script: "console.log(1);\n"})
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { _ = p.Stop(context.Background(), id) })
	ctx := context.Background()
	ok, err := p.Probe(ctx, id, nil, 0)
	if err != nil || !ok {
		t.Fatalf("an empty probe = %v err = %v, want pass", ok, err)
	}
	ok, err = p.Probe(ctx, id, []string{"sh", "-c", "test -f main.ts"}, time.Second)
	if err != nil || !ok {
		t.Fatalf("a probe of the entry module = %v err = %v, want pass", ok, err)
	}
	ok, err = p.Probe(ctx, id, []string{"sh", "-c", "exit 1"}, time.Second)
	if err != nil || ok {
		t.Fatalf("a failing probe = %v err = %v, want a clean false", ok, err)
	}
	ok, err = p.Probe(ctx, id, []string{"sh", "-c", "sleep 5"}, time.Millisecond)
	if err != nil || ok {
		t.Fatalf("a probe past its timeout = %v err = %v, want a clean false", ok, err)
	}
	if _, err := p.Probe(ctx, "pod-missing", []string{"sh", "-c", "exit 0"}, time.Second); err == nil {
		t.Fatal("probing an unknown run should fail")
	}
}

func TestExecPodObserveRecoversAFinishedRunFromDisk(t *testing.T) {
	p, err := NewExecPod(ExecPodOptions{RunsDir: t.TempDir(), Timeout: 10 * time.Second})
	if err != nil {
		t.Fatal(err)
	}
	runDir := filepath.Join(p.opts.RunsDir, "pod-recovered")
	if err := os.MkdirAll(runDir, 0o755); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(filepath.Join(runDir, "done.json"), []byte(`{"exitCode":0}`), 0o644); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(filepath.Join(runDir, "result.json"), []byte(`{"x":"1"}`), 0o644); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(filepath.Join(runDir, "state.json"), []byte(`{"pid":0,"started":"2026-01-01T00:00:00Z"}`), 0o644); err != nil {
		t.Fatal(err)
	}
	st, err := p.Observe(context.Background(), "pod-recovered")
	if err != nil {
		t.Fatal(err)
	}
	if st.State != StateSucceeded || st.Outputs["x"] != "1" {
		t.Fatalf("recovered status = %+v", st)
	}
	if err := p.Stop(context.Background(), "pod-recovered"); err != nil {
		t.Fatalf("stopping a finished recovered run = %v", err)
	}
}

func TestExecPodObserveRecoversSucceededFromAResultFileAlone(t *testing.T) {
	p, err := NewExecPod(ExecPodOptions{RunsDir: t.TempDir(), Timeout: 10 * time.Second})
	if err != nil {
		t.Fatal(err)
	}
	runDir := filepath.Join(p.opts.RunsDir, "pod-stale")
	if err := os.MkdirAll(runDir, 0o755); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(filepath.Join(runDir, "result.json"), []byte(`{"x":"1"}`), 0o644); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(filepath.Join(runDir, "state.json"), []byte(`{"pid":0}`), 0o644); err != nil {
		t.Fatal(err)
	}
	st, err := p.Observe(context.Background(), "pod-stale")
	if err != nil {
		t.Fatal(err)
	}
	if st.State != StateSucceeded || st.Outputs["x"] != "1" {
		t.Fatalf("status = %+v, want the result file to stand in for a missing done marker", st)
	}
}

func TestExecPodObserveFailsClosedWithoutADoneMarker(t *testing.T) {
	p, err := NewExecPod(ExecPodOptions{RunsDir: t.TempDir(), Timeout: 10 * time.Second})
	if err != nil {
		t.Fatal(err)
	}
	runDir := filepath.Join(p.opts.RunsDir, "pod-unfinished")
	if err := os.MkdirAll(runDir, 0o755); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(filepath.Join(runDir, "state.json"), []byte(`{"pid":0}`), 0o644); err != nil {
		t.Fatal(err)
	}
	st, err := p.Observe(context.Background(), "pod-unfinished")
	if err != nil {
		t.Fatal(err)
	}
	if st.State != StateFailed {
		t.Fatalf("status = %+v, want failed when the exit code was never reported", st)
	}
	if _, err := p.Observe(context.Background(), "pod-does-not-exist"); err == nil {
		t.Fatal("observing an unknown pod should fail")
	}
	if err := p.Stop(context.Background(), "pod-does-not-exist"); err != nil {
		t.Fatalf("stopping an unknown pod should be a no-op, got %v", err)
	}
}
