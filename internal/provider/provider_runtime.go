package provider

import (
	"context"
	"sync"
	"time"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	k8stypes "k8s.io/apimachinery/pkg/types"

	"github.com/johnandersen777/deno-kcp/api/v1alpha1"
)

const JobRunLabel = "deno.computer/job"

const DefaultLivenessThreshold int32 = 3

const DefaultProbeTimeout = 5 * time.Second

// ponytail: coalesce non-essential job progress writes to one per cooldown window; creates, phase changes and terminal writes still go through immediately.
const jobStatusCooldown = 500 * time.Millisecond

type Runtime interface {
	Instances

	CreateRun(ctx context.Context, logicalCluster string, run *v1alpha1.DenoRun) error

	WriteRunStatus(ctx context.Context, ref Ref, st v1alpha1.DenoRunStatus) error

	DeleteRun(ctx context.Context, ref Ref) error

	RemoveRunFinalizer(ctx context.Context, ref Ref) error

	CreatePod(ctx context.Context, logicalCluster string, pod *v1alpha1.DenoPod) error

	WritePodStatus(ctx context.Context, ref Ref, st v1alpha1.DenoPodStatus) error

	DeletePod(ctx context.Context, ref Ref) error

	RemovePodFinalizer(ctx context.Context, ref Ref) error

	CreateJob(ctx context.Context, logicalCluster string, job *v1alpha1.DenoJob) error

	WriteJobStatus(ctx context.Context, ref Ref, st v1alpha1.DenoJobStatus) error

	DeleteJob(ctx context.Context, ref Ref) error

	WriteTriggerStatus(ctx context.Context, ref Ref, st v1alpha1.RunTriggerStatus) error

	ListOpenBaos(ctx context.Context, logicalCluster, namespace string) ([]v1alpha1.OpenBao, error)

	WriteOpenBaoStatus(ctx context.Context, ref Ref, st v1alpha1.OpenBaoStatus) error

	WriteOpenBaoFinalizer(ctx context.Context, ref Ref, finalizers []string) error

	RemoveOpenBaoFinalizer(ctx context.Context, ref Ref) error

	DeleteOpenBao(ctx context.Context, ref Ref) error

	WriteEngineStatus(ctx context.Context, ref Ref, st v1alpha1.PolicyEngineStatus) error

	DeleteEngine(ctx context.Context, ref Ref) error

	RemoveEngineFinalizer(ctx context.Context, ref Ref) error

	WriteWorkflowPodStatus(ctx context.Context, ref Ref, st v1alpha1.PolicyWorkflowPodStatus) error

	DeleteWorkflowPod(ctx context.Context, ref Ref) error

	CreateWorkflowRun(ctx context.Context, logicalCluster string, run *v1alpha1.PolicyWorkflowRun) error
}

type TokenMinter interface {
	MintServiceAccountToken(ctx context.Context, logicalCluster, namespace, name string, ttl time.Duration) (string, error)
}

var _ Runtime = (*Registry)(nil)

var _ TokenMinter = (*Registry)(nil)

type probeCounter struct {
	runID string

	failures int
}

type probeTracker struct {
	mu sync.Mutex

	liveness map[string]probeCounter
}

func newProbeTracker() *probeTracker {
	return &probeTracker{liveness: map[string]probeCounter{}}
}

func (t *probeTracker) livenessFailed(key, runID string, passed bool, threshold int32) bool {
	t.mu.Lock()
	defer t.mu.Unlock()
	c := t.liveness[key]
	if c.runID != runID {
		c = probeCounter{runID: runID}
	}
	if passed {
		c.failures = 0
	} else {
		c.failures++
	}
	t.liveness[key] = c
	if threshold <= 0 {
		threshold = DefaultLivenessThreshold
	}
	return int32(c.failures) >= threshold
}

func thresholdOf(probe *v1alpha1.ExecProbe) int32 {
	if probe.FailureThreshold != nil && *probe.FailureThreshold > 0 {
		return *probe.FailureThreshold
	}
	return DefaultLivenessThreshold
}

func ownerRef(kind, name string, uid k8stypes.UID) metav1.OwnerReference {
	controller := true
	block := true
	return metav1.OwnerReference{
		APIVersion:         v1alpha1.GroupVersion.String(),
		Kind:               kind,
		Name:               name,
		UID:                uid,
		Controller:         &controller,
		BlockOwnerDeletion: &block,
	}
}

func exitCodePtr(code int32) *int32 {
	c := code
	return &c
}
