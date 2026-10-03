package baopki

import (
	"context"
	"fmt"
	"strings"
	"sync"
	"testing"
	"time"

	"github.com/johnandersen777/deno-kcp/internal/openbao"
)

type fakeClient struct {
	mu sync.Mutex

	mounts map[string]map[string]string

	namespaces map[string]bool

	serial map[string]string

	chains map[string]string

	calls []string

	generatedRoots int

	signedIntermediate int

	role openbao.Role

	issued []openbao.CertRequest

	issueNamespace string
}

func newFake() *fakeClient {
	return &fakeClient{
		mounts:     map[string]map[string]string{},
		namespaces: map[string]bool{},
		serial:     map[string]string{},
		chains:     map[string]string{},
	}
}

func (f *fakeClient) record(format string, args ...any) {
	f.calls = append(f.calls, fmt.Sprintf(format, args...))
}

func (f *fakeClient) EnsureNamespace(_ context.Context, path string) error {
	f.mu.Lock()
	defer f.mu.Unlock()
	f.record("ensure-namespace %s", path)
	f.namespaces[path] = true
	return nil
}

func (f *fakeClient) EnsureMount(_ context.Context, namespace, path, kind string) error {
	f.mu.Lock()
	defer f.mu.Unlock()
	f.record("ensure-mount %s/%s", namespace, path)
	if f.mounts[namespace] == nil {
		f.mounts[namespace] = map[string]string{}
	}
	f.mounts[namespace][path] = kind
	return nil
}

func (f *fakeClient) GenerateRoot(_ context.Context, namespace, mount, commonName, _ string) (openbao.RootCA, error) {
	f.mu.Lock()
	defer f.mu.Unlock()
	f.record("generate-root %s/%s", namespace, mount)
	f.generatedRoots++
	f.serial[namespace] = "ROOT-SERIAL"
	f.chains[namespace] = "ROOT-PEM-" + commonName
	return openbao.RootCA{Certificate: f.chains[namespace], Serial: "ROOT-SERIAL"}, nil
}

func (f *fakeClient) CASerial(_ context.Context, namespace, _ string) (string, error) {
	f.mu.Lock()
	defer f.mu.Unlock()
	return f.serial[namespace], nil
}

func (f *fakeClient) CAChain(_ context.Context, namespace, _ string) (string, error) {
	f.mu.Lock()
	defer f.mu.Unlock()
	return f.chains[namespace], nil
}

func (f *fakeClient) GenerateIntermediate(_ context.Context, namespace, _, commonName string) (openbao.IntermediateCSR, error) {
	f.mu.Lock()
	defer f.mu.Unlock()
	f.record("generate-intermediate %s", namespace)
	return openbao.IntermediateCSR{CSR: "CSR-" + commonName}, nil
}

func (f *fakeClient) SignIntermediate(_ context.Context, rootNamespace, _, csr, commonName, _ string) (string, error) {
	f.mu.Lock()
	defer f.mu.Unlock()
	f.record("sign-intermediate root=%s csr=%s", rootNamespace, csr)
	f.signedIntermediate++
	f.serial[strings.TrimSuffix(commonName, ".intermediate")] = "INT-SERIAL"
	f.chains[strings.TrimSuffix(commonName, ".intermediate")] = "INT-PEM\nROOT-PEM"
	return "SIGNED-" + csr, nil
}

func (f *fakeClient) SetSignedIntermediate(_ context.Context, namespace, _, chain string) error {
	f.mu.Lock()
	defer f.mu.Unlock()
	f.record("set-signed %s", namespace)
	if !strings.HasPrefix(chain, "SIGNED-") {
		f.record("set-signed-not-signed %s", namespace)
	}
	return nil
}

func (f *fakeClient) WriteRole(_ context.Context, namespace, _, _ string, role openbao.Role) error {
	f.mu.Lock()
	defer f.mu.Unlock()
	f.record("write-role %s", namespace)
	f.role = role
	return nil
}

func (f *fakeClient) DeleteNamespace(_ context.Context, path string) error {
	f.mu.Lock()
	defer f.mu.Unlock()
	f.record("delete-namespace %s", path)
	delete(f.namespaces, path)
	delete(f.serial, path)
	return nil
}

func (f *fakeClient) Issue(_ context.Context, namespace, _, _ string, req openbao.CertRequest) (openbao.Cert, error) {
	f.mu.Lock()
	defer f.mu.Unlock()
	f.record("issue %s", namespace)
	f.issued = append(f.issued, req)
	f.issueNamespace = namespace
	return openbao.Cert{Certificate: "LEAF", CAChain: []string{"INT-PEM", "ROOT-PEM"}, Serial: "LEAF-SERIAL"}, nil
}

func newProvisioner(t *testing.T, fake *fakeClient, opts ...func(*Options)) *Provisioner {
	t.Helper()
	o := Options{Client: fake, Domain: "kcp.local"}
	for _, opt := range opts {
		opt(&o)
	}
	p, err := New(o)
	if err != nil {
		t.Fatal(err)
	}
	return p
}

func TestAuthorityIsSignedByTheRootInTheRootNamespace(t *testing.T) {
	fake := newFake()
	p := newProvisioner(t, fake)

	authority, err := p.EnsureAuthority(context.Background(), "alice.default")
	if err != nil {
		t.Fatal(err)
	}
	if authority.Serial != "INT-SERIAL" {
		t.Fatalf("authority serial = %q, want the intermediate's", authority.Serial)
	}
	if fake.generatedRoots != 1 {
		t.Fatalf("generated %d roots, want 1", fake.generatedRoots)
	}
	if fake.signedIntermediate != 1 {
		t.Fatalf("signed %d intermediates, want 1", fake.signedIntermediate)
	}
	signed := false
	for _, call := range fake.calls {
		if call == "sign-intermediate root= csr=CSR-alice.default.intermediate" {
			signed = true
		}
	}
	if !signed {
		t.Fatalf("the intermediate was not signed at the root namespace: %v", fake.calls)
	}
	if fake.mounts[""]["pki"] != "pki" {
		t.Fatalf("the root namespace holds %v, want a pki mount", fake.mounts[""])
	}
	if fake.mounts["alice.default"]["pki"] != "pki" {
		t.Fatalf("the namespace holds %v, want a pki mount", fake.mounts["alice.default"])
	}
}

func TestASecondNamespaceIsSignedByTheSameRoot(t *testing.T) {
	fake := newFake()
	p := newProvisioner(t, fake)

	if _, err := p.EnsureAuthority(context.Background(), "alice.default"); err != nil {
		t.Fatal(err)
	}
	if _, err := p.EnsureAuthority(context.Background(), "relay.default"); err != nil {
		t.Fatal(err)
	}
	if fake.generatedRoots != 1 {
		t.Fatalf("generated %d roots for two namespaces, want 1", fake.generatedRoots)
	}
	if fake.signedIntermediate != 2 {
		t.Fatalf("signed %d intermediates, want one per namespace", fake.signedIntermediate)
	}
}

func TestAuthorityIsCachedAndReused(t *testing.T) {
	fake := newFake()
	p := newProvisioner(t, fake)

	if _, err := p.EnsureAuthority(context.Background(), "alice.default"); err != nil {
		t.Fatal(err)
	}
	before := len(fake.calls)
	if _, err := p.EnsureAuthority(context.Background(), "alice.default"); err != nil {
		t.Fatal(err)
	}
	if len(fake.calls) != before {
		t.Fatalf("the second call made %d more calls, want none while the cache is warm", len(fake.calls)-before)
	}
}

// A cache that expires must not mint a new intermediate: the namespace already
// has one, and replacing it would invalidate every leaf issued under it.
func TestAnExpiredCacheRereadsRatherThanResigns(t *testing.T) {
	fake := newFake()
	now := time.Now()
	p := newProvisioner(t, fake, func(o *Options) {
		o.Now = func() time.Time { return now }
		o.AuthorityTTL = time.Minute
	})

	if _, err := p.EnsureAuthority(context.Background(), "alice.default"); err != nil {
		t.Fatal(err)
	}
	now = now.Add(2 * time.Minute)
	if _, err := p.EnsureAuthority(context.Background(), "alice.default"); err != nil {
		t.Fatal(err)
	}
	if fake.signedIntermediate != 1 {
		t.Fatalf("signed %d intermediates after the cache expired, want 1", fake.signedIntermediate)
	}
}

func TestIssueCarriesLoopbackWhenNoAddressIsGiven(t *testing.T) {
	fake := newFake()
	p := newProvisioner(t, fake)

	if _, err := p.Issue(context.Background(), "alice.default", "pds.default.alice.svc.kcp.local", []string{"pds.default.alice.svc.kcp.local"}, nil); err != nil {
		t.Fatal(err)
	}
	if len(fake.issued) != 1 {
		t.Fatalf("issued %d certificates, want 1", len(fake.issued))
	}
	got := strings.Join(fake.issued[0].IPSANs, ",")
	if got != "127.0.0.1,::1" {
		t.Fatalf("ip sans = %q, want the loopback pair: a probe reaches the workload there", got)
	}
	if fake.issueNamespace != "alice.default" {
		t.Fatalf("issued in namespace %q, want the workload's own", fake.issueNamespace)
	}
}

func TestRoleAdmitsTheServiceDomainAndNothingElse(t *testing.T) {
	fake := newFake()
	p := newProvisioner(t, fake)

	if _, err := p.EnsureAuthority(context.Background(), "alice.default"); err != nil {
		t.Fatal(err)
	}
	if len(fake.role.AllowedDomains) != 1 || fake.role.AllowedDomains[0] != "kcp.local" {
		t.Fatalf("allowed domains = %v, want just the service domain", fake.role.AllowedDomains)
	}
	if !fake.role.AllowSubdomains {
		t.Fatal("subdomains are not allowed, so no workload name would be issuable")
	}
	if fake.role.AllowBareDomains {
		t.Fatal("bare domains are allowed, so the namespace could be issued a certificate for the domain itself")
	}
	if fake.role.MaxTTL != DefaultLeafTTL {
		t.Fatalf("max ttl = %q, want %q", fake.role.MaxTTL, DefaultLeafTTL)
	}
}

func TestRootIsGeneratedOnceAcrossNamespacesAndIssues(t *testing.T) {
	fake := newFake()
	p := newProvisioner(t, fake)

	for _, ns := range []string{"alice.default", "relay.default", "global.default"} {
		if _, err := p.Issue(context.Background(), ns, ns+".svc.kcp.local", nil, nil); err != nil {
			t.Fatal(err)
		}
	}
	if fake.generatedRoots != 1 {
		t.Fatalf("generated %d roots, want 1: a second root signs nothing the first one's leaves trust", fake.generatedRoots)
	}
}
