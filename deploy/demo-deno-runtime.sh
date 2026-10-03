#!/usr/bin/env bash
set -euo pipefail

REPO=$(cd "$(dirname "$0")/.." && pwd)
cd "$REPO"

ROOT=${ROOT:-$REPO/.kcp-demo}
export KUBECONFIG=${KUBECONFIG:-$ROOT/admin.kubeconfig}
KUBECTL=${KUBECTL:-kubectl}
SERVER_DIR=${POLICY_ENGINE_DIR:-$REPO/../policy-engine/lib/policy-engine-server-gha-lite}
ACTIONS_DIR=${BUNDLED_ACTIONS_DIR:-$REPO/../policy-engine/lib/policies/gha-lite/bundled-actions}
RUNS_DIR=${RUNS_DIR:-$REPO/runs}
WORKSPACE=${WORKSPACE:-runtime}
KCP_SECURE_PORT=${KCP_SECURE_PORT:-16443}
KINE_ENDPOINT=${KINE_ENDPOINT:-http://127.0.0.1:23791}

ROOT="$ROOT" KCP_SECURE_PORT="$KCP_SECURE_PORT" KINE_ENDPOINT="$KINE_ENDPOINT" bash deploy/start-kcp.sh
KUBECONFIG_PATH="$KUBECONFIG" bash deploy/install-provider.sh

S=$("$KUBECTL" --kubeconfig="$KUBECONFIG" config view --minify -o jsonpath='{.clusters[0].cluster.server}')
S=${S%%/clusters/*}
TENANT="$S/clusters/root:$WORKSPACE"

if ! "$KUBECTL" --kubeconfig="$KUBECONFIG" --server="$S/clusters/root" get workspace "$WORKSPACE" >/dev/null 2>&1; then
  "$KUBECTL" --kubeconfig="$KUBECONFIG" --server="$S/clusters/root" apply --validate=false -f - <<YAML
apiVersion: tenancy.kcp.io/v1alpha1
kind: Workspace
metadata:
  name: ${WORKSPACE}
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

"$KUBECTL" --kubeconfig="$KUBECONFIG" --server="$TENANT" apply --validate=false -f - <<'YAML'
apiVersion: v1
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
---
apiVersion: rbac.authorization.k8s.io/v1
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
YAML

go build -o "$ROOT/deno-kcp-provider" ./cmd/deno-kcp-provider

"$ROOT/deno-kcp-provider" --kubeconfig="$KUBECONFIG" --runs-dir "$RUNS_DIR" \
  --policy-engine-dir "$SERVER_DIR" --bundled-actions-dir "$ACTIONS_DIR" \
  >"$ROOT/provider.log" 2>&1 &
PROVIDER_PID=$!
trap 'kill "$PROVIDER_PID" 2>/dev/null || true' EXIT

wait_phase() {
  local resource=$1 name=$2 want=$3
  local deadline=$((SECONDS + 300)) phase=""
  while [ "$SECONDS" -lt "$deadline" ]; do
    phase=$("$KUBECTL" --kubeconfig="$KUBECONFIG" --server="$TENANT" get "$resource" "$name" \
      -o jsonpath='{.status.phase}' 2>/dev/null || true)
    [ "$phase" = "$want" ] && return 0
    sleep 1
  done
  echo "$resource $name did not reach $want; last phase $phase" >&2
  tail -20 "$ROOT/provider.log" >&2 || true
  return 1
}

wait_ready() {
  local resource=$1 name=$2
  local deadline=$((SECONDS + 300)) ready=""
  while [ "$SECONDS" -lt "$deadline" ]; do
    ready=$("$KUBECTL" --kubeconfig="$KUBECONFIG" --server="$TENANT" get "$resource" "$name" \
      -o jsonpath='{.status.ready}' 2>/dev/null || true)
    [ "$ready" = "true" ] && return 0
    sleep 1
  done
  echo "$resource $name never became ready" >&2
  tail -20 "$ROOT/provider.log" >&2 || true
  return 1
}

"$KUBECTL" --kubeconfig="$KUBECONFIG" --server="$TENANT" apply --validate=false \
  -f deploy/examples/policyengine.yaml
wait_ready policyengine policy-engine

"$KUBECTL" --kubeconfig="$KUBECONFIG" --server="$TENANT" apply --validate=false \
  -f deploy/examples/policyworkflowpod.yaml
wait_phase policyworkflowpod open-policy-pod Running

"$KUBECTL" --kubeconfig="$KUBECONFIG" --server="$TENANT" apply --validate=false \
  -f deploy/examples/native-fire-pod.yaml
wait_phase denopod native-fire-open-policy Succeeded

"$KUBECTL" --kubeconfig="$KUBECONFIG" --server="$TENANT" apply --validate=false \
  -f deploy/examples/runtrigger.yaml
wait_phase runtrigger on-policy-allow Triggered
JOB=$("$KUBECTL" --kubeconfig="$KUBECONFIG" --server="$TENANT" get runtrigger on-policy-allow \
  -o jsonpath='{.status.jobName}')
wait_phase denojob "$JOB" Succeeded
RUN=$("$KUBECTL" --kubeconfig="$KUBECONFIG" --server="$TENANT" get policyworkflowruns \
  -l deno.computer/policyworkflowpod=open-policy-pod --sort-by=.metadata.creationTimestamp -o name | tail -1)
RUN=${RUN##*/}
DENORUN=$("$KUBECTL" --kubeconfig="$KUBECONFIG" --server="$TENANT" get denojob "$JOB" \
  -o jsonpath='{.status.runName}')

echo "== PolicyEngine =="
"$KUBECTL" --kubeconfig="$KUBECONFIG" --server="$TENANT" get policyengine policy-engine \
  -o jsonpath='phase={.status.phase} ready={.status.ready} endpoint={.status.endpoint}{"\n"}'
echo "== PolicyWorkflowPod =="
"$KUBECTL" --kubeconfig="$KUBECONFIG" --server="$TENANT" get policyworkflowpod open-policy-pod \
  -o jsonpath='phase={.status.phase} endpoint={.status.endpoint}{"\n"}'
echo "== DenoPod (native run create) =="
"$KUBECTL" --kubeconfig="$KUBECONFIG" --server="$TENANT" get denopod native-fire-open-policy \
  -o jsonpath='phase={.status.phase} http={.status.outputs.httpStatus}{"\n"}'
echo "== PolicyWorkflowRun =="
"$KUBECTL" --kubeconfig="$KUBECONFIG" --server="$TENANT" get policyworkflowrun "$RUN" \
  -o jsonpath='name={.metadata.name} phase={.status.phase} allow={.status.outputs.allow}{"\n"}'
echo "== RunTrigger =="
"$KUBECTL" --kubeconfig="$KUBECONFIG" --server="$TENANT" get runtrigger on-policy-allow \
  -o jsonpath='phase={.status.phase} matched={.status.matched} lastRun={.status.lastRun} job={.status.jobName}{"\n"}'
echo "== DenoJob =="
"$KUBECTL" --kubeconfig="$KUBECONFIG" --server="$TENANT" get denojob "$JOB" \
  -o jsonpath='name={.metadata.name} phase={.status.phase} succeeded={.status.succeeded} run={.status.runName} allow={.status.outputs.allow} http={.status.outputs.httpStatus}{"\n"}'
echo "== DenoRun =="
"$KUBECTL" --kubeconfig="$KUBECONFIG" --server="$TENANT" get denorun "$DENORUN" \
  -o jsonpath='phase={.status.phase} exit={.status.exitCode} allow={.status.outputs.allow} http={.status.outputs.httpStatus}{"\n"}'
