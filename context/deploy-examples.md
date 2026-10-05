# Context: deploy-examples

Repository: `deno-kcp`

This context exists so the example manifests and the registry that describes them have a single written contract. The manifests are the only executable proof that each deno-kcp kind can be expressed as a Kubernetes object, and the registry is what lets the integration suite pair a manifest with its Kind, its plural Resource and its generated APIResourceSchema. Writing that pairing down makes drift detectable: a manifest added on disk without a registry entry, or a manifest whose kind stops matching the schema the registry names, is a spec violation rather than a silent gap in coverage.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:deploy/examples/deno-job.yaml` file deno-job.yaml (deploy/examples/deno-job.yaml)
- `file:deploy/examples/deno-pod.yaml` file deno-pod.yaml (deploy/examples/deno-pod.yaml)
- `file:deploy/examples/deno-run.yaml` file deno-run.yaml (deploy/examples/deno-run.yaml)
- `file:deploy/examples/native-fire-pod.yaml` file native-fire-pod.yaml (deploy/examples/native-fire-pod.yaml)
- `file:deploy/examples/openbao-tls-pod.yaml` file openbao-tls-pod.yaml (deploy/examples/openbao-tls-pod.yaml)
- `file:deploy/examples/openbao.yaml` file openbao.yaml (deploy/examples/openbao.yaml)
- `file:deploy/examples/policy-workflow-run.yaml` file policy-workflow-run.yaml (deploy/examples/policy-workflow-run.yaml)
- `file:deploy/examples/policyengine.yaml` file policyengine.yaml (deploy/examples/policyengine.yaml)
- `file:deploy/examples/policyworkflowpod.yaml` file policyworkflowpod.yaml (deploy/examples/policyworkflowpod.yaml)
- `file:deploy/examples/runtrigger.yaml` file runtrigger.yaml (deploy/examples/runtrigger.yaml)
<!-- SPECD_MANAGED_END -->
