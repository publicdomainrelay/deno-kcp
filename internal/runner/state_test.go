package runner

import (
	"math"
	"os"
	"testing"
)

func TestStringifyOutputsEmptyIsNil(t *testing.T) {
	if got := stringifyOutputs(nil); got != nil {
		t.Fatalf("stringifyOutputs(nil) = %v, want nil", got)
	}
	if got := stringifyOutputs(map[string]any{}); got != nil {
		t.Fatalf("stringifyOutputs(empty) = %v, want nil", got)
	}
}

func TestStringifyOutputsKeepsStringsRawAndEncodesTheRest(t *testing.T) {
	got := stringifyOutputs(map[string]any{
		"allow":      "true",
		"text":       `{"raw":true}`,
		"n":          3,
		"f":          1.5,
		"flag":       false,
		"nothing":    nil,
		"violations": []any{},
		"nested":     map[string]any{"b": 2, "a": 1},
	})
	want := map[string]string{
		"allow":      "true",
		"text":       `{"raw":true}`,
		"n":          "3",
		"f":          "1.5",
		"flag":       "false",
		"nothing":    "null",
		"violations": "[]",
		"nested":     `{"a":1,"b":2}`,
	}
	if len(got) != len(want) {
		t.Fatalf("stringifyOutputs kept %d keys, want %d: %v", len(got), len(want), got)
	}
	for k, v := range want {
		if got[k] != v {
			t.Fatalf("%s = %q, want %q", k, got[k], v)
		}
	}
}

func TestStringifyValueFallsBackToSprintWhenMarshalFails(t *testing.T) {
	if got := stringifyValue(math.Inf(1)); got != "+Inf" {
		t.Fatalf("stringifyValue(+Inf) = %q, want the Sprint fallback", got)
	}
}

func TestProcessAliveFailsClosedOnAMissingPID(t *testing.T) {
	if processAlive(0) || processAlive(-1) {
		t.Fatal("a pod or engine recovered from disk without a pid must not read as alive")
	}
	if processAlive(1 << 30) {
		t.Fatal("an unused pid should not read as alive")
	}
	if !processAlive(os.Getpid()) {
		t.Fatal("a live pid should read as alive")
	}
}
