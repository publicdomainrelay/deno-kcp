package runner

import (
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"syscall"
	"time"
)

func stringifyOutputs(in map[string]any) map[string]string {
	if len(in) == 0 {
		return nil
	}
	out := make(map[string]string, len(in))
	for k, v := range in {
		out[k] = stringifyValue(v)
	}
	return out
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

type State string

const (
	StateRunning State = "running"

	StateSucceeded State = "succeeded"

	StateFailed State = "failed"
)

type runState struct {
	PID int `json:"pid"`

	Started string `json:"started"`
}

func writeRunState(dir string, pid int, started time.Time) error {
	body, err := json.Marshal(runState{PID: pid, Started: started.Format(time.RFC3339Nano)})
	if err != nil {
		return err
	}
	return os.WriteFile(dir+"/state.json", body, 0o644)
}

func processAlive(pid int) bool {
	if pid <= 0 {
		return false
	}
	err := syscall.Kill(pid, 0)
	return err == nil || errors.Is(err, syscall.EPERM)
}

func containsKey(env []string, key string) bool {
	prefix := key + "="
	for _, kv := range env {
		if len(kv) >= len(prefix) && kv[:len(prefix)] == prefix {
			return true
		}
	}
	return false
}
