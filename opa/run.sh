#!/usr/bin/env bash
set -euo pipefail

# Load a spec tree into the input document the policies read, evaluate every
# policy over it, and exit non-zero when a violation of severity error was
# raised.
#
#   opa/run.sh --spec-root /path/to/spec-tree [--code-root /path/to/code]
#              [--ref <git-ref>] [--change <SpecChange name>]
#              [--diff-base <ref> --diff-head <ref>] [--diff-root <path>]
#              [--scope own|all] [--query <rego query>] [--json] [--out <file>]
#
# OPA defaults to the opa binary on PATH; set OPA to point at another one.

HERE=$(cd "$(dirname "$0")" && pwd)
OPA=${OPA:-opa}
SPEC_ROOT=${SPEC_ROOT:-$(cd "$HERE/.." && pwd)}
CODE_ROOT=${CODE_ROOT:-}
REF=""
CHANGE=""
DIFF_BASE=""
DIFF_HEAD=""
DIFF_ROOT=""
SCOPE="own"
QUERY="data.deno_kcp.report"
JSON=0
OUT=""

while [ $# -gt 0 ]; do
  case "$1" in
    --spec-root) SPEC_ROOT=$2; shift 2 ;;
    --code-root) CODE_ROOT=$2; shift 2 ;;
    --ref) REF=$2; shift 2 ;;
    --change) CHANGE=$2; shift 2 ;;
    --diff-base) DIFF_BASE=$2; shift 2 ;;
    --diff-head) DIFF_HEAD=$2; shift 2 ;;
    --diff-root) DIFF_ROOT=$2; shift 2 ;;
    --scope) SCOPE=$2; shift 2 ;;
    --query) QUERY=$2; shift 2 ;;
    --out) OUT=$2; shift 2 ;;
    --json) JSON=1; shift ;;
    *) echo "run.sh: unknown argument $1" >&2; exit 2 ;;
  esac
done

LOAD_ARGS=(--root "$SPEC_ROOT" --out "${OUT:-$HERE/data/input.json}")
[ -n "$REF" ] && LOAD_ARGS+=(--ref "$REF")
[ -n "$CODE_ROOT" ] && LOAD_ARGS+=(--code-root "$CODE_ROOT")
[ -n "$CHANGE" ] && LOAD_ARGS+=(--change "$CHANGE")
[ -n "$DIFF_BASE" ] && LOAD_ARGS+=(--diff-base "$DIFF_BASE")
[ -n "$DIFF_HEAD" ] && LOAD_ARGS+=(--diff-head "$DIFF_HEAD")
[ -n "$DIFF_ROOT" ] && LOAD_ARGS+=(--diff-root "$DIFF_ROOT")

mkdir -p "$HERE/data"
python3 "$HERE/tools/load_spec_tree.py" "${LOAD_ARGS[@]}"

INPUT=${OUT:-$HERE/data/input.json}

EVAL_FORMAT=pretty
[ "$JSON" = "1" ] && EVAL_FORMAT=json

if [ "$JSON" = "1" ]; then
  "$OPA" eval -b "$HERE" -i "$INPUT" --input-scope all \
    --format json "$QUERY" \
    | python3 -c 'import json,sys; d=json.load(sys.stdin); print(json.dumps(d["result"][0]["expressions"][0]["value"], indent=2, sort_keys=True))'
else
  "$OPA" eval -b "$HERE" -i "$INPUT" "$QUERY" --format "$EVAL_FORMAT"
fi

PASSED=$("$OPA" eval -b "$HERE" -i "$INPUT" --format raw 'data.deno_kcp.passed' 2>/dev/null | tr -d '[:space:]')

if [ "$PASSED" != "true" ]; then
  echo "opa: violations of severity error were raised; see the report above" >&2
  exit 1
fi
