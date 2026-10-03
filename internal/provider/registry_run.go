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

func (r *Registry) ListRuns(ctx context.Context, logicalCluster string) ([]v1alpha1.DenoRun, error) {
	c, err := r.deno(ctx, logicalCluster)
	if err != nil {
		return nil, err
	}
	var list v1alpha1.DenoRunList
	if err := c.Get().Resource("denoruns").Do(ctx).Into(&list); err != nil {
		return nil, err
	}
	return list.Items, nil
}

func (r *Registry) ReadRun(ctx context.Context, ref Ref) (*v1alpha1.DenoRun, error) {
	c, err := r.deno(ctx, ref.LogicalCluster)
	if err != nil {
		return nil, err
	}
	var run v1alpha1.DenoRun
	if err := c.Get().Namespace(ref.Namespace).Resource("denoruns").Name(ref.Name).Do(ctx).Into(&run); err != nil {
		return nil, fmt.Errorf("provider: read run %s in %s: %w", ref.Name, ref.LogicalCluster, err)
	}
	return &run, nil
}

func (r *Registry) CreateRun(ctx context.Context, logicalCluster string, run *v1alpha1.DenoRun) error {
	c, err := r.deno(ctx, logicalCluster)
	if err != nil {
		return err
	}
	if err := c.Post().Namespace(run.Namespace).Resource("denoruns").Body(run).Do(ctx).Into(&v1alpha1.DenoRun{}); err != nil {
		return fmt.Errorf("provider: create run %s in %s: %w", run.Name, logicalCluster, err)
	}
	return nil
}

func (r *Registry) WriteRunStatus(ctx context.Context, ref Ref, st v1alpha1.DenoRunStatus) error {
	c, err := r.deno(ctx, ref.LogicalCluster)
	if err != nil {
		return err
	}
	body, err := runStatusPatch(st)
	if err != nil {
		return err
	}
	if body, err = statuspatch.WithResourceVersion(body, ref.ResourceVersion); err != nil {
		return err
	}
	if err := c.Patch(types.MergePatchType).SubResource("status").Namespace(ref.Namespace).Resource("denoruns").
		Name(ref.Name).Body(body).Do(ctx).Into(&v1alpha1.DenoRun{}); err != nil {
		return fmt.Errorf("provider: write run status for %s in %s: %w", ref.Name, ref.LogicalCluster, err)
	}
	return nil
}

func (r *Registry) DeleteRun(ctx context.Context, ref Ref) error {
	c, err := r.deno(ctx, ref.LogicalCluster)
	if err != nil {
		return err
	}
	if err := c.Delete().Namespace(ref.Namespace).Resource("denoruns").Name(ref.Name).
		Body([]byte(`{"propagationPolicy":"Background"}`)).Do(ctx).Error(); err != nil {
		if apierrors.IsNotFound(err) {
			return nil
		}
		return fmt.Errorf("provider: delete run %s in %s: %w", ref.Name, ref.LogicalCluster, err)
	}
	return nil
}

func (r *Registry) RemoveRunFinalizer(ctx context.Context, ref Ref) error {
	c, err := r.deno(ctx, ref.LogicalCluster)
	if err != nil {
		return err
	}
	var obj v1alpha1.DenoRun
	if err := c.Get().Namespace(ref.Namespace).Resource("denoruns").Name(ref.Name).Do(ctx).Into(&obj); err != nil {
		if apierrors.IsNotFound(err) {
			return nil
		}
		return fmt.Errorf("provider: reading run %s in %s to release its finalizer: %w", ref.Name, ref.LogicalCluster, err)
	}
	return patchFinalizers(ctx, c, "denoruns", ref.Namespace, ref.Name, obj.Finalizers, v1alpha1.FinalizerDenoRun)
}

func (r *Registry) RemoveRunFinalizerKnown(ctx context.Context, ref Ref, finalizers []string) error {
	c, err := r.deno(ctx, ref.LogicalCluster)
	if err != nil {
		return err
	}
	return patchFinalizers(ctx, c, "denoruns", ref.Namespace, ref.Name, finalizers, v1alpha1.FinalizerDenoRun)
}

func runStatusPatch(st v1alpha1.DenoRunStatus) ([]byte, error) {
	status := map[string]any{
		"phase":    string(st.Phase),
		"runID":    st.RunID,
		"message":  st.Message,
		"exitCode": st.ExitCode,
		"retries":  st.Retries,
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
