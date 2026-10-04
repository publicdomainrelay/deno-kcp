#!/usr/bin/env python3
"""Normalize a spec tree into the JSON document the opa/ policy library evaluates.

A spec tree is the layout a specd/HydraDB repository branch carries:

    repository.yaml      Repository manifest
    arch.yaml            OpenArchitecture: every system context at once
    specs/<ctx>.yaml     SystemContext spec (intent, interfaces, requirements)
    status/<ctx>.yaml    observed code facts and conditions
    context/<ctx>.md     the CLM context document a model reads and edits
    changes/<n>.yaml     one SpecChange record per direction/round trip
    graph/vertices.jsonl one vertex per line
    graph/edges.jsonl    one edge per line

The loader reads that tree from a directory or from a git ref, and writes one
JSON object that is the `input` document of every policy:

    {
      "spec_tree": {repository, arch, contexts{...}, changes{...}, graph{...},
                    files{...}, observed_files[...]},
      "change":    the SpecChange under review, or null,
      "diff":      the code change under review, or null,
      "options":   run options
    }

Everything is resolved to absolute file paths and stable context names so a
policy never has to know how the tree was laid out or read.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import subprocess
import sys
from typing import Any

try:
    import yaml
except ImportError:  # pragma: no cover
    sys.stderr.write("load_spec_tree: PyYAML is required\n")
    raise SystemExit(2)


TREE_DIRS = ("specs", "status", "context", "changes")
KEY_FILES = ("repository.yaml", "arch.yaml", "README.md")
PRUNED_DIRS = {".git", "node_modules", "third_party", "__pycache__", "vendor"}
KEPT_DOTDIRS = {".tools", ".github"}


def git(root: str, *args: str) -> str:
    proc = subprocess.run(
        ["git", "-C", root, *args],
        capture_output=True,
        text=True,
        check=False,
    )
    if proc.returncode != 0:
        raise RuntimeError(f"git {' '.join(args)}: {proc.stderr.strip()}")
    return proc.stdout


class Source:
    """Reads tree entries from a working directory or from a git ref."""

    def __init__(self, root: str, ref: str | None) -> None:
        self.root = os.path.abspath(root)
        self.ref = ref

    def names(self, sub: str | None = None) -> list[str]:
        if self.ref:
            path = self.ref + (":" + sub if sub else "")
            out = git(self.root, "ls-tree", "--name-only", path)
            return [line for line in out.splitlines() if line]
        base = os.path.join(self.root, sub) if sub else self.root
        if not os.path.isdir(base):
            return []
        return sorted(os.listdir(base))

    def read_bytes(self, path: str) -> bytes:
        if self.ref:
            proc = subprocess.run(
                ["git", "-C", self.root, "show", f"{self.ref}:{path}"],
                capture_output=True,
                check=False,
            )
            if proc.returncode != 0:
                raise FileNotFoundError(path)
            return proc.stdout
        with open(os.path.join(self.root, path), "rb") as handle:
            return handle.read()

    def exists(self, path: str) -> bool:
        return self.read_optional(path) is not None

    def read_optional(self, path: str) -> bytes | None:
        try:
            return self.read_bytes(path)
        except (FileNotFoundError, RuntimeError):
            return None

    def read_yaml(self, path: str) -> Any:
        raw = self.read_optional(path)
        if raw is None:
            return None
        return yaml.safe_load(raw)

    def read_text(self, path: str) -> str | None:
        raw = self.read_optional(path)
        if raw is None:
            return None
        return raw.decode("utf-8", "replace")


def sha256_hex(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def file_kind(path: str) -> str:
    ext = os.path.splitext(path)[1]
    return {
        ".yaml": "yaml",
        ".yml": "yaml",
        ".json": "json",
        ".jsonl": "jsonl",
        ".md": "markdown",
        ".go": "go",
        ".ts": "typescript",
        ".sh": "shell",
        ".py": "python",
        ".rego": "rego",
    }.get(ext, "other")


def parse_jsonl(text: str | None) -> list[Any]:
    if not text:
        return []
    rows = []
    for line in text.splitlines():
        line = line.strip()
        if not line:
            continue
        try:
            rows.append(json.loads(line))
        except json.JSONDecodeError:
            continue
    return rows


HEADING_RE = re.compile(r"^(#{1,6})\s+(.*)$", re.MULTILINE)


def headings_of(markdown: str) -> list[dict[str, Any]]:
    out = []
    for match in HEADING_RE.finditer(markdown):
        out.append(
            {
                "level": len(match.group(1)),
                "text": match.group(2).strip(),
                "offset": match.start(),
            }
        )
    return out


def build_file_index(source: Source, extra_roots: list[str]) -> dict[str, Any]:
    index: dict[str, Any] = {}
    for sub in TREE_DIRS:
        for name in source.names(sub):
            path = f"{sub}/{name}"
            data = source.read_optional(path)
            if data is None:
                continue
            index[path] = {
                "path": path,
                "kind": file_kind(path),
                "size": len(data),
                "sha256": sha256_hex(data),
                "present": True,
            }
    for name in KEY_FILES:
        data = source.read_optional(name)
        if data is None:
            continue
        index[name] = {
            "path": name,
            "kind": file_kind(name),
            "size": len(data),
            "sha256": sha256_hex(data),
            "present": True,
        }
    for name in source.names("graph"):
        path = f"graph/{name}"
        data = source.read_optional(path)
        if data is None:
            continue
        index[path] = {
            "path": path,
            "kind": file_kind(path),
            "size": len(data),
            "sha256": sha256_hex(data),
            "present": True,
        }

    for root in extra_roots:
        if not os.path.isdir(root):
            continue
        for dirpath, dirnames, filenames in os.walk(root):
            dirnames[:] = [
                d
                for d in dirnames
                if d not in PRUNED_DIRS
                and not d.startswith("runs")
                and not (d.startswith(".") and d not in KEPT_DOTDIRS)
            ]
            for filename in filenames:
                full = os.path.join(dirpath, filename)
                rel = os.path.relpath(full, root)
                if rel in index:
                    continue
                try:
                    with open(full, "rb") as handle:
                        data = handle.read()
                except OSError:
                    continue
                index[rel] = {
                    "path": rel,
                    "kind": file_kind(rel),
                    "size": len(data),
                    "sha256": sha256_hex(data),
                    "present": True,
                }
    return index


def build_texts(source: Source) -> dict[str, str]:
    texts: dict[str, str] = {}
    for sub in TREE_DIRS:
        if sub == "context":
            continue
        for name in source.names(sub):
            path = f"{sub}/{name}"
            text = source.read_text(path)
            if text is not None:
                texts[path] = text
    return texts


def build_contexts(source: Source) -> dict[str, Any]:
    contexts: dict[str, Any] = {}
    for name in source.names("specs"):
        if not name.endswith((".yaml", ".yml")):
            continue
        ctx = os.path.splitext(name)[0]
        spec_path = f"specs/{name}"
        status_path = f"status/{name}"
        doc_path = f"context/{ctx}.md"
        document = source.read_yaml(spec_path)
        status = source.read_yaml(status_path)
        doc = source.read_text(doc_path)
        body = document.get("spec") if isinstance(document, dict) else None
        meta = document.get("metadata") if isinstance(document, dict) else None
        contexts[ctx] = {
            "name": ctx,
            "spec_path": spec_path,
            "status_path": status_path,
            "context_doc_path": doc_path,
            "document": document,
            "metadata": meta,
            "spec": body,
            "status": status,
            "context_doc": (
                {
                    "path": doc_path,
                    "text": doc,
                    "headings": headings_of(doc),
                    "sha256": sha256_hex(doc.encode()),
                }
                if doc is not None
                else None
            ),
            "changes": {},
        }

    for name in source.names("changes"):
        if not name.endswith((".yaml", ".yml")):
            continue
        change = source.read_yaml(f"changes/{name}")
        if not isinstance(change, dict):
            continue
        record = {
            "name": os.path.splitext(name)[0],
            "path": f"changes/{name}",
            "document": change,
            "system_context": (change.get("spec") or {}).get("systemContext"),
            "direction": (change.get("spec") or {}).get("direction"),
        }
        ctx = record["system_context"]
        if isinstance(ctx, str) and ctx in contexts:
            contexts[ctx]["changes"][record["name"]] = record
        else:
            contexts.setdefault(
                ctx if isinstance(ctx, str) else "",
                {
                    "name": ctx,
                    "spec_path": None,
                    "status_path": None,
                    "context_doc_path": None,
                    "document": None,
                    "metadata": None,
                    "spec": None,
                    "status": None,
                    "context_doc": None,
                    "changes": {},
                },
            )["changes"][record["name"]] = record
    return contexts


def flatten_changes(contexts: dict[str, Any]) -> dict[str, Any]:
    out: dict[str, Any] = {}
    for ctx in contexts.values():
        for name, record in (ctx.get("changes") or {}).items():
            out[name] = record
    return out


def build_graph(source: Source) -> dict[str, Any]:
    vertices = parse_jsonl(source.read_text("graph/vertices.jsonl"))
    edges = parse_jsonl(source.read_text("graph/edges.jsonl"))
    by_id = {}
    for vertex in vertices:
        key = str(vertex.get("id"))
        by_id[key] = vertex
    kinds: dict[str, int] = {}
    for vertex in vertices:
        kind = str(vertex.get("kind"))
        kinds[kind] = kinds.get(kind, 0) + 1
    edge_types: dict[str, int] = {}
    for edge in edges:
        etype = str(edge.get("type"))
        edge_types[etype] = edge_types.get(etype, 0) + 1
    return {
        "vertices": vertices,
        "edges": edges,
        "vertices_by_id": by_id,
        "vertex_kinds": kinds,
        "edge_types": edge_types,
    }


def build_diff(root: str, base: str, head: str) -> dict[str, Any] | None:
    """The code change under review, as a file list plus per-file patch text."""
    try:
        name_status = git(root, "diff", "--name-status", "-M", base, head)
    except RuntimeError:
        return None
    files = []
    for line in name_status.splitlines():
        parts = line.split("\t")
        if len(parts) < 2:
            continue
        status = parts[0]
        path = parts[-1]
        entry = {"status": status[0], "path": path, "raw_status": status}
        if status[0] == "R" and len(parts) >= 3:
            entry["old_path"] = parts[1]
            entry["path"] = parts[2]
        files.append(entry)

    numstat = git(root, "diff", "--numstat", "-M", base, head)
    stats = {}
    for line in numstat.splitlines():
        parts = line.split("\t")
        if len(parts) < 3:
            continue
        added, removed, path = parts[0], parts[1], parts[-1]
        stats[path] = {
            "additions": 0 if added == "-" else int(added),
            "deletions": 0 if removed == "-" else int(removed),
        }

    for entry in files:
        entry.update(stats.get(entry["path"], {"additions": 0, "deletions": 0}))
        try:
            entry["patch"] = git(root, "diff", "-M", base, head, "--", entry["path"])
        except RuntimeError:
            entry["patch"] = ""
        try:
            entry["base_text"] = git(root, "show", f"{base}:{entry.get('old_path', entry['path'])}")
        except RuntimeError:
            entry["base_text"] = None
        try:
            entry["head_text"] = git(root, "show", f"{head}:{entry['path']}")
        except RuntimeError:
            entry["head_text"] = None

    try:
        commits = git(root, "log", "--format=%H%x00%s%x00%an%x00%aI", f"{base}..{head}")
    except RuntimeError:
        commits = ""
    commit_rows = []
    for line in commits.splitlines():
        if not line.strip():
            continue
        parts = line.split("\x00")
        if len(parts) == 4:
            commit_rows.append(
                {"sha": parts[0], "subject": parts[1], "author": parts[2], "date": parts[3]}
            )

    return {
        "base": base,
        "head": head,
        "files": files,
        "commits": commit_rows,
        "paths": sorted(entry["path"] for entry in files),
        "added": sorted(e["path"] for e in files if e["status"] == "A"),
        "modified": sorted(e["path"] for e in files if e["status"] == "M"),
        "deleted": sorted(e["path"] for e in files if e["status"] == "D"),
        "renamed": sorted(e["path"] for e in files if e["status"] == "R"),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", default=".", help="spec tree root (default: cwd)")
    parser.add_argument("--ref", default=None, help="read the tree from this git ref")
    parser.add_argument("--code-root", default=None, help="code repository root for file existence")
    parser.add_argument("--diff-base", default=None)
    parser.add_argument("--diff-head", default=None)
    parser.add_argument(
        "--diff-root",
        default=None,
        help="repository the diff refs live in (default: --root)",
    )
    parser.add_argument("--change", default=None, help="SpecChange name under review")
    parser.add_argument("--out", default=None, help="write JSON here (default: stdout)")
    args = parser.parse_args()

    root = os.path.abspath(args.root)
    source = Source(root, args.ref)
    extra_roots = [os.path.abspath(p) for p in (args.code_root,) if p]

    repository = source.read_yaml("repository.yaml") or {}
    arch = source.read_yaml("arch.yaml") or {}
    contexts = build_contexts(source)
    changes = flatten_changes(contexts)
    graph = build_graph(source)
    files = build_file_index(source, extra_roots)
    texts = build_texts(source)

    observed_files: set[str] = set()
    for ctx in contexts.values():
        status = ctx.get("status") or {}
        for rel in ((status.get("observed") or {}).get("files") or []):
            observed_files.add(str(rel))
        spec = ctx.get("spec") or {}
        for req in (spec.get("requirements") or []):
            for ref in (req.get("codeRefs") or []):
                observed_files.add(str(ref).split(":", 1)[-1])
        for iface in (spec.get("interfaces") or []):
            if iface.get("file"):
                observed_files.add(str(iface["file"]))

    change = None
    if args.change:
        change = changes.get(args.change)
        if change is None:
            for name, record in changes.items():
                if name.startswith(args.change):
                    change = record
                    break

    diff = None
    if args.diff_base and args.diff_head:
        diff = build_diff(args.diff_root or root, args.diff_base, args.diff_head)
        if diff:
            head_paths = set(diff["paths"])
            for entry in diff["files"]:
                entry["head_exists"] = entry["status"] != "D"
                entry["known_path"] = entry["path"] in files
            diff["untracked_paths"] = sorted(
                path for path in head_paths if path not in files
            )

    document = {
        "spec_tree": {
            "root": root,
            "ref": args.ref,
            "repository": repository,
            "arch": arch,
            "contexts": contexts,
            "changes": changes,
            "graph": graph,
            "files": files,
            "texts": texts,
            "observed_files": sorted(observed_files),
            "context_names": sorted(contexts.keys()),
            "generated_by": "opa/tools/load_spec_tree.py",
        },
        "change": change,
        "diff": diff,
        "options": {
            "code_root": args.code_root,
            "diff_base": args.diff_base,
            "diff_head": args.diff_head,
        },
    }

    payload = json.dumps(document, indent=2, sort_keys=False, default=str)
    if args.out:
        with open(args.out, "w", encoding="utf-8") as handle:
            handle.write(payload)
            handle.write("\n")
    else:
        sys.stdout.write(payload)
        sys.stdout.write("\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
