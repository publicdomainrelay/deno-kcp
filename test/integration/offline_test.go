package integration

import (
	"fmt"
	"os"
	"path/filepath"
	"reflect"
	"sort"
	"testing"

	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"

	"github.com/johnandersen777/deno-kcp/api/v1alpha1"
)

const workflowPodName = "open-policy-pod"

const engineName = "policy-engine"

const directRunName = "open-policy"

func TestEveryExampleDecodesFromDisk(t *testing.T) {
	for _, e := range exampleFiles() {
		e := e
		t.Run(e.File, func(t *testing.T) {
			body, err := loadExampleFile(e.File)
			if err != nil {
				t.Fatal(err)
			}
			if len(body) == 0 {
				t.Fatalf("%s is empty", e.File)
			}
			obj, err := decodeExample(body, e.Kind)
			if err != nil {
				t.Fatalf("decoding %s as %s: %v", e.File, e.Kind, err)
			}
			gvk := obj.GetObjectKind().GroupVersionKind()
			if gvk.Group != v1alpha1.GroupName || gvk.Version != v1alpha1.Version {
				t.Fatalf("%s declares apiVersion %q, want %q", e.File, gvk.GroupVersion().String(), v1alpha1.GroupVersion.String())
			}
			if gvk.Kind != e.Kind {
				t.Fatalf("%s declares kind %q, want %q", e.File, gvk.Kind, e.Kind)
			}
			if obj.GetName() == "" {
				t.Fatalf("%s declares no metadata.name", e.File)
			}
			if e.Resource == "" {
				t.Fatalf("%s has no resource in the suite's table", e.File)
			}
		})
	}
}

func TestExampleInventoryMatchesDisk(t *testing.T) {
	raw, err := exampleFilesOnDisk()
	if err != nil {
		t.Fatal(err)
	}
	skip := map[string]bool{}
	for _, file := range nonExamples {
		skip[file] = true
	}
	var disk []string
	for _, file := range raw {
		if skip[file] {
			continue
		}
		disk = append(disk, file)
	}
	var covered []string
	for _, e := range exampleFiles() {
		covered = append(covered, e.File)
	}
	sort.Strings(covered)
	if !reflect.DeepEqual(disk, covered) {
		t.Fatalf("deploy/examples holds %v, the suite covers %v", disk, covered)
	}
}

func TestExamplesAreWiredToEachOther(t *testing.T) {
	engine, err := loadExample("policyengine.yaml")
	if err != nil {
		t.Fatal(err)
	}
	workflowPod, err := loadExample("policyworkflowpod.yaml")
	if err != nil {
		t.Fatal(err)
	}
	firePod, err := loadExample("native-fire-pod.yaml")
	if err != nil {
		t.Fatal(err)
	}
	trigger, err := loadExample("runtrigger.yaml")
	if err != nil {
		t.Fatal(err)
	}
	directRun, err := loadExample("policy-workflow-run.yaml")
	if err != nil {
		t.Fatal(err)
	}

	if workflowPod.GetName() != workflowPodName {
		t.Fatalf("the workflow pod example is named %q, the chain expects %q", workflowPod.GetName(), workflowPodName)
	}
	if engine.GetName() != engineName {
		t.Fatalf("the engine example is named %q, the chain expects %q", engine.GetName(), engineName)
	}

	pod := workflowPod.(*v1alpha1.PolicyWorkflowPod)
	if pod.Spec.PolicyEngine != engine.GetName() {
		t.Fatalf("the workflow pod references engine %q, the engine example is %q", pod.Spec.PolicyEngine, engine.GetName())
	}

	fire := firePod.(*v1alpha1.DenoPod)
	if fire.Labels[v1alpha1.PolicyWorkflowPodLabel] != workflowPodName {
		t.Fatalf("the run creator pod carries label %s=%q, the workflow pod example is %q",
			v1alpha1.PolicyWorkflowPodLabel, fire.Labels[v1alpha1.PolicyWorkflowPodLabel], workflowPodName)
	}

	tr := trigger.(*v1alpha1.RunTrigger)
	if tr.Spec.PolicyWorkflowPod != workflowPodName {
		t.Fatalf("the trigger watches %q, the workflow pod example is %q", tr.Spec.PolicyWorkflowPod, workflowPodName)
	}

	run := directRun.(*v1alpha1.PolicyWorkflowRun)
	if run.Spec.EngineEndpoint == "" {
		t.Fatalf("%s carries no spec.engineEndpoint; the live tier substitutes the engine's live endpoint, so the file must keep the field", "policy-workflow-run.yaml")
	}
	if run.Spec.PolicyWorkflowPod != "" {
		t.Fatalf("%s sets spec.policyWorkflowPod=%q; it is the pod-independent direct-create example", "policy-workflow-run.yaml", run.Spec.PolicyWorkflowPod)
	}
	if run.GetName() != directRunName {
		t.Fatalf("the direct run example is named %q, the readers expect %q", run.GetName(), directRunName)
	}
	if len(run.Spec.Workflow.Raw) == 0 {
		t.Fatalf("%s carries no inline spec.workflow", "policy-workflow-run.yaml")
	}

	for _, file := range []string{"deno-pod.yaml", "deno-run.yaml", "deno-job.yaml"} {
		obj, err := loadExample(file)
		if err != nil {
			t.Fatal(err)
		}
		if got := workflowArg(t, obj); got != directRunName {
			t.Fatalf("%s sets POD_WORKFLOW=%q, the direct run example is named %q", file, got, directRunName)
		}
	}
}

func workflowArg(t *testing.T, obj exampleObject) string {
	t.Helper()
	switch v := obj.(type) {
	case *v1alpha1.DenoPod:
		return v.Spec.Env["POD_WORKFLOW"]
	case *v1alpha1.DenoRun:
		return v.Spec.Env["POD_WORKFLOW"]
	case *v1alpha1.DenoJob:
		return v.Spec.Template.Env["POD_WORKFLOW"]
	}
	t.Fatalf("no POD_WORKFLOW reader for %T", obj)
	return ""
}

func TestExamplesFitTheInstalledSchemas(t *testing.T) {
	for _, e := range exampleFiles() {
		e := e
		t.Run(e.File, func(t *testing.T) {
			body, err := loadExampleFile(e.File)
			if err != nil {
				t.Fatal(err)
			}
			doc := decodeDocs(t, body)[0]
			spec, ok := doc["spec"].(map[string]any)
			if !ok {
				t.Fatalf("%s declares no spec", e.File)
			}
			checkAgainstSchema(t, e.File, "spec", spec, schemaSpec(t, e.Schema))
		})
	}
}

func checkAgainstSchema(t *testing.T, file, path string, value any, node map[string]any) {
	t.Helper()
	if len(node) == 0 {
		t.Errorf("%s: the APIResourceSchema declares nothing under %s, so KCP would prune it", file, path)
		return
	}
	if preserve, _, _ := unstructured.NestedBool(node, "x-kubernetes-preserve-unknown-fields"); preserve {
		return
	}
	switch v := value.(type) {
	case map[string]any:
		props, _, _ := unstructured.NestedMap(node, "properties")
		if len(props) == 0 {
			additional, _, _ := unstructured.NestedMap(node, "additionalProperties")
			if len(additional) == 0 {
				t.Errorf("%s: the APIResourceSchema declares no properties under %s, so KCP would prune %s", file, path, path)
				return
			}
			for key, item := range v {
				checkAgainstSchema(t, file, path+"."+key, item, additional)
			}
			return
		}
		for key, item := range v {
			child, ok := props[key].(map[string]any)
			if !ok {
				t.Errorf("%s: the APIResourceSchema does not declare %s.%s, so KCP would prune it", file, path, key)
				continue
			}
			checkAgainstSchema(t, file, path+"."+key, item, child)
		}
	case []any:
		items, ok := node["items"].(map[string]any)
		if !ok {
			t.Errorf("%s: the APIResourceSchema declares no items under %s", file, path)
			return
		}
		for i, item := range v {
			checkAgainstSchema(t, file, fmt.Sprintf("%s[%d]", path, i), item, items)
		}
	}
}

func schemaSpec(t *testing.T, file string) map[string]any {
	t.Helper()
	docs := decodeDocs(t, deployFile(t, file))
	if len(docs) != 1 {
		t.Fatalf("deploy/%s holds %d documents, want 1", file, len(docs))
	}
	versions, found, _ := unstructured.NestedSlice(docs[0], "spec", "versions")
	if !found || len(versions) == 0 {
		t.Fatalf("deploy/%s declares no spec.versions", file)
	}
	version, ok := versions[0].(map[string]any)
	if !ok {
		t.Fatalf("deploy/%s declares a non-object spec.versions[0]", file)
	}
	schema, _, _ := unstructured.NestedMap(version, "schema", "properties")
	spec, ok := schema["spec"].(map[string]any)
	if !ok {
		t.Fatalf("deploy/%s declares no spec.versions[0].schema.properties.spec", file)
	}
	return spec
}

func deployFile(t *testing.T, name string) []byte {
	t.Helper()
	body, err := os.ReadFile(filepath.Join(repoRoot(), "deploy", name))
	if err != nil {
		t.Fatal(err)
	}
	return body
}

func TestAPIExportsNameDeclaredSchemas(t *testing.T) {
	declared := map[string]bool{}
	for _, e := range exampleFiles() {
		docs := decodeDocs(t, deployFile(t, e.Schema))
		name, _, _ := unstructured.NestedString(docs[0], "metadata", "name")
		declared[name] = true
	}
	for _, file := range []string{"policyworkflowrun-apiexport.yaml", "denoruntime-apiexport.yaml"} {
		docs := decodeDocs(t, deployFile(t, file))
		resources, found, _ := unstructured.NestedSlice(docs[0], "spec", "resources")
		if !found || len(resources) == 0 {
			t.Fatalf("deploy/%s declares no spec.resources", file)
		}
		for _, entry := range resources {
			m, ok := entry.(map[string]any)
			if !ok {
				t.Fatalf("deploy/%s declares a non-object resource entry", file)
			}
			schema, _ := m["schema"].(string)
			if !declared[schema] {
				t.Errorf("deploy/%s exports the schema %q, which no deploy/*-apiresourceschema.yaml declares", file, schema)
			}
			group, _ := m["group"].(string)
			if group != v1alpha1.GroupName {
				t.Errorf("deploy/%s exports the group %q, want %q", file, group, v1alpha1.GroupName)
			}
		}
	}
}
