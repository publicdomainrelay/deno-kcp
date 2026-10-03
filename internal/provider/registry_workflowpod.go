package provider

import (
	"context"
	"encoding/json"
	"fmt"

	apierrors "k8s.io/apimachinery/pkg/api/errors"
	"k8s.io/apimachinery/pkg/types"

	"github.com/johnandersen777/deno-kcp/api/v1alpha1"
)

func (r *Registry) ReadWorkflowPod(ctx context.Context, ref Ref) (*v1alpha1.PolicyWorkflowPod, error) {
	c, err := r.deno(ctx, ref.LogicalCluster)
	if err != nil {
		return nil, err
	}
	var pod v1alpha1.PolicyWorkflowPod
	if err := c.Get().Namespace(ref.Namespace).Resource("policyworkflowpods").Name(ref.Name).Do(ctx).Into(&pod); err != nil {
		return nil, fmt.Errorf("provider: read workflow pod %s in %s: %w", ref.Name, ref.LogicalCluster, err)
	}
	return &pod, nil
}

func (r *Registry) WriteWorkflowPodStatus(ctx context.Context, ref Ref, st v1alpha1.PolicyWorkflowPodStatus) error {
	c, err := r.deno(ctx, ref.LogicalCluster)
	if err != nil {
		return err
	}
	body, err := workflowPodStatusPatch(st)
	if err != nil {
		return err
	}
	if body, err = withResourceVersion(body, ref.ResourceVersion); err != nil {
		return err
	}
	if err := c.Patch(types.MergePatchType).SubResource("status").Namespace(ref.Namespace).Resource("policyworkflowpods").
		Name(ref.Name).Body(body).Do(ctx).Into(&v1alpha1.PolicyWorkflowPod{}); err != nil {
		return fmt.Errorf("provider: write workflow pod status for %s in %s: %w", ref.Name, ref.LogicalCluster, err)
	}
	return nil
}

func (r *Registry) DeleteWorkflowPod(ctx context.Context, ref Ref) error {
	c, err := r.deno(ctx, ref.LogicalCluster)
	if err != nil {
		return err
	}
	if err := c.Delete().Namespace(ref.Namespace).Resource("policyworkflowpods").Name(ref.Name).
		Body([]byte(`{"propagationPolicy":"Background"}`)).Do(ctx).Error(); err != nil {
		if apierrors.IsNotFound(err) {
			return nil
		}
		return fmt.Errorf("provider: delete workflow pod %s in %s: %w", ref.Name, ref.LogicalCluster, err)
	}
	return nil
}

func workflowPodStatusPatch(st v1alpha1.PolicyWorkflowPodStatus) ([]byte, error) {
	status := map[string]any{
		"phase":    string(st.Phase),
		"endpoint": st.Endpoint,
		"active":   st.Active,
	}
	if st.Conditions != nil {
		status["conditions"] = st.Conditions
	} else {
		status["conditions"] = nil
	}
	return json.Marshal(map[string]any{"status": status})
}
