package provider

import (
	"context"
	"encoding/json"
	"fmt"

	apierrors "k8s.io/apimachinery/pkg/api/errors"
	"k8s.io/apimachinery/pkg/types"

	"github.com/johnandersen777/deno-kcp/api/v1alpha1"
)

func (r *Registry) ReadPod(ctx context.Context, ref Ref) (*v1alpha1.DenoPod, error) {
	c, err := r.deno(ctx, ref.LogicalCluster)
	if err != nil {
		return nil, err
	}
	var pod v1alpha1.DenoPod
	if err := c.Get().Namespace(ref.Namespace).Resource("denopods").Name(ref.Name).Do(ctx).Into(&pod); err != nil {
		return nil, fmt.Errorf("provider: read pod %s in %s: %w", ref.Name, ref.LogicalCluster, err)
	}
	return &pod, nil
}

func (r *Registry) CreatePod(ctx context.Context, logicalCluster string, pod *v1alpha1.DenoPod) error {
	c, err := r.deno(ctx, logicalCluster)
	if err != nil {
		return err
	}
	if err := c.Post().Namespace(pod.Namespace).Resource("denopods").Body(pod).Do(ctx).Into(&v1alpha1.DenoPod{}); err != nil {
		return fmt.Errorf("provider: create pod %s in %s: %w", pod.Name, logicalCluster, err)
	}
	return nil
}

func (r *Registry) WritePodStatus(ctx context.Context, ref Ref, st v1alpha1.DenoPodStatus) error {
	c, err := r.deno(ctx, ref.LogicalCluster)
	if err != nil {
		return err
	}
	body, err := podStatusPatch(st)
	if err != nil {
		return err
	}
	if body, err = withResourceVersion(body, ref.ResourceVersion); err != nil {
		return err
	}
	if err := c.Patch(types.MergePatchType).SubResource("status").Namespace(ref.Namespace).Resource("denopods").
		Name(ref.Name).Body(body).Do(ctx).Into(&v1alpha1.DenoPod{}); err != nil {
		return fmt.Errorf("provider: write pod status for %s in %s: %w", ref.Name, ref.LogicalCluster, err)
	}
	return nil
}

func (r *Registry) DeletePod(ctx context.Context, ref Ref) error {
	c, err := r.deno(ctx, ref.LogicalCluster)
	if err != nil {
		return err
	}
	if err := c.Delete().Namespace(ref.Namespace).Resource("denopods").Name(ref.Name).
		Body([]byte(`{"propagationPolicy":"Background"}`)).Do(ctx).Error(); err != nil {
		if apierrors.IsNotFound(err) {
			return nil
		}
		return fmt.Errorf("provider: delete pod %s in %s: %w", ref.Name, ref.LogicalCluster, err)
	}
	return nil
}

func (r *Registry) RemovePodFinalizer(ctx context.Context, ref Ref) error {
	c, err := r.deno(ctx, ref.LogicalCluster)
	if err != nil {
		return err
	}
	var obj v1alpha1.DenoPod
	if err := c.Get().Namespace(ref.Namespace).Resource("denopods").Name(ref.Name).Do(ctx).Into(&obj); err != nil {
		if apierrors.IsNotFound(err) {
			return nil
		}
		return fmt.Errorf("provider: reading pod %s in %s to release its finalizer: %w", ref.Name, ref.LogicalCluster, err)
	}
	return patchFinalizers(ctx, c, "denopods", ref.Namespace, ref.Name, obj.Finalizers, v1alpha1.FinalizerDenoPod)
}

func podStatusPatch(st v1alpha1.DenoPodStatus) ([]byte, error) {
	status := map[string]any{
		"phase":    string(st.Phase),
		"runID":    st.RunID,
		"restarts": st.Restarts,
		"message":  st.Message,
		"exitCode": st.ExitCode,
		"ready":    st.Ready,
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
