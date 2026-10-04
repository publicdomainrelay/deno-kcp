#!/usr/bin/env python3
"""Per-violation counts over the real documents, so a rule can be tuned.

    python3 opa/tools/calibrate.py [--opa opa]

Prints one row per violation id: how many times it fires on the base tree and
on the change tree, its severity, and whether it fires anywhere at all. A rule
that fires on a large fraction of a hand-written tree is miscalibrated; a rule
that fires nowhere in either document is either dead or waiting for a shape
neither document has, and one of those two is a bug.
"""

from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
OPA_ROOT = os.path.dirname(HERE)
DATA = os.path.join(OPA_ROOT, "data")

DOCUMENTS = [
    ("base", os.path.join(DATA, "input-base.json")),
    ("change", os.path.join(DATA, "input-change.json")),
]


def report(opa: str, document: str) -> dict | None:
    if not os.path.exists(document):
        return None
    proc = subprocess.run(
        [opa, "eval", "-b", OPA_ROOT, "-i", document, "--format", "json", "data.deno_kcp.report"],
        capture_output=True,
        text=True,
    )
    if proc.returncode != 0:
        sys.stderr.write(proc.stderr[:4000])
        return None
    return json.loads(proc.stdout)["result"][0]["expressions"][0]["value"]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--opa", default=os.environ.get("OPA", "opa"))
    args = parser.parse_args()

    reports = {}
    severity = {}
    titles = {}
    for name, path in DOCUMENTS:
        rep = report(args.opa, path)
        if rep is None:
            print(f"calibrate: {path} is missing; run make base / make change first")
            continue
        reports[name] = {}
        for violation in rep["violations"]:
            reports[name][violation["id"]] = reports[name].get(violation["id"], 0) + 1
            severity[violation["id"]] = violation["severity"]
            titles[violation["id"]] = violation["title"]

    if not reports:
        return 1

    ids = sorted({i for table in reports.values() for i in table})
    columns = list(reports)
    width = max([len(i) for i in ids] + [8])
    header = f"{'violation':<{width}} " + " ".join(f"{c:>7}" for c in columns) + f" {'sev':>7}  title"
    print(header)
    print("-" * len(header))

    dead = []
    for violation in ids:
        counts = [reports[c].get(violation, 0) for c in columns]
        if sum(counts) == 0:
            dead.append(violation)
        print(
            f"{violation:<{width}} "
            + " ".join(f"{n:>7}" for n in counts)
            + f" {severity.get(violation, ''):>7}  {titles.get(violation, '')}"
        )

    print()
    for name, table in reports.items():
        total = sum(table.values())
        print(f"{name}: {total} violations across {len(table)} distinct ids")

    declared = declared_ids(args.opa)
    never = sorted(declared - set(ids))
    if never:
        print()
        print(f"{len(never)} declared violation id(s) never fire on either document (a violation id absent here is dead or unexercised):")
        for violation in never:
            print(f"    {violation}")
    return 0


def declared_ids(opa: str) -> set[str]:
    proc = subprocess.run(
        [opa, "eval", "-b", OPA_ROOT, "--format", "json", "data.deno_kcp.metadata"],
        capture_output=True,
        text=True,
    )
    if proc.returncode != 0:
        return set()
    metadata = json.loads(proc.stdout)["result"][0]["expressions"][0]["value"]
    return {f"{policy}/{violation}" for policy, rules in metadata.items() for violation in rules}


if __name__ == "__main__":
    raise SystemExit(main())
