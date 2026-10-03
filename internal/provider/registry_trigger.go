package provider

import (
	"context"
	"encoding/json"
	"fmt"

	"k8s.io/apimachinery/pkg/types"

	"github.com/johnandersen777/deno-kcp/api/v1alpha1"
)

func (r *Registry) ReadTrigger(ctx context.Context, ref Ref) (*v1alpha1.RunTrigger, error) {
	c, err := r.deno(ctx, ref.LogicalCluster)
	if err != nil {
		return nil, err
	}
	var tr v1alpha1.RunTrigger
	if err := c.Get().Namespace(ref.Namespace).Resource("runtriggers").Name(ref.Name).Do(ctx).Into(&tr); err != nil {
		return nil, fmt.Errorf("provider: read trigger %s in %s: %w", ref.Name, ref.LogicalCluster, err)
	}
	return &tr, nil
}

func (r *Registry) WriteTriggerStatus(ctx context.Context, ref Ref, st v1alpha1.RunTriggerStatus) error {
	c, err := r.deno(ctx, ref.LogicalCluster)
	if err != nil {
		return err
	}
	body, err := triggerStatusPatch(st)
	if err != nil {
		return err
	}
	if body, err = withResourceVersion(body, ref.ResourceVersion); err != nil {
		return err
	}
	if err := c.Patch(types.MergePatchType).SubResource("status").Namespace(ref.Namespace).Resource("runtriggers").
		Name(ref.Name).Body(body).Do(ctx).Into(&v1alpha1.RunTrigger{}); err != nil {
		return fmt.Errorf("provider: write trigger status for %s in %s: %w", ref.Name, ref.LogicalCluster, err)
	}
	return nil
}

func triggerStatusPatch(st v1alpha1.RunTriggerStatus) ([]byte, error) {
	status := map[string]any{
		"phase":   string(st.Phase),
		"matched": st.Matched,
		"jobName": st.JobName,
		"lastRun": st.LastRun,
	}
	if st.Conditions != nil {
		status["conditions"] = st.Conditions
	} else {
		status["conditions"] = nil
	}
	return json.Marshal(map[string]any{"status": status})
}
