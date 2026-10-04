package provider

import (
	"context"
	"io"
	"log/slog"
	"sync/atomic"
	"testing"
	"time"

	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	"k8s.io/client-go/util/workqueue"

	"github.com/johnandersen777/deno-kcp/api/v1alpha1"
	"github.com/publicdomainrelay/kcp-libs/common/kcp"
)

func runObject(kind, name, lc, phase string, labels map[string]string) *unstructured.Unstructured {
	meta := map[string]any{
		"name":        name,
		"annotations": map[string]any{kcp.ClusterAnnotation: lc},
	}
	if labels != nil {
		raw := map[string]any{}
		for k, v := range labels {
			raw[k] = v
		}
		meta["labels"] = raw
	}
	return &unstructured.Unstructured{Object: map[string]any{
		"apiVersion": "deno.computer/v1alpha1",
		"kind":       kind,
		"metadata":   meta,
		"status":     map[string]any{"phase": phase},
	}}
}

func policyRunObject(name, lc, phase string, labels map[string]string) *unstructured.Unstructured {
	return runObject("PolicyWorkflowRun", name, lc, phase, labels)
}

func podObject(name, ns, lc string) *unstructured.Unstructured {
	return &unstructured.Unstructured{Object: map[string]any{
		"apiVersion": "deno.computer/v1alpha1",
		"kind":       "DenoPod",
		"metadata": map[string]any{
			"name":        name,
			"namespace":   ns,
			"annotations": map[string]any{kcp.ClusterAnnotation: lc},
		},
	}}
}

func triggerObject(name, lc, pod string) *unstructured.Unstructured {
	return triggerObjectNS(name, lc, "", pod)
}

func triggerObjectNS(name, lc, ns, pod string) *unstructured.Unstructured {
	meta := map[string]any{
		"name":        name,
		"annotations": map[string]any{kcp.ClusterAnnotation: lc},
	}
	if ns != "" {
		meta["namespace"] = ns
	}
	return &unstructured.Unstructured{Object: map[string]any{
		"apiVersion": "deno.computer/v1alpha1",
		"kind":       "RunTrigger",
		"metadata":   meta,
		"spec":       map[string]any{"policyWorkflowPod": pod},
	}}
}

func triggerReader(t *testing.T, objects ...*unstructured.Unstructured) *cacheReader {
	t.Helper()
	reader := newCacheReader()
	for _, obj := range objects {
		reader.upsert(workTrigger, obj)
	}
	return reader
}

func newQueue(t *testing.T) workqueue.TypedRateLimitingInterface[workKey] {
	t.Helper()
	queue := workqueue.NewTypedRateLimitingQueue(workqueue.DefaultTypedControllerRateLimiter[workKey]())
	t.Cleanup(queue.ShutDown)
	return queue
}

func drainKeys(queue workqueue.TypedRateLimitingInterface[workKey]) []workKey {
	var out []workKey
	for queue.Len() > 0 {
		key, shutdown := queue.Get()
		if shutdown {
			break
		}
		out = append(out, key)
		queue.Done(key)
	}
	return out
}

func TestTheTriggerPodIndexFindsTheTriggersThatNameThePod(t *testing.T) {
	reader := triggerReader(t,
		triggerObject("on-policy-allow", "root:runtime", "open-policy-pod"),
		triggerObject("on-policy-deny", "root:runtime", "other-pod"),
		triggerObject("on-policy-elsewhere", "root:other", "open-policy-pod"),
	)
	got := reader.triggerNamesForPod("root:runtime", "", "open-policy-pod")
	if len(got) != 1 || got[0] != "on-policy-allow" {
		t.Fatalf("triggerNamesForPod = %v, want [on-policy-allow]", got)
	}
}

// ponytail: the guard for the failure mode a namespace introduces. Every index was keyed logical-cluster plus name, so two same-named objects in different namespaces shared one index key and cacheReader.get returned whichever the index held first, which reconciles the wrong object rather than failing.
func TestTriggersOfTheSameNameInDifferentNamespacesDoNotCollide(t *testing.T) {
	reader := triggerReader(t,
		triggerObjectNS("on-allow", "root:runtime", "team-a", "policy-pod"),
		triggerObjectNS("on-allow", "root:runtime", "team-b", "policy-pod"),
	)
	a := reader.triggerNamesForPod("root:runtime", "team-a", "policy-pod")
	b := reader.triggerNamesForPod("root:runtime", "team-b", "policy-pod")
	if len(a) != 1 || a[0] != "on-allow" {
		t.Fatalf("team-a triggers = %v, want [on-allow]", a)
	}
	if len(b) != 1 || b[0] != "on-allow" {
		t.Fatalf("team-b triggers = %v, want [on-allow]", b)
	}
	if other := reader.triggerNamesForPod("root:runtime", "team-c", "policy-pod"); len(other) != 0 {
		t.Fatalf("a namespace with no triggers returned %v, want none", other)
	}
}

func TestAPolicyRunReachingATerminalPhaseWakesTheTriggersOfItsPod(t *testing.T) {
	for _, phase := range []string{"Succeeded", "Failed", "Cancelled"} {
		phase := phase
		t.Run(phase, func(t *testing.T) {
			reader := triggerReader(t,
				triggerObject("on-policy-allow", "root:runtime", "open-policy-pod"),
				triggerObject("on-policy-other", "root:runtime", "another-pod"),
			)
			queue := newQueue(t)
			labels := map[string]string{v1alpha1.PolicyWorkflowPodLabel: "open-policy-pod"}
			enqueueWatchUpdate(workPolicyRun,
				policyRunObject("open-policy-pod-1", "root:runtime", "Running", labels),
				policyRunObject("open-policy-pod-1", "root:runtime", phase, labels), reader, queue)

			got := drainKeys(queue)
			want := workKey{kind: workTrigger, ref: Ref{LogicalCluster: "root:runtime", Name: "on-policy-allow"}}
			if len(got) != 2 || got[1] != want {
				t.Fatalf("queued keys = %v, want the run key then %v", got, want)
			}
		})
	}
}

func TestAPolicyRunThatIsNotTerminalDoesNotWakeTheTriggers(t *testing.T) {
	reader := triggerReader(t, triggerObject("on-policy-allow", "root:runtime", "open-policy-pod"))
	queue := newQueue(t)
	labels := map[string]string{v1alpha1.PolicyWorkflowPodLabel: "open-policy-pod"}
	enqueueWatchUpdate(workPolicyRun,
		policyRunObject("open-policy-pod-1", "root:runtime", "Pending", labels),
		policyRunObject("open-policy-pod-1", "root:runtime", "Running", labels), reader, queue)

	got := drainKeys(queue)
	if len(got) != 1 || got[0].kind != workPolicyRun {
		t.Fatalf("queued keys = %v, want only the policy run key", got)
	}
}

func TestATerminalPolicyRunAppearingWakesTheTriggersOfItsPod(t *testing.T) {
	reader := triggerReader(t, triggerObject("on-policy-allow", "root:runtime", "open-policy-pod"))
	queue := newQueue(t)
	labels := map[string]string{v1alpha1.PolicyWorkflowPodLabel: "open-policy-pod"}
	enqueueWatchObject(workPolicyRun, policyRunObject("open-policy-pod-1", "root:runtime", "Succeeded", labels), reader, queue)

	got := drainKeys(queue)
	if len(got) != 2 || got[1].kind != workTrigger {
		t.Fatalf("queued keys = %v, want the policy run key and the trigger key", got)
	}
}

func TestADenoRunNeverWakesATrigger(t *testing.T) {
	reader := triggerReader(t, triggerObject("on-policy-allow", "root:runtime", "open-policy-pod"))
	queue := newQueue(t)
	labels := map[string]string{v1alpha1.PolicyWorkflowPodLabel: "open-policy-pod"}
	child := runObject("DenoRun", "on-policy-allow-open-policy-pod-1-1", "root:runtime", "Succeeded", labels)
	enqueueWatchObject(workRun, child, reader, queue)
	enqueueWatchUpdate(workRun, runObject("DenoRun", child.GetName(), "root:runtime", "Running", labels), child, reader, queue)

	for _, key := range drainKeys(queue) {
		if key.kind == workTrigger {
			t.Fatalf("a DenoRun woke %v; the trigger watches PolicyWorkflowRuns", key)
		}
	}
}

func TestATriggerWithoutAPodIsNotWoken(t *testing.T) {
	reader := triggerReader(t, &unstructured.Unstructured{Object: map[string]any{
		"apiVersion": "deno.computer/v1alpha1",
		"kind":       "RunTrigger",
		"metadata": map[string]any{
			"name":        "no-pod",
			"annotations": map[string]any{kcp.ClusterAnnotation: "root:runtime"},
		},
		"spec": map[string]any{},
	}})
	queue := newQueue(t)
	labels := map[string]string{v1alpha1.PolicyWorkflowPodLabel: "open-policy-pod"}
	enqueueWatchObject(workPolicyRun, policyRunObject("open-policy-pod-1", "root:runtime", "Succeeded", labels), reader, queue)

	for _, key := range drainKeys(queue) {
		if key.kind == workTrigger {
			t.Fatalf("a trigger with no pod reference was woken: %v", key)
		}
	}
}

// ponytail: one wildcard informer serves every workspace, so root:alice and
// root:bob each hold a DenoPod named pds in namespace default. A cache keyed by
// namespace and name alone keeps one entry and evicts the other; this test
// fails then.
func TestTheWatchCacheKeepsSameNamedPodsFromDifferentWorkspaces(t *testing.T) {
	reader := newCacheReader()
	alice := podObject("pds", "default", "root:alice")
	bob := podObject("pds", "default", "root:bob")
	reader.upsert(workPod, alice)
	reader.upsert(workPod, bob)

	// A wildcard informer re-list adds every workspace's object again; neither
	// may displace the other.
	reader.upsert(workPod, alice)
	reader.upsert(workPod, bob)

	pods := reader.allPods()
	if len(pods) != 2 {
		t.Fatalf("allPods returned %d pods, want both workspaces' pds", len(pods))
	}
	seen := map[string]bool{}
	for _, p := range pods {
		seen[p.GetAnnotations()[kcp.ClusterAnnotation]] = true
	}
	if !seen["root:alice"] || !seen["root:bob"] {
		t.Fatalf("allPods clusters = %v, want root:alice and root:bob", seen)
	}

	gotAlice, err := reader.ReadPod(context.Background(), Ref{LogicalCluster: "root:alice", Namespace: "default", Name: "pds"})
	if err != nil {
		t.Fatalf("read root:alice pds: %v", err)
	}
	gotBob, err := reader.ReadPod(context.Background(), Ref{LogicalCluster: "root:bob", Namespace: "default", Name: "pds"})
	if err != nil {
		t.Fatalf("read root:bob pds: %v", err)
	}
	if lc := gotAlice.GetAnnotations()[kcp.ClusterAnnotation]; lc != "root:alice" {
		t.Fatalf("ReadPod(root:alice) returned the pod of %q", lc)
	}
	if lc := gotBob.GetAnnotations()[kcp.ClusterAnnotation]; lc != "root:bob" {
		t.Fatalf("ReadPod(root:bob) returned the pod of %q", lc)
	}
}

func quietProvider() *Provider {
	return &Provider{opts: Options{Log: slog.New(slog.NewTextHandler(io.Discard, nil))}}
}

// ponytail: an informer whose initial list never ends leaves its cache unsynced
// forever; a provider that waits on the first attempt without a deadline sits
// there reconciling nothing while looking healthy. This test fails -- by timing
// out -- against that provider.
func TestTheCacheSyncWaitRetriesWhenNoCacheSyncs(t *testing.T) {
	p := quietProvider()
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	var attempts atomic.Int32
	start := func(stop <-chan struct{}) ([]kindInformer, error) {
		if attempts.Add(1) == 2 {
			cancel()
		}
		return []kindInformer{{kind: workPod, synced: func() bool { return false }}}, nil
	}

	begin := time.Now()
	done := make(chan error, 1)
	go func() {
		_, _, err := p.syncWatchCaches(ctx, 40*time.Millisecond, 5*time.Millisecond, start)
		done <- err
	}()
	select {
	case err := <-done:
		if err != nil {
			t.Fatalf("syncWatchCaches: %v", err)
		}
	case <-time.After(2 * time.Second):
		// A provider that waits on its first attempt without a deadline blocks
		// here forever; this is the failure this test exists to catch.
		t.Fatal("the cache-sync wait never retried a stalled informer")
	}
	if got := attempts.Load(); got < 2 {
		t.Fatalf("a stalled cache sync started the informers %d time(s), want a retry", got)
	}
	if elapsed := time.Since(begin); elapsed > time.Second {
		t.Fatalf("the bounded wait blocked for %s, want a retry inside a second", elapsed)
	}
}

func TestTheCacheSyncWaitReturnsWithoutAnotherAttemptOnceSynced(t *testing.T) {
	p := quietProvider()
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	attempts := 0
	start := func(stop <-chan struct{}) ([]kindInformer, error) {
		attempts++
		return []kindInformer{
			{kind: workPod, synced: func() bool { return true }},
			{kind: workPolicyRun, synced: func() bool { return true }},
		}, nil
	}

	begin := time.Now()
	informers, stopWatch, err := p.syncWatchCaches(ctx, 30*time.Second, time.Second, start)
	if err != nil {
		t.Fatalf("syncWatchCaches: %v", err)
	}
	if stopWatch == nil {
		t.Fatal("a synced attempt returned no way to stop its informers")
	}
	defer stopWatch()
	if len(informers) != 2 {
		t.Fatalf("synced attempt returned %d informers, want both kinds", len(informers))
	}
	if attempts != 1 {
		t.Fatalf("a synced cache sync started the informers %d time(s), want one attempt", attempts)
	}
	if elapsed := time.Since(begin); elapsed > time.Second {
		t.Fatalf("a synced cache sync took %s to return, want promptly", elapsed)
	}
}
