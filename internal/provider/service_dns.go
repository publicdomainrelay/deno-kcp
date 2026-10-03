package provider

import (
	"context"

	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"

	"github.com/publicdomainrelay/kcp-libs/abc/pki"
	"github.com/publicdomainrelay/kcp-libs/common/denospec"
	"github.com/publicdomainrelay/kcp-libs/factory/servicenames"
	"github.com/publicdomainrelay/kcp-libs/impl/assets"
	"github.com/publicdomainrelay/kcp-libs/impl/pkiprovisioner"

	"github.com/johnandersen777/deno-kcp/api/v1alpha1"
)

// buildServices points the FQDN layer at this provider's pod cache, path cache
// and token minter, and at the shim the provider materialised.
func (p *Provider) buildServices() *servicenames.Resolver {
	var paths servicenames.PathResolver
	if p.paths != nil {
		paths = p.paths
	}
	return servicenames.New(servicenames.Options{
		Source:                  servicenames.SourceFunc(p.allPods),
		Minter:                  p.opts.Minter,
		Paths:                   paths,
		Domain:                  p.opts.ServiceDomain,
		TokenTTL:                p.opts.TokenTTL,
		ServiceAccountNamespace: DefaultServiceAccountNamespace,
		Shim:                    p.dnsShim,
	})
}

// serviceResolver is the FQDN layer. New builds it once; a Provider assembled by
// hand in a test gets one on first use.
func (p *Provider) serviceResolver() *servicenames.Resolver {
	if p.services == nil {
		p.services = p.buildServices()
	}
	return p.services
}

// podEnv is the environment a workload starts with: whatever the CR asked for,
// then what the FQDN layer needs, then this provider's own additions. The shim
// runs inside the workload's process, so these keys must also be in the CR's
// permissions.env allowList or the shim cannot read them.
func (p *Provider) podEnv(ctx context.Context, ref Ref, tmpl *v1alpha1.DenoPodTemplate) map[string]string {
	env := map[string]string{}
	for k, v := range tmpl.Env {
		env[k] = v
	}
	services := p.serviceResolver()
	for k, v := range services.Env(ctx, ref, tmpl.Env["SERVICE_ARGS"], tmpl.Env["SERVICE_ENV"], tmpl.ServiceAccount.DenoSpec()) {
		env[k] = v
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
		fqdn := services.Name(ctx, ref.Name, ref.Namespace, ref.LogicalCluster)
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
	return env
}

// probeCommand expands the kcpdns probe form -- the marker the deploy examples
// carry -- into the argv a probe actually runs, through denospec.ProbeCommand.
// A manifest cannot know where the shim was materialised, so it names the probe
// as ["kcpdns", "<fqdn>", "<path>"] and this fills in the paths, keeping the
// absolute runs directory out of every example. Anything else is passed through
// untouched, and without a materialised shim the form cannot be expanded at all,
// so the probe is dropped rather than run against a path that is not there.
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
