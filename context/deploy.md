# Context: deploy

Repository: `deno-kcp`

This context exists so the deno.computer API surface can be installed into a local kcp instance as declarative YAML: the APIResourceSchemas are the single definition of each kind's spec and status, the APIExports are what tenant workspaces bind to, and the WorkspaceTypes are what gives a tenant workspace that binding by default. Tooling and scripts consume these files by path, so the file names, schema names, kind names, shortNames and phase enums are a contract and not decoration.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:deploy/denojob-apiresourceschema.yaml` file denojob-apiresourceschema.yaml (deploy/denojob-apiresourceschema.yaml)
- `file:deploy/denopod-apiresourceschema.yaml` file denopod-apiresourceschema.yaml (deploy/denopod-apiresourceschema.yaml)
- `file:deploy/denorun-apiresourceschema.yaml` file denorun-apiresourceschema.yaml (deploy/denorun-apiresourceschema.yaml)
- `file:deploy/denoruntime-apiexport.yaml` file denoruntime-apiexport.yaml (deploy/denoruntime-apiexport.yaml)
- `file:deploy/openbao-apiresourceschema.yaml` file openbao-apiresourceschema.yaml (deploy/openbao-apiresourceschema.yaml)
- `file:deploy/policyengine-apiresourceschema.yaml` file policyengine-apiresourceschema.yaml (deploy/policyengine-apiresourceschema.yaml)
- `file:deploy/policyworkflowpod-apiresourceschema.yaml` file policyworkflowpod-apiresourceschema.yaml (deploy/policyworkflowpod-apiresourceschema.yaml)
- `file:deploy/policyworkflowrun-apiexport.yaml` file policyworkflowrun-apiexport.yaml (deploy/policyworkflowrun-apiexport.yaml)
- `file:deploy/policyworkflowrun-apiresourceschema.yaml` file policyworkflowrun-apiresourceschema.yaml (deploy/policyworkflowrun-apiresourceschema.yaml)
- `file:deploy/runtrigger-apiresourceschema.yaml` file runtrigger-apiresourceschema.yaml (deploy/runtrigger-apiresourceschema.yaml)
- `file:deploy/workspacetype-denoruntime.yaml` file workspacetype-denoruntime.yaml (deploy/workspacetype-denoruntime.yaml)
- `file:deploy/workspacetype-workflow.yaml` file workspacetype-workflow.yaml (deploy/workspacetype-workflow.yaml)
<!-- SPECD_MANAGED_END -->
