package integration

import (
	"context"
	"crypto/x509"
	"encoding/pem"
	"net"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"github.com/johnandersen777/deno-kcp/api/v1alpha1"
	"github.com/johnandersen777/deno-kcp/internal/openbao"
)

const openBaoName = "openbao"

const openBaoTLSProbe = "openbao-tls-probe"

// The whole point of the mapping: a Kubernetes namespace is served by an OpenBao
// namespace of its own, that namespace's intermediate is signed by the root the
// OpenBao root namespace holds, and a workload in the Kubernetes namespace is
// issued a certificate by that intermediate which a peer holding only the root
// can verify.
func TestOpenBaoAuthorityIssuesTheCertificateADenoPodServesWith(t *testing.T) {
	requireLive(t)
	vault := startEmbeddedBao(t)
	c := startCluster(t, withOpenBao(vault))
	assertAuthorityIssuesADenoPodItsCertificate(t, c, vault)
}

// The same path over https, which is how a vault that is not on loopback is
// reached: the provider is handed the CA the listener's certificate chains to,
// and without it the client would fall back to the system roots and refuse a
// vault nobody publicly signed for.
func TestOpenBaoOverTLSIssuesTheCertificateADenoPodServesWith(t *testing.T) {
	requireLive(t)
	vault := startEmbeddedBaoTLS(t)
	if vault.caCertPath == "" {
		t.Fatal("the TLS vault reported no CA certificate, so the provider has nothing to verify it with")
	}
	c := startCluster(t, withOpenBao(vault))
	assertAuthorityIssuesADenoPodItsCertificate(t, c, vault)
}

func assertAuthorityIssuesADenoPodItsCertificate(t *testing.T, c *liveCluster, vault baoServer) {
	t.Helper()
	addr, token := vault.address, vault.token
	c.apply("openbao.yaml")
	c.expect("the OpenBao object Ready with an intermediate", 120*time.Second, func() bool {
		obj := c.openBao(openBaoName)
		return obj != nil && obj.Status.Ready && obj.Status.Serial != "" && obj.Status.Chain != ""
	})
	obj := c.openBao(openBaoName)
	if obj.Status.Namespace != "runtime.default" {
		t.Fatalf("the object reports namespace %q, want the one it declares", obj.Status.Namespace)
	}
	t.Logf("openbao.yaml: namespace=%s serial=%s chain=%d bytes",
		obj.Status.Namespace, obj.Status.Serial, len(obj.Status.Chain))

	root := readRootCA(t, vault)
	intermediate := verifyChain(t, obj.Status.Chain, root)

	// The root lives in the OpenBao root namespace and nowhere else, and the
	// namespace's authority is a different certificate that chains to it.
	server, err := openbao.New(openbao.Options{Address: addr, Token: token, CACert: vault.caCert()})
	if err != nil {
		t.Fatal(err)
	}
	exists, err := server.NamespaceExists(context.Background(), "runtime.default")
	if err != nil {
		t.Fatal(err)
	}
	if !exists {
		t.Fatalf("the OpenBao namespace %q the object reports does not exist", obj.Status.Namespace)
	}
	if intermediate.Subject.CommonName != "runtime.default.intermediate" {
		t.Fatalf("the intermediate's subject = %q, want the namespace's own", intermediate.Subject.CommonName)
	}

	c.apply("openbao-tls-pod.yaml")
	pod := awaitPodOutput(t, c, openBaoTLSProbe, "certificate")

	leaf := parseCert(t, pod.Status.Outputs["certificate"])
	// The peer holds the root and is handed the rest of the chain with the leaf,
	// which is why the namespace's intermediate is an intermediate here and not a
	// root: a bundle carrying every namespace's authority is not the design.
	if _, err := leaf.Verify(x509.VerifyOptions{
		Roots:         poolOf(t, root),
		Intermediates: intermediatePool(t, obj.Status.Chain),
		KeyUsages:     []x509.ExtKeyUsage{x509.ExtKeyUsageServerAuth},
	}); err != nil {
		t.Fatalf("the certificate the pod was issued does not chain to the root CA in the root namespace: %v", err)
	}
	if !strings.Contains(pod.Status.Outputs["certificate"], strings.TrimSpace(lastCert(obj.Status.Chain))) {
		t.Fatal("the certificate the pod serves does not carry the namespace's intermediate, so a peer holding only the root cannot verify it")
	}
	want := "openbao-tls-probe.default.runtime.svc.kcp.local"
	if pod.Status.Outputs["serviceName"] != want {
		t.Fatalf("the pod reports service name %q, want %q", pod.Status.Outputs["serviceName"], want)
	}
	if len(leaf.DNSNames) != 1 || leaf.DNSNames[0] != want {
		t.Fatalf("the certificate names %v, want just %q", leaf.DNSNames, want)
	}
	if !containsIP(leaf.IPAddresses, "127.0.0.1") || !containsIP(leaf.IPAddresses, "::1") {
		t.Fatalf("the certificate carries %v, want loopback: a probe reaches the workload there", leaf.IPAddresses)
	}
	if pod.Status.Outputs["hasKey"] != "true" {
		t.Fatal("the pod was issued a certificate without a key")
	}
	// The intermediate the leaf was issued by is the namespace's, not the root:
	// that is the difference between a per-namespace authority and a flat one.
	if leaf.Issuer.CommonName != intermediate.Subject.CommonName {
		t.Fatalf("the leaf's issuer = %q, want the namespace's intermediate %q", leaf.Issuer.CommonName, intermediate.Subject.CommonName)
	}
	t.Logf("issued: subject=%s issuer=%s serial=%s dns=%v ips=%v",
		leaf.Subject.CommonName, leaf.Issuer.CommonName, leaf.SerialNumber, leaf.DNSNames, leaf.IPAddresses)
}

// A namespace with no OpenBao object has no authority, so a workload that asked
// for TLS there is not issued a certificate and serves plain HTTP, which is the
// same degradation the provider has when it holds no CA at all -- the workload
// runs either way.
func TestANamespaceWithoutAnOpenBaoObjectGetsNoCertificate(t *testing.T) {
	requireLive(t)
	c := startCluster(t, withOpenBao(startEmbeddedBao(t)))

	c.apply("openbao-tls-pod.yaml")
	pod := awaitPodOutput(t, c, openBaoTLSProbe, "serviceName")
	if pod.Status.Outputs["certificate"] != "" {
		t.Fatal("a pod in a namespace with no OpenBao object was issued a certificate, so the authority is not the namespace's")
	}
	if pod.Status.Outputs["serviceName"] != "" {
		t.Fatal("a pod with no authority reported a service name, so something else signed for it")
	}
	if pod.Status.Outputs["hasKey"] != "false" {
		t.Fatalf("the pod reports hasKey=%q, want false", pod.Status.Outputs["hasKey"])
	}
	t.Logf("no-authority pod: ready=%v certificate=%d bytes", pod.Status.Ready, len(pod.Status.Outputs["certificate"]))
}

// awaitPodOutput waits for a pod to finish and report its outputs, and reports
// the pod's own message when it does not: a workload that fails to write its
// result says why in the message, and without it the failure is a bare timeout.
// The pod has to reach a terminal phase, because a running pod's outputs are
// transient by design -- the next execution of a restarted pod overwrites them.
func awaitPodOutput(t *testing.T, c *liveCluster, name, key string) *v1alpha1.DenoPod {
	t.Helper()
	deadline := time.Now().Add(180 * time.Second)
	for time.Now().Before(deadline) {
		pod := c.pod(name)
		if pod != nil && terminalPodPhase(pod.Status.Phase) && len(pod.Status.Outputs) > 0 {
			return pod
		}
		time.Sleep(2 * time.Second)
	}
	pod := c.pod(name)
	if pod == nil {
		t.Fatalf("the pod %s was never created", name)
	}
	runDir := filepath.Join(c.root, "pods", pod.Status.RunID)
	t.Fatalf("the pod %s never reported %q: phase=%s ready=%v restarts=%d message=%q outputs=%v\nstderr:\n%s\nprovider.log:\n%s",
		name, key, pod.Status.Phase, pod.Status.Ready, pod.Status.Restarts, pod.Status.Message, pod.Status.Outputs,
		tail(filepath.Join(runDir, "stderr.txt"), 20), tail(filepath.Join(c.root, "provider.log"), 20))
	return nil
}

func readRootCA(t *testing.T, vault baoServer) []byte {
	t.Helper()
	client, err := openbao.New(openbao.Options{Address: vault.address, Token: vault.token, CACert: vault.caCert()})
	if err != nil {
		t.Fatal(err)
	}
	chain, err := client.CAChain(context.Background(), "", "pki")
	if err != nil {
		t.Fatalf("reading the root namespace's CA chain: %v", err)
	}
	return []byte(chain)
}

// verifyChain returns the certificate a chain names below its root, and fails if
// the chain does not verify against that root.
func verifyChain(t *testing.T, chain string, root []byte) *x509.Certificate {
	t.Helper()
	pool := poolOf(t, root)
	var issued *x509.Certificate
	for _, cert := range parseCerts(t, chain) {
		// A self-signed certificate verifies against its own key; the root does,
		// the intermediate does not.
		if cert.IsCA && cert.CheckSignatureFrom(cert) != nil {
			issued = cert
		}
	}
	if issued == nil {
		t.Fatalf("the chain holds no intermediate:\n%s", chain)
	}
	if _, err := issued.Verify(x509.VerifyOptions{Roots: pool, KeyUsages: []x509.ExtKeyUsage{x509.ExtKeyUsageAny}}); err != nil {
		t.Fatalf("the intermediate does not chain to the root: %v", err)
	}
	count := 0
	for _, cert := range parseCerts(t, chain) {
		if cert.IsCA {
			count++
		}
	}
	if count != 2 {
		t.Fatalf("the chain holds %d CA certificates, want the intermediate and the root", count)
	}
	return issued
}

// intermediatePool is the rest of the chain a peer is handed alongside a leaf.
func intermediatePool(t *testing.T, chain string) *x509.CertPool {
	t.Helper()
	pool := x509.NewCertPool()
	for _, cert := range parseCerts(t, chain) {
		if !cert.IsCA || cert.CheckSignatureFrom(cert) == nil {
			continue
		}
		pool.AddCert(cert)
	}
	return pool
}

func lastCert(chain string) string {
	blocks := strings.Split(strings.TrimSpace(chain), "-----END CERTIFICATE-----")
	if len(blocks) == 0 {
		return ""
	}
	return blocks[0] + "-----END CERTIFICATE-----"
}

func poolOf(t *testing.T, pemBytes []byte) *x509.CertPool {
	t.Helper()
	pool := x509.NewCertPool()
	if !pool.AppendCertsFromPEM(pemBytes) {
		t.Fatalf("the PEM holds no certificate:\n%s", pemBytes)
	}
	return pool
}

func parseCert(t *testing.T, body string) *x509.Certificate {
	t.Helper()
	certs := parseCerts(t, body)
	if len(certs) == 0 {
		t.Fatalf("no certificate in:\n%s", body)
	}
	return certs[0]
}

func parseCerts(t *testing.T, body string) []*x509.Certificate {
	t.Helper()
	var out []*x509.Certificate
	rest := []byte(strings.TrimSpace(body))
	for {
		var block *pem.Block
		block, rest = pem.Decode(rest)
		if block == nil {
			break
		}
		if block.Type != "CERTIFICATE" {
			continue
		}
		cert, err := x509.ParseCertificate(block.Bytes)
		if err != nil {
			t.Fatalf("parsing a certificate: %v", err)
		}
		out = append(out, cert)
	}
	return out
}

func containsIP(ips []net.IP, want string) bool {
	for _, ip := range ips {
		if ip.String() == want {
			return true
		}
	}
	return false
}
