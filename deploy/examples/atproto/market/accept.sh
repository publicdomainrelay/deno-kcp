#!/usr/bin/env bash
set -euo pipefail

# Live acceptance for the AT Protocol market example.
#
# This brings the whole market up in a throwaway state directory -- its own kcp,
# its own kine, its own OpenBao, the provider, and every DenoPod apply.sh
# applies -- and then reaches the workloads, rather than only decoding the
# manifests. It exits 0 only when every check passed.
#
# Everything it starts it starts itself, under $ACCEPT_ROOT, on ports the kernel
# hands out, so it cannot collide with another kcp, kine or OpenBao already
# running on the machine, and it never stops one it did not start:
# deploy/stop-kcp.sh signals only processes whose cmdline names its own root, and
# OpenBao is killed only through the pid file inside $ACCEPT_ROOT.

REPO=$(cd "$(dirname "$0")/../../../.." && pwd)
MARKET_DIR=$(cd "$(dirname "$0")" && pwd)
ORG_ROOT=${ORG_ROOT:-$(cd "$REPO/.." && pwd)}
ACCEPT_ROOT=${ACCEPT_ROOT:-$(mktemp -d)}
KUBECTL=${KUBECTL:-kubectl}
WAIT_SECONDS=${WAIT_SECONDS:-240}
SETTLE_SECONDS=${SETTLE_SECONDS:-10}

KUBECONFIG_PATH=$ACCEPT_ROOT/kcp/admin.kubeconfig
KCACHE=$ACCEPT_ROOT/.kubectl-cache
OPENBAO_DIR=$ACCEPT_ROOT/openbao
PROVIDER_LOG=$ACCEPT_ROOT/provider.log
PROVIDER_PID=""

mkdir -p "$ACCEPT_ROOT" "$KCACHE"

# Three free 127.0.0.1 ports, from the kernel, so two accept.sh runs on one
# machine do not fight over a pinned one.
free_port() {
  python3 -c 'import socket
s = socket.socket()
s.bind(("127.0.0.1", 0))
print(s.getsockname()[1])
s.close()'
}

KCP_PORT=$(free_port)
KINE_PORT=$(free_port)
while [ "$KINE_PORT" = "$KCP_PORT" ]; do KINE_PORT=$(free_port); done
OPENBAO_PORT=$(free_port)
while [ "$OPENBAO_PORT" = "$KCP_PORT" ] || [ "$OPENBAO_PORT" = "$KINE_PORT" ]; do
  OPENBAO_PORT=$(free_port)
done

cleanup() {
  local status=$?
  trap - EXIT
  if [ -n "$PROVIDER_PID" ] && kill -0 "$PROVIDER_PID" 2>/dev/null; then
    kill "$PROVIDER_PID" 2>/dev/null || true
    wait "$PROVIDER_PID" 2>/dev/null || true
  fi
  if [ -s "$OPENBAO_DIR/bao.pid" ]; then
    local bao_pid
    bao_pid=$(cat "$OPENBAO_DIR/bao.pid")
    if [ -n "$bao_pid" ] && kill -0 "$bao_pid" 2>/dev/null; then
      kill "$bao_pid" 2>/dev/null || true
    fi
  fi
  ROOT="$ACCEPT_ROOT/kcp" bash "$REPO/deploy/stop-kcp.sh" >/dev/null || true
  rm -rf "$ACCEPT_ROOT"
  exit "$status"
}
trap cleanup EXIT

echo "accept root: $ACCEPT_ROOT"
echo "ports: kcp=$KCP_PORT kine=$KINE_PORT openbao=$OPENBAO_PORT"

echo
echo "== kcp =="
ROOT="$ACCEPT_ROOT/kcp" \
KCP_SECURE_PORT="$KCP_PORT" \
KINE_ENDPOINT="http://127.0.0.1:$KINE_PORT" \
  bash "$REPO/deploy/start-kcp.sh"

echo
echo "== provider workspace and schemas =="
KUBECONFIG_PATH="$KUBECONFIG_PATH" bash "$REPO/deploy/install-provider.sh"

echo
echo "== provider build =="
(cd "$REPO" && go build -o "$ACCEPT_ROOT/deno-kcp-provider" ./cmd/deno-kcp-provider)

echo
echo "== openbao =="
OPENBAO_DIR="$OPENBAO_DIR" \
OPENBAO_LISTEN="127.0.0.1:$OPENBAO_PORT" \
  bash "$REPO/deploy/start-openbao.sh"

echo
echo "== provider =="
RUNS_DIR="$ACCEPT_ROOT/runs" "$ACCEPT_ROOT/deno-kcp-provider" \
  --kubeconfig="$KUBECONFIG_PATH" \
  --openbao-addr="http://127.0.0.1:$OPENBAO_PORT" \
  --openbao-token=root \
  >"$PROVIDER_LOG" 2>&1 &
PROVIDER_PID=$!

echo
echo "== apply =="
apply_status=0
ORG_ROOT="$ORG_ROOT" \
KUBECONFIG="$KUBECONFIG_PATH" \
OPENBAO_LISTEN="127.0.0.1:$OPENBAO_PORT" \
START_OPENBAO=0 \
WAIT_SECONDS="$WAIT_SECONDS" \
KEY_FILE="$ACCEPT_ROOT/alice-pds-key.hex" \
BOB_KEY_FILE="$ACCEPT_ROOT/bob-pds-key.hex" \
BIDDER_KEY_FILE="$ACCEPT_ROOT/bidder-key.hex" \
  bash "$MARKET_DIR/apply.sh" || apply_status=$?

# apply.sh failing is not a reason to skip the checks: what came up and what did
# not is the evidence, and it is read the same way either way.
echo
echo "== checks =="

KC() { "$KUBECTL" --kubeconfig="$KUBECONFIG_PATH" --cache-dir="$KCACHE" "$@"; }

SERVER=$(KC config view --minify -o jsonpath='{.clusters[0].cluster.server}')
SERVER=${SERVER%%/clusters/*}

pod_phase() {
  KC --server="$SERVER/clusters/root:$1" get denopod "$2" -o jsonpath='{.status.phase}' 2>/dev/null || true
}
pod_ready() {
  KC --server="$SERVER/clusters/root:$1" get denopod "$2" -o jsonpath='{.status.ready}' 2>/dev/null || true
}
http_code() {
  curl -sS -o /dev/null -w '%{http_code}' --max-time 10 "$1" 2>/dev/null || echo 000
}

RESULTS=()
FAILED=0
check() {
  RESULTS+=("$(printf '%-36s %-4s %s' "$1" "$2" "$3")")
  [ "$2" = "PASS" ] || FAILED=1
}

PODS=("global plc" "relay relay" "alice pds" "bob pds" "bob bidder")

if [ "$apply_status" -eq 0 ]; then
  check "apply.sh" PASS "exit=0"
else
  check "apply.sh" FAIL "exit=$apply_status"
fi

for entry in "${PODS[@]}"; do
  set -- $entry
  ws=$1; name=$2
  phase=$(pod_phase "$ws" "$name")
  ready=$(pod_ready "$ws" "$name")
  if [ "$phase" = "Running" ] && [ "$ready" = "true" ]; then
    check "denopod root:$ws/$name" PASS "phase=Running ready=true"
  else
    check "denopod root:$ws/$name" FAIL "phase=${phase:-missing} ready=${ready:-missing}"
  fi
done

vphase=$(pod_phase alice verifier)
if [ "$vphase" = "Succeeded" ]; then
  check "denopod root:alice/verifier" PASS "phase=Succeeded"
else
  check "denopod root:alice/verifier" FAIL "phase=${vphase:-missing}"
fi

# The provider proves the service answers on its own cluster-local name: the
# readiness probe resolves the name through the shim and requests the path, and
# ready=true is that probe's verdict. The host proves the same listener answers
# from outside, where the name does not resolve.
ready=$(pod_ready bob pds)
if [ "$ready" = "true" ]; then
  check "bob pds on its name" PASS "ready=true probe=kcpdns pds.default.bob.svc.kcp.local /xrpc/_health"
else
  check "bob pds on its name" FAIL "ready=${ready:-missing} probe=kcpdns pds.default.bob.svc.kcp.local /xrpc/_health"
fi

code=$(http_code http://127.0.0.1:2585/xrpc/_health)
if [ "$code" = "200" ]; then
  check "bob pds on the host" PASS "GET http://127.0.0.1:2585/xrpc/_health -> $code"
else
  check "bob pds on the host" FAIL "GET http://127.0.0.1:2585/xrpc/_health -> $code"
fi

ready=$(pod_ready bob bidder)
if [ "$ready" = "true" ]; then
  check "bidder on its name" PASS "ready=true probe=kcpdns bidder.default.bob.svc.kcp.local /oauth-client-metadata.json"
else
  check "bidder on its name" FAIL "ready=${ready:-missing} probe=kcpdns bidder.default.bob.svc.kcp.local /oauth-client-metadata.json"
fi

code=$(http_code http://127.0.0.1:2586/oauth-client-metadata.json)
if [ "$code" = "200" ]; then
  check "bidder on the host" PASS "GET http://127.0.0.1:2586/oauth-client-metadata.json -> $code"
else
  check "bidder on the host" FAIL "GET http://127.0.0.1:2586/oauth-client-metadata.json -> $code"
fi

# A pod that dies after startup passes a single read. Reading the long-running
# pods again after a pause is what catches it.
echo "waiting ${SETTLE_SECONDS}s, then reading the long-running pods again"
sleep "$SETTLE_SECONDS"
for entry in "${PODS[@]}"; do
  set -- $entry
  ws=$1; name=$2
  phase=$(pod_phase "$ws" "$name")
  ready=$(pod_ready "$ws" "$name")
  if [ "$phase" = "Running" ] && [ "$ready" = "true" ]; then
    check "still up root:$ws/$name" PASS "phase=Running ready=true after ${SETTLE_SECONDS}s"
  else
    check "still up root:$ws/$name" FAIL "phase=${phase:-missing} ready=${ready:-missing} after ${SETTLE_SECONDS}s"
  fi
done

echo
echo "results:"
printf '  %-36s %-4s %s\n' "check" "result" "evidence"
for line in "${RESULTS[@]}"; do
  echo "  $line"
done

if [ "$FAILED" -ne 0 ]; then
  echo
  echo "provider log, tail of $PROVIDER_LOG:"
  tail -n 40 "$PROVIDER_LOG" || true
  echo
  echo "status of the pods that are not Running and ready:"
  for entry in "${PODS[@]}" "alice verifier"; do
    set -- $entry
    ws=$1; name=$2
    phase=$(pod_phase "$ws" "$name")
    ready=$(pod_ready "$ws" "$name")
    if [ "$phase" = "Running" ] && [ "$ready" = "true" ] || [ "$phase" = "Succeeded" ]; then
      continue
    fi
    echo "root:$ws $name:"
    KC --server="$SERVER/clusters/root:$ws" get denopod "$name" -o jsonpath='{.status}' 2>&1 | sed 's/^/  /' || true
    echo
  done
fi

echo
if [ "$FAILED" -eq 0 ]; then
  echo "accept: pass"
else
  echo "accept: fail"
fi
exit "$FAILED"
