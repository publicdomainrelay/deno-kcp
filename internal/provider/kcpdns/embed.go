// Package kcpdns ships the preload shim that gives a workload cluster-local
// names, and the probe that uses it.
//
// The two files are embedded rather than referenced, so a compiled provider
// carries them and materialises them next to its runs on first use. That is the
// same shape the worker host used for host.ts while it existed.
package kcpdns

import (
	_ "embed"
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

//go:embed shim.ts
var Shim string

//go:embed probe.ts
var Probe string

// DirName is where Materialise puts them, relative to the runs directory. The
// leading dot keeps them out of the way of a run's own files.
const DirName = ".kcpdns"

// Materialise writes the shim and probe into <runsDir>/.kcpdns and returns their
// paths. Called once at startup; writing them again on a later start is
// harmless and is how an upgraded provider replaces them.
func Materialise(runsDir string) (shimPath, probePath string, err error) {
	dir := filepath.Join(runsDir, DirName)
	if err := os.MkdirAll(dir, 0o755); err != nil {
		return "", "", fmt.Errorf("kcpdns: create %s: %w", dir, err)
	}
	shimPath = filepath.Join(dir, "shim.ts")
	probePath = filepath.Join(dir, "probe.ts")
	if err := os.WriteFile(shimPath, []byte(Shim), 0o644); err != nil {
		return "", "", fmt.Errorf("kcpdns: write shim: %w", err)
	}
	if err := os.WriteFile(probePath, []byte(Probe), 0o644); err != nil {
		return "", "", fmt.Errorf("kcpdns: write probe: %w", err)
	}
	return shimPath, probePath, nil
}

// probeEnv is every variable the shim reads. The probe is its own process with
// its own permissions, so a variable the shim reads and this list omits is a
// probe that dies with NotCapable -- which an operator sees as a service that
// never becomes ready, and not as a missing flag.
// TestProbeCommandAllowsEveryVariableTheShimReads holds the two together.
var probeEnv = []string{"KCP_SERVICE_DOMAIN", "KCP_DNS_TABLE", "KCP_TOKENS", "KCP_SERVER"}

// ProbeCommand is the argv an exec readiness probe runs to check one name. The
// pod's run directory is the working directory for a probe, but these are
// absolute so the command works from anywhere.
//
// The permissions are the lease the shim needs and no more: the variables above,
// and the network, because a name in the table resolves to the address a peer
// advertised and a name that misses is looked up at the kcp API -- neither set
// is known in advance, so the network grant cannot name them.
//
// ponytail: without these the shim throws on its first Deno.env.get and every
// kcpdns probe fails, which is how the market demo's services came up serving
// traffic and never reported Ready.
func ProbeCommand(shimPath, probePath, fqdn, path string) []string {
	return []string{
		"deno", "run",
		"--allow-env=" + strings.Join(probeEnv, ","),
		"--allow-net",
		"--preload", shimPath,
		probePath, fqdn, path,
	}
}
