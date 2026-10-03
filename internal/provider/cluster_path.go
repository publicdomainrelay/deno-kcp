package provider

import (
	"context"
)

// ClusterPath resolves a logical cluster's ID to its path, which is what a
// service name should be built from.
//
// Objects carry only the ID: the kcp.io/cluster annotation holds
// `2j35eh7jjhsc8ny9`, not `root:alice`, so a name built straight from what the
// informer hands over reads pds.default.2j35eh7jjhsc8ny9.svc.kcp.local. The path
// lives on the workspace's own LogicalCluster object, under the kcp.io/path
// annotation, and the ID is a valid cluster identifier in a request path, so the
// object is reachable without already knowing the path.
func (r *Registry) ClusterPath(ctx context.Context, id string) (string, error) {
	return r.store.ClusterPath(ctx, id)
}
