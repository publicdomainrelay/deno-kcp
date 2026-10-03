package integration

import (
	"bytes"
	"context"
	"crypto/tls"
	"encoding/json"
	"fmt"
	"io"
	"log/slog"
	"net"
	"net/http"
	"os"
	"os/exec"
	"os/signal"
	"path/filepath"
	"strings"
	"sync"
	"syscall"
	"testing"
	"time"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	"k8s.io/apimachinery/pkg/runtime/schema"
	yamlutil "k8s.io/apimachinery/pkg/util/yaml"
	"k8s.io/client-go/dynamic"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"

	"github.com/johnandersen777/deno-kcp/api/v1alpha1"
	"github.com/johnandersen777/deno-kcp/internal/livegate"
	"github.com/johnandersen777/deno-kcp/internal/provider"
	"github.com/johnandersen777/deno-kcp/internal/runner"
)

const tenantWorkspace = "runtime"

const providerWorkspace = "deno-provider"

type process struct {
	cmd *exec.Cmd

	log *os.File

	once sync.Once
}

var spawned struct {
	mu sync.Mutex

	all []*process
}

func (p *process) kill() {
	p.once.Do(func() {
		spawned.mu.Lock()
		for i, q := range spawned.all {
			if q == p {
				spawned.all = append(spawned.all[:i], spawned.all[i+1:]...)
				break
			}
		}
		spawned.mu.Unlock()
		if p.cmd.Process != nil {
			_ = syscall.Kill(-p.cmd.Process.Pid, syscall.SIGKILL)
		}
		_ = p.cmd.Wait()
		if p.log != nil {
			_ = p.log.Close()
		}
	})
}

func killSpawned() int {
	spawned.mu.Lock()
	all := make([]*process, len(spawned.all))
	copy(all, spawned.all)
	spawned.mu.Unlock()
	for _, p := range all {
		p.kill()
	}
	return len(all)
}

func TestMain(m *testing.M) {
	signals := make(chan os.Signal, 1)
	signal.Notify(signals, syscall.SIGINT, syscall.SIGTERM)
	done := make(chan struct{})
	go func() {
		select {
		case sig := <-signals:
			n := killSpawned()
			fmt.Fprintf(os.Stderr, "integration: %v: killed %d spawned process group(s)\n", sig, n)
			os.Exit(130)
		case <-done:
		}
	}()
	code := m.Run()
	close(done)
	killSpawned()
	os.Exit(code)
}

func startProcess(t *testing.T, logPath, bin string, args ...string) *exec.Cmd {
	t.Helper()
	log, err := os.Create(logPath)
	if err != nil {
		t.Fatal(err)
	}
	cmd := exec.Command(bin, args...)
	cmd.Stdout = log
	cmd.Stderr = log
	cmd.SysProcAttr = &syscall.SysProcAttr{Setpgid: true}
	if err := cmd.Start(); err != nil {
		_ = log.Close()
		t.Fatalf("starting %s: %v", bin, err)
	}
	p := &process{cmd: cmd, log: log}
	spawned.mu.Lock()
	spawned.all = append(spawned.all, p)
	spawned.mu.Unlock()
	t.Cleanup(p.kill)
	return cmd
}

func requireLive(t *testing.T) {
	t.Helper()
	if !livegate.RequiresLive() {
		t.Skip("set DENO_KCP_REQUIRE_LIVE=1 and provide kcp, kine, deno and a sibling policy-engine checkout")
	}
}

func requireBinary(t *testing.T, name string) {
	t.Helper()
	if _, err := exec.LookPath(name); err != nil {
		livegate.Require(t, "required binary %q not found: %v", name, err)
	}
}

func envOr(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}

func freePort(t *testing.T) int {
	t.Helper()
	l, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatal(err)
	}
	defer l.Close()
	return l.Addr().(*net.TCPAddr).Port
}

func tcpOpen(addr string) bool {
	c, err := net.DialTimeout("tcp", addr, time.Second)
	if err != nil {
		return false
	}
	_ = c.Close()
	return true
}

func httpOK(url string) bool {
	client := &http.Client{Timeout: 2 * time.Second}
	client.Transport = &http.Transport{TLSClientConfig: &tls.Config{InsecureSkipVerify: true}}
	resp, err := client.Get(url)
	if err != nil {
		return false
	}
	defer resp.Body.Close()
	return resp.StatusCode < 400
}

func caData(t *testing.T, data []byte, file string) []byte {
	t.Helper()
	if len(data) > 0 {
		return data
	}
	if file == "" {
		return nil
	}
	body, err := os.ReadFile(filepath.Clean(file))
	if err != nil {
		t.Fatal(err)
	}
	return body
}

func tail(path string, lines int) string {
	body, err := os.ReadFile(path)
	if err != nil {
		return ""
	}
	all := strings.Split(strings.TrimRight(string(body), "\n"), "\n")
	if len(all) > lines {
		all = all[len(all)-lines:]
	}
	return strings.Join(all, "\n")
}

func baseHost(host string) string {
	if i := strings.Index(host, provider.ApiPathPrefix); i >= 0 {
		return host[:i]
	}
	return strings.TrimSuffix(host, "/")
}

func policyEngineDir(t *testing.T) string {
	t.Helper()
	if v := os.Getenv("POLICY_ENGINE_DIR"); v != "" {
		return v
	}
	rel := filepath.Join("policy-engine", "lib", "policy-engine-server-gha-lite")
	dir := repoRoot()
	for i := 0; i < 6; i++ {
		candidate := filepath.Join(dir, rel)
		if _, err := os.Stat(filepath.Join(candidate, "main.ts")); err == nil {
			return candidate
		}
		parent := filepath.Dir(dir)
		if parent == dir {
			break
		}
		dir = parent
	}
	livegate.Require(t, "the policy engine was not found near %s; set POLICY_ENGINE_DIR", repoRoot())
	return ""
}

func bundledActionsDir(engineDir string) string {
	if v := os.Getenv("BUNDLED_ACTIONS_DIR"); v != "" {
		return v
	}
	return filepath.Clean(filepath.Join(engineDir, "..", "policies", "gha-lite", "bundled-actions"))
}

func requireDir(t *testing.T, what, dir, env string) {
	t.Helper()
	info, err := os.Stat(dir)
	if err != nil || !info.IsDir() {
		livegate.Require(t, "%s was not found at %s; set %s", what, dir, env)
	}
}

type bootstrapResource struct {
	gvr schema.GroupVersionResource

	namespaced bool
}

type resourceKey struct {
	apiVersion string

	kind string
}

var bootstrapResources = map[resourceKey]bootstrapResource{
	{"apis.kcp.io/v1alpha1", "APIResourceSchema"}: {
		gvr: schema.GroupVersionResource{Group: "apis.kcp.io", Version: "v1alpha1", Resource: "apiresourceschemas"},
	},
	{"apis.kcp.io/v1alpha2", "APIExport"}: {
		gvr: schema.GroupVersionResource{Group: "apis.kcp.io", Version: "v1alpha2", Resource: "apiexports"},
	},
	{"tenancy.kcp.io/v1alpha1", "Workspace"}: {
		gvr: schema.GroupVersionResource{Group: "tenancy.kcp.io", Version: "v1alpha1", Resource: "workspaces"},
	},
	{"tenancy.kcp.io/v1alpha1", "WorkspaceType"}: {
		gvr: schema.GroupVersionResource{Group: "tenancy.kcp.io", Version: "v1alpha1", Resource: "workspacetypes"},
	},
	{"v1", "ServiceAccount"}: {
		gvr:        schema.GroupVersionResource{Group: "", Version: "v1", Resource: "serviceaccounts"},
		namespaced: true,
	},
	{"rbac.authorization.k8s.io/v1", "ClusterRole"}: {
		gvr: schema.GroupVersionResource{Group: "rbac.authorization.k8s.io", Version: "v1", Resource: "clusterroles"},
	},
	{"rbac.authorization.k8s.io/v1", "ClusterRoleBinding"}: {
		gvr: schema.GroupVersionResource{Group: "rbac.authorization.k8s.io", Version: "v1", Resource: "clusterrolebindings"},
	},
}

var workspaceGVR = schema.GroupVersionResource{Group: "tenancy.kcp.io", Version: "v1alpha1", Resource: "workspaces"}

var apiExportGVR = schema.GroupVersionResource{Group: "apis.kcp.io", Version: "v1alpha2", Resource: "apiexports"}

var policyEngineGVR = schema.GroupVersionResource{Group: v1alpha1.GroupName, Version: v1alpha1.Version, Resource: "policyengines"}

type liveCluster struct {
	t *testing.T

	ctx context.Context

	cancel context.CancelFunc

	root string

	host string

	kubeconfig string

	tenant string

	rest *rest.Config

	registry *provider.Registry

	provider *provider.Provider

	clients map[string]dynamic.Interface

	openBaoAddr string

	openBaoToken string

	openBaoCACert []byte
}

func withOpenBao(vault baoServer) func(*liveCluster) {
	return func(c *liveCluster) {
		c.openBaoAddr = vault.address
		c.openBaoToken = vault.token
		c.openBaoCACert = vault.caCert()
	}
}

func startCluster(t *testing.T, options ...func(*liveCluster)) *liveCluster {
	t.Helper()
	requireBinary(t, envOr("KCP_BIN", "kcp"))
	requireBinary(t, envOr("KINE_BIN", "kine"))
	requireBinary(t, envOr("DENO_BIN", "deno"))
	engineDir := policyEngineDir(t)
	actionsDir := bundledActionsDir(engineDir)
	requireDir(t, "the policy engine", engineDir, "POLICY_ENGINE_DIR")
	requireDir(t, "the bundled policy actions", actionsDir, "BUNDLED_ACTIONS_DIR")

	root := t.TempDir()
	ctx, cancel := context.WithCancel(context.Background())
	kubeconfig := filepath.Join(root, "admin.kubeconfig")
	c := &liveCluster{
		t:          t,
		ctx:        ctx,
		cancel:     cancel,
		root:       root,
		kubeconfig: kubeconfig,
		tenant:     provider.RootWorkspace + ":" + tenantWorkspace,
		clients:    map[string]dynamic.Interface{},
	}
	for _, option := range options {
		option(c)
	}
	kinePort := freePort(t)
	kcpPort := freePort(t)
	kineEndpoint := fmt.Sprintf("http://127.0.0.1:%d", kinePort)

	startProcess(t, filepath.Join(root, "kine.log"), envOr("KINE_BIN", "kine"),
		"--endpoint", "sqlite://"+filepath.Join(root, "kine.db"),
		"--listen-address", fmt.Sprintf("127.0.0.1:%d", kinePort),
		"--metrics-bind-address=0")
	c.expect("kine to listen", 30*time.Second, func() bool { return tcpOpen(fmt.Sprintf("127.0.0.1:%d", kinePort)) })

	startProcess(t, filepath.Join(root, "kcp.log"), envOr("KCP_BIN", "kcp"),
		"start",
		"--root-directory="+root,
		"--etcd-servers="+kineEndpoint,
		"--bind-address=127.0.0.1",
		"--secure-port="+fmt.Sprint(kcpPort),
		"--feature-gates=WorkspaceMounts=true")
	c.expect("kcp to serve /readyz", 180*time.Second, func() bool {
		if _, err := os.Stat(kubeconfig); err != nil {
			return false
		}
		return httpOK(fmt.Sprintf("https://127.0.0.1:%d/readyz", kcpPort))
	})

	restCfg, err := clientcmd.BuildConfigFromFlags("", kubeconfig)
	if err != nil {
		cancel()
		t.Fatal(err)
	}
	c.rest = restCfg
	c.host = baseHost(restCfg.Host)
	if c.host == "" {
		cancel()
		t.Fatalf("the kubeconfig at %s names no server", kubeconfig)
	}

	c.bootstrap()
	c.startProvider(t, engineDir, actionsDir)
	t.Cleanup(func() {
		cancel()
		if c.provider != nil {
			_ = c.provider.Close()
		}
	})
	return c
}

func (c *liveCluster) client(logicalCluster string) dynamic.Interface {
	if d, ok := c.clients[logicalCluster]; ok {
		return d
	}
	cfg := rest.CopyConfig(c.rest)
	cfg.Host = c.host + provider.ApiPathPrefix + logicalCluster
	cfg.ContentType = "application/json"
	cfg.AcceptContentTypes = "application/json"
	d, err := dynamic.NewForConfig(cfg)
	if err != nil {
		c.t.Fatalf("building a client for %s: %v", logicalCluster, err)
	}
	c.clients[logicalCluster] = d
	return d
}

func decodeDocs(t *testing.T, body []byte) []map[string]any {
	t.Helper()
	dec := yamlutil.NewYAMLOrJSONDecoder(bytes.NewReader(body), 4096)
	var out []map[string]any
	for {
		var doc map[string]any
		err := dec.Decode(&doc)
		if err == io.EOF {
			break
		}
		if err != nil {
			t.Fatalf("decoding a manifest document: %v", err)
		}
		if len(doc) == 0 {
			continue
		}
		out = append(out, doc)
	}
	return out
}

func (c *liveCluster) createDoc(logicalCluster string, doc map[string]any) {
	c.t.Helper()
	apiVersion, _ := doc["apiVersion"].(string)
	kind, _ := doc["kind"].(string)
	res, ok := bootstrapResources[resourceKey{apiVersion: apiVersion, kind: kind}]
	if !ok {
		c.t.Fatalf("no client for the bootstrap kind %s %s", apiVersion, kind)
	}
	obj := &unstructured.Unstructured{Object: doc}
	client := c.client(logicalCluster).Resource(res.gvr)
	var err error
	if res.namespaced {
		namespace := "default"
		if ns, found, _ := unstructured.NestedString(doc, "metadata", "namespace"); found && ns != "" {
			namespace = ns
		}
		_, err = client.Namespace(namespace).Create(c.ctx, obj, metav1.CreateOptions{})
	} else {
		_, err = client.Create(c.ctx, obj, metav1.CreateOptions{})
	}
	if err != nil {
		c.t.Fatalf("creating %s %s in %s: %v", kind, obj.GetName(), logicalCluster, err)
	}
}

func (c *liveCluster) createExampleDoc(logicalCluster string, e example, doc map[string]any) {
	c.t.Helper()
	gvr := schema.GroupVersionResource{Group: v1alpha1.GroupName, Version: v1alpha1.Version, Resource: e.Resource}
	obj := &unstructured.Unstructured{Object: doc}
	namespace := "default"
	if ns, found, _ := unstructured.NestedString(doc, "metadata", "namespace"); found && ns != "" {
		namespace = ns
	}
	if _, err := c.client(logicalCluster).Resource(gvr).Namespace(namespace).Create(c.ctx, obj, metav1.CreateOptions{}); err != nil {
		c.t.Fatalf("creating %s %s in %s: %v", e.Kind, obj.GetName(), logicalCluster, err)
	}
}

func (c *liveCluster) createDocs(logicalCluster string, body []byte) {
	c.t.Helper()
	for _, doc := range decodeDocs(c.t, body) {
		c.createDoc(logicalCluster, doc)
	}
}

func (c *liveCluster) applyDeployFile(logicalCluster, name string) {
	c.t.Helper()
	body, err := os.ReadFile(filepath.Join(repoRoot(), "deploy", name))
	if err != nil {
		c.t.Fatal(err)
	}
	c.createDocs(logicalCluster, body)
}

func (c *liveCluster) expect(what string, timeout time.Duration, ok func() bool) {
	c.t.Helper()
	deadline := time.Now().Add(timeout)
	for time.Now().Before(deadline) {
		if ok() {
			return
		}
		time.Sleep(300 * time.Millisecond)
	}
	c.t.Fatalf("timed out after %s waiting for %s\nkcp.log:\n%s\nprovider.log:\n%s",
		timeout, what, tail(filepath.Join(c.root, "kcp.log"), 40), tail(filepath.Join(c.root, "provider.log"), 40))
}

func (c *liveCluster) get(logicalCluster string, gvr schema.GroupVersionResource, namespace, name string) *unstructured.Unstructured {
	c.t.Helper()
	client := c.client(logicalCluster).Resource(gvr)
	var (
		obj *unstructured.Unstructured
		err error
	)
	if namespace == "" {
		obj, err = client.Get(c.ctx, name, metav1.GetOptions{})
	} else {
		obj, err = client.Namespace(namespace).Get(c.ctx, name, metav1.GetOptions{})
	}
	if err != nil {
		return nil
	}
	return obj
}

func (c *liveCluster) workspacePhase(logicalCluster, name string) string {
	obj := c.get(logicalCluster, workspaceGVR, "", name)
	if obj == nil {
		return ""
	}
	phase, _, _ := unstructured.NestedString(obj.Object, "status", "phase")
	return phase
}

// ponytail: the namespace is a parameter rather than a constant because this checks both cluster-scoped resources (an APIExport in the provider workspace, which must pass "") and the namespaced kinds. Passing default for a cluster-scoped resource makes the get malformed and the wait time out with no useful message.
func (c *liveCluster) conditionTrue(logicalCluster string, gvr schema.GroupVersionResource, namespace, name, condition string) bool {
	obj := c.get(logicalCluster, gvr, namespace, name)
	if obj == nil {
		return false
	}
	conditions, _, _ := unstructured.NestedSlice(obj.Object, "status", "conditions")
	for _, entry := range conditions {
		m, ok := entry.(map[string]any)
		if !ok {
			continue
		}
		if m["type"] == condition && m["status"] == "True" {
			return true
		}
	}
	return false
}

func (c *liveCluster) bootstrap() {
	c.t.Helper()
	c.createDocs(provider.RootWorkspace, workspaceDoc(providerWorkspace, "universal"))
	c.expect("provider workspace Ready", 60*time.Second, func() bool {
		return c.workspacePhase(provider.RootWorkspace, providerWorkspace) == "Ready"
	})

	for _, name := range []string{
		"policyworkflowrun-apiresourceschema.yaml",
		"denopod-apiresourceschema.yaml",
		"denorun-apiresourceschema.yaml",
		"denojob-apiresourceschema.yaml",
		"runtrigger-apiresourceschema.yaml",
		"policyengine-apiresourceschema.yaml",
		"policyworkflowpod-apiresourceschema.yaml",
		"openbao-apiresourceschema.yaml",
	} {
		c.applyDeployFile(provider.RootWorkspace+":"+providerWorkspace, name)
	}
	c.applyDeployFile(provider.RootWorkspace+":"+providerWorkspace, "policyworkflowrun-apiexport.yaml")
	c.applyDeployFile(provider.RootWorkspace+":"+providerWorkspace, "denoruntime-apiexport.yaml")
	c.applyDeployFile(provider.RootWorkspace, "workspacetype-workflow.yaml")
	c.applyDeployFile(provider.RootWorkspace, "workspacetype-denoruntime.yaml")

	for _, export := range []string{"policyworkflowruns", "denoruntime"} {
		export := export
		c.expect("apiexport "+export+" IdentityValid", 60*time.Second, func() bool {
			return c.conditionTrue(provider.RootWorkspace+":"+providerWorkspace, apiExportGVR, "", export, "IdentityValid")
		})
	}

	c.createDocs(provider.RootWorkspace, workspaceDoc(tenantWorkspace, "denoruntime"))
	c.expect("tenant API bound", 60*time.Second, func() bool {
		_, err := c.client(c.tenant).Resource(policyEngineGVR).List(c.ctx, metav1.ListOptions{})
		return err == nil
	})
	c.createDocs(c.tenant, readerRBAC)
	c.createDocs(c.tenant, fireRBAC)
}

func (c *liveCluster) startProvider(t *testing.T, engineDir, actionsDir string) {
	t.Helper()
	registry, err := provider.NewRegistry(provider.RegistryOptions{Host: c.rest.Host, RestConfig: c.rest})
	if err != nil {
		t.Fatal(err)
	}
	logFile, err := os.Create(filepath.Join(c.root, "provider.log"))
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { _ = logFile.Close() })
	podRunner, err := runner.NewExecPod(runner.ExecPodOptions{
		DenoBin: envOr("DENO_BIN", "deno"),
		RunsDir: filepath.Join(c.root, "pods"),
		Timeout: 2 * time.Minute,
		CAData:  caData(t, c.rest.CAData, c.rest.CAFile),
	})
	if err != nil {
		t.Fatal(err)
	}
	engineRunner, err := runner.NewExecEngine(runner.ExecEngineOptions{
		DenoBin:   envOr("DENO_BIN", "deno"),
		ServerDir: engineDir,
		RunsDir:   filepath.Join(c.root, "engines"),
	})
	if err != nil {
		t.Fatal(err)
	}
	p, err := provider.New(provider.Options{
		Registry:          registry,
		PolicyClient:      provider.NewHTTPPolicyClient(),
		Runtime:           registry,
		Minter:            registry,
		PodRunner:         podRunner,
		EngineRunner:      engineRunner,
		Host:              c.rest.Host,
		RestConfig:        c.rest,
		TokenTTL:          time.Hour,
		BundledActionsDir: actionsDir,
		WriteStatus:       true,
		OpenBaoAddress:    c.openBaoAddr,
		OpenBaoToken:      c.openBaoToken,
		OpenBaoCACert:     c.openBaoCACert,
		Log:               slog.New(slog.NewTextHandler(logFile, nil)),
	})
	if err != nil {
		t.Fatal(err)
	}
	c.registry = registry
	c.provider = p
	go func() {
		if err := p.Run(c.ctx); err != nil {
			t.Logf("provider loop stopped: %v", err)
		}
	}()
}

// ponytail: every typed accessor reads through this, so the namespace lives here rather than in each of them. The examples all sit in default; a test that needs another namespace builds its own Ref.
func (c *liveCluster) ref(name string) provider.Ref {
	return provider.Ref{LogicalCluster: c.tenant, Namespace: "default", Name: name}
}

func (c *liveCluster) engine(name string) *v1alpha1.PolicyEngine {
	engine, err := c.registry.ReadEngine(c.ctx, c.ref(name))
	if err != nil {
		return nil
	}
	return engine
}

func (c *liveCluster) workflowPod(name string) *v1alpha1.PolicyWorkflowPod {
	pod, err := c.registry.ReadWorkflowPod(c.ctx, c.ref(name))
	if err != nil {
		return nil
	}
	return pod
}

func (c *liveCluster) pod(name string) *v1alpha1.DenoPod {
	pod, err := c.registry.ReadPod(c.ctx, c.ref(name))
	if err != nil {
		return nil
	}
	return pod
}

func (c *liveCluster) job(name string) *v1alpha1.DenoJob {
	job, err := c.registry.ReadJob(c.ctx, c.ref(name))
	if err != nil {
		return nil
	}
	return job
}

func (c *liveCluster) run(name string) *v1alpha1.DenoRun {
	run, err := c.registry.ReadRun(c.ctx, c.ref(name))
	if err != nil {
		return nil
	}
	return run
}

func (c *liveCluster) openBao(name string) *v1alpha1.OpenBao {
	obj, err := c.registry.ReadOpenBao(c.ctx, c.ref(name))
	if err != nil {
		return nil
	}
	return obj
}

func (c *liveCluster) trigger(name string) *v1alpha1.RunTrigger {
	tr, err := c.registry.ReadTrigger(c.ctx, c.ref(name))
	if err != nil {
		return nil
	}
	return tr
}

func (c *liveCluster) workflowRuns() []v1alpha1.PolicyWorkflowRun {
	runs, err := c.registry.ListWorkflowRuns(c.ctx, c.tenant)
	if err != nil {
		return nil
	}
	return runs
}

func (c *liveCluster) load(file string) (example, exampleObject) {
	c.t.Helper()
	e, ok := exampleByName(file)
	if !ok {
		c.t.Fatalf("%s is not a registered example", file)
	}
	body, err := loadExampleFile(file)
	if err != nil {
		c.t.Fatal(err)
	}
	obj, err := decodeExample(body, e.Kind)
	if err != nil {
		c.t.Fatalf("decoding %s: %v", file, err)
	}
	return e, obj
}

func (c *liveCluster) create(e example, obj exampleObject) {
	c.t.Helper()
	switch v := obj.(type) {
	case *v1alpha1.DenoPod:
		if err := c.registry.CreatePod(c.ctx, c.tenant, v); err != nil {
			c.t.Fatalf("applying %s: %v", e.File, err)
		}
	case *v1alpha1.DenoRun:
		if err := c.registry.CreateRun(c.ctx, c.tenant, v); err != nil {
			c.t.Fatalf("applying %s: %v", e.File, err)
		}
	case *v1alpha1.DenoJob:
		if err := c.registry.CreateJob(c.ctx, c.tenant, v); err != nil {
			c.t.Fatalf("applying %s: %v", e.File, err)
		}
	case *v1alpha1.PolicyWorkflowRun:
		if err := c.registry.CreateWorkflowRun(c.ctx, c.tenant, v); err != nil {
			c.t.Fatalf("applying %s: %v", e.File, err)
		}
	default:
		body, err := json.Marshal(obj)
		if err != nil {
			c.t.Fatalf("encoding %s: %v", e.File, err)
		}
		var doc map[string]any
		if err := json.Unmarshal(body, &doc); err != nil {
			c.t.Fatalf("encoding %s: %v", e.File, err)
		}
		c.createExampleDoc(c.tenant, e, doc)
	}
}

func (c *liveCluster) apply(file string) exampleObject {
	c.t.Helper()
	e, obj := c.load(file)
	c.create(e, obj)
	return obj
}

func workspaceDoc(name, kind string) []byte {
	return []byte(fmt.Sprintf(`apiVersion: tenancy.kcp.io/v1alpha1
kind: Workspace
metadata:
  name: %s
spec:
  type:
    name: %s
    path: root
`, name, kind))
}

var readerRBAC = []byte(`apiVersion: v1
kind: ServiceAccount
metadata:
  name: deno-runner
  namespace: default
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: deno-runner-read
rules:
  - apiGroups: ["deno.computer"]
    resources: ["policyworkflowruns"]
    verbs: ["get", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: deno-runner-read
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: deno-runner-read
subjects:
  - kind: ServiceAccount
    name: deno-runner
    namespace: default
`)

var fireRBAC = []byte(`apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: deno-runner-fire
rules:
  - apiGroups: ["deno.computer"]
    resources: ["policyworkflowruns"]
    verbs: ["get", "list", "create"]
  - apiGroups: ["deno.computer"]
    resources: ["policyworkflowpods"]
    verbs: ["get", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: deno-runner-fire
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: deno-runner-fire
subjects:
  - kind: ServiceAccount
    name: deno-runner
    namespace: default
`)
