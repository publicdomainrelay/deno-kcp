package openbao

import (
	"context"
	"crypto/ecdsa"
	"crypto/elliptic"
	"crypto/rand"
	"crypto/x509"
	"crypto/x509/pkix"
	"encoding/json"
	"encoding/pem"
	"errors"
	"io"
	"math/big"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
	"time"
)

type recorded struct {
	method string

	path string

	namespace string

	token string

	body map[string]any
}

func newRecorder(t *testing.T, handler func(w http.ResponseWriter, r *http.Request, rec recorded)) (*Client, *[]recorded) {
	t.Helper()
	var seen []recorded
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		raw, _ := io.ReadAll(r.Body)
		rec := recorded{
			method:    r.Method,
			path:      r.URL.Path,
			namespace: r.Header.Get(namespaceHeader),
			token:     r.Header.Get(tokenHeader),
		}
		if len(raw) > 0 {
			_ = json.Unmarshal(raw, &rec.body)
		}
		seen = append(seen, rec)
		handler(w, r, rec)
	}))
	t.Cleanup(server.Close)
	client, err := New(Options{Address: server.URL, Token: "root-token"})
	if err != nil {
		t.Fatal(err)
	}
	return client, &seen
}

func TestEnsureNamespaceCreatesOnlyWhenAbsent(t *testing.T) {
	exists := false
	client, seen := newRecorder(t, func(w http.ResponseWriter, r *http.Request, _ recorded) {
		switch {
		case r.Method == http.MethodGet && exists:
			_, _ = w.Write([]byte(`{"data":{"path":"alice.default/"}}`))
		case r.Method == http.MethodGet:
			w.WriteHeader(http.StatusNotFound)
			_, _ = w.Write([]byte(`{"errors":["namespace not found"]}`))
		default:
			exists = true
			_, _ = w.Write([]byte(`{"data":{"path":"alice.default/"}}`))
		}
	})

	if err := client.EnsureNamespace(context.Background(), "alice.default"); err != nil {
		t.Fatal(err)
	}
	if err := client.EnsureNamespace(context.Background(), "alice.default"); err != nil {
		t.Fatal(err)
	}

	creates := 0
	for _, rec := range *seen {
		if rec.method == http.MethodPost {
			creates++
			if rec.path != "/v1/sys/namespaces/alice.default" {
				t.Fatalf("created %s, want /v1/sys/namespaces/alice.default", rec.path)
			}
			if rec.token != "root-token" {
				t.Fatalf("the create carried token %q, want the configured one", rec.token)
			}
		}
	}
	if creates != 1 {
		t.Fatalf("posted the namespace %d times, want 1: the second call found it and should not have created it", creates)
	}
}

func TestNamespaceHeaderIsAbsentAtTheRoot(t *testing.T) {
	client, seen := newRecorder(t, func(w http.ResponseWriter, _ *http.Request, _ recorded) {
		_, _ = w.Write([]byte(`{"data":{"certificate":"ROOT"}}`))
	})
	if _, err := client.GenerateRoot(context.Background(), "", "pki", "kcp-mesh-root", "87600h"); err != nil {
		t.Fatal(err)
	}
	if (*seen)[0].namespace != "" {
		t.Fatalf("a root-namespace call carried %s=%q, want no header", namespaceHeader, (*seen)[0].namespace)
	}
}

func TestIssueSendsIPsInTheirOwnField(t *testing.T) {
	client, seen := newRecorder(t, func(w http.ResponseWriter, _ *http.Request, _ recorded) {
		_, _ = w.Write([]byte(`{"data":{"certificate":"LEAF","serial_number":"01"}}`))
	})
	cert, err := client.Issue(context.Background(), "alice.default", "pki", "denopod", CertRequest{
		CommonName: "pds.default.alice.svc.kcp.local",
		AltNames:   []string{"pds.default.alice.svc.kcp.local"},
		IPSANs:     []string{"127.0.0.1", "::1"},
		TTL:        "720h",
	})
	if err != nil {
		t.Fatal(err)
	}
	if cert.Certificate != "LEAF" || cert.Serial != "01" {
		t.Fatalf("issue answered %+v", cert)
	}
	body := (*seen)[0].body
	if body["ip_sans"] != "127.0.0.1,::1" {
		t.Fatalf("ip_sans = %v, want the loopback pair in its own field", body["ip_sans"])
	}
	if strings.Contains(body["alt_names"].(string), "127.0.0.1") {
		t.Fatalf("alt_names = %v carries an address, which OpenBao reads as a DNS name and refuses", body["alt_names"])
	}
}

// A namespace has its own mount table, so a read that asked the root would see
// the root's pki mount, decide the namespace already had one, and leave the
// namespace's own name routing nowhere.
func TestEnsureMountReadsTheNamespacesOwnTable(t *testing.T) {
	client, seen := newRecorder(t, func(w http.ResponseWriter, r *http.Request, rec recorded) {
		if r.Method == http.MethodGet {
			if rec.namespace == "" {
				_, _ = w.Write([]byte(`{"data":{"pki/":{"type":"pki"}}}`))
				return
			}
			_, _ = w.Write([]byte(`{"data":{}}`))
			return
		}
		w.WriteHeader(http.StatusNoContent)
	})
	if err := client.EnsureMount(context.Background(), "alice.default", "pki", "pki"); err != nil {
		t.Fatal(err)
	}
	posted := false
	for _, rec := range *seen {
		if rec.method == http.MethodPost {
			posted = true
			if rec.path != "/v1/sys/mounts/pki" && rec.path != "/v1/sys/mounts/pki/" {
				t.Fatalf("mounted %s", rec.path)
			}
		}
	}
	if !posted {
		t.Fatal("the mount was not created: the root's pki mount was mistaken for the namespace's")
	}
}

func TestEnsureMountRefusesToReplaceAMountOfAnotherType(t *testing.T) {
	client, _ := newRecorder(t, func(w http.ResponseWriter, _ *http.Request, _ recorded) {
		_, _ = w.Write([]byte(`{"data":{"kv/":{"type":"kv"}}}`))
	})
	err := client.EnsureMount(context.Background(), "", "kv", "pki")
	if err == nil {
		t.Fatal("a mount of another type was accepted, so a real mount would have been replaced")
	}
	if !strings.Contains(err.Error(), "will not replace a mount in use") {
		t.Fatalf("error = %q, want it to say why it refused", err)
	}
}

func TestResponseErrorCarriesTheServersReason(t *testing.T) {
	client, _ := newRecorder(t, func(w http.ResponseWriter, _ *http.Request, _ recorded) {
		w.WriteHeader(http.StatusBadRequest)
		_, _ = w.Write([]byte(`{"errors":["subject alternate name 127.0.0.1 not allowed by this role"]}`))
	})
	_, err := client.Issue(context.Background(), "alice.default", "pki", "denopod", CertRequest{CommonName: "x"})
	if err == nil {
		t.Fatal("a 400 was reported as success")
	}
	if !strings.Contains(err.Error(), "not allowed by this role") {
		t.Fatalf("error = %q, want the server's own message rather than the status alone", err)
	}
}

func TestNotFoundIsRecognisable(t *testing.T) {
	client, _ := newRecorder(t, func(w http.ResponseWriter, _ *http.Request, _ recorded) {
		w.WriteHeader(http.StatusNotFound)
		_, _ = w.Write([]byte(`{"errors":[]}`))
	})
	exists, err := client.NamespaceExists(context.Background(), "nope.default")
	if err != nil {
		t.Fatalf("a 404 read as an error: %v", err)
	}
	if exists {
		t.Fatal("a 404 read as an existing namespace")
	}
}

// A listener over TLS is spoken to with the CA the operator names and not with
// the system pool: a vault's certificate is issued by whoever runs the vault, so
// a client that silently fell back to the system roots would trust every public
// CA for it.
func TestATLSServerIsSpokenToOnlyThroughTheSuppliedCA(t *testing.T) {
	server := httptest.NewTLSServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		_, _ = w.Write([]byte(`{"initialized":true,"sealed":false}`))
	}))
	t.Cleanup(server.Close)

	trusted, err := New(Options{Address: server.URL, Token: "t", CACert: pem.EncodeToMemory(&pem.Block{Type: "CERTIFICATE", Bytes: server.Certificate().Raw})})
	if err != nil {
		t.Fatal(err)
	}
	health, err := trusted.Health(context.Background())
	if err != nil {
		t.Fatalf("the supplied CA did not verify the listener: %v", err)
	}
	if !health.Initialized {
		t.Fatalf("health = %+v, want the body the listener answered with", health)
	}

	untrusted, err := New(Options{Address: server.URL, Token: "t"})
	if err != nil {
		t.Fatal(err)
	}
	if _, err := untrusted.Health(context.Background()); err == nil {
		t.Fatal("a TLS listener was spoken to with no CA at all, so the system pool was used")
	}

	wrong, err := New(Options{Address: server.URL, Token: "t", CACert: selfSignedCA(t)})
	if err != nil {
		t.Fatal(err)
	}
	if _, err := wrong.Health(context.Background()); err == nil {
		t.Fatal("a TLS listener was spoken to with a CA that did not sign it")
	}

	if _, err := New(Options{Address: server.URL, Token: "t", CACert: []byte("not a certificate")}); !errors.Is(err, ErrNoCA) {
		t.Fatalf("a CA that holds no certificate was accepted: %v", err)
	}
}

// /cert/ca answers with the certificate and no serial, so a read that trusted a
// serial field would report that a mount which has a CA has none.
func TestCASerialReadsTheSerialOutOfTheCertificate(t *testing.T) {
	caPEM := string(selfSignedCA(t))
	client, _ := newRecorder(t, func(w http.ResponseWriter, _ *http.Request, _ recorded) {
		body, _ := json.Marshal(map[string]any{"data": map[string]any{"certificate": caPEM}})
		_, _ = w.Write(body)
	})
	serial, err := client.CASerial(context.Background(), "alice.default", "pki")
	if err != nil {
		t.Fatal(err)
	}
	if serial == "" {
		t.Fatal("a mount holding a CA reported no serial, so it would be replaced rather than reused")
	}
	if !strings.Contains(serial, ":") {
		t.Fatalf("serial %q is not in the colon-separated form the rest of the API reports", serial)
	}
}

// selfSignedCA is a CA that signed nothing the tests speak to.
func selfSignedCA(t *testing.T) []byte {
	t.Helper()
	key, err := ecdsa.GenerateKey(elliptic.P256(), rand.Reader)
	if err != nil {
		t.Fatal(err)
	}
	tmpl := &x509.Certificate{
		SerialNumber:          big.NewInt(0x4f2a1b),
		Subject:               pkix.Name{CommonName: "test-ca"},
		NotBefore:             time.Now().Add(-time.Hour),
		NotAfter:              time.Now().Add(time.Hour),
		KeyUsage:              x509.KeyUsageCertSign,
		BasicConstraintsValid: true,
		IsCA:                  true,
	}
	der, err := x509.CreateCertificate(rand.Reader, tmpl, tmpl, &key.PublicKey, key)
	if err != nil {
		t.Fatal(err)
	}
	return pem.EncodeToMemory(&pem.Block{Type: "CERTIFICATE", Bytes: der})
}
