#!/usr/bin/env bash
#
# Demonstrates the DIRECTLY CREATED PolicyWorkflowRun path: the user applies a
# PolicyWorkflowRun that carries its own spec.engineEndpoint, and the provider
# submits it to the warm PolicyEngine. No PolicyWorkflowPod, RunTrigger,
# DenoJob or DenoRun is involved.
#
# For the full chain (run creator pod -> PolicyWorkflowRun -> engine verdict ->
# RunTrigger -> DenoJob -> DenoRun) use deploy/demo-deno-runtime.sh instead. That
# is the one-command demo referenced by docs/DENO_RUNTIME_KCP.md.
#
# This script works in tenant workspace root:demo; demo-deno-runtime.sh uses
# root:runtime. Both share the root directory .kcp-demo.
#
set -euo pipefail

REPO=$(cd "$(dirname "$0")/.." && pwd)
cd "$REPO"

ROOT=${ROOT:-$REPO/.kcp-demo}
export KUBECONFIG=${KUBECONFIG:-$ROOT/admin.kubeconfig}
KUBECTL=${KUBECTL:-kubectl}
SERVER_DIR=${POLICY_ENGINE_DIR:-$REPO/../policy-engine/lib/policy-engine-server-gha-lite}
ACTIONS_DIR=${BUNDLED_ACTIONS_DIR:-$REPO/../policy-engine/lib/policies/gha-lite/bundled-actions}
RUNS_DIR=${RUNS_DIR:-$REPO/runs}
KCP_SECURE_PORT=${KCP_SECURE_PORT:-16444}
KINE_ENDPOINT=${KINE_ENDPOINT:-http://127.0.0.1:23792}

ROOT="$ROOT" KCP_SECURE_PORT="$KCP_SECURE_PORT" KINE_ENDPOINT="$KINE_ENDPOINT" bash deploy/start-kcp.sh
KUBECONFIG_PATH="$KUBECONFIG" bash deploy/install-provider.sh

S=$("$KUBECTL" --kubeconfig="$KUBECONFIG" config view --minify -o jsonpath='{.clusters[0].cluster.server}')
S=${S%%/clusters/*}
TENANT="$S/clusters/root:demo"

if ! "$KUBECTL" --kubeconfig="$KUBECONFIG" --server="$S/clusters/root" get workspace demo >/dev/null 2>&1; then
  "$KUBECTL" --kubeconfig="$KUBECONFIG" --server="$S/clusters/root" apply --validate=false -f - <<'YAML'
apiVersion: tenancy.kcp.io/v1alpha1
kind: Workspace
metadata:
  name: demo
spec:
  type:
    name: denoruntime
    path: root
YAML
fi

for _ in $(seq 1 60); do
  "$KUBECTL" --kubeconfig="$KUBECONFIG" --server="$TENANT" get policyengines >/dev/null 2>&1 && break
  sleep 1
done

go build -o "$ROOT/deno-kcp-provider" ./cmd/deno-kcp-provider

"$ROOT/deno-kcp-provider" --kubeconfig="$KUBECONFIG" --runs-dir "$RUNS_DIR" \
  --policy-engine-dir "$SERVER_DIR" --bundled-actions-dir "$ACTIONS_DIR" \
  >"$ROOT/provider.log" 2>&1 &
PROVIDER_PID=$!
trap 'kill "$PROVIDER_PID" 2>/dev/null || true' EXIT

"$KUBECTL" --kubeconfig="$KUBECONFIG" --server="$TENANT" apply --validate=false \
  -f deploy/examples/policyengine.yaml

for _ in $(seq 1 180); do
  endpoint=$("$KUBECTL" --kubeconfig="$KUBECONFIG" --server="$TENANT" get policyengine policy-engine \
    -o jsonpath='{.status.endpoint}' 2>/dev/null || true)
  [ -n "$endpoint" ] && break
  sleep 1
done

# deploy/examples/policy-workflow-run.yaml carries the placeholder endpoint
# http://127.0.0.1:8080, which is why this script used to keep its own inline
# copy. Substitute the live endpoint instead, so the example file stays the one
# definition of this run and cannot drift out of use again.
sed "s|http://127.0.0.1:8080|${endpoint}|" deploy/examples/policy-workflow-run.yaml \
  | "$KUBECTL" --kubeconfig="$KUBECONFIG" --server="$TENANT" apply --validate=false -f -

for _ in $(seq 1 240); do
  phase=$("$KUBECTL" --kubeconfig="$KUBECONFIG" --server="$TENANT" \
    get pwr open-policy -o jsonpath='{.status.phase}' 2>/dev/null || true)
  case "$phase" in Succeeded | Failed) break ;; esac
  sleep 1
done

echo "== PolicyEngine =="
"$KUBECTL" --kubeconfig="$KUBECONFIG" --server="$TENANT" get policyengine policy-engine \
  -o jsonpath='phase={.status.phase} ready={.status.ready} endpoint={.status.endpoint}{"\n"}'
echo "== PolicyWorkflowRun status =="
"$KUBECTL" --kubeconfig="$KUBECONFIG" --server="$TENANT" get pwr open-policy \
  -o jsonpath='phase={.status.phase} exit={.status.exitStatus} allow={.status.outputs.allow} runID={.status.runID}{"\n"}'
