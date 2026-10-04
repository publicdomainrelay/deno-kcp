# Context: deploy-examples-atproto-market

Repository: `deno-kcp`

This context exists to pin down the deploy/examples/atproto/market example as an executable specification of what the kcp deno runtime must support: peer services that reach each other only by cluster-local name over TLS, with identity and certificates supplied from outside the pod, and a market bidder that reaches those same peers the same way. It is the reference topology that exercises workspace creation, per-workspace API bindings, per-workspace RBAC, per-workspace OpenBao certificate authority selection, the provider's virtual DNS table and shim, and the TLS leaf injection path, and it exists so that a regression in any of those surfaces shows up as a failing verifier pod rather than as an untested assumption in the provider. The example carries its own live acceptance, accept.sh, so that it is proven by bringing the whole topology up and reaching it, not only by decoding its manifests and fitting them to the schemas.

Two properties of the provider virtual DNS shape the example and are stated in its requirements. A workload address table is written once, when its pod starts, so a consumer that starts before its producer cannot reach it by cluster-local name: the shim can fall back to discovery only for fetch, and only when it holds a token for the producer workspace, which a pod started earlier does not. WebSocket construction is synchronous and cannot fall back at all, so the relay must start after the PDS whose commits it carries. The PDS is therefore applied first and announces itself to the relay through the relay listener address, which needs no table lookup, while the relay reaches the PDS by the PDS cluster-local name, which its later start puts in the table.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:deploy/examples/atproto/market/00-workspaces.yaml` file 00-workspaces.yaml (deploy/examples/atproto/market/00-workspaces.yaml)
- `file:deploy/examples/atproto/market/10-rbac.yaml` file 10-rbac.yaml (deploy/examples/atproto/market/10-rbac.yaml)
- `file:deploy/examples/atproto/market/15-openbao-alice.yaml` file 15-openbao-alice.yaml (deploy/examples/atproto/market/15-openbao-alice.yaml)
- `file:deploy/examples/atproto/market/15-openbao-bob.yaml` file 15-openbao-bob.yaml (deploy/examples/atproto/market/15-openbao-bob.yaml)
- `file:deploy/examples/atproto/market/15-openbao-global.yaml` file 15-openbao-global.yaml (deploy/examples/atproto/market/15-openbao-global.yaml)
- `file:deploy/examples/atproto/market/15-openbao-relay.yaml` file 15-openbao-relay.yaml (deploy/examples/atproto/market/15-openbao-relay.yaml)
- `file:deploy/examples/atproto/market/20-global-plc.yaml` file 20-global-plc.yaml (deploy/examples/atproto/market/20-global-plc.yaml)
- `file:deploy/examples/atproto/market/30-relay-relay.yaml` file 30-relay-relay.yaml (deploy/examples/atproto/market/30-relay-relay.yaml)
- `file:deploy/examples/atproto/market/40-alice-pds.yaml` file 40-alice-pds.yaml (deploy/examples/atproto/market/40-alice-pds.yaml)
- `file:deploy/examples/atproto/market/50-verifier.yaml` file 50-verifier.yaml (deploy/examples/atproto/market/50-verifier.yaml)
- `file:deploy/examples/atproto/market/60-bob-pds.yaml` file 60-bob-pds.yaml (deploy/examples/atproto/market/60-bob-pds.yaml)
- `file:deploy/examples/atproto/market/70-bidder.yaml` file 70-bidder.yaml (deploy/examples/atproto/market/70-bidder.yaml)
<!-- SPECD_MANAGED_END -->
