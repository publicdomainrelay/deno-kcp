package provider

import (
	"context"
	"encoding/json"
	"io"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"

	"github.com/johnandersen777/deno-kcp/api/v1alpha1"
)

type recordedRequest struct {
	Method string

	Path string

	ContentType string

	Body string
}

func newRegistryServer(t *testing.T, respond func(w http.ResponseWriter, r *http.Request, index int)) (*Registry, *[]recordedRequest) {
	t.Helper()
	seen := &[]recordedRequest{}
	index := 0
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		body, _ := io.ReadAll(r.Body)
		*seen = append(*seen, recordedRequest{
			Method:      r.Method,
			Path:        r.URL.Path,
			ContentType: r.Header.Get("Content-Type"),
			Body:        string(body),
		})
		respond(w, r, index)
		index++
	}))
	t.Cleanup(server.Close)
	registry, err := NewRegistry(RegistryOptions{Host: server.URL})
	if err != nil {
		t.Fatal(err)
	}
	return registry, seen
}

func registryWriteJSON(w http.ResponseWriter, status int, body any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(body)
}

func TestRegistryReadsThroughTheClusterPath(t *testing.T) {
	registry, seen := newRegistryServer(t, func(w http.ResponseWriter, _ *http.Request, _ int) {
		registryWriteJSON(w, 200, map[string]any{
			"metadata": map[string]any{"name": "run-1", "namespace": "default"},
			"status":   map[string]any{"runID": "abc"},
		})
	})
	run, err := registry.Read(context.Background(), Ref{LogicalCluster: "root:alice", Namespace: "default", Name: "run-1"})
	if err != nil {
		t.Fatal(err)
	}
	if run.Name != "run-1" || run.Status.RunID != "abc" {
		t.Fatalf("run = %+v", run)
	}
	want := "/clusters/root:alice/apis/deno.computer/v1alpha1/namespaces/default/policyworkflowruns/run-1"
	if (*seen)[0].Method != "GET" || (*seen)[0].Path != want {
		t.Fatalf("request = %s %s, want GET %s", (*seen)[0].Method, (*seen)[0].Path, want)
	}
}

func TestRegistryListsRunsClusterWide(t *testing.T) {
	registry, seen := newRegistryServer(t, func(w http.ResponseWriter, _ *http.Request, _ int) {
		registryWriteJSON(w, 200, map[string]any{"items": []any{
			map[string]any{"metadata": map[string]any{"name": "run-1"}},
			map[string]any{"metadata": map[string]any{"name": "run-2"}},
		}})
	})
	runs, err := registry.ListRuns(context.Background(), "root:alice")
	if err != nil {
		t.Fatal(err)
	}
	if len(runs) != 2 || runs[0].Name != "run-1" {
		t.Fatalf("runs = %+v", runs)
	}
	want := "/clusters/root:alice/apis/deno.computer/v1alpha1/denoruns"
	if (*seen)[0].Method != "GET" || (*seen)[0].Path != want {
		t.Fatalf("request = %s %s, want GET %s", (*seen)[0].Method, (*seen)[0].Path, want)
	}
}

func TestRegistryCreatesRunsInTheirNamespace(t *testing.T) {
	registry, seen := newRegistryServer(t, func(w http.ResponseWriter, _ *http.Request, _ int) {
		registryWriteJSON(w, 201, map[string]any{"metadata": map[string]any{"name": "run-1"}})
	})
	run := &v1alpha1.DenoRun{ObjectMeta: metav1.ObjectMeta{Name: "run-1", Namespace: "default"}}
	if err := registry.CreateRun(context.Background(), "root:alice", run); err != nil {
		t.Fatal(err)
	}
	want := "/clusters/root:alice/apis/deno.computer/v1alpha1/namespaces/default/denoruns"
	if (*seen)[0].Method != "POST" || (*seen)[0].Path != want {
		t.Fatalf("request = %s %s, want POST %s", (*seen)[0].Method, (*seen)[0].Path, want)
	}
	if !strings.Contains((*seen)[0].Body, `"name":"run-1"`) {
		t.Fatalf("body = %s", (*seen)[0].Body)
	}
}

func TestRegistryDeletesWithTheBackgroundPolicyAndToleratesNotFound(t *testing.T) {
	registry, seen := newRegistryServer(t, func(w http.ResponseWriter, _ *http.Request, index int) {
		if index == 0 {
			registryWriteJSON(w, 200, map[string]any{"kind": "Status", "status": "Success"})
			return
		}
		registryWriteJSON(w, 404, map[string]any{"kind": "Status", "reason": "NotFound", "code": 404})
	})
	ref := Ref{LogicalCluster: "root:alice", Namespace: "default", Name: "run-1"}
	if err := registry.DeleteRun(context.Background(), ref); err != nil {
		t.Fatal(err)
	}
	want := "/clusters/root:alice/apis/deno.computer/v1alpha1/namespaces/default/denoruns/run-1"
	if (*seen)[0].Method != "DELETE" || (*seen)[0].Path != want {
		t.Fatalf("request = %s %s, want DELETE %s", (*seen)[0].Method, (*seen)[0].Path, want)
	}
	if !strings.Contains((*seen)[0].Body, `"propagationPolicy":"Background"`) {
		t.Fatalf("body = %s", (*seen)[0].Body)
	}
	if err := registry.DeleteRun(context.Background(), ref); err != nil {
		t.Fatalf("a delete of a missing object is not an error: %v", err)
	}
}

func TestRegistryWritesRunStatusAsAMergePatchWithEveryManagedField(t *testing.T) {
	registry, seen := newRegistryServer(t, func(w http.ResponseWriter, _ *http.Request, _ int) {
		registryWriteJSON(w, 200, map[string]any{})
	})
	ref := Ref{LogicalCluster: "root:alice", Namespace: "default", Name: "run-1", ResourceVersion: "42"}
	st := v1alpha1.DenoRunStatus{Phase: v1alpha1.DenoRunRunning, RunID: "abc"}
	if err := registry.WriteRunStatus(context.Background(), ref, st); err != nil {
		t.Fatal(err)
	}
	request := (*seen)[0]
	want := "/clusters/root:alice/apis/deno.computer/v1alpha1/namespaces/default/denoruns/run-1/status"
	if request.Method != "PATCH" || request.Path != want {
		t.Fatalf("request = %s %s, want PATCH %s", request.Method, request.Path, want)
	}
	if !strings.Contains(request.ContentType, "merge-patch") {
		t.Fatalf("content type = %q", request.ContentType)
	}
	var patch struct {
		Metadata struct {
			ResourceVersion string `json:"resourceVersion"`
		} `json:"metadata"`
		Status map[string]any `json:"status"`
	}
	if err := json.Unmarshal([]byte(request.Body), &patch); err != nil {
		t.Fatal(err)
	}
	if patch.Metadata.ResourceVersion != "42" {
		t.Fatalf("resourceVersion = %q, want the Ref's 42", patch.Metadata.ResourceVersion)
	}
	for _, key := range []string{"phase", "runID", "message", "exitCode", "retries",
		"startTime", "completionTime", "outputs", "conditions"} {
		if _, ok := patch.Status[key]; !ok {
			t.Fatalf("status field %q missing: %v", key, patch.Status)
		}
	}
	if patch.Status["phase"] != "Running" {
		t.Fatalf("phase = %v", patch.Status["phase"])
	}
}

func TestRegistryRemovesARunFinalizerWithATestOp(t *testing.T) {
	registry, seen := newRegistryServer(t, func(w http.ResponseWriter, _ *http.Request, index int) {
		if index == 0 {
			registryWriteJSON(w, 200, map[string]any{
				"metadata": map[string]any{"name": "run-1", "finalizers": []string{v1alpha1.FinalizerDenoRun, "b"}},
			})
			return
		}
		registryWriteJSON(w, 200, map[string]any{})
	})
	ref := Ref{LogicalCluster: "root:alice", Namespace: "default", Name: "run-1"}
	if err := registry.RemoveRunFinalizer(context.Background(), ref); err != nil {
		t.Fatal(err)
	}
	if (*seen)[0].Method != "GET" {
		t.Fatalf("first request = %s, want the read back of the object", (*seen)[0].Method)
	}
	patchRequest := (*seen)[1]
	if patchRequest.Method != "PATCH" || !strings.Contains(patchRequest.ContentType, "json-patch") {
		t.Fatalf("patch request = %s %q", patchRequest.Method, patchRequest.ContentType)
	}
	if !strings.Contains(patchRequest.Body, `"op":"test"`) {
		t.Fatalf("patch = %s", patchRequest.Body)
	}
	if !strings.Contains(patchRequest.Body, `"value":["`+v1alpha1.FinalizerDenoRun+`","b"]`) {
		t.Fatalf("patch does not test the current list: %s", patchRequest.Body)
	}
	if !strings.Contains(patchRequest.Body, `"value":["b"]`) {
		t.Fatalf("patch does not remove exactly the one finalizer: %s", patchRequest.Body)
	}
}

func TestRegistryListsOpenBaosInOneNamespace(t *testing.T) {
	registry, seen := newRegistryServer(t, func(w http.ResponseWriter, _ *http.Request, _ int) {
		registryWriteJSON(w, 200, map[string]any{"items": []any{
			map[string]any{"metadata": map[string]any{"name": "bao-1", "namespace": "ns"}},
		}})
	})
	baos, err := registry.ListOpenBaos(context.Background(), "root:alice", "ns")
	if err != nil {
		t.Fatal(err)
	}
	if len(baos) != 1 || baos[0].Name != "bao-1" {
		t.Fatalf("openbaos = %+v", baos)
	}
	want := "/clusters/root:alice/apis/deno.computer/v1alpha1/namespaces/ns/openbaos"
	if (*seen)[0].Method != "GET" || (*seen)[0].Path != want {
		t.Fatalf("request = %s %s, want GET %s", (*seen)[0].Method, (*seen)[0].Path, want)
	}
}
