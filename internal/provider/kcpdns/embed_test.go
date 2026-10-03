package kcpdns

import (
	"os"
	"path/filepath"
	"regexp"
	"strings"
	"testing"
)

func TestMaterialiseWritesBothFiles(t *testing.T) {
	dir := t.TempDir()
	shim, probe, err := Materialise(dir)
	if err != nil {
		t.Fatal(err)
	}
	if filepath.Dir(shim) != filepath.Join(dir, DirName) {
		t.Fatalf("shim went to %s, want it under %s", shim, DirName)
	}
	for _, p := range []string{shim, probe} {
		if _, err := os.Stat(p); err != nil {
			t.Fatalf("%s: %v", p, err)
		}
	}
	body, err := os.ReadFile(shim)
	if err != nil {
		t.Fatal(err)
	}
	// The shim is only useful if it patches the entry points Deno actually uses;
	// a shim that patched Deno.resolveDns alone would do nothing, which is the
	// mistake its comment records.
	for _, want := range []string{"globalThis.fetch", "globalThis.WebSocket", "Deno.connect", "Deno.resolveDns"} {
		if !strings.Contains(string(body), want) {
			t.Fatalf("the shim does not patch %s", want)
		}
	}
}

// The probe runs the shim in its own process, under its own permissions. A
// variable the shim reads and the argv does not allow is a probe that fails with
// NotCapable, so the two lists are pinned to each other here rather than
// discovered as a service that never reports ready.
func TestProbeCommandAllowsEveryVariableTheShimReads(t *testing.T) {
	reads := envReads(t, Shim)
	if len(reads) == 0 {
		t.Fatal("the shim reads no environment, so this test would pass without checking anything")
	}
	command := strings.Join(ProbeCommand("/runs/.kcpdns/shim.ts", "/runs/.kcpdns/probe.ts", "pds.default.alice.svc.kcp.local", "/xrpc/_health"), " ")
	for _, name := range reads {
		if !strings.Contains(command, name) {
			t.Fatalf("the shim reads %s and the probe command does not allow it: %s", name, command)
		}
	}
	if !strings.Contains(command, "--allow-net") {
		t.Fatalf("the probe resolves a name to an address and looks one up at the kcp API, so it needs the network: %s", command)
	}
}

func TestProbeCommandAllowsNothingTheShimDoesNotRead(t *testing.T) {
	reads := map[string]bool{}
	for _, name := range envReads(t, Shim) {
		reads[name] = true
	}
	command := strings.Join(ProbeCommand("/s", "/p", "a.b.c.svc.kcp.local", "/"), " ")
	for _, allowed := range probeEnv {
		if !reads[allowed] {
			t.Fatalf("the probe allows %s, which the shim does not read: %s", allowed, command)
		}
	}
}

func envReads(t *testing.T, source string) []string {
	t.Helper()
	seen := map[string]bool{}
	var out []string
	for _, match := range regexp.MustCompile(`Deno\.env\.get\("([A-Z0-9_]+)"\)`).FindAllStringSubmatch(source, -1) {
		if seen[match[1]] {
			continue
		}
		seen[match[1]] = true
		out = append(out, match[1])
	}
	return out
}

func TestProbeCommandCarriesTheShim(t *testing.T) {
	got := ProbeCommand("/runs/.kcpdns/shim.ts", "/runs/.kcpdns/probe.ts", "pds.default.alice.svc.kcp.local", "/xrpc/_health")
	joined := strings.Join(got, " ")
	if !strings.Contains(joined, "--preload /runs/.kcpdns/shim.ts") {
		t.Fatalf("probe command does not preload the shim: %v", got)
	}
	if !strings.Contains(joined, "/xrpc/_health") {
		t.Fatalf("probe command lost the path: %v", got)
	}
}
