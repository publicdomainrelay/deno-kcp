package provider

import (
	"context"
	"encoding/json"

	"github.com/johnandersen777/deno-kcp/api/v1alpha1"
)

func (r *Registry) ReadOpenBao(ctx context.Context, ref Ref) (*v1alpha1.OpenBao, error) {
	return r.openBaos.Get(ctx, ref)
}

// ListOpenBaos answers the OpenBao objects in one namespace, straight from the
// API rather than from the informer cache. A workload's certificate is issued
// from the object this returns, and the cache is a cache: it is filled per
// virtual workspace and can hold one cluster's objects and not another's, which
// is the wrong answer to give a pod that is starting.
func (r *Registry) ListOpenBaos(ctx context.Context, logicalCluster, namespace string) ([]v1alpha1.OpenBao, error) {
	return r.openBaos.ListIn(ctx, logicalCluster, namespace)
}

func (r *Registry) WriteOpenBaoStatus(ctx context.Context, ref Ref, st v1alpha1.OpenBaoStatus) error {
	body, err := openBaoStatusPatch(st)
	if err != nil {
		return err
	}
	return r.openBaos.PatchStatus(ctx, ref, body)
}

func (r *Registry) DeleteOpenBao(ctx context.Context, ref Ref) error {
	return r.openBaos.Delete(ctx, ref)
}

func (r *Registry) RemoveOpenBaoFinalizer(ctx context.Context, ref Ref) error {
	return r.openBaos.RemoveFinalizer(ctx, ref, v1alpha1.FinalizerOpenBao)
}

func (r *Registry) WriteOpenBaoFinalizer(ctx context.Context, ref Ref, finalizers []string) error {
	return r.openBaos.AddFinalizer(ctx, ref, finalizers)
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
