package provider

import (
	"context"
	"encoding/json"
	"strings"

	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"

	"github.com/publicdomainrelay/kcp-libs/abc/pki"
	"github.com/publicdomainrelay/kcp-libs/common/denospec"
	"github.com/publicdomainrelay/kcp-libs/impl/assets"
	"github.com/publicdomainrelay/kcp-libs/impl/pkiprovisioner"

	"github.com/johnandersen777/deno-kcp/api/v1alpha1"
)

const DefaultServiceDomain = "kcp.local"

// ponytail: the FQDN shape is <name>.<namespace>.<workspace labels>.svc.<service domain>, e.g. pds.default.alice.svc.kcp.local. The service domain is the cluster domain in the Kubernetes sense, defaulting to kcp.local, so svc is structural and not part of the flag. The workspace labels are the logical cluster path with root dropped and the rest reversed, because a path separator is not legal in a DNS label and the path is the only name kcp gives a workspace. The rule is mirrored in the preload shim, which runs in Deno and cannot import this: it is three lines in both places on purpose, and a test here pins the examples the README quotes.
func serviceLabels(logicalCluster string) string {
	parts := strings.Split(logicalCluster, ":")
	out := make([]string, 0, len(parts))
	for i := len(parts) - 1; i >= 0; i-- {
		if parts[i] == "" || parts[i] == RootWorkspace {
			continue
		}
		out = append(out, parts[i])
	}
	return strings.Join(out, ".")
}

func serviceFQDN(name, namespace, logicalCluster, domain string) string {
	labels := serviceLabels(logicalCluster)
	if namespace == "" {
		namespace = "default"
	}
	host := name + "." + namespace
	if labels != "" {
		host += "." + labels
	}
	return host + ".svc." + domain
}

// ponytail: the address a pod advertises is read from its own env, in the shape
// the examples already use for their service arguments. That couples the table
// to that convention rather than to a field in the CRD, and it is the cheaper
// coupling: the schema is immutable, so a first-class advertise field would cost
// a version bump, and the convention is already what every example carries. A
// pod that advertises nothing is simply absent from the table.
func advertisedAddress(argsJSON, envJSON string) string {
	args := []string{}
	if argsJSON != "" {
		_ = json.Unmarshal([]byte(argsJSON), &args)
	}
	serviceEnv := map[string]string{}
	if envJSON != "" {
		_ = json.Unmarshal([]byte(envJSON), &serviceEnv)
	}
	flag := func(f string) string {
		for i, a := range args {
			if a == f && i+1 < len(args) {
				return args[i+1]
			}
		}
		return ""
	}
	port := flag("--port")
	if port == "" {
		port = serviceEnv["PORT"]
	}
	if port == "" {
		return ""
	}
	host := flag("--hostname")
	if host == "" {
		host = serviceEnv["HOSTNAME"]
	}
	if host == "" || host == "0.0.0.0" || host == "::" {
		host = "127.0.0.1"
	}
	return host + ":" + port
}

func envOf(u *unstructured.Unstructured) map[string]any {
	env, _, _ := unstructured.NestedMap(u.Object, "spec", "env")
	return env
}

func stringOf(env map[string]any, key string) string {
	s, _ := env[key].(string)
	return s
}

// dnsTable maps every advertised name to its address, across every workspace the
// provider watches, and reports which workspaces it saw. The table is injected
// into each pod so the shim can resolve a peer without an API call; the shim
// falls back to asking kcp only on a miss, and that fallback needs one token per
// workspace, which is why the workspace list comes back with it.
func (p *Provider) dnsTable() (map[string]string, []string) {
	table := map[string]string{}
	seen := map[string]bool{}
	var workspaces []string
	for _, pod := range p.allPods() {
		lc := pod.GetAnnotations()[clusterAnnotation]
		if lc == "" {
			continue
		}
		if !seen[lc] {
			seen[lc] = true
			workspaces = append(workspaces, lc)
		}
		addr := advertisedAddress(stringOf(envOf(pod), "SERVICE_ARGS"), stringOf(envOf(pod), "SERVICE_ENV"))
		if addr == "" {
			continue
		}
		table[p.serviceName(pod.GetName(), pod.GetNamespace(), lc)] = addr
	}
	return table, workspaces
}

// serviceName is the FQDN a workload is reachable at, built from the workspace's
// path rather than its ID, so the name reads pds.default.alice rather than
// pds.default.2j35eh7jjhsc8ny9.
func (p *Provider) serviceName(name, namespace, logicalCluster string) string {
	registry, _ := p.opts.Registry.(*Registry)
	path := p.paths.lookup(registry, context.Background(), logicalCluster)
	return serviceFQDN(name, namespace, path, p.opts.ServiceDomain)
}

// dnsTokens mints one token per workspace, so the shim's fallback can read a
// peer's DenoPod from the workspace that owns it. A token minted in one
// workspace is not authorised in another, which is the measurement that makes
// this a map rather than a single token. Minting needs a service account in each
// target workspace, so a pod that names none gets an empty map and the shim
// reports an unresolved name instead of guessing.
func (p *Provider) dnsTokens(workspaces []string, tmpl *v1alpha1.DenoPodTemplate) string {
	out := map[string]string{}
	if tmpl.ServiceAccount != nil && p.opts.Minter != nil {
		namespace := tmpl.ServiceAccount.Namespace
		if namespace == "" {
			namespace = DefaultServiceAccountNamespace
		}
		for _, lc := range workspaces {
			tok, err := p.opts.Minter.MintServiceAccountToken(context.Background(), lc, namespace, tmpl.ServiceAccount.Name, p.opts.TokenTTL)
			if err != nil {
				continue
			}
			out[lc] = tok
		}
	}
	body, err := json.Marshal(out)
	if err != nil {
		return "{}"
	}
	return string(body)
}

// podEnv is the environment a workload starts with: whatever the CR asked for,
// plus what the FQDN layer needs. The shim runs inside the workload's process,
// so these keys must also be in the CR's permissions.env allowList or the shim
// cannot read them.
func (p *Provider) podEnv(ctx context.Context, ref Ref, tmpl *v1alpha1.DenoPodTemplate) map[string]string {
	env := map[string]string{}
	for k, v := range tmpl.Env {
		env[k] = v
	}
	env["KCP_SERVICE_DOMAIN"] = p.opts.ServiceDomain
	env["KCP_NAMESPACE"] = ref.Namespace
	if p.dnsShim != "" {
		env["KCP_SHIM"] = p.dnsShim
	}
	// ponytail: the runner writes the trust bundle to ca.pem in the run
	// directory, which is this process's working directory, so DENO_CERT is a
	// relative path on purpose. Deno reads it at startup, which is the only
	// moment it can be set: a workload that does its own TLS cannot install a CA
	// from inside the script.
	if len(p.clusterCA) > 0 {
		env["DENO_CERT"] = "ca.pem"
	}
	// ponytail: TLS is opt-in per pod, because a workload that does not serve
	// anything has no use for a certificate and no reason to carry one. The leaf
	// is signed for the pod's own name by the intermediate of the namespace the
	// pod is in -- which is why a namespace needs an OpenBao object before any of
	// its workloads can serve TLS -- and carries loopback as a subject alternative
	// name, which is what a probe reaches it on and what the shim's rewritten
	// address verifies against.
	if p.pki != nil && tmpl.Env["SERVICE_TLS"] == "true" {
		fqdn := p.serviceName(ref.Name, ref.Namespace, ref.LogicalCluster)
		cert, err := p.issueFor(ctx, ref, fqdn)
		if err != nil {
			p.opts.Log.Warn("openbao: no certificate for this workload, it will not serve TLS", "name", fqdn, "err", err)
		} else {
			env["KCP_TLS_CERT"] = pkiprovisioner.LeafChain(cert)
			env["KCP_TLS_KEY"] = cert.PrivateKey
			env["KCP_SERVICE_NAME"] = fqdn
		}
		// The bundle carries the root the intermediates chain to and kcp's own CA,
		// so a workload trusts its peers' leaves and the API server with one
		// setting. A peer serves its own intermediate alongside its leaf, so the
		// bundle does not have to carry every namespace's.
		env["KCP_CA_BUNDLE"] = string(p.pki.CachedRootPEM()) + string(p.clusterCA)
	}
	// ponytail: a pod's own name has to be in the table from its first moment,
	// because its readiness probe resolves that name and the pod cannot be in the
	// informer cache before it has started. Its own address is computable from
	// its own declarations, so it needs no discovery.
	table, workspaces := p.dnsTable()
	if self := advertisedAddress(tmpl.Env["SERVICE_ARGS"], tmpl.Env["SERVICE_ENV"]); self != "" {
		selfName := p.serviceName(ref.Name, ref.Namespace, ref.LogicalCluster)
		table[selfName] = self
		if !containsString(workspaces, ref.LogicalCluster) {
			workspaces = append(workspaces, ref.LogicalCluster)
		}
	}
	if len(table) > 0 {
		if body, err := json.Marshal(table); err == nil {
			env["KCP_DNS_TABLE"] = string(body)
		}
	}
	// ponytail: the tokens are minted whether or not the table is empty, because
	// an empty table is exactly when the shim needs its fallback, and a pod
	// created before the informer cache saw its peers would otherwise have
	// neither a table nor a way to discover one.
	if tmpl.ServiceAccount != nil {
		env["KCP_TOKENS"] = p.dnsTokens(workspaces, tmpl)
	}
	return env
}

func containsString(haystack []string, needle string) bool {
	for _, s := range haystack {
		if s == needle {
			return true
		}
	}
	return false
}

// probeCommand expands the kcpdns probe form into the argv a probe actually
// runs. A manifest cannot know where the shim was materialised, so it names the
// probe as ["kcpdns", "<fqdn>", "<path>"] and this fills in the paths, keeping
// the absolute runs directory out of every example. Anything else is passed
// through untouched, and without a materialised shim the form cannot be expanded
// at all, so the probe is dropped rather than run against a path that is not
// there.
func (p *Provider) probeCommand(command []string) []string {
	if len(command) < 2 || command[0] != "kcpdns" {
		return command
	}
	if p.dnsShim == "" || p.dnsProbe == "" {
		return nil
	}
	return denospec.ProbeCommand("", p.dnsShim, p.dnsProbe, command[1], probePath(command), assets.DNSProbeEnv)
}

func probePath(command []string) string {
	if len(command) > 2 && command[2] != "" {
		return command[2]
	}
	return "/"
}

// allPods reads every DenoPod in every workspace out of the informer cache. The
// cache is the only component that can do this: a pod's own token authorises
// reads within its workspace but not in a peer.
func (p *Provider) allPods() []*unstructured.Unstructured {
	if lister, ok := p.reader.(podLister); ok {
		return lister.allPods()
	}
	return nil
}

type podLister interface {
	allPods() []*unstructured.Unstructured
}

// issueFor signs a workload's serving certificate out of the authority of the
// namespace it is in. The namespace is named by the OpenBao object in that
// Kubernetes namespace, so a pod whose namespace holds none -- or holds two --
// is one the provider cannot say an authority for, and it says so rather than
// guessing.
func (p *Provider) issueFor(ctx context.Context, ref Ref, fqdn string) (pki.Cert, error) {
	obj, err := p.authorityFor(ctx, ref.LogicalCluster, ref.Namespace)
	if err != nil {
		return pki.Cert{}, err
	}
	return p.pki.Issue(ctx, obj.Spec.Namespace, fqdn, []string{fqdn}, nil)
}
