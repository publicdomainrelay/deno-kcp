# Context: tools-open-architecture

Repository: `deno-kcp`

This context exists so the deno-kcp architecture is described as data rather than prose, and so that description can be checked. arch.yaml carries the architecture facts other documents and reviewers read (which upstreams run, which system contexts exist, which reconciler reads and writes which fields, which crossings lack a gate). validate.py exists to keep that data honest: it fails the build when an id is unresolved, a path or symbol does not exist in the repo, a system context tree has a cycle, a kind's phases or conditions disagree with its Go source, or a spec field is neither read by a reconciler nor declared unread.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:.tools/open-architecture/arch.yaml` file arch.yaml (.tools/open-architecture/arch.yaml)
- `file:.tools/open-architecture/validate.py` file validate.py (.tools/open-architecture/validate.py)
<!-- SPECD_MANAGED_END -->
