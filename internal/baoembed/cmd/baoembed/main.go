// Command baoembed runs the OpenBao server the tests talk to, built from the
// openbao checkout pinned in third_party/openbao.
//
// It is a separate module rather than a package of deno-kcp because it imports
// github.com/openbao/openbao/v2/internal/command: Go allows that import only from
// a package whose own path sits under github.com/openbao/openbao/v2/, and the only
// way to get such a path without editing the submodule is to declare one. The
// module path below is that declaration, and the replace directives in go.mod are
// the ones openbao's own go.mod carries, rewritten to reach into the checkout --
// a replace in a dependency is ignored, so they have to be repeated here.
//
// The point of running the pinned build rather than whatever bao is on PATH is
// that the tests and the provider then agree on one version, and the certificate
// and namespace behaviour the provider depends on is the behaviour under test.
// The point of printing the ready line is that a caller gets the address, the
// root token and, in TLS mode, the CA certificate from the process it started
// instead of scraping a log.
package main

import (
	"crypto/tls"
	"crypto/x509"
	"encoding/json"
	"flag"
	"fmt"
	"net/http"
	"os"
	"path/filepath"
	"time"

	"github.com/openbao/openbao/v2/internal/command"
)

const readyPrefix = "BAOEMBED "

// devTLS names the files openbao's development TLS mode writes into its
// certificate directory. The CA is what a client needs to verify the listener.
const (
	devTLSCAFile = "vault-ca.pem"
)

type ready struct {
	Address string `json:"address"`

	Token string `json:"token"`

	CACert string `json:"ca_cert,omitempty"`
}

func main() {
	addr := flag.String("addr", envOr("BAOEMBED_ADDR", "127.0.0.1:8200"),
		"address the development server listens on")
	rootToken := flag.String("root-token", envOr("BAOEMBED_ROOT_TOKEN", "root"),
		"root token the development server is created with")
	tlsMode := flag.Bool("tls", envOr("BAOEMBED_TLS", "") == "1",
		"serve https with a generated CA, and report the CA's path in the ready line")
	certDir := flag.String("tls-dir", envOr("BAOEMBED_TLS_DIR", ""),
		"directory the generated TLS files are written into; empty means a fresh temporary one")
	flag.Parse()

	if err := os.Setenv("BAO_DEV_ROOT_TOKEN_ID", *rootToken); err != nil {
		fmt.Fprintf(os.Stderr, "baoembed: setting the root token: %v\n", err)
		os.Exit(1)
	}

	scheme := "http"
	caCertPath := ""
	tlsDir := *certDir
	if *tlsMode {
		scheme = "https"
		if tlsDir == "" {
			dir, err := os.MkdirTemp("", "baoembed-tls")
			if err != nil {
				fmt.Fprintf(os.Stderr, "baoembed: making a certificate directory: %v\n", err)
				os.Exit(1)
			}
			tlsDir = dir
		}
		// openbao refuses a certificate directory that is not there, and it does
		// not create one.
		if err := os.MkdirAll(tlsDir, 0o700); err != nil {
			fmt.Fprintf(os.Stderr, "baoembed: making the certificate directory %s: %v\n", tlsDir, err)
			os.Exit(1)
		}
		caCertPath = filepath.Join(tlsDir, devTLSCAFile)
	}

	url := scheme + "://" + *addr
	go func() {
		// ponytail: a fixed poll rather than an address the server reports, because
		// dev mode is told where to listen and a listener that is up is not yet a
		// vault that answers; readiness is the health endpoint, not the socket. In
		// TLS mode the poll trusts the CA the server generated, which is the same
		// certificate the caller is handed.
		deadline := time.Now().Add(90 * time.Second)
		client := &http.Client{Timeout: time.Second}
		if *tlsMode {
			// The server writes the certificate directory as it starts, so the CA
			// is waited for rather than read once: an empty pool makes every poll
			// fail verification, which is indistinguishable from a server that
			// never came up.
			waitForCA(caCertPath, 30*time.Second)
			client.Transport = &http.Transport{TLSClientConfig: &tls.Config{RootCAs: caPool(caCertPath), MinVersion: tls.VersionTLS12}}
		}
		for time.Now().Before(deadline) {
			resp, err := client.Get(url + "/v1/sys/health")
			if err == nil {
				resp.Body.Close()
				body, err := json.Marshal(ready{Address: url, Token: *rootToken, CACert: caCertPath})
				if err != nil {
					fmt.Fprintf(os.Stderr, "baoembed: encoding the ready line: %v\n", err)
					return
				}
				fmt.Printf("%s%s\n", readyPrefix, body)
				os.Stdout.Sync()
				return
			}
			time.Sleep(50 * time.Millisecond)
		}
		fmt.Fprintf(os.Stderr, "baoembed: %s did not answer /v1/sys/health within 90s\n", url)
	}()

	args := []string{
		"server",
		"-dev",
		"-dev-root-token-id=" + *rootToken,
		"-dev-listen-address=" + *addr,
		"-log-level=error",
	}
	if *tlsMode {
		args = append(args, "-dev-tls", "-dev-tls-cert-dir="+tlsDir)
	}
	os.Exit(command.Run(args))
}

func waitForCA(path string, wait time.Duration) {
	deadline := time.Now().Add(wait)
	for time.Now().Before(deadline) {
		if info, err := os.Stat(path); err == nil && info.Size() > 0 {
			return
		}
		time.Sleep(20 * time.Millisecond)
	}
}

// caPool reads the CA the caller will be handed.
func caPool(path string) *x509.CertPool {
	pool := x509.NewCertPool()
	if body, err := os.ReadFile(path); err == nil {
		pool.AppendCertsFromPEM(body)
	}
	return pool
}

func envOr(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}
