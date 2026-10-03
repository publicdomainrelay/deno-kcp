// Package baopki keeps one certificate authority per Kubernetes namespace.
//
// The shape it maintains inside OpenBao:
//
//	root namespace   pki/  <- the root CA, and the only key that signs another
//	                         namespace's authority
//	<labels>.<ns>    pki/  <- an intermediate CA signed by the root above, and
//	                         the role leaves are issued through
//
// Why not one CA for everything: a leaf signed directly by the root is a leaf
// whose key, if it leaks, is a root key. An intermediate per namespace means a
// namespace's authority can be replaced without touching any other namespace's
// chain, and it is the level at which the Kubernetes namespace is the unit of
// trust, which is what makes the mapping worth having.
//
// Everything here is orchestration over the client interface, so the tests drive
// the whole hierarchy against a fake and the provider drives the real one.
package baopki

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"sync"
	"time"

	"github.com/johnandersen777/deno-kcp/internal/openbao"
)

const (
	DefaultMount = "pki"

	DefaultRole = "denopod"

	DefaultRootCommonName = "kcp-mesh-root"

	DefaultRootTTL = "87600h"

	DefaultIntermediateTTL = "43800h"

	DefaultLeafTTL = "720h"
)

// ponytail: an authority is cached rather than re-read per pod, because minting a
// pod's certificate happens at pod start and the read is four round trips; the
// cache expires so a namespace deleted underneath the provider is noticed rather
// than served from memory forever.
const defaultAuthorityTTL = 5 * time.Minute

var ErrNoClient = errors.New("baopki: a client is required")

type Client interface {
	EnsureNamespace(ctx context.Context, path string) error

	EnsureMount(ctx context.Context, namespace, path, kind string) error

	GenerateRoot(ctx context.Context, namespace, mount, commonName, ttl string) (openbao.RootCA, error)

	CASerial(ctx context.Context, namespace, mount string) (string, error)

	CAChain(ctx context.Context, namespace, mount string) (string, error)

	GenerateIntermediate(ctx context.Context, namespace, mount, commonName string) (openbao.IntermediateCSR, error)

	SignIntermediate(ctx context.Context, rootNamespace, mount, csr, commonName, ttl string) (string, error)

	SetSignedIntermediate(ctx context.Context, namespace, mount, chain string) error

	WriteRole(ctx context.Context, namespace, mount, name string, role openbao.Role) error

	Issue(ctx context.Context, namespace, mount, role string, req openbao.CertRequest) (openbao.Cert, error)

	DeleteNamespace(ctx context.Context, path string) error
}

type Options struct {
	Client Client

	RootNamespace string

	Mount string

	RootCommonName string

	RootTTL string

	IntermediateTTL string

	LeafTTL string

	Role string

	Domain string

	AuthorityTTL time.Duration

	Now func() time.Time
}

// Authority is what a namespace got, and what a peer needs to verify a leaf from
// it: the chain from the namespace's intermediate up to the root.
type Authority struct {
	Namespace string

	CommonName string

	Serial string

	Chain string
}

// ponytail: one lock over every provisioning step, not one per namespace. The
// steps are rare -- a namespace is provisioned once and then cached -- and two
// callers racing on the root would both see no CA and both generate one, which
// leaves the second root signing intermediates the first root's leaves do not
// chain to. Serialising is the cheaper thing to be sure of.
type Provisioner struct {
	opts Options

	mu sync.Mutex

	root *openbao.RootCA

	namespaces map[string]cachedAuthority
}

type cachedAuthority struct {
	authority Authority

	at time.Time
}

func New(opts Options) (*Provisioner, error) {
	if opts.Client == nil {
		return nil, ErrNoClient
	}
	if opts.Mount == "" {
		opts.Mount = DefaultMount
	}
	if opts.Role == "" {
		opts.Role = DefaultRole
	}
	if opts.RootCommonName == "" {
		opts.RootCommonName = DefaultRootCommonName
	}
	if opts.RootTTL == "" {
		opts.RootTTL = DefaultRootTTL
	}
	if opts.IntermediateTTL == "" {
		opts.IntermediateTTL = DefaultIntermediateTTL
	}
	if opts.LeafTTL == "" {
		opts.LeafTTL = DefaultLeafTTL
	}
	if opts.AuthorityTTL <= 0 {
		opts.AuthorityTTL = defaultAuthorityTTL
	}
	if opts.Now == nil {
		opts.Now = time.Now
	}
	return &Provisioner{opts: opts, namespaces: map[string]cachedAuthority{}}, nil
}

// EnsureRoot mounts the root namespace's PKI and generates the CA if there is
// none. It is idempotent: a mount that already answers for its CA certificate is
// left alone, because regenerating it would invalidate every intermediate and
// every leaf signed under it.
func (p *Provisioner) EnsureRoot(ctx context.Context) (openbao.RootCA, error) {
	p.mu.Lock()
	defer p.mu.Unlock()
	return p.ensureRootLocked(ctx)
}

// ensureRootLocked is the body, and it is separate from EnsureRoot only because
// a caller that already holds the lock would deadlock on it.
func (p *Provisioner) ensureRootLocked(ctx context.Context) (openbao.RootCA, error) {
	if p.root != nil {
		return *p.root, nil
	}
	root, err := p.ensureRoot(ctx)
	if err != nil {
		return openbao.RootCA{}, err
	}
	p.root = &root
	return root, nil
}

func (p *Provisioner) ensureRoot(ctx context.Context) (openbao.RootCA, error) {
	if err := p.opts.Client.EnsureMount(ctx, p.opts.RootNamespace, p.opts.Mount, "pki"); err != nil {
		return openbao.RootCA{}, err
	}
	if serial, err := p.opts.Client.CASerial(ctx, p.opts.RootNamespace, p.opts.Mount); err == nil && serial != "" {
		chain, err := p.opts.Client.CAChain(ctx, p.opts.RootNamespace, p.opts.Mount)
		if err != nil {
			return openbao.RootCA{}, err
		}
		return openbao.RootCA{Certificate: chain, Serial: serial}, nil
	}
	root, err := p.opts.Client.GenerateRoot(ctx, p.opts.RootNamespace, p.opts.Mount, p.opts.RootCommonName, p.opts.RootTTL)
	if err != nil {
		return openbao.RootCA{}, fmt.Errorf("baopki: generating the root CA in namespace %q: %w", p.opts.RootNamespace, err)
	}
	return root, nil
}

// EnsureAuthority gives a namespace its own intermediate CA, signed by the root,
// and the role leaves are issued through. A namespace that already has a CA is
// reused rather than replaced, so the call is safe to make at every pod start.
func (p *Provisioner) EnsureAuthority(ctx context.Context, path string) (Authority, error) {
	if path == "" {
		return Authority{}, errors.New("baopki: a namespace path is required")
	}
	p.mu.Lock()
	defer p.mu.Unlock()
	if cached, ok := p.namespaces[path]; ok && p.opts.Now().Sub(cached.at) < p.opts.AuthorityTTL {
		return cached.authority, nil
	}
	authority, err := p.ensureAuthority(ctx, path)
	if err != nil {
		return Authority{}, err
	}
	p.namespaces[path] = cachedAuthority{authority: authority, at: p.opts.Now()}
	return authority, nil
}

// ponytail: the caller holds the lock, so this calls the unlocked ensureRoot
// rather than EnsureRoot, which would deadlock on the same mutex.
func (p *Provisioner) ensureAuthority(ctx context.Context, path string) (Authority, error) {
	if _, err := p.ensureRootLocked(ctx); err != nil {
		return Authority{}, err
	}
	if err := p.opts.Client.EnsureNamespace(ctx, path); err != nil {
		return Authority{}, fmt.Errorf("baopki: creating the namespace %q: %w", path, err)
	}
	if err := p.opts.Client.EnsureMount(ctx, path, p.opts.Mount, "pki"); err != nil {
		return Authority{}, fmt.Errorf("baopki: mounting %s in namespace %q: %w", p.opts.Mount, path, err)
	}
	commonName := path + ".intermediate"
	serial, err := p.opts.Client.CASerial(ctx, path, p.opts.Mount)
	if err != nil || serial == "" {
		serial, err = p.signIntermediate(ctx, path, commonName)
		if err != nil {
			return Authority{}, err
		}
	}
	chain, err := p.opts.Client.CAChain(ctx, path, p.opts.Mount)
	if err != nil {
		return Authority{}, fmt.Errorf("baopki: reading the chain for namespace %q: %w", path, err)
	}
	if err := p.writeRole(ctx, path); err != nil {
		return Authority{}, err
	}
	return Authority{Namespace: path, CommonName: commonName, Serial: serial, Chain: strings.TrimSpace(chain)}, nil
}

func (p *Provisioner) signIntermediate(ctx context.Context, path, commonName string) (string, error) {
	csr, err := p.opts.Client.GenerateIntermediate(ctx, path, p.opts.Mount, commonName)
	if err != nil {
		return "", fmt.Errorf("baopki: generating the intermediate for namespace %q: %w", path, err)
	}
	signed, err := p.opts.Client.SignIntermediate(ctx, p.opts.RootNamespace, p.opts.Mount, csr.CSR, commonName, p.opts.IntermediateTTL)
	if err != nil {
		return "", fmt.Errorf("baopki: signing the intermediate for namespace %q against the root: %w", path, err)
	}
	if err := p.opts.Client.SetSignedIntermediate(ctx, path, p.opts.Mount, signed); err != nil {
		return "", fmt.Errorf("baopki: installing the signed intermediate in namespace %q: %w", path, err)
	}
	serial, err := p.opts.Client.CASerial(ctx, path, p.opts.Mount)
	if err != nil {
		return "", fmt.Errorf("baopki: reading the serial of the intermediate in namespace %q: %w", path, err)
	}
	return serial, nil
}

func (p *Provisioner) writeRole(ctx context.Context, path string) error {
	role := openbao.Role{
		AllowSubdomains:  true,
		AllowBareDomains: false,
		EnforceHostnames: true,
		KeyType:          "ec",
		KeyBits:          256,
		MaxTTL:           p.opts.LeafTTL,
	}
	if p.opts.Domain != "" {
		role.AllowedDomains = []string{p.opts.Domain}
	}
	if err := p.opts.Client.WriteRole(ctx, path, p.opts.Mount, p.opts.Role, role); err != nil {
		return fmt.Errorf("baopki: writing role %s in namespace %q: %w", p.opts.Role, path, err)
	}
	return nil
}

// Issue signs a workload's serving certificate out of its namespace's
// intermediate. The loopback addresses are always included: a probe reaches the
// workload on the loopback address rather than the service name, and a
// certificate that does not carry it fails the handshake the readiness check is.
func (p *Provisioner) Issue(ctx context.Context, path, commonName string, altNames, ips []string) (openbao.Cert, error) {
	if _, err := p.EnsureAuthority(ctx, path); err != nil {
		return openbao.Cert{}, err
	}
	if len(ips) == 0 {
		ips = []string{"127.0.0.1", "::1"}
	}
	cert, err := p.opts.Client.Issue(ctx, path, p.opts.Mount, p.opts.Role, openbao.CertRequest{
		CommonName: commonName,
		AltNames:   altNames,
		IPSANs:     ips,
		TTL:        p.opts.LeafTTL,
	})
	if err != nil {
		return openbao.Cert{}, fmt.Errorf("baopki: issuing %s in namespace %q: %w", commonName, path, err)
	}
	return cert, nil
}

// Delete removes a namespace's authority and forgets it. The namespace goes
// whole -- its mount, its intermediate and everything issued under it -- because
// an intermediate with no namespace to live in is a key nothing can use.
func (p *Provisioner) Delete(ctx context.Context, path string) error {
	if path == "" {
		return errors.New("baopki: a namespace path is required")
	}
	p.mu.Lock()
	delete(p.namespaces, path)
	p.mu.Unlock()
	if err := p.opts.Client.DeleteNamespace(ctx, path); err != nil {
		return fmt.Errorf("baopki: deleting the namespace %q: %w", path, err)
	}
	return nil
}

// CachedRootPEM is the root a workload needs to verify any namespace's leaf, and
// the half of a trust bundle that is not kcp's own CA. It never reads: it answers
// once something has provisioned, so a caller that builds a trust bundle at a
// pod's start does not block on a vault that may be unreachable. Generating the
// root is a side effect of the first namespace that asked for a certificate.
func (p *Provisioner) CachedRootPEM() []byte {
	p.mu.Lock()
	defer p.mu.Unlock()
	if p.root == nil {
		return nil
	}
	return []byte(p.root.Certificate)
}
