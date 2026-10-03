package provider

import (
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestHTTPPolicyClientSubmitAndStatus(t *testing.T) {
	mux := http.NewServeMux()
	mux.HandleFunc("/request/create", func(w http.ResponseWriter, r *http.Request) {
		var body policySubmitRequest
		if err := json.NewDecoder(r.Body).Decode(&body); err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}
		if len(body.Workflow) == 0 {
			http.Error(w, "no workflow", http.StatusBadRequest)
			return
		}
		_, _ = w.Write([]byte(`{"status":"submitted","detail":{"id":"task-7"}}`))
	})
	mux.HandleFunc("/request/status/task-7", func(w http.ResponseWriter, r *http.Request) {
		_, _ = w.Write([]byte(`{"status":"complete","detail":{"exit_status":"success","outputs":{"job":"evaluate"},"cache":{"policy/open/||":{"result.json":{"data":"{\"allow\":true,\"violations\":[]}","encoding":"text"}}}}}`))
	})
	srv := httptest.NewServer(mux)
	defer srv.Close()

	c := NewHTTPPolicyClient()
	id, err := c.Submit(context.Background(), srv.URL, []byte(`{"name":"x","jobs":{}}`), map[string]string{"a": "1"})
	if err != nil {
		t.Fatal(err)
	}
	if id != "task-7" {
		t.Fatalf("id = %q", id)
	}
	task, err := c.Status(context.Background(), srv.URL, id)
	if err != nil {
		t.Fatal(err)
	}
	if task.State != "succeeded" || task.ExitStatus != "success" {
		t.Fatalf("task = %+v", task)
	}
	if task.Outputs["allow"] != "true" || task.Outputs["job"] != "evaluate" {
		t.Fatalf("outputs = %v", task.Outputs)
	}
}

func TestHTTPPolicyClientStatusInProgress(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		_, _ = w.Write([]byte(`{"status":"in_progress","detail":{"id":"task-1"}}`))
	}))
	defer srv.Close()
	task, err := NewHTTPPolicyClient().Status(context.Background(), srv.URL, "task-1")
	if err != nil {
		t.Fatal(err)
	}
	if task.State != "running" {
		t.Fatalf("state = %q, want running", task.State)
	}
}

func TestHTTPPolicyClientSubmitRejectsMissingEndpoint(t *testing.T) {
	if _, err := NewHTTPPolicyClient().Submit(context.Background(), "", []byte(`{}`), nil); err == nil {
		t.Fatal("an empty endpoint must fail")
	}
}
