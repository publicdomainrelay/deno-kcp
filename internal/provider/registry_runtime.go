package provider

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	authenticationv1 "k8s.io/api/authentication/v1"
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/types"
	"k8s.io/client-go/rest"
)

const DefaultServiceAccountNamespace = "default"

func (r *Registry) MintServiceAccountToken(ctx context.Context, logicalCluster, namespace, name string, ttl time.Duration) (string, error) {
	if namespace == "" {
		namespace = DefaultServiceAccountNamespace
	}
	c, err := r.resource(logicalCluster, corev1.SchemeGroupVersion)
	if err != nil {
		return "", err
	}
	seconds := int64(ttl / time.Second)
	req := &authenticationv1.TokenRequest{
		TypeMeta: metav1.TypeMeta{
			APIVersion: authenticationv1.SchemeGroupVersion.String(),
			Kind:       "TokenRequest",
		},
		Spec: authenticationv1.TokenRequestSpec{
			Audiences:         []string{},
			ExpirationSeconds: &seconds,
		},
	}
	var out authenticationv1.TokenRequest
	if err := c.Post().Namespace(namespace).Resource("serviceaccounts").Name(name).
		SubResource("token").Body(req).Do(ctx).Into(&out); err != nil {
		return "", fmt.Errorf("provider: mint token for %s/%s in %s: %w", namespace, name, logicalCluster, err)
	}
	if out.Status.Token == "" {
		return "", fmt.Errorf("provider: the TokenRequest for %s/%s in %s returned no token", namespace, name, logicalCluster)
	}
	return out.Status.Token, nil
}

func patchFinalizers(ctx context.Context, c rest.Interface, resource, namespace, name string, current []string, dropped string) error {
	remaining := make([]string, 0, len(current))
	for _, f := range current {
		if f != dropped {
			remaining = append(remaining, f)
		}
	}
	if len(remaining) == len(current) {
		return nil
	}
	body, err := json.Marshal([]map[string]any{
		{"op": "test", "path": "/metadata/finalizers", "value": current},
		{"op": "add", "path": "/metadata/finalizers", "value": remaining},
	})
	if err != nil {
		return fmt.Errorf("provider: releasing the finalizer of %s %s: %w", resource, name, err)
	}
	if err := c.Patch(types.JSONPatchType).Namespace(namespace).Resource(resource).Name(name).
		Body(body).Do(ctx).Error(); err != nil {
		return fmt.Errorf("provider: releasing the finalizer of %s %s: %w", resource, name, err)
	}
	return nil
}
