#!/usr/bin/env python3
"""Integration gate: run every policy over the real spec trees and assert the
findings the change is known to carry, and the quiet the well-formed base tree
is known to keep.

    python3 opa/test/integration.py

Each expectation is (document, violation id prefix, comparator, count). An
expectation naming an id no policy raises is a failure, because a rule that
stopped existing is a rule that stopped guarding.
"""

from __future__ import annotations

import json
import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
OPA_ROOT = os.path.dirname(HERE)
SPEC_ROOT = os.path.dirname(OPA_ROOT)
CODE_ROOT = os.path.join(os.path.dirname(SPEC_ROOT), "deno-kcp")
OPA = os.environ.get("OPA", "opa")

BASE = "/tmp/opa-integration-base.json"
CHANGE = "/tmp/opa-integration-change.json"
CHANGE_NAME = "deploy-examples-atproto-market-s2c-834078074eaa"

BUILD = [
    (
        BASE,
        [
            "python3", os.path.join(OPA_ROOT, "tools", "load_spec_tree.py"),
            "--root", SPEC_ROOT, "--code-root", CODE_ROOT,
            "--base-ref", "origin/open-architecture/deno-kcp",
            "--out", BASE,
        ],
    ),
    (
        CHANGE,
        [
            "python3", os.path.join(OPA_ROOT, "tools", "load_spec_tree.py"),
            "--root", SPEC_ROOT,
            "--ref", "origin/open-architecture/deno-kcp--spec-bidder-and-bob-pds",
            "--change", CHANGE_NAME,
            "--base-ref", "origin/open-architecture/deno-kcp",
            "--code-root", CODE_ROOT,
            "--diff-base", "origin/main",
            "--diff-head", "origin/spec/bidder-and-bob-pds",
            "--out", CHANGE,
        ],
    ),
]

# (document, violation id, comparator, count, why)
EXPECTATIONS = [
    (BASE, "spec_structure/requirement-text-has-machine-path", "==", 0,
     "the base tree carries no absolute machine path in a requirement"),
    (CHANGE, "spec_structure/requirement-text-has-machine-path", ">=", 1,
     "r.bidder-pod in the change names /home/johnandersen777/src/publicdomainrelay-kcp"),

    (CHANGE, "change_integrity/change-succeeded-with-failed-acceptance", ">=", 1,
     "the change is Succeeded while market-live-acceptance passed:false"),
    (CHANGE, "acceptance_integrity/acceptance-gate-failed", ">=", 1,
     "the only gating acceptance step failed"),
    (CHANGE, "acceptance_integrity/acceptance-frozen-repository", ">=", 1,
     "a failed gate with phase Succeeded freezes the repository"),
    (CHANGE, "acceptance_integrity/acceptance-no-gate", "==", 0,
     "the repository does declare a gating step"),

    (CHANGE, "traceability/trace-files-touched-not-in-diff", "==", 0,
     "filesTouched names accept.sh, which the diff touches"),
    (CHANGE, "traceability/trace-diff-touches-nothing", "==", 0,
     "the diff touches ten files"),

    (BASE, "code_safety/", "==", 0,
     "there is no code diff in the base document, so no code rule can fire"),
]

REQUIRED_POLICIES = [
    "spec_structure",
    "spec_references",
    "arch_consistency",
    "change_integrity",
    "change_impact",
    "acceptance_integrity",
    "traceability",
    "code_safety",
    "change_security",
    "change_quality",
]


def run(cmd: list[str]) -> subprocess.CompletedProcess:
    return subprocess.run(cmd, capture_output=True, text=True, cwd=OPA_ROOT)


def build_inputs() -> None:
    for out, cmd in BUILD:
        proc = run(cmd)
        if proc.returncode != 0:
            sys.stderr.write(proc.stderr)
            raise SystemExit(f"integration: could not build {out}")


def report(document: str) -> dict:
    proc = run([
        OPA, "eval", "-b", OPA_ROOT, "-i", document,
        "--format", "json", "data.deno_kcp.report",
    ])
    if proc.returncode != 0:
        sys.stderr.write(proc.stderr[:4000])
        raise SystemExit("integration: opa eval failed")
    return json.loads(proc.stdout)["result"][0]["expressions"][0]["value"]


def counts(rep: dict) -> dict[str, int]:
    out: dict[str, int] = {}
    for violation in rep["violations"]:
        out[violation["id"]] = out.get(violation["id"], 0) + 1
    return out


def compare(value: int, op: str, expected: int) -> bool:
    return {
        "==": value == expected,
        "<=": value <= expected,
        ">=": value >= expected,
        "<": value < expected,
        ">": value > expected,
    }[op]


def main() -> int:
    build_inputs()
    reports = {BASE: report(BASE), CHANGE: report(CHANGE)}
    tables = {path: counts(rep) for path, rep in reports.items()}

    failures = 0
    print(f"{'document':<8} {'violation':<62} {'want':>6} {'got':>5}  result")
    for document, prefix, op, expected, why in EXPECTATIONS:
        table = tables[document]
        if prefix.endswith("/"):
            got = sum(n for i, n in table.items() if i.startswith(prefix))
        else:
            got = table.get(prefix, 0)
            if got == 0 and prefix not in table:
                failures += 1
                print(f"{label(document):<8} {prefix:<62} {op + ' ' + str(expected):>6} {'absent':>5}  FAIL  {why}")
                continue
        ok = compare(got, op, expected)
        if not ok:
            failures += 1
        print(f"{label(document):<8} {prefix:<62} {op + ' ' + str(expected):>6} {got:>5}  {'ok' if ok else 'FAIL'}  {why if not ok else ''}")

    print()
    for document, rep in reports.items():
        print(
            f"{label(document)}: {rep['count']} violations "
            f"({rep['errors']} error, {rep['warnings']} warning, {rep['infos']} info), "
            f"passed={rep['passed']}"
        )
        for policy, n in sorted(rep["by_policy"].items()):
            print(f"    {policy:<24} {n}")

    present = set()
    for rep in reports.values():
        present.update(rep["by_policy"].keys())
    missing = [p for p in REQUIRED_POLICIES if p not in present]
    if missing:
        failures += 1
        print(f"\nFAIL: no violation was ever raised by: {', '.join(missing)}")

    print()
    if failures:
        print(f"integration: {failures} expectation(s) failed")
        return 1
    print("integration: every expectation held")
    return 0


def label(document: str) -> str:
    return "base" if document == BASE else "change"


if __name__ == "__main__":
    raise SystemExit(main())
