package integration

import (
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"sync"
	"testing"
	"time"

	"github.com/johnandersen777/deno-kcp/internal/livegate"
)

// The server under test is built from the openbao checkout the repository pins
// rather than taken from PATH, so the version the certificates are issued by is
// the version in third_party/openbao and not whatever bao an operator installed.
// The build is the expensive part and it is done once per test binary.
var (
	baoBuildOnce sync.Once

	baoBuildPath string

	baoBuildErr error
)

func baoembedBinary(t *testing.T) string {
	t.Helper()
	baoBuildOnce.Do(func() {
		dir, err := os.MkdirTemp("", "baoembed")
		if err != nil {
			baoBuildErr = err
			return
		}
		bin := filepath.Join(dir, "baoembed")
		cmd := exec.Command("go", "build", "-o", bin, "./cmd/baoembed")
		cmd.Dir = filepath.Join(repoRoot(), "internal", "baoembed")
		if out, err := cmd.CombinedOutput(); err != nil {
			baoBuildErr = fmt.Errorf("%v: %s", err, strings.TrimSpace(string(out)))
			return
		}
		baoBuildPath = bin
	})
	if baoBuildErr != nil {
		livegate.Require(t, "the pinned OpenBao server could not be built from third_party/openbao: %v", baoBuildErr)
	}
	return baoBuildPath
}

// baoServer is a running vault: where it answers, how to authenticate, and the
// CA a client needs when it answers over TLS.
type baoServer struct {
	address string

	token string

	caCertPath string
}

func (b baoServer) caCert() []byte {
	if b.caCertPath == "" {
		return nil
	}
	body, err := os.ReadFile(b.caCertPath)
	if err != nil {
		return nil
	}
	return body
}

// startEmbeddedBao runs the pinned OpenBao in development mode and answers the
// address and root token it came up with. Development mode is in-memory storage
// and an unsealed vault, which is what a test needs: the hierarchy under test is
// the namespace and PKI behaviour, not the storage or the seal.
func startEmbeddedBao(t *testing.T) baoServer {
	t.Helper()
	return startBao(t, false)
}

// startEmbeddedBaoTLS is the same server over https, with the CA it generated
// handed back so a client can verify it.
func startEmbeddedBaoTLS(t *testing.T) baoServer {
	t.Helper()
	return startBao(t, true)
}

func startBao(t *testing.T, secure bool) baoServer {
	t.Helper()
	bin := baoembedBinary(t)
	port := freePort(t)
	addr := fmt.Sprintf("127.0.0.1:%d", port)
	token := "root"
	logPath := filepath.Join(t.TempDir(), "bao.log")
	args := []string{"-addr", addr, "-root-token", token}
	if secure {
		args = append(args, "-tls", "-tls-dir", t.TempDir())
	}
	startProcess(t, logPath, bin, args...)
	deadline := time.Now().Add(90 * time.Second)
	for time.Now().Before(deadline) {
		if line := embeddedReadyLine(t, logPath); line != "" {
			var announced baoAnnouncement
			if err := json.Unmarshal([]byte(strings.TrimPrefix(line, "BAOEMBED ")), &announced); err != nil {
				t.Fatalf("the ready line %q is not the JSON this helper reads: %v", line, err)
			}
			return baoServer{address: announced.Address, token: announced.Token, caCertPath: announced.CACert}
		}
		time.Sleep(100 * time.Millisecond)
	}
	t.Fatalf("the embedded OpenBao at %s never reported ready\n%s", addr, tail(logPath, 20))
	return baoServer{}
}

type baoAnnouncement struct {
	Address string `json:"address"`

	Token string `json:"token"`

	CACert string `json:"ca_cert"`
}

func embeddedReadyLine(t *testing.T, logPath string) string {
	t.Helper()
	body, err := os.ReadFile(logPath)
	if err != nil {
		return ""
	}
	for _, line := range strings.Split(string(body), "\n") {
		if strings.HasPrefix(line, "BAOEMBED ") {
			return line
		}
	}
	return ""
}
