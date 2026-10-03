package provider

import (
	"context"
	"encoding/json"
	"fmt"
	"sync"

	"github.com/publicdomainrelay/kcp-libs/common/kcp"
	"k8s.io/apimachinery/pkg/runtime/schema"
)

var logicalClusterGV = schema.GroupVersion{Group: "core.kcp.io", Version: "v1alpha1"}

// ClusterPath resolves a logical cluster's ID to its path, which is what a
// service name should be built from.
//
// Objects carry only the ID: the kcp.io/cluster annotation holds
// `2j35eh7jjhsc8ny9`, not `root:alice`, so a name built straight from what the
// informer hands over reads pds.default.2j35eh7jjhsc8ny9.svc.kcp.local. The path
// lives on the workspace's own LogicalCluster object, under the kcp.io/path
// annotation, and the ID is a valid cluster identifier in a request path, so the
// object is reachable without already knowing the path.
//
// Decoded from raw bytes rather than into a typed object: core.kcp.io is not in
// this client's scheme, and it does not need to be for one annotation.
func (r *Registry) ClusterPath(ctx context.Context, id string) (string, error) {
	c, err := r.resource(id, logicalClusterGV)
	if err != nil {
		return "", err
	}
	raw, err := c.Get().Resource("logicalclusters").Name("cluster").Do(ctx).Raw()
	if err != nil {
		return "", fmt.Errorf("provider: read logical cluster %s: %w", id, err)
	}
	var obj struct {
		Metadata struct {
			Annotations map[string]string `json:"annotations"`
		} `json:"metadata"`
	}
	if err := json.Unmarshal(raw, &obj); err != nil {
		return "", fmt.Errorf("provider: parse logical cluster %s: %w", id, err)
	}
	path := obj.Metadata.Annotations[kcp.PathAnnotation]
	if path == "" {
		return "", fmt.Errorf("provider: logical cluster %s carries no %s annotation", id, kcp.PathAnnotation)
	}
	return path, nil
}

// clusterPaths caches the ID-to-path resolution. It is asked once per workspace
// per address table, and a miss costs one request, so a plain map under a mutex
// is enough; a failure is cached as empty to avoid retrying it on every
// reconcile, since a workspace whose path cannot be read is not going to start
// working mid-loop.
type clusterPaths struct {
	mu   sync.Mutex
	byID map[string]string
}

func newClusterPaths() *clusterPaths {
	return &clusterPaths{byID: map[string]string{}}
}

func (c *clusterPaths) lookup(r *Registry, ctx context.Context, id string) string {
	c.mu.Lock()
	if path, seen := c.byID[id]; seen {
		c.mu.Unlock()
		return path
	}
	c.mu.Unlock()

	path := ""
	if r != nil {
		if resolved, err := r.ClusterPath(ctx, id); err == nil {
			path = resolved
		}
	}
	c.mu.Lock()
	c.byID[id] = path
	c.mu.Unlock()
	return path
}
