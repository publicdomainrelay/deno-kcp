package provider

import (
	"context"
	"encoding/json"
	"fmt"

	apierrors "k8s.io/apimachinery/pkg/api/errors"
	"k8s.io/apimachinery/pkg/types"

	"github.com/johnandersen777/deno-kcp/api/v1alpha1"
)

func (r *Registry) ReadEngine(ctx context.Context, ref Ref) (*v1alpha1.PolicyEngine, error) {
	c, err := r.deno(ctx, ref.LogicalCluster)
	if err != nil {
		return nil, err
	}
	var engine v1alpha1.PolicyEngine
	if err := c.Get().Namespace(ref.Namespace).Resource("policyengines").Name(ref.Name).Do(ctx).Into(&engine); err != nil {
		return nil, fmt.Errorf("provider: read engine %s in %s: %w", ref.Name, ref.LogicalCluster, err)
	}
	return &engine, nil
}

func (r *Registry) WriteEngineStatus(ctx context.Context, ref Ref, st v1alpha1.PolicyEngineStatus) error {
	c, err := r.deno(ctx, ref.LogicalCluster)
	if err != nil {
		return err
	}
	body, err := engineStatusPatch(st)
	if err != nil {
		return err
	}
	if body, err = withResourceVersion(body, ref.ResourceVersion); err != nil {
		return err
	}
	if err := c.Patch(types.MergePatchType).SubResource("status").Namespace(ref.Namespace).Resource("policyengines").
		Name(ref.Name).Body(body).Do(ctx).Into(&v1alpha1.PolicyEngine{}); err != nil {
		return fmt.Errorf("provider: write engine status for %s in %s: %w", ref.Name, ref.LogicalCluster, err)
	}
	return nil
}

func (r *Registry) DeleteEngine(ctx context.Context, ref Ref) error {
	c, err := r.deno(ctx, ref.LogicalCluster)
	if err != nil {
		return err
	}
	if err := c.Delete().Namespace(ref.Namespace).Resource("policyengines").Name(ref.Name).
		Body([]byte(`{"propagationPolicy":"Background"}`)).Do(ctx).Error(); err != nil {
		if apierrors.IsNotFound(err) {
			return nil
		}
		return fmt.Errorf("provider: delete engine %s in %s: %w", ref.Name, ref.LogicalCluster, err)
	}
	return nil
}

func (r *Registry) RemoveEngineFinalizer(ctx context.Context, ref Ref) error {
	c, err := r.deno(ctx, ref.LogicalCluster)
	if err != nil {
		return err
	}
	var obj v1alpha1.PolicyEngine
	if err := c.Get().Namespace(ref.Namespace).Resource("policyengines").Name(ref.Name).Do(ctx).Into(&obj); err != nil {
		if apierrors.IsNotFound(err) {
			return nil
		}
		return fmt.Errorf("provider: reading engine %s in %s to release its finalizer: %w", ref.Name, ref.LogicalCluster, err)
	}
	return patchFinalizers(ctx, c, "policyengines", ref.Namespace, ref.Name, obj.Finalizers, v1alpha1.FinalizerPolicyEngine)
}

func engineStatusPatch(st v1alpha1.PolicyEngineStatus) ([]byte, error) {
	status := map[string]any{
		"phase":    string(st.Phase),
		"runID":    st.RunID,
		"endpoint": st.Endpoint,
		"restarts": st.Restarts,
		"ready":    st.Ready,
		"message":  st.Message,
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
	if st.Conditions != nil {
		status["conditions"] = st.Conditions
	} else {
		status["conditions"] = nil
	}
	return json.Marshal(map[string]any{"status": status})
}
