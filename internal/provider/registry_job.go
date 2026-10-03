package provider

import (
	"context"
	"encoding/json"
	"fmt"

	apierrors "k8s.io/apimachinery/pkg/api/errors"
	"k8s.io/apimachinery/pkg/types"

	"github.com/johnandersen777/deno-kcp/api/v1alpha1"
	"github.com/publicdomainrelay/kcp-libs/common/statuspatch"
)

func (r *Registry) ReadJob(ctx context.Context, ref Ref) (*v1alpha1.DenoJob, error) {
	c, err := r.deno(ctx, ref.LogicalCluster)
	if err != nil {
		return nil, err
	}
	var job v1alpha1.DenoJob
	if err := c.Get().Namespace(ref.Namespace).Resource("denojobs").Name(ref.Name).Do(ctx).Into(&job); err != nil {
		return nil, fmt.Errorf("provider: read job %s in %s: %w", ref.Name, ref.LogicalCluster, err)
	}
	return &job, nil
}

func (r *Registry) CreateJob(ctx context.Context, logicalCluster string, job *v1alpha1.DenoJob) error {
	c, err := r.deno(ctx, logicalCluster)
	if err != nil {
		return err
	}
	if err := c.Post().Namespace(job.Namespace).Resource("denojobs").Body(job).Do(ctx).Into(&v1alpha1.DenoJob{}); err != nil {
		return fmt.Errorf("provider: create job %s in %s: %w", job.Name, logicalCluster, err)
	}
	return nil
}

func (r *Registry) WriteJobStatus(ctx context.Context, ref Ref, st v1alpha1.DenoJobStatus) error {
	c, err := r.deno(ctx, ref.LogicalCluster)
	if err != nil {
		return err
	}
	body, err := jobStatusPatch(st)
	if err != nil {
		return err
	}
	if body, err = statuspatch.WithResourceVersion(body, ref.ResourceVersion); err != nil {
		return err
	}
	if err := c.Patch(types.MergePatchType).SubResource("status").Namespace(ref.Namespace).Resource("denojobs").
		Name(ref.Name).Body(body).Do(ctx).Into(&v1alpha1.DenoJob{}); err != nil {
		return fmt.Errorf("provider: write job status for %s in %s: %w", ref.Name, ref.LogicalCluster, err)
	}
	return nil
}

func (r *Registry) DeleteJob(ctx context.Context, ref Ref) error {
	c, err := r.deno(ctx, ref.LogicalCluster)
	if err != nil {
		return err
	}
	if err := c.Delete().Namespace(ref.Namespace).Resource("denojobs").Name(ref.Name).
		Body([]byte(`{"propagationPolicy":"Background"}`)).Do(ctx).Error(); err != nil {
		if apierrors.IsNotFound(err) {
			return nil
		}
		return fmt.Errorf("provider: delete job %s in %s: %w", ref.Name, ref.LogicalCluster, err)
	}
	return nil
}

func jobStatusPatch(st v1alpha1.DenoJobStatus) ([]byte, error) {
	status := map[string]any{
		"phase":     string(st.Phase),
		"runName":   st.RunName,
		"active":    st.Active,
		"ready":     st.Ready,
		"succeeded": st.Succeeded,
		"failed":    st.Failed,
		"retries":   st.Retries,
		"exitCode":  st.ExitCode,
	}
	if st.Runs != nil {
		status["runs"] = st.Runs
	} else {
		status["runs"] = nil
	}
	if st.StartTime != nil {
		status["startTime"] = st.StartTime
	} else {
		status["startTime"] = nil
	}
	if st.CompletionTime != nil {
		status["completionTime"] = st.CompletionTime
	} else {
		status["completionTime"] = nil
	}
	if st.Outputs != nil {
		status["outputs"] = st.Outputs
	} else {
		status["outputs"] = nil
	}
	if st.Conditions != nil {
		status["conditions"] = st.Conditions
	} else {
		status["conditions"] = nil
	}
	return json.Marshal(map[string]any{"status": status})
}
