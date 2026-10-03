package provider

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"strings"

	kcpv1alpha1 "github.com/kcp-dev/sdk/apis/tenancy/v1alpha1"
	authenticationv1 "k8s.io/api/authentication/v1"
	corev1 "k8s.io/api/core/v1"
	apierrors "k8s.io/apimachinery/pkg/api/errors"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/runtime"
	"k8s.io/apimachinery/pkg/runtime/schema"
	"k8s.io/apimachinery/pkg/runtime/serializer"
	"k8s.io/apimachinery/pkg/types"
	"k8s.io/client-go/rest"

	"github.com/johnandersen777/deno-kcp/api/v1alpha1"
)

const RootWorkspace = "root"

const ApiPathPrefix = "/clusters/"

type Ref struct {
	LogicalCluster string

	Namespace string

	Name string

	ResourceVersion string
}

// ponytail: every composite key in this package goes through refKey, because the indexers build a key from an unstructured object and the cache reader builds one from a Ref, and the two must produce the same string or a lookup silently returns another object. Adding the namespace in one place is what keeps them in step.
func refKey(logicalCluster, namespace, name string) string {
	return logicalCluster + "/" + namespace + "/" + name
}

func (r Ref) key() string {
	return refKey(r.LogicalCluster, r.Namespace, r.Name)
}

func (r Ref) withResourceVersion(rv string) Ref {
	r.ResourceVersion = rv
	return r
}

type RegistryOptions struct {
	Host string

	RestConfig *rest.Config

	Transport http.RoundTripper
}

type Registry struct {
	cfg *rest.Config

	http *http.Client

	codecs runtime.NegotiatedSerializer
}

func NewRegistry(opts RegistryOptions) (*Registry, error) {
	if opts.Host == "" {
		return nil, errors.New("provider: Host is required")
	}
	cfg := &rest.Config{}
	if opts.RestConfig != nil {
		cfg = rest.CopyConfig(opts.RestConfig)
	}
	cfg.Host = baseHost(opts.Host)
	cfg.ContentType = "application/json"
	cfg.AcceptContentTypes = "application/json"
	if opts.Transport != nil {
		cfg.Transport = opts.Transport
	}
	httpClient, err := rest.HTTPClientFor(cfg)
	if err != nil {
		return nil, fmt.Errorf("provider: %w", err)
	}
	scheme, err := newScheme()
	if err != nil {
		return nil, err
	}
	return &Registry{
		cfg:    cfg,
		http:   httpClient,
		codecs: serializer.NewCodecFactory(scheme).WithoutConversion(),
	}, nil
}

func (r *Registry) Read(ctx context.Context, ref Ref) (*v1alpha1.PolicyWorkflowRun, error) {
	c, err := r.deno(ctx, ref.LogicalCluster)
	if err != nil {
		return nil, err
	}
	var run v1alpha1.PolicyWorkflowRun
	if err := c.Get().Namespace(ref.Namespace).Resource("policyworkflowruns").Name(ref.Name).Do(ctx).Into(&run); err != nil {
		return nil, fmt.Errorf("provider: read %s in %s: %w", ref.Name, ref.LogicalCluster, err)
	}
	return &run, nil
}

func (r *Registry) WriteStatus(ctx context.Context, ref Ref, st v1alpha1.PolicyWorkflowRunStatus) error {
	c, err := r.deno(ctx, ref.LogicalCluster)
	if err != nil {
		return err
	}
	body, err := statusPatch(st)
	if err != nil {
		return err
	}
	if body, err = withResourceVersion(body, ref.ResourceVersion); err != nil {
		return err
	}
	if err := c.Patch(types.MergePatchType).SubResource("status").Namespace(ref.Namespace).Resource("policyworkflowruns").
		Name(ref.Name).Body(body).Do(ctx).Into(&v1alpha1.PolicyWorkflowRun{}); err != nil {
		return fmt.Errorf("provider: write status for %s in %s: %w", ref.Name, ref.LogicalCluster, err)
	}
	return nil
}

func (r *Registry) Delete(ctx context.Context, ref Ref) error {
	c, err := r.deno(ctx, ref.LogicalCluster)
	if err != nil {
		return err
	}
	if err := c.Delete().Namespace(ref.Namespace).Resource("policyworkflowruns").Name(ref.Name).
		Body([]byte(`{"propagationPolicy":"Background"}`)).Do(ctx).Error(); err != nil {
		if apierrors.IsNotFound(err) {
			return nil
		}
		return fmt.Errorf("provider: delete %s in %s: %w", ref.Name, ref.LogicalCluster, err)
	}
	return nil
}

func (r *Registry) RemoveFinalizer(ctx context.Context, ref Ref) error {
	c, err := r.deno(ctx, ref.LogicalCluster)
	if err != nil {
		return err
	}
	var obj v1alpha1.PolicyWorkflowRun
	if err := c.Get().Namespace(ref.Namespace).Resource("policyworkflowruns").Name(ref.Name).Do(ctx).Into(&obj); err != nil {
		if apierrors.IsNotFound(err) {
			return nil
		}
		return fmt.Errorf("provider: reading %s in %s to release its finalizer: %w",
			ref.Name, ref.LogicalCluster, err)
	}
	return patchFinalizers(ctx, c, "policyworkflowruns", ref.Namespace, ref.Name, obj.Finalizers, v1alpha1.FinalizerPolicyWorkflowRun)
}

func (r *Registry) CreateWorkflowRun(ctx context.Context, logicalCluster string, run *v1alpha1.PolicyWorkflowRun) error {
	c, err := r.deno(ctx, logicalCluster)
	if err != nil {
		return err
	}
	if err := c.Post().Namespace(run.Namespace).Resource("policyworkflowruns").Body(run).Do(ctx).Into(&v1alpha1.PolicyWorkflowRun{}); err != nil {
		return fmt.Errorf("provider: create policyworkflowrun %s in %s: %w", run.Name, logicalCluster, err)
	}
	return nil
}

func (r *Registry) ListWorkflowRuns(ctx context.Context, logicalCluster string) ([]v1alpha1.PolicyWorkflowRun, error) {
	list, err := r.listWorkflowRuns(ctx, logicalCluster)
	if err != nil {
		return nil, err
	}
	return list.Items, nil
}

func (r *Registry) listWorkflowRuns(ctx context.Context, logicalCluster string) (*v1alpha1.PolicyWorkflowRunList, error) {
	c, err := r.deno(ctx, logicalCluster)
	if err != nil {
		return nil, err
	}
	var list v1alpha1.PolicyWorkflowRunList
	if err := c.Get().Resource("policyworkflowruns").Do(ctx).Into(&list); err != nil {
		return nil, err
	}
	return &list, nil
}

func (r *Registry) deno(ctx context.Context, logicalCluster string) (rest.Interface, error) {
	return r.resource(logicalCluster, v1alpha1.GroupVersion)
}

func (r *Registry) resource(logicalCluster string, gv schema.GroupVersion) (rest.Interface, error) {
	cfg := rest.CopyConfig(r.cfg)
	cfg.GroupVersion = &gv
	apiPath := ApiPathPrefix + logicalCluster + "/apis"
	if gv.Group == "" {
		apiPath = ApiPathPrefix + logicalCluster + "/api"
	}
	cfg.APIPath = apiPath
	cfg.NegotiatedSerializer = r.codecs
	c, err := rest.RESTClientForConfigAndClient(cfg, r.http)
	if err != nil {
		return nil, fmt.Errorf("provider: %s: %w", logicalCluster, err)
	}
	return c, nil
}

func newScheme() (*runtime.Scheme, error) {
	s := runtime.NewScheme()
	if err := v1alpha1.AddToScheme(s); err != nil {
		return nil, fmt.Errorf("provider: %w", err)
	}
	if err := kcpv1alpha1.AddToScheme(s); err != nil {
		return nil, fmt.Errorf("provider: %w", err)
	}
	if err := corev1.AddToScheme(s); err != nil {
		return nil, fmt.Errorf("provider: %w", err)
	}
	if err := authenticationv1.AddToScheme(s); err != nil {
		return nil, fmt.Errorf("provider: %w", err)
	}
	metav1.AddToGroupVersion(s, schema.GroupVersion{Version: "v1"})
	return s, nil
}

func baseHost(host string) string {
	host = strings.TrimSuffix(host, "/")
	if i := strings.Index(host, "/clusters/"); i >= 0 {
		host = host[:i]
	}
	return host
}

func withResourceVersion(body []byte, rv string) ([]byte, error) {
	if rv == "" {
		return body, nil
	}
	var m map[string]any
	if err := json.Unmarshal(body, &m); err != nil {
		return nil, fmt.Errorf("provider: status patch: %w", err)
	}
	m["metadata"] = map[string]any{"resourceVersion": rv}
	return json.Marshal(m)
}

func statusPatch(st v1alpha1.PolicyWorkflowRunStatus) ([]byte, error) {
	status := map[string]any{
		"phase":      string(st.Phase),
		"runID":      st.RunID,
		"active":     st.Active,
		"succeeded":  st.Succeeded,
		"failed":     st.Failed,
		"retries":    st.Retries,
		"exitStatus": st.ExitStatus,
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
