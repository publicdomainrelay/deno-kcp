# Context: tools-open-architecture

Repository: `deno-kcp`

The context exists so that deno-kcp's architecture is a checked artifact rather than prose: arch.yaml states the repo's upstreams, kinds, boundaries, crossings, risks and reconcile passes, and validate.py is the gate that refuses a document whose ids, paths, symbols, boundary tree, crossing accounting or reconcile wiring do not hold together. It keeps the declared architecture in step with the Go source by checking kind names, resources, phases, conditions and status facts against the APIResourceSchema manifests and Go type files, and it keeps the document itself honest by rejecting duplicate YAML keys and schema nodes that lack descriptions.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:.tools/open-architecture/arch.yaml` file arch.yaml (.tools/open-architecture/arch.yaml)
- `file:.tools/open-architecture/validate.py` file validate.py (.tools/open-architecture/validate.py)
<!-- SPECD_MANAGED_END -->
