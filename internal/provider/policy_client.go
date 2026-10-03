package provider

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"sort"
	"strconv"
	"strings"
	"time"
)

type PolicyTask struct {
	State string

	ExitStatus string

	Outputs map[string]string

	Message string
}

type PolicyClient interface {
	Submit(ctx context.Context, endpoint string, workflow []byte, inputs map[string]string) (string, error)

	Status(ctx context.Context, endpoint, taskID string) (PolicyTask, error)
}

type HTTPPolicyClient struct {
	http *http.Client
}

func NewHTTPPolicyClient() *HTTPPolicyClient {
	return &HTTPPolicyClient{http: &http.Client{Timeout: 30 * time.Second}}
}

type policySubmitRequest struct {
	Workflow json.RawMessage `json:"workflow"`

	Inputs map[string]string `json:"inputs,omitempty"`
}

type policySubmitResponse struct {
	Status string `json:"status"`

	Detail struct {
		ID string `json:"id"`
	} `json:"detail"`
}

type policyStatusResponse struct {
	Status string `json:"status"`

	Detail struct {
		ExitStatus string                          `json:"exit_status"`
		Outputs    map[string]any                  `json:"outputs"`
		Cache      map[string]map[string]cacheFile `json:"cache"`
	} `json:"detail"`
}

type cacheFile struct {
	Data string `json:"data"`

	Encoding string `json:"encoding"`
}

type policyVerdict struct {
	Allow *bool `json:"allow"`

	Violations json.RawMessage `json:"violations"`
}

func (c *HTTPPolicyClient) Submit(ctx context.Context, endpoint string, workflow []byte, inputs map[string]string) (string, error) {
	if endpoint == "" {
		return "", fmt.Errorf("provider: submitting a policy run without an engine endpoint")
	}
	if !json.Valid(workflow) {
		return "", fmt.Errorf("provider: the workflow is not valid JSON")
	}
	body, err := json.Marshal(policySubmitRequest{Workflow: json.RawMessage(workflow), Inputs: inputs})
	if err != nil {
		return "", fmt.Errorf("provider: encoding the policy request: %w", err)
	}
	url := strings.TrimSuffix(endpoint, "/") + "/request/create"
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, url, bytes.NewReader(body))
	if err != nil {
		return "", err
	}
	req.Header.Set("Content-Type", "application/json")
	resp, err := c.http.Do(req)
	if err != nil {
		return "", fmt.Errorf("provider: submitting the policy run: %w", err)
	}
	defer resp.Body.Close()
	raw, _ := io.ReadAll(resp.Body)
	if resp.StatusCode >= 400 {
		return "", fmt.Errorf("provider: the policy engine returned %d: %s", resp.StatusCode, strings.TrimSpace(string(raw)))
	}
	var out policySubmitResponse
	if err := json.Unmarshal(raw, &out); err != nil {
		return "", fmt.Errorf("provider: parsing the policy submit response: %w", err)
	}
	if out.Detail.ID == "" {
		return "", fmt.Errorf("provider: the policy engine returned no task id")
	}
	return out.Detail.ID, nil
}

func (c *HTTPPolicyClient) Status(ctx context.Context, endpoint, taskID string) (PolicyTask, error) {
	url := strings.TrimSuffix(endpoint, "/") + "/request/status/" + taskID
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
	if err != nil {
		return PolicyTask{}, err
	}
	resp, err := c.http.Do(req)
	if err != nil {
		return PolicyTask{State: "running"}, nil
	}
	defer resp.Body.Close()
	raw, _ := io.ReadAll(resp.Body)
	if resp.StatusCode >= 400 {
		return PolicyTask{}, fmt.Errorf("provider: the policy engine returned %d for task %s", resp.StatusCode, taskID)
	}
	var out policyStatusResponse
	if err := json.Unmarshal(raw, &out); err != nil {
		return PolicyTask{State: "running"}, nil
	}
	switch out.Status {
	case "", "submitted", "in_progress":
		return PolicyTask{State: "running"}, nil
	}
	task := PolicyTask{
		ExitStatus: out.Detail.ExitStatus,
		Outputs:    outputsFrom(out),
	}
	if out.Detail.ExitStatus == "success" {
		task.State = "succeeded"
		return task, nil
	}
	task.State = "failed"
	if out.Detail.ExitStatus != "" {
		task.Message = "the workflow exited with status " + out.Detail.ExitStatus
	} else {
		task.Message = "the policy engine did not report a success exit status"
	}
	return task, nil
}

func stringifyValue(v any) string {
	if s, ok := v.(string); ok {
		return s
	}
	encoded, err := json.Marshal(v)
	if err != nil {
		return fmt.Sprint(v)
	}
	return string(encoded)
}

func outputsFrom(ws policyStatusResponse) map[string]string {
	out := map[string]string{}
	for k, v := range ws.Detail.Outputs {
		out[k] = stringifyValue(v)
	}

	keys := make([]string, 0, len(ws.Detail.Cache))
	for key := range ws.Detail.Cache {
		if strings.HasPrefix(key, "policy/") {
			keys = append(keys, key)
		}
	}
	sort.Strings(keys)
	single := len(keys) == 1
	for _, key := range keys {
		file, ok := ws.Detail.Cache[key]["result.json"]
		if !ok {
			continue
		}
		var verdict policyVerdict
		if err := json.Unmarshal([]byte(file.Data), &verdict); err != nil {
			continue
		}
		prefix := ""
		if !single {
			prefix = policyName(key) + "/"
		}
		if verdict.Allow != nil {
			out[prefix+"allow"] = strconv.FormatBool(*verdict.Allow)
		}
		if len(verdict.Violations) > 0 && string(verdict.Violations) != "null" {
			out[prefix+"violations"] = string(verdict.Violations)
		}
	}
	if len(out) == 0 {
		return nil
	}
	return out
}

func policyName(cacheKey string) string {
	parts := strings.Split(cacheKey, "/")
	if len(parts) >= 2 && parts[1] != "" {
		return parts[1]
	}
	return "policy"
}
