package runner

import (
	"os"
	"path/filepath"
	"testing"
)

func TestReadOutputsParsesResultFile(t *testing.T) {
	dir := t.TempDir()
	body := `{"allow":"true","violations":"[]","n":3}`
	if err := os.WriteFile(filepath.Join(dir, "result.json"), []byte(body), 0o644); err != nil {
		t.Fatal(err)
	}
	e := &ExecPod{opts: ExecPodOptions{ResultFile: "result.json"}}
	out, err := e.readOutputs(&execPodRun{dir: dir})
	if err != nil {
		t.Fatal(err)
	}
	if out["allow"] != "true" || out["violations"] != "[]" {
		t.Fatalf("outputs = %v", out)
	}
	if out["n"] != "3" {
		t.Fatalf("n = %q, want 3", out["n"])
	}
}

func TestReadOutputsMissingFileIsEmpty(t *testing.T) {
	e := &ExecPod{opts: ExecPodOptions{ResultFile: "result.json"}}
	out, err := e.readOutputs(&execPodRun{dir: t.TempDir()})
	if err != nil {
		t.Fatal(err)
	}
	if out != nil {
		t.Fatalf("outputs = %v, want nil", out)
	}
}

func TestReadPodResultFailsClosedWithoutDoneMarker(t *testing.T) {
	e := &ExecPod{opts: ExecPodOptions{ResultFile: "result.json"}}
	st, err := e.readPodResult(&execPodRun{dir: t.TempDir(), exitCode: 0})
	if err != nil {
		t.Fatal(err)
	}
	if st.State != StateFailed {
		t.Fatalf("state = %s, want failed when the exit code was never reported", st.State)
	}
}

func TestReadPodResultReportsSuccessWithDoneMarker(t *testing.T) {
	dir := t.TempDir()
	if err := os.WriteFile(filepath.Join(dir, "done.json"), []byte(`{"exitCode":0}`), 0o644); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(filepath.Join(dir, "result.json"), []byte(`{"allow":"true"}`), 0o644); err != nil {
		t.Fatal(err)
	}
	e := &ExecPod{opts: ExecPodOptions{ResultFile: "result.json"}}
	st, err := e.readPodResult(&execPodRun{dir: dir})
	if err != nil {
		t.Fatal(err)
	}
	if st.State != StateSucceeded || st.Outputs["allow"] != "true" {
		t.Fatalf("state=%s outputs=%v", st.State, st.Outputs)
	}
}

func TestEnvInjectsTokenServerAndWorkspace(t *testing.T) {
	e := &ExecPod{opts: ExecPodOptions{}}
	env := e.env(PodRequest{
		Token:     "tok",
		Server:    "https://kcp/clusters/root:demo",
		Workspace: "root:demo",
		Env:       map[string]string{"B": "2", "A": "1"},
	}, t.TempDir())
	want := map[string]string{
		"KCP_TOKEN":     "tok",
		"KCP_SERVER":    "https://kcp/clusters/root:demo",
		"KCP_WORKSPACE": "root:demo",
		"A":             "1",
		"B":             "2",
	}
	for k := range want {
		if !containsKey(env, k) {
			t.Fatalf("env missing %s: %v", k, env)
		}
	}
	if !hasEnvValue(env, "A", "1") {
		t.Fatalf("A not set: %v", env)
	}
}

func hasEnvValue(env []string, key, value string) bool {
	want := key + "=" + value
	for _, kv := range env {
		if kv == want {
			return true
		}
	}
	return false
}
