package policyworkflowpod

import (
	"context"
	"testing"
	"time"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/runtime"

	"github.com/johnandersen777/deno-kcp/api/v1alpha1"
)

var base = time.Date(2026, 9, 24, 12, 0, 0, 0, time.UTC)

func rawWorkflow() runtime.RawExtension {
	return runtime.RawExtension{Raw: []byte(`{"name":"x"}`)}
}

func pod(spec v1alpha1.PolicyWorkflowPodSpec, status v1alpha1.PolicyWorkflowPodStatus) v1alpha1.PolicyWorkflowPod {
	return v1alpha1.PolicyWorkflowPod{
		ObjectMeta: metav1.ObjectMeta{Name: "open-policy-pod", Generation: 1},
		Spec:       spec,
		Status:     status,
	}
}

func reconcile(t *testing.T, o Observed) Result {
	t.Helper()
	r := New(Options{Now: func() time.Time { return base }})
	res, err := r.Reconcile(context.Background(), o)
	if err != nil {
		t.Fatalf("Reconcile: %v", err)
	}
	return res
}

func TestPendingUntilEngineReady(t *testing.T) {
	res := reconcile(t, Observed{Pod: pod(v1alpha1.PolicyWorkflowPodSpec{Workflow: rawWorkflow()}, v1alpha1.PolicyWorkflowPodStatus{})})
	if res.Phase != v1alpha1.PolicyWorkflowPodPending {
		t.Fatalf("phase = %s, want Pending", res.Phase)
	}
}

func TestRunningWhenEngineReady(t *testing.T) {
	res := reconcile(t, Observed{
		Pod:            pod(v1alpha1.PolicyWorkflowPodSpec{Workflow: rawWorkflow()}, v1alpha1.PolicyWorkflowPodStatus{}),
		EngineReady:    true,
		EngineEndpoint: "http://127.0.0.1:5111",
	})
	if res.Phase != v1alpha1.PolicyWorkflowPodRunning {
		t.Fatalf("phase = %s, want Running", res.Phase)
	}
	if res.Endpoint != "http://127.0.0.1:5111" {
		t.Fatalf("endpoint=%q", res.Endpoint)
	}
}

func i32(v int32) *int32 { return &v }

func queueDrain(policy v1alpha1.ConcurrencyPolicy, maxConcurrent *int32, pending int) (started int, peakActive int, finished int) {
	active := 0
	queued := pending
	for queued > 0 {
		startable := 0
		for ahead := 0; ahead < queued; ahead++ {
			allowed, _, _ := QueueDecision(policy, maxConcurrent, int32(active), int32(ahead))
			if !allowed {
				break
			}
			startable++
		}
		if startable == 0 {
			break
		}
		active += startable
		queued -= startable
		started += startable
		if active > peakActive {
			peakActive = active
		}
		active--
		finished++
	}
	for active > 0 {
		active--
		finished++
	}
	return started, peakActive, finished
}

func TestForbidAdmitsOneThenQueues(t *testing.T) {
	allowed, reason, message := QueueDecision(v1alpha1.ConcurrencyForbid, nil, 1, 0)
	if allowed || reason != QueueReasonAtCapacity {
		t.Fatalf("allowed=%v reason=%q, want queued", allowed, reason)
	}
	if message == "" {
		t.Fatal("a queued run must carry a message")
	}
	if allowed, _, _ := QueueDecision(v1alpha1.ConcurrencyForbid, nil, 0, 0); !allowed {
		t.Fatal("Forbid should admit when nothing is active")
	}
}

func TestAllowWithoutMaxConcurrentIsUnlimited(t *testing.T) {
	allowed, reason, message := QueueDecision(v1alpha1.ConcurrencyAllow, nil, 100, 0)
	if !allowed || reason != "" || message != "" {
		t.Fatalf("allowed=%v reason=%q message=%q, want unlimited", allowed, reason, message)
	}
}

func TestQueuedMessageIsStableAcrossPasses(t *testing.T) {
	max := int32(3)
	_, _, first := QueueDecision(v1alpha1.ConcurrencyAllow, &max, 3, 0)
	for _, active := range []int32{3, 4, 9} {
		for _, ahead := range []int32{0, 1, 7} {
			_, _, message := QueueDecision(v1alpha1.ConcurrencyAllow, &max, active, ahead)
			if message != first {
				t.Fatalf("queued message changed with active=%d ahead=%d: %q vs %q",
					active, ahead, message, first)
			}
		}
	}
}

func TestQueueDrainNeverExceedsCapacity(t *testing.T) {
	cases := []struct {
		name string
		pol  v1alpha1.ConcurrencyPolicy
		max  *int32
		cap  int
	}{
		{"forbid", v1alpha1.ConcurrencyForbid, nil, 1},
		{"allow1", v1alpha1.ConcurrencyAllow, i32(1), 1},
		{"allow2", v1alpha1.ConcurrencyAllow, i32(2), 2},
		{"allow5", v1alpha1.ConcurrencyAllow, i32(5), 5},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			started, peak, finished := queueDrain(tc.pol, tc.max, 12)
			if started != 12 || finished != 12 {
				t.Fatalf("drained started=%d finished=%d of 12, want 12", started, finished)
			}
			if peak > tc.cap {
				t.Fatalf("peak active %d exceeded cap %d", peak, tc.cap)
			}
		})
	}
}

func TestEmptyPolicyDefaultsToForbid(t *testing.T) {
	if allowed, _, _ := QueueDecision("", nil, 1, 0); allowed {
		t.Fatal("an empty concurrency policy should default to Forbid")
	}
}

func i64(v int64) *int64 { return &v }

func TestRunTTLResolution(t *testing.T) {
	cases := []struct {
		name     string
		podTTL   *int64
		provider *int64
		want     *int64
	}{
		{"pod wins", i64(30), i64(3600), i64(30)},
		{"pod nil uses provider", nil, i64(3600), i64(3600)},
		{"both nil", nil, nil, nil},
		{"negative default", nil, i64(-1), nil},
		{"negative pod", i64(-5), i64(3600), nil},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			p := pod(v1alpha1.PolicyWorkflowPodSpec{RunTTLSecondsAfterFinished: tc.podTTL}, v1alpha1.PolicyWorkflowPodStatus{})
			got := RunTTL(&p, tc.provider)
			if (got == nil) != (tc.want == nil) {
				t.Fatalf("RunTTL = %v, want %v", got, tc.want)
			}
			if got != nil && *got != *tc.want {
				t.Fatalf("RunTTL = %d, want %d", *got, *tc.want)
			}
		})
	}
}

func TestRunTTLNilPodUsesProviderDefault(t *testing.T) {
	if got := RunTTL(nil, i64(600)); got == nil || *got != 600 {
		t.Fatalf("RunTTL(nil) = %v, want 600", got)
	}
}
