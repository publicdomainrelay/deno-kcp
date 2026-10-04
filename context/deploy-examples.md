# Context: deploy-examples

Repository: `deno-kcp`

This context exists so the deploy/examples directory and the test-side registry that describes it are specified as one unit rather than as an untracked pile of YAML. The examples are the smoke-test fixtures for every custom resource the operator ships, so the specification pins three things at once: which ten manifests are present, which Kind/resource/schema each one maps to, and the invariant that the on-disk listing and the in-code listing stay in step. Anything that adds, renames or removes an example breaks the pairing, and the requirements below make that breakage explicit instead of silent.

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
