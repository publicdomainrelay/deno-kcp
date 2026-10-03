package integration

import (
	"fmt"
	"os"
	"path/filepath"
	"sort"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/runtime"
	"sigs.k8s.io/yaml"

	"github.com/johnandersen777/deno-kcp/api/v1alpha1"
)

type exampleObject interface {
	metav1.Object

	runtime.Object
}

type example struct {
	File string

	Kind string

	Resource string

	Schema string
}

func exampleFiles() []example {
	return []example{
		{File: "deno-job.yaml", Kind: "DenoJob", Resource: "denojobs", Schema: "denojob-apiresourceschema.yaml"},
		{File: "deno-pod.yaml", Kind: "DenoPod", Resource: "denopods", Schema: "denopod-apiresourceschema.yaml"},
		{File: "deno-run.yaml", Kind: "DenoRun", Resource: "denoruns", Schema: "denorun-apiresourceschema.yaml"},
		{File: "native-fire-pod.yaml", Kind: "DenoPod", Resource: "denopods", Schema: "denopod-apiresourceschema.yaml"},
		{File: "openbao.yaml", Kind: "OpenBao", Resource: "openbaos", Schema: "openbao-apiresourceschema.yaml"},
		{File: "openbao-tls-pod.yaml", Kind: "DenoPod", Resource: "denopods", Schema: "denopod-apiresourceschema.yaml"},
		{File: "policy-workflow-run.yaml", Kind: "PolicyWorkflowRun", Resource: "policyworkflowruns", Schema: "policyworkflowrun-apiresourceschema.yaml"},
		{File: "policyengine.yaml", Kind: "PolicyEngine", Resource: "policyengines", Schema: "policyengine-apiresourceschema.yaml"},
		{File: "policyworkflowpod.yaml", Kind: "PolicyWorkflowPod", Resource: "policyworkflowpods", Schema: "policyworkflowpod-apiresourceschema.yaml"},
		{File: "runtrigger.yaml", Kind: "RunTrigger", Resource: "runtriggers", Schema: "runtrigger-apiresourceschema.yaml"},
	}
}

func exampleByName(file string) (example, bool) {
	for _, e := range exampleFiles() {
		if e.File == file {
			return e, true
		}
	}
	return example{}, false
}

func localExamples() string {
	return filepath.Join(repoRoot(), "deploy", "examples")
}

func repoRoot() string {
	dir, err := os.Getwd()
	if err != nil {
		return "."
	}
	for {
		if _, err := os.Stat(filepath.Join(dir, "go.mod")); err == nil {
			return dir
		}
		parent := filepath.Dir(dir)
		if parent == dir {
			return dir
		}
		dir = parent
	}
}

func loadExampleFile(file string) ([]byte, error) {
	path := filepath.Join(localExamples(), file)
	body, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}
	return body, nil
}

func decodeExample(body []byte, kind string) (exampleObject, error) {
	switch kind {
	case "DenoJob":
		var v v1alpha1.DenoJob
		if err := yaml.Unmarshal(body, &v); err != nil {
			return nil, err
		}
		return &v, nil
	case "DenoPod":
		var v v1alpha1.DenoPod
		if err := yaml.Unmarshal(body, &v); err != nil {
			return nil, err
		}
		return &v, nil
	case "DenoRun":
		var v v1alpha1.DenoRun
		if err := yaml.Unmarshal(body, &v); err != nil {
			return nil, err
		}
		return &v, nil
	case "PolicyEngine":
		var v v1alpha1.PolicyEngine
		if err := yaml.Unmarshal(body, &v); err != nil {
			return nil, err
		}
		return &v, nil
	case "PolicyWorkflowPod":
		var v v1alpha1.PolicyWorkflowPod
		if err := yaml.Unmarshal(body, &v); err != nil {
			return nil, err
		}
		return &v, nil
	case "OpenBao":
		var v v1alpha1.OpenBao
		if err := yaml.Unmarshal(body, &v); err != nil {
			return nil, err
		}
		return &v, nil
	case "PolicyWorkflowRun":
		var v v1alpha1.PolicyWorkflowRun
		if err := yaml.Unmarshal(body, &v); err != nil {
			return nil, err
		}
		return &v, nil
	case "RunTrigger":
		var v v1alpha1.RunTrigger
		if err := yaml.Unmarshal(body, &v); err != nil {
			return nil, err
		}
		return &v, nil
	}
	return nil, fmt.Errorf("no api/v1alpha1 type for kind %q", kind)
}

func loadExample(file string) (exampleObject, error) {
	e, ok := exampleByName(file)
	if !ok {
		return nil, fmt.Errorf("%s is not a registered example", file)
	}
	body, err := loadExampleFile(e.File)
	if err != nil {
		return nil, err
	}
	return decodeExample(body, e.Kind)
}

func exampleFilesOnDisk() ([]string, error) {
	entries, err := os.ReadDir(localExamples())
	if err != nil {
		return nil, err
	}
	var out []string
	for _, entry := range entries {
		if entry.IsDir() || filepath.Ext(entry.Name()) != ".yaml" {
			continue
		}
		out = append(out, entry.Name())
	}
	sort.Strings(out)
	return out, nil
}
