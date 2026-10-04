package provider

import (
	"bytes"
	"context"
	"encoding/json"
	"io"
	"net/http"
	"strings"
	"sync"
	"testing"

	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"

	"github.com/johnandersen777/deno-kcp/api/v1alpha1"
	"github.com/publicdomainrelay/kcp-libs/common/kcp"
	"github.com/publicdomainrelay/kcp-libs/factory/servicenames"
	"github.com/publicdomainrelay/kcp-libs/impl/kcpstore"
)

func advertisedPod(t *testing.T, name, namespace, lc, args, env string) *unstructured.Unstructured {
	t.Helper()
	specEnv := map[string]any{}
	if args != "" {
		specEnv["SERVICE_ARGS"] = args
	}
	if env != "" {
		specEnv["SERVICE_ENV"] = env
	}
	return &unstructured.Unstructured{Object: map[string]any{
		"apiVersion": "deno.computer/v1alpha1",
		"kind":       "DenoPod",
		"metadata": map[string]any{
			"name":        name,
			"namespace":   namespace,
			"annotations": map[string]any{kcp.ClusterAnnotation: lc},
		},
		"spec": map[string]any{"env": specEnv},
	}}
}

// identityPaths answers every logical cluster ID with itself, so a test does not
// need a live cluster to resolve a path. Identity mapping: the test fixtures use
// a path as their cluster identifier, so the name that comes out is the one they
// assert on.
type identityPaths struct{}

func (identityPaths) RoundTrip(req *http.Request) (*http.Response, error) {
	id := strings.SplitN(strings.TrimPrefix(req.URL.Path, "/clusters/"), "/", 2)[0]
	body, err := json.Marshal(map[string]any{
		"metadata": map[string]any{"annotations": map[string]string{kcp.PathAnnotation: id}},
	})
	if err != nil {
		return nil, err
	}
	return &http.Response{
		StatusCode: http.StatusOK,
		Header:     http.Header{"Content-Type": []string{"application/json"}},
		Body:       io.NopCloser(bytes.NewReader(body)),
		Request:    req,
	}, nil
}

func withPaths(p *Provider, _ ...string) *Provider {
	store, err := kcpstore.New(kcpstore.Options{Host: "https://kcp.test", Transport: identityPaths{}})
	if err != nil {
		panic(err)
	}
	p.paths = kcpstore.NewPathCache(store)
	return p
}

func podTableReader(t *testing.T, pods ...*unstructured.Unstructured) *cacheReader {
	t.Helper()
	reader := newCacheReader()
	for _, pod := range pods {
		reader.upsert(workPod, pod)
	}
	return reader
}

func TestTheTableNamesEveryPodThatAdvertisesAndSkipsTheRest(t *testing.T) {
	reader := podTableReader(t,
		advertisedPod(t, "plc", "default", "root:global", `["--port","2587","--hostname","127.0.0.1"]`, `{"PORT":"2587"}`),
		advertisedPod(t, "pds", "default", "root:alice", `[]`, `{"PORT":"2583","HOSTNAME":"127.0.0.1"}`),
		advertisedPod(t, "quiet", "default", "root:alice", "", ""),
	)
	p := withPaths(&Provider{opts: Options{ServiceDomain: kcp.DefaultServiceDomain}, reader: reader}, "root:global", "root:alice")
	table, workspaces := p.serviceResolver().Table(context.Background())

	if got := table["plc.default.global.svc.kcp.local"]; got != "127.0.0.1:2587" {
		t.Fatalf("plc address = %q, want 127.0.0.1:2587", got)
	}
	if got := table["pds.default.alice.svc.kcp.local"]; got != "127.0.0.1:2583" {
		t.Fatalf("the SERVICE_ENV form was not read: pds address = %q", got)
	}
	if _, ok := table["quiet.default.alice.svc.kcp.local"]; ok {
		t.Fatal("a pod that advertises nothing should not be in the table")
	}
	if len(workspaces) != 2 {
		t.Fatalf("workspaces = %v, want the two that hold pods", workspaces)
	}
}

// ponytail: a wildcard bind is not an address anything can dial, so the table
// has to translate it; 0.0.0.0 is what a service picks when it wants every
// interface and would be useless to a peer on the same host.
func TestAWildcardBindIsTranslatedToLoopback(t *testing.T) {
	if got := servicenames.AdvertisedAddress(`["--port","2587","--hostname","0.0.0.0"]`, ""); got != "127.0.0.1:2587" {
		t.Fatalf("advertisedAddress = %q, want 127.0.0.1:2587", got)
	}
	if got := servicenames.AdvertisedAddress("", `{"PORT":"9","HOSTNAME":"::"}`); got != "127.0.0.1:9" {
		t.Fatalf("a :: bind should also become loopback, got %q", got)
	}
}

func TestPodEnvCarriesTheDomainAndNamespace(t *testing.T) {
	p := withPaths(&Provider{opts: Options{ServiceDomain: kcp.DefaultServiceDomain}, reader: podTableReader(t)}, "root:alice")
	env := p.podEnv(context.Background(), Ref{LogicalCluster: "root:alice", Namespace: "team-a", Name: "pds"}, &v1alpha1.DenoPodTemplate{
		Env: map[string]string{"MY_OWN": "kept"},
	})
	if env["MY_OWN"] != "kept" {
		t.Fatal("the CR's own env was dropped")
	}
	if env["KCP_SERVICE_DOMAIN"] != "kcp.local" {
		t.Fatalf("service domain = %q", env["KCP_SERVICE_DOMAIN"])
	}
	if env["KCP_NAMESPACE"] != "team-a" {
		t.Fatalf("namespace = %q, want the object's own", env["KCP_NAMESPACE"])
	}
	if _, ok := env["KCP_DNS_TABLE"]; ok {
		t.Fatal("an empty table should not be injected; the shim treats absent and empty the same, and an absent key is one less env allowList entry to get wrong")
	}
}

func TestPodEnvInjectsTheTableAsJSON(t *testing.T) {
	reader := podTableReader(t, advertisedPod(t, "plc", "default", "root:global", `["--port","2587"]`, ""))
	p := withPaths(&Provider{opts: Options{ServiceDomain: kcp.DefaultServiceDomain}, reader: reader}, "root:global", "root:alice")
	env := p.podEnv(context.Background(), Ref{LogicalCluster: "root:alice", Namespace: "default", Name: "pds"}, &v1alpha1.DenoPodTemplate{})

	var table map[string]string
	if err := json.Unmarshal([]byte(env["KCP_DNS_TABLE"]), &table); err != nil {
		t.Fatalf("the injected table is not JSON: %v", err)
	}
	if table["plc.default.global.svc.kcp.local"] != "127.0.0.1:2587" {
		t.Fatalf("table = %v", table)
	}
	// A pod that names no service account gets no tokens at all, rather than an
	// empty map: there is nothing to mint with, and an absent key is one less
	// env allowList entry to get wrong.
	if _, ok := env["KCP_TOKENS"]; ok {
		t.Fatalf("a pod with no service account was given tokens: %q", env["KCP_TOKENS"])
	}
}

// ponytail: a pod's readiness probe resolves the pod's own name, and the pod
// cannot be in the informer cache before it has started, so its own entry has to
// come from its own declarations. Without this every pod sits not-ready forever.
func TestAPodAlwaysHasItsOwnNameInTheTable(t *testing.T) {
	p := withPaths(&Provider{opts: Options{ServiceDomain: kcp.DefaultServiceDomain}, reader: podTableReader(t)}, "root:alice")
	env := p.podEnv(context.Background(),
		Ref{LogicalCluster: "root:alice", Namespace: "default", Name: "pds"},
		&v1alpha1.DenoPodTemplate{Env: map[string]string{"SERVICE_ARGS": `["--port","2583","--hostname","127.0.0.1"]`}},
	)
	var table map[string]string
	if err := json.Unmarshal([]byte(env["KCP_DNS_TABLE"]), &table); err != nil {
		t.Fatalf("the injected table is not JSON: %v", err)
	}
	if got := table["pds.default.alice.svc.kcp.local"]; got != "127.0.0.1:2583" {
		t.Fatalf("the pod's own entry = %q, want 127.0.0.1:2583 (table %v)", got, table)
	}
}

// ponytail: the manifest names the probe as kcpdns plus a name and a path, and
// the provider expands it, because a manifest cannot know where the shim was
// materialised and a run directory is not where apply.sh runs.
func TestTheProviderExpandsAKcpdnsProbeIntoRealPaths(t *testing.T) {
	p := withPaths(&Provider{opts: Options{ServiceDomain: kcp.DefaultServiceDomain}, dnsShim: "/runs/.kcpdns/shim.ts", dnsProbe: "/runs/.kcpdns/probe.ts"}, "root:alice")
	got := p.probeCommand([]string{"kcpdns", "plc.default.global.svc.kcp.local", "/health"})
	if len(got) == 0 {
		t.Fatal("a kcpdns probe expanded to nothing")
	}
	joined := ""
	for _, a := range got {
		joined += a + " "
	}
	// The permissions are part of the expansion: a probe without them dies on the
	// shim's first Deno.env.get, which an operator sees as a service that never
	// becomes ready.
	for _, want := range []string{"deno", "run", "--allow-env=", "--allow-net", "--preload", "/runs/.kcpdns/shim.ts", "/runs/.kcpdns/probe.ts", "plc.default.global.svc.kcp.local", "/health"} {
		if !strings.Contains(joined, want) {
			t.Fatalf("expanded probe %q is missing %q", joined, want)
		}
	}
}

// A provider assembled by hand has no resolver until first use; concurrent
// workloads must not each build one.
func TestServiceResolverBuildsOnceUnderConcurrency(t *testing.T) {
	p := withPaths(&Provider{opts: Options{ServiceDomain: kcp.DefaultServiceDomain}}, "root:alice")
	const callers = 32
	start := make(chan struct{})
	resolvers := make([]*servicenames.Resolver, callers)
	var wg sync.WaitGroup
	wg.Add(callers)
	for i := 0; i < callers; i++ {
		go func(i int) {
			defer wg.Done()
			<-start
			resolvers[i] = p.serviceResolver()
		}(i)
	}
	close(start)
	wg.Wait()
	for i := 1; i < callers; i++ {
		if resolvers[i] != resolvers[0] {
			t.Fatal("concurrent callers built more than one resolver")
		}
	}
}

func TestAnOrdinaryProbeIsLeftAlone(t *testing.T) {
	p := &Provider{opts: Options{ServiceDomain: kcp.DefaultServiceDomain}}
	got := p.probeCommand([]string{"true"})
	if len(got) != 1 || got[0] != "true" {
		t.Fatalf("a probe that is not kcpdns was rewritten: %v", got)
	}
}

// A pod with no service account gets no tokens, so its shim reports an
// unresolved name rather than guessing; and with no shim materialised the probe
// form cannot be expanded at all, which has to degrade instead of panicking.
func TestAKcpdnsProbeWithoutAShimDegrades(t *testing.T) {
	p := &Provider{opts: Options{ServiceDomain: kcp.DefaultServiceDomain}}
	if got := p.probeCommand([]string{"kcpdns", "x.default.alice.svc.kcp.local", "/"}); got != nil {
		t.Fatalf("expected no command without a shim, got %v", got)
	}
}
