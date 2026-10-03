package provider

import (
	"context"
	"encoding/json"
	"fmt"

	apierrors "k8s.io/apimachinery/pkg/api/errors"
	"k8s.io/apimachinery/pkg/types"

	"github.com/johnandersen777/deno-kcp/api/v1alpha1"
)

func (r *Registry) ReadOpenBao(ctx context.Context, ref Ref) (*v1alpha1.OpenBao, error) {
	c, err := r.deno(ctx, ref.LogicalCluster)
	if err != nil {
		return nil, err
	}
	var obj v1alpha1.OpenBao
	if err := c.Get().Namespace(ref.Namespace).Resource("openbaos").Name(ref.Name).Do(ctx).Into(&obj); err != nil {
		return nil, fmt.Errorf("provider: read openbao %s in %s: %w", ref.Name, ref.LogicalCluster, err)
	}
	return &obj, nil
}

// ListOpenBaos answers the OpenBao objects in one namespace, straight from the
// API rather than from the informer cache. A workload's certificate is issued
// from the object this returns, and the cache is a cache: it is filled per
// virtual workspace and can hold one cluster's objects and not another's, which
// is the wrong answer to give a pod that is starting.
func (r *Registry) ListOpenBaos(ctx context.Context, logicalCluster, namespace string) ([]v1alpha1.OpenBao, error) {
	c, err := r.deno(ctx, logicalCluster)
	if err != nil {
		return nil, err
	}
	var list v1alpha1.OpenBaoList
	if err := c.Get().Namespace(namespace).Resource("openbaos").Do(ctx).Into(&list); err != nil {
		return nil, fmt.Errorf("provider: list openbaos in %s/%s: %w", logicalCluster, namespace, err)
	}
	return list.Items, nil
}

func (r *Registry) WriteOpenBaoStatus(ctx context.Context, ref Ref, st v1alpha1.OpenBaoStatus) error {
	c, err := r.deno(ctx, ref.LogicalCluster)
	if err != nil {
		return err
	}
	body, err := openBaoStatusPatch(st)
	if err != nil {
		return err
	}
	if body, err = withResourceVersion(body, ref.ResourceVersion); err != nil {
		return err
	}
	if err := c.Patch(types.MergePatchType).SubResource("status").Namespace(ref.Namespace).Resource("openbaos").
		Name(ref.Name).Body(body).Do(ctx).Into(&v1alpha1.OpenBao{}); err != nil {
		return fmt.Errorf("provider: write openbao status for %s in %s: %w", ref.Name, ref.LogicalCluster, err)
	}
	return nil
}

func (r *Registry) DeleteOpenBao(ctx context.Context, ref Ref) error {
	c, err := r.deno(ctx, ref.LogicalCluster)
	if err != nil {
		return err
	}
	if err := c.Delete().Namespace(ref.Namespace).Resource("openbaos").Name(ref.Name).
		Body([]byte(`{"propagationPolicy":"Background"}`)).Do(ctx).Error(); err != nil {
		if apierrors.IsNotFound(err) {
			return nil
		}
		return fmt.Errorf("provider: delete openbao %s in %s: %w", ref.Name, ref.LogicalCluster, err)
	}
	return nil
}

func (r *Registry) RemoveOpenBaoFinalizer(ctx context.Context, ref Ref) error {
	c, err := r.deno(ctx, ref.LogicalCluster)
	if err != nil {
		return err
	}
	var obj v1alpha1.OpenBao
	if err := c.Get().Namespace(ref.Namespace).Resource("openbaos").Name(ref.Name).Do(ctx).Into(&obj); err != nil {
		if apierrors.IsNotFound(err) {
			return nil
		}
		return fmt.Errorf("provider: reading openbao %s in %s to release its finalizer: %w", ref.Name, ref.LogicalCluster, err)
	}
	return patchFinalizers(ctx, c, "openbaos", ref.Namespace, ref.Name, obj.Finalizers, v1alpha1.FinalizerOpenBao)
}

func (r *Registry) WriteOpenBaoFinalizer(ctx context.Context, ref Ref, finalizers []string) error {
	c, err := r.deno(ctx, ref.LogicalCluster)
	if err != nil {
		return err
	}
	body, err := json.Marshal([]map[string]any{
		{"op": "add", "path": "/metadata/finalizers", "value": finalizers},
	})
	if err != nil {
		return fmt.Errorf("provider: adding the openbao finalizer to %s: %w", ref.Name, err)
	}
	if err := c.Patch(types.JSONPatchType).Namespace(ref.Namespace).Resource("openbaos").Name(ref.Name).
		Body(body).Do(ctx).Error(); err != nil {
		return fmt.Errorf("provider: adding the openbao finalizer to %s: %w", ref.Name, err)
	}
	return nil
}

func openBaoStatusPatch(st v1alpha1.OpenBaoStatus) ([]byte, error) {
	status := map[string]any{
		"namespace": st.Namespace,
		"serial":    st.Serial,
		"chain":     st.Chain,
		"ready":     st.Ready,
		"message":   st.Message,
	}
	if st.Conditions != nil {
		status["conditions"] = st.Conditions
	} else {
		status["conditions"] = nil
	}
	return json.Marshal(map[string]any{"status": status})
}
