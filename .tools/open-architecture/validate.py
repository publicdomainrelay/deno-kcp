#!/usr/bin/env python3
"""Validate arch.yaml: schema, ids and refs, system context trees, boundary tree, signs, flows, crossings, risks, paths, symbols, data file keys, reconcile wiring, orphans.

Exit 1 on any error. Warnings never change the exit code.
"""
import argparse
import json
import re
import sys
from pathlib import Path

import yaml
from jsonschema import Draft202012Validator

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[1]

PREFIXES = ("up", "orch", "type", "cred", "ov", "sc", "tb", "x", "r", "rec", "flow")
REF = re.compile(r"^(" + "|".join(PREFIXES) + r")\.([A-Za-z0-9][A-Za-z0-9._-]*)$")
PROSE_REF = re.compile(r"(?<![A-Za-z0-9._/-])(?:" + "|".join(PREFIXES) + r")\.[a-z0-9][a-z0-9.-]*[a-z0-9]")
KIND_OBJECT = re.compile(r"^(sc\.kind\.[a-z0-9]+)\.(spec|status)$")
ID_MAPS = {"upstreams", "orchestrators", "types", "credentials", "risks", "flows", "reconcilers"}
GROUPED_MAPS = {"crossings"}
LONGEST_MATCH = ("sc", "ov", "rec")
ORPHAN_PREFIXES = ("up", "orch", "type", "cred", "tb")
INLINE_WHERE_USED = ("up", "orch", "type")
TERMINAL_PREFIXES = ("r", "x", "flow", "rec")
MAP_PREFIXES = {
    "upstreams": "up",
    "orchestrators": "orch",
    "types": "type",
    "credentials": "cred",
    "crossings": "x",
    "risks": "r",
    "flows": "flow",
    "reconcilers": "rec",
}
FILE_DATA_KEYS = ("script", "entry", "file", "manifest")
BARE_IDENT = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")
WORKLOAD_KINDS = ("DenoPod", "DenoRun")
PATH_KEYS = {"source", "file", "code", "evidence", "manifest"}
ORCH_PATH_KEYS = {"path", "stop", "module", "used_by", "tests"}
NO_PATH_SECTIONS = {"upstreams"}
TRIPLE = ("upstream", "overlay", "orchestrator")
KEY_ORDER = ("id", "upstream", "overlay", "orchestrator", "context", "object")

KIND_MANIFESTS = {
    "sc.kind.denopod": "deploy/denopod-apiresourceschema.yaml",
    "sc.kind.denorun": "deploy/denorun-apiresourceschema.yaml",
    "sc.kind.denojob": "deploy/denojob-apiresourceschema.yaml",
    "sc.kind.runtrigger": "deploy/runtrigger-apiresourceschema.yaml",
    "sc.kind.policyengine": "deploy/policyengine-apiresourceschema.yaml",
    "sc.kind.policyworkflowpod": "deploy/policyworkflowpod-apiresourceschema.yaml",
    "sc.kind.policyworkflowrun": "deploy/policyworkflowrun-apiresourceschema.yaml",
    "sc.kind.openbao": "deploy/openbao-apiresourceschema.yaml",
}
APIEXPORTS = {
    "denoruntime": "deploy/denoruntime-apiexport.yaml",
    "policyworkflowruns": "deploy/policyworkflowrun-apiexport.yaml",
}
SHARED_TYPES = "api/v1alpha1/types_shared.go"
MARKET_WORKSPACES = "deploy/examples/atproto/market/00-workspaces.yaml"


class Report:
    def __init__(self):
        self.errors = []
        self.warnings = []

    def error(self, path, msg):
        self.errors.append((fmt(path), msg))

    def warn(self, path, msg):
        self.warnings.append((fmt(path), msg))


def fmt(path):
    return "/".join(str(p) for p in path) or "/"


def load(doc_path, report):
    class Loader(yaml.SafeLoader):
        pass

    def mapping(loader, node, deep=False):
        seen = set()
        for key_node, _ in node.value:
            key = loader.construct_object(key_node, deep=deep)
            if key in seen:
                report.error((f"line {key_node.start_mark.line + 1}",), f"duplicate key {key!r}")
            seen.add(key)
        return loader.construct_mapping(node, deep=deep)

    Loader.add_constructor(yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG, mapping)
    Loader.add_constructor("tag:yaml.org,2002:timestamp", lambda loader, node: loader.construct_scalar(node))
    with open(doc_path) as f:
        return yaml.load(f, Loader=Loader)


def walk(node, path=()):
    if isinstance(node, dict):
        for k, v in node.items():
            yield from walk(v, path + (str(k),))
    elif isinstance(node, list):
        for i, v in enumerate(node):
            yield from walk(v, path + (i,))
    else:
        yield path, node


def walk_dicts(node, path=()):
    if isinstance(node, dict):
        yield path, node
        for k, v in node.items():
            yield from walk_dicts(v, path + (k,))
    elif isinstance(node, list):
        for i, v in enumerate(node):
            yield from walk_dicts(v, path + (i,))


def as_dict(value):
    return value if isinstance(value, dict) else {}


def as_list(value):
    if value is None:
        return []
    return value if isinstance(value, list) else [value]


def check_axes(doc, index, report):
    axes = as_dict(as_dict(doc.get("metadata")).get("axes"))
    all_ids = {i for ids in index.ids.values() for i in ids}
    for name, axis in axes.items():
        base = ("metadata", "axes", name)
        for section in as_list(axis.get("section")):
            if not doc.get(section):
                report.error(base + ("section",), f"section {section!r} is absent or empty")
        for prefix in as_list(axis.get("prefix")):
            if not any(i == prefix or i.startswith(prefix + ".") for i in all_ids):
                report.error(base + ("prefix",), f"no id under {prefix}.*")
        suffix = axis.get("suffix")
        if suffix is not None and not any(i.endswith(suffix) for i in index.ids["sc"]):
            report.error(base + ("suffix",), f"no system context id ends with {suffix!r}")
    for kind_id in index.kinds:
        if "axis" not in index.ids["sc"][kind_id]:
            report.error(("system_contexts", kind_id, "axis"), "kind context must carry axis, its lifecycle")


def rid(node):
    return node.get("id") if isinstance(node, dict) else node


def find(doc, name):
    for path, node in walk_dicts(doc):
        if name in node and isinstance(node[name], dict):
            return node[name]
    return {}


OUTLINE_ATTRS = ("kind", "axis", "mode", "use", "cluster", "target", "bin", "lang", "role", "system")
OUTLINE_MAPS = ("upstreams", "orchestrators", "types", "reconcilers", "wakes", "flows", "credentials", "crossings", "addresses", "surfaces", "failures", "risks", "systems")
OUTLINE_SKIP = {"data", "evidence", "finding"}


def outline(doc, stream, only=None):
    def emit(depth, text):
        print("  " * depth + text, file=stream)

    ids, by_id = set(), {}
    for _, node in walk_dicts(doc):
        for key in node:
            if isinstance(key, str) and REF.match(key):
                ids.add(key)
        nid = node.get("id")
        if isinstance(nid, str) and REF.match(nid):
            ids.add(nid)
            by_id.setdefault(nid, node)

    def attrs(node):
        bits = [f"{k}={node[k]}" for k in OUTLINE_ATTRS if isinstance(node.get(k), str)]
        api = as_dict(as_dict(node.get("upstream")).get("api"))
        if isinstance(api.get("kind"), str):
            bits.append("api=" + api["kind"])
        obj = as_dict(node.get("object"))
        if isinstance(obj.get("kind"), str):
            bits.append("object=" + obj["kind"])
        if isinstance(as_dict(node.get("pin")).get("by"), str):
            bits.append("pin=" + node["pin"]["by"])
        return (" [" + " ".join(bits) + "]") if bits else ""

    def refs(node, skip):
        found = []

        def walk(value, root):
            if isinstance(value, dict):
                if not root and value.get("id") in ids:
                    return
                for key, inner in value.items():
                    if key not in OUTLINE_SKIP:
                        walk(inner, False)
            elif isinstance(value, list):
                for inner in value:
                    walk(inner, False)
            elif isinstance(value, str) and REF.match(value) and value not in skip and value not in found:
                found.append(value)

        walk(node, True)
        return found

    def children(node):
        out = []

        def walk(value):
            if isinstance(value, dict):
                nid = value.get("id")
                if isinstance(nid, str) and nid in ids and value is not node:
                    out.append(nid)
                    return
                for inner in value.values():
                    walk(inner)
            elif isinstance(value, list):
                for inner in value:
                    walk(inner)

        for key, value in node.items():
            if key not in OUTLINE_SKIP:
                walk(value)
        return out

    def text(entry):
        skip = set(children(entry))
        nid = entry.get("id")
        if isinstance(nid, str):
            skip.add(nid)
        found = refs(entry, skip)
        if len(found) > 12:
            return " -> " + " ".join(found[:12]) + f" ...(+{len(found) - 12})"
        return (" -> " + " ".join(found)) if found else ""

    def emit_maps(node, depth):
        for key in OUTLINE_MAPS:
            entries = node.get(key)
            if not isinstance(entries, dict) or not entries:
                continue
            if key in GROUPED_MAPS:
                for group, inner in entries.items():
                    emit(depth, f"{key}/{group}")
                    for eid, entry in as_dict(inner).items():
                        emit(depth + 1, str(eid) + attrs(as_dict(entry)) + text(as_dict(entry)))
            else:
                for eid, entry in entries.items():
                    emit(depth, str(eid) + attrs(as_dict(entry)) + text(as_dict(entry)))
        for name, entry in as_dict(as_dict(node.get("identity")).get("systems")).items():
            emit(depth, "identity " + str(name) + attrs(as_dict(entry)))

    def plain(node, depth):
        if isinstance(node, dict):
            if node.get("id") in ids:
                return
            emit_maps(node, depth)
            for key, value in node.items():
                if key not in OUTLINE_SKIP:
                    plain(value, depth)
        elif isinstance(node, list):
            for value in node:
                plain(value, depth)

    def walk(node, depth):
        if isinstance(node, dict):
            nid = node.get("id")
            if isinstance(nid, str) and REF.match(nid):
                emit(depth, nid + attrs(node) + text(node))
                depth += 1
            emit_maps(node, depth)
            for key, value in node.items():
                if key not in OUTLINE_SKIP:
                    plain(value, depth)
            for child in children(node):
                walk(by_id[child], depth)
        elif isinstance(node, list):
            for value in node:
                walk(value, depth)

    if only:
        if only not in by_id:
            emit(0, f"{only} is not an id in the document")
            return
        walk(by_id[only], 0)
        return
    emit(0, "metadata root=" + str(as_dict(doc.get("metadata")).get("root")))
    emit_maps(doc, 0)
    emit(0, "system_contexts")
    for context in doc.get("system_contexts") or []:
        walk(context, 1)


def check_schema_rules(schema, report):
    Draft202012Validator.check_schema(schema)
    for path, node in walk_dicts(schema):
        t = node.get("type")
        if isinstance(t, (str, list)) and "description" not in node:
            report.error(("arch.schema.json",) + path, "schema node with type has no description")


def check_schema(doc, schema, report):
    validator = Draft202012Validator(schema)
    for err in sorted(validator.iter_errors(doc), key=lambda e: list(map(str, e.absolute_path))):
        report.error(tuple(err.absolute_path), f"schema: {err.message}")


class Index:
    def __init__(self, doc, report):
        self.ids = {p: {} for p in PREFIXES}
        self.inline = set()
        self.parent = {}
        self.groups = {}
        for path, node in walk_dicts(doc):
            if path and path[-1] in GROUPED_MAPS:
                for group, entries in node.items():
                    self.groups[group] = path + (group,)
                    for key, entry in as_dict(entries).items():
                        self.add(key, entry, path + (group, key), report)
            elif path and path[-1] in ID_MAPS:
                for key, entry in node.items():
                    self.add(key, entry, path + (key,), report)
            node_id = node.get("id")
            if isinstance(node_id, str):
                if not REF.match(node_id):
                    report.error(path + ("id",), f"id {node_id!r} is not a prefixed ref")
                    continue
                self.add(node_id, node, path, report)
                if node_id.split(".")[0] in INLINE_WHERE_USED:
                    self.inline.add(node_id)
                for child in node.get("children") or []:
                    self.parent[rid(child)] = node_id
        self.types = self.ids["type"]
        self.kinds = {k: v["upstream"] for k, v in self.ids["sc"].items() if isinstance(v.get("upstream"), dict) and "api" in v["upstream"]}

    def add(self, key, entry, path, report):
        m = REF.match(str(key))
        if not m:
            return
        prefix = m.group(1)
        if key in self.ids[prefix]:
            report.error(path, f"id {key} defined twice; use a ref")
        self.ids[prefix][key] = entry if isinstance(entry, dict) else {}

    def spec_fields(self, kind_id):
        m = self.kinds.get(kind_id) or {}
        fields = set(m.get("spec") or [])
        if m.get("embeds") in self.types:
            fields |= set(self.types[m["embeds"]].get("fields") or [])
        return fields

    def object_fields(self, kind_id, part):
        return self.spec_fields(kind_id) if part == "spec" else set((self.kinds.get(kind_id) or {}).get("status") or [])

    def resolve(self, value):
        prefix, rest = REF.match(value).groups()
        ids = self.ids[prefix]
        if prefix == "type":
            name, _, tail = rest.partition(".")
            tid = f"type.{name}"
            if tid not in ids:
                return tid, f"{tid} not defined"
            if tail:
                segs = tail.split(".")
                if len(segs) > 1:
                    return tid, f"{tid} takes one field, got .{tail}"
                if segs[0] not in (ids[tid].get("fields") or []):
                    return tid, f"{tid} has no field {tail}"
            return tid, None
        if prefix in LONGEST_MATCH:
            parts = value.split(".")
            for i in range(len(parts), 1, -1):
                cand = ".".join(parts[:i])
                if cand in ids:
                    tail = parts[i:]
                    if not tail:
                        return cand, None
                    if cand not in self.kinds or tail[0] not in ("spec", "status"):
                        return cand, f"{cand} is not a kind context; cannot take .{'.'.join(tail)}"
                    if len(tail) > 3:
                        return cand, f"{cand} takes .spec|.status[.<field>[.<key>]], got .{'.'.join(tail)}"
                    if len(tail) > 1 and tail[1] not in self.object_fields(cand, tail[0]):
                        return cand, f"{cand} has no {tail[0]} field {tail[1]}"
                    return cand, None
            return value, f"{value} not defined"
        if value not in ids:
            return value, f"{value} not defined"
        return value, None


def check_refs(doc, index, report):
    src_keys = set(as_dict(as_dict(doc.get("metadata")).get("src")))
    referenced = set()
    for path, value in walk(doc):
        if not path or path[0] == "$schema" or not isinstance(value, str):
            continue
        key = path[-1] if isinstance(path[-1], str) else path[-2]
        if key == "id" or path[:2] == ("metadata", "axes"):
            continue
        if REF.match(value):
            target, err = index.resolve(value)
            if err:
                report.error(path, f"unresolved ref: {err}")
            elif path[:2] == ("metadata", "roots") or target in path:
                pass
            else:
                referenced.add(target)
        elif not ({p for p in path if isinstance(p, str)} & PATH_KEYS):
            for m in PROSE_REF.finditer(value):
                token = m.group(0)
                if REF.match(token) and index.resolve(token)[1]:
                    report.warn(path, f"prose mentions undefined {token}")
        if (key == "src" or path == ("metadata", "format")) and path[:2] != ("metadata", "src") and "data" not in path and value not in src_keys:
            report.error(path, f"src {value!r} is not a metadata.src key")
    for group, path in index.groups.items():
        target, err = index.resolve(group) if REF.match(group) else (group, f"{group} is not a ref")
        if err:
            report.error(path, f"crossing group: {err}")
        else:
            referenced.add(target)
    return referenced


def local_path_error(value):
    if value.startswith(("http://", "https://", "/", "..")):
        return None
    rel, _, symbol = value.partition(":")
    rel = rel.rstrip("/")
    target = REPO / rel
    if not target.exists():
        return f"path does not exist in repo: {rel}"
    if not symbol:
        return None
    if not target.is_file():
        return f"symbol {symbol!r} given on a directory: {rel}"
    if not re.search(r"(?<![A-Za-z0-9_])" + re.escape(symbol) + r"(?![A-Za-z0-9_])", target.read_text(errors="replace")):
        return f"symbol {symbol!r} not found in {rel}"
    return None


def check_paths(doc, report):
    for path, value in walk(doc):
        if not isinstance(value, str) or not path:
            continue
        keys = {p for p in path if isinstance(p, str)}
        if path[0] == "metadata":
            wanted = path[1:2] == ("src",)
        elif path[0] == "orchestrators":
            wanted = len(path) > 2 and path[2] in ORCH_PATH_KEYS
        elif path[0] == "upstreams":
            wanted = "executes" in path
        elif path[0] in NO_PATH_SECTIONS or "data" in path:
            wanted = False
        else:
            wanted = bool(keys & PATH_KEYS) or path[-1] == "types"
        if wanted:
            err = local_path_error(value)
            if err:
                report.error(path, err)


def check_data_file_keys(doc, report):
    for path, value in walk(doc):
        keys = [p for p in path if isinstance(p, str)]
        if "data" not in keys or keys[-1] not in FILE_DATA_KEYS or not isinstance(value, str):
            continue
        if BARE_IDENT.match(value):
            report.error(path, f"data.{keys[-1]} is a bare identifier {value!r}; must be an existing path or path:Symbol")
        elif "/" in value and "<" not in value and not value.startswith(("/", "..", "http")):
            err = local_path_error(value)
            if err:
                report.error(path, err)


def check_pin_source(doc, report):
    for path, value in walk(doc):
        if not isinstance(value, str) or path[:1] != ("upstreams",) or "pin" not in path or path[-1] != "source":
            continue
        rel, _, line = value.partition(":")
        target = REPO / rel
        if not target.is_file():
            report.error(path, f"pin.source file does not exist: {rel}")
            continue
        if line:
            n = int(line)
            total = target.read_text(errors="replace").count("\n") + 1
            if not 1 <= n <= total:
                report.error(path, f"pin.source line {n} out of range; {rel} has {total}")


def reached_kind(sc_id, contexts):
    seen = set()
    while sc_id in contexts and sc_id not in seen:
        seen.add(sc_id)
        upstream = contexts[sc_id].get("upstream")
        if isinstance(upstream, dict) and "api" in upstream:
            return upstream["api"].get("kind")
        sc_id = rid(upstream)
    return None


def check_contexts(index, report):
    contexts = index.ids["sc"]
    graph = {}
    for sc_id, entry in contexts.items():
        base = ("system_contexts", sc_id)
        missing = [k for k in TRIPLE if k not in entry]
        if missing:
            report.error(base, f"system context missing {', '.join(missing)}")
        lead = [k for k in entry if k in KEY_ORDER]
        if lead != [k for k in KEY_ORDER if k in entry] or list(entry)[:len(lead)] != lead:
            report.error(base, f"keys must start in order {', '.join(KEY_ORDER)}; got {', '.join(entry)}")
        upstream = rid(entry.get("upstream"))
        overlay = [rid(o) for o in entry.get("overlay") or []]
        if upstream == sc_id or sc_id in overlay:
            report.error(base, "system context refers to itself as upstream or overlay")
        depends = entry.get("depends_on") or []
        introduces = [rid(o) for o in entry.get("introduces") or []]
        graph[sc_id] = [n for n in [upstream, *overlay, *depends, *introduces] if isinstance(n, str) and n in contexts]
        obj = entry.get("object")
        if isinstance(obj, dict):
            kind = reached_kind(sc_id, contexts)
            if not kind:
                report.error(base + ("object",), "upstream chain reaches no kind")
            elif obj.get("kind") != kind:
                report.error(base + ("object", "kind"), f"{obj.get('kind')} != {kind}")
    state = {}

    def visit(node, stack):
        state[node] = 1
        for nxt in graph.get(node, []):
            if state.get(nxt) == 1:
                report.error(("system_contexts", node), f"upstream/overlay/depends_on/introduces cycle: {' -> '.join(stack[stack.index(nxt):] + [nxt])}")
            elif nxt not in state:
                visit(nxt, stack + [nxt])
        state[node] = 2

    for node in graph:
        if node not in state:
            visit(node, [node])


def ancestors(tb_id, parent):
    chain = []
    while tb_id is not None:
        chain.append(tb_id)
        tb_id = parent.get(tb_id)
    return chain


def check_boundaries(index, report):
    boundaries = index.ids["tb"]
    roots = [tb for tb in boundaries if tb not in index.parent]
    if len(roots) != 1:
        report.error(("contexts",), f"execution contexts need exactly one root; found {roots}")
    for tb_id, entry in boundaries.items():
        if "enforced_by" not in entry:
            report.error(("contexts", tb_id, "enforced_by"), "execution context must carry enforced_by; [] when nothing enforces it")
    for sc_id, entry in index.ids["sc"].items():
        tb_id = entry.get("context")
        obj = entry.get("object")
        if not isinstance(obj, dict) or tb_id not in boundaries:
            continue
        if boundaries[tb_id].get("kind") != "namespace":
            report.error(("system_contexts", sc_id, "context"), f"instance with object must sit in a namespace context, not {tb_id}")
        listed = [ws for a in ancestors(tb_id, index.parent) for ws in boundaries[a].get("workspaces") or []]
        if obj.get("workspace") not in listed:
            report.error(("system_contexts", sc_id, "object", "workspace"), f"{obj.get('workspace')} not in workspaces of any ancestor of {tb_id}")


def check_crossings(index, report):
    boundaries = index.ids["tb"]
    for x_id, x in index.ids["x"].items():
        for end in ("from", "to"):
            tb_id = x.get(end)
            if tb_id not in boundaries:
                report.error(("crossings", x_id, end), f"{tb_id} is not an execution context in the boundary tree")


def check_signs(index, report):
    contexts = index.ids["sc"]
    edges = {sc_id: list(e.get("signs") or []) for sc_id, e in contexts.items() if e.get("signs")}
    for sc_id, targets in edges.items():
        for target in targets:
            if target not in contexts:
                report.error(("system_contexts", sc_id, "signs"), f"{target} is not a system context")
                continue
            if target in index.kinds:
                report.error(("system_contexts", sc_id, "signs"), f"{target} is a kind context, not an instance")
                continue
            kind = reached_kind(target, contexts)
            if edges.get(target):
                if kind != "OpenBao":
                    report.error(("system_contexts", sc_id, "signs"), f"intermediate {target} reaches {kind}, not OpenBao")
            elif kind not in WORKLOAD_KINDS:
                report.error(("system_contexts", sc_id, "signs"), f"leaf {target} reaches {kind}, not a workload kind")
    state = {}

    def visit(node, stack):
        state[node] = 1
        for nxt in edges.get(node, []):
            if state.get(nxt) == 1:
                report.error(("system_contexts", node, "signs"), f"signs cycle: {' -> '.join(stack[stack.index(nxt):] + [nxt])}")
            elif nxt not in state:
                visit(nxt, stack + [nxt])
        state[node] = 2

    for node in edges:
        if node not in state:
            visit(node, [node])


def subtree_ids(node):
    found = set()

    def descend(value):
        if isinstance(value, dict):
            if isinstance(value.get("id"), str) and value["id"].startswith("sc."):
                found.add(value["id"])
            for v in value.values():
                descend(v)
        elif isinstance(value, list):
            for v in value:
                descend(v)

    descend(node)
    return found


def check_flows(doc, index, report):
    contexts = index.ids["sc"]
    for path, node in walk_dicts(doc):
        for flow_id, flow in as_dict(node.get("flows")).items():
            owner = node.get("id")
            within = subtree_ids(node)
            for edge in flow.get("edges") or []:
                for end in edge[:2]:
                    if end not in contexts:
                        report.error(path + ("flows", flow_id), f"{end} is not a system context")
                    elif end not in within:
                        report.error(path + ("flows", flow_id), f"{end} is not under {owner}")


def check_risks(index, report):
    crossings = index.ids["x"]
    for r_id, entry in index.ids["r"].items():
        x_ids = entry.get("crossing")
        for x_id in x_ids if isinstance(x_ids, list) else [x_ids]:
            if x_id in crossings:
                ends = {crossings[x_id].get("from"), crossings[x_id].get("to")}
                if entry.get("context") not in ends:
                    report.error(("risks", r_id, "context"), f"{entry.get('context')} is neither end of {x_id} {sorted(ends)}")


def check_risk_coverage(index, report):
    named = set()
    for entry in index.ids["r"].values():
        crossing = as_dict(entry).get("crossing")
        for x_id in crossing if isinstance(crossing, list) else [crossing]:
            if isinstance(x_id, str):
                named.add(x_id)
    for x_id, x in index.ids["x"].items():
        if x.get("auth") == "none" or x.get("gate") == []:
            if x_id not in named:
                report.error(("crossings", x_id), "auth none / gate [] crossing is named by no risk")


def check_principals(index, report):
    boundaries = index.ids["tb"]
    context_of = {sc_id: e.get("context") for sc_id, e in index.ids["sc"].items()}

    def ancestors(tb_id):
        chain = []
        while tb_id is not None:
            chain.append(tb_id)
            tb_id = index.parent.get(tb_id)
        return chain

    for cred_id, cred in index.ids["cred"].items():
        holders = set(cred.get("holder") or [])
        for tb_id, boundary in boundaries.items():
            principals = as_dict(boundary.get("principals"))
            if cred_id not in principals:
                continue
            for ref in principals[cred_id]:
                if ref.startswith("tb."):
                    boundary_ref = ref
                elif ref.startswith("sc."):
                    boundary_ref = context_of.get(ref)
                else:
                    continue
                if boundary_ref and not any(h in ancestors(boundary_ref) for h in holders):
                    report.error(("contexts", tb_id, "principals"), f"{ref} is outside every holder subtree of {cred_id} {sorted(holders)}")


def check_upstreams(index, report):
    unpinned = {"binary_on_path", "sibling_path"}
    named = {as_dict(entry).get("upstream") for entry in index.ids["r"].values()}
    for up_id, entry in index.ids["up"].items():
        if as_dict(entry.get("pin")).get("by") not in unpinned or not entry.get("executes"):
            continue
        if up_id not in named:
            report.error(("upstreams", up_id), "unpinned executing upstream is named by no risk")


def check_kinds(index, report):
    for kind_id, m in index.kinds.items():
        shared = as_dict(m.get("field_types")).get("conditions")
        if shared:
            extra = set(m.get("conditions") or []) - set(index.types.get(shared, {}).get("enum") or [])
            if extra:
                report.error((kind_id, "conditions"), f"not in {shared} enum: {sorted(extra)}")
    for type_id, entry in index.types.items():
        for held in entry.get("held_by") or []:
            parts = held.split(".")
            kind_id, field = ".".join(parts[:3]), parts[-1]
            declared = as_dict(as_dict(index.kinds.get(kind_id)).get("field_types")).get(field)
            if declared != type_id:
                report.error(("types", type_id, "held_by"), f"{held}: kind declares {declared!r}, not {type_id}")


def check_values(doc, index, report):
    def load(rel):
        return yaml.safe_load((REPO / rel).read_text())

    def by_id(node_id):
        for _, node in walk_dicts(doc):
            if node.get("id") == node_id:
                return node
        return {}

    def data(node_id):
        return as_dict(by_id(node_id).get("data"))

    def go_consts(rel, marker):
        return set(re.findall(marker + r"\w*\s*=\s*\"([A-Za-z]+)\"", (REPO / rel).read_text()))

    for kind_id, rel in KIND_MANIFESTS.items():
        base = ("system_contexts", kind_id, "upstream")
        up = as_dict(as_dict(index.ids["sc"].get(kind_id)).get("upstream"))
        names = as_dict(as_dict(load(rel).get("spec")).get("names"))
        api = as_dict(up.get("api"))
        short = names.get("shortNames") or []
        for key, got, want in (("short", api.get("short"), short[0] if short else None), ("resource", api.get("resource"), names.get("plural"))):
            if got != want:
                report.error(base + ("api", key), f"{got} != {rel} names.{key} {want}")
        if up.get("phases"):
            want = go_consts(up["types"], "Phase")
            if set(up["phases"]) != want:
                report.error(base + ("phases",), f"{sorted(set(up['phases']) ^ want)} differ from {up['types']}")
        conds = set(up.get("conditions") or [])
        if conds - (go_consts(up["types"], "Condition") | go_consts(SHARED_TYPES, "Condition")):
            report.error(base + ("conditions",), f"not in {up['types']} or {SHARED_TYPES}: {sorted(conds)}")
        facts = up.get("status_facts") or {}
        if facts:
            if set(facts) != set(up.get("status") or []):
                report.error(base + ("status_facts",), f"keys {sorted(set(facts) ^ set(up.get('status') or []))} differ from status")
            allowed = conds | set(up.get("phases") or []) | {"self", "none"}
            for field, fact in facts.items():
                if fact.get("decides") not in allowed:
                    report.error(base + ("status_facts", field, "decides"), f"{fact.get('decides')!r} is not a phase, a condition, self or none")
        if set(up.get("unset_phases") or []) - set(up.get("phases") or []):
            report.error(base + ("unset_phases",), f"not in phases: {sorted(set(up['unset_phases']) - set(up.get('phases') or []))}")

    for export, rel in APIEXPORTS.items():
        got = sorted(as_dict(data("ov.kcp-api-exports").get("apiexports", {})).get(export, {}).get("serves", []))
        want = sorted(r.get("name") for r in load(rel)["spec"]["resources"])
        if got != want:
            report.error(("ov.kcp-api-exports", export, "serves"), f"{got} != {rel} resources {want}")

    got = sorted(d["metadata"]["name"] for d in yaml.safe_load_all((REPO / MARKET_WORKSPACES).read_text()) if d)
    want = sorted(w["path"].split(":")[-1] for w in by_id("ov.market-workspaces").get("data") or [])
    if got != want:
        report.error(("ov.market-workspaces",), f"{got} != {MARKET_WORKSPACES} {want}")

    for node_id, rel, pattern in (
        ("ov.runtime-workspace", "deploy/demo-deno-runtime.sh", r"WORKSPACE=\$\{WORKSPACE:-(\w+)\}"),
        ("ov.direct-run-workspace", "deploy/demo.sh", r"clusters/root:(\w+)"),
    ):
        m = re.search(pattern, (REPO / rel).read_text())
        if m and data(node_id).get("path") != f"root:{m.group(1)}":
            report.error((node_id, "data", "path"), f"{data(node_id).get('path')} != {rel} {m.group(0)!r}")


def applied_objects(doc, index):
    applied = find(doc, "applied")
    kinds_by_name = {m["api"]["kind"]: k for k, m in index.kinds.items()}
    out = set()
    if applied.get("objects"):
        for entry in index.ids["sc"].values():
            obj = entry.get("object")
            if isinstance(obj, dict) and obj.get("kind") in kinds_by_name:
                out.add(kinds_by_name[obj["kind"]] + ".spec")
    for entry in applied.get("also") or []:
        out.add(entry.get("object"))
    return out


def check_reconcile(doc, index, report):
    recs = index.ids["rec"]
    wakes = find(doc, "wakes")
    applied = applied_objects(doc, index)
    passes, reads, used_wakes, applied_used = {}, {}, set(), set()
    for rec_id, rec in recs.items():
        base = ("reconcile", rec_id)
        kind_id = rec.get("kind")
        if kind_id not in index.kinds:
            report.error(base + ("kind",), f"{kind_id} is not a kind context")
            continue
        for role in ("runner", "target"):
            ref = rec.get(role)
            if ref in (None, "none"):
                continue
            if ref not in index.ids["sc"] or ref in index.kinds:
                report.error(base + (role,), f"{ref} is not a non-kind system context")
        if rec.get("target") is not None and rec.get("target") == rec.get("runner"):
            report.error(base + ("target",), "target equals runner")
        if rec.get("mode") == "reconcile":
            passes.setdefault(kind_id, []).append(rec_id)
            if f"{kind_id}.status" not in (rec.get("writes") or []):
                report.error(base + ("writes",), f"reconcile pass must write {kind_id}.status")
        elif rec.get("unread"):
            report.error(base + ("unread",), "unread is for the reconcile pass only")
        for key, read in as_dict(rec.get("reads")).items():
            m = KIND_OBJECT.match(key)
            if not m or m.group(1) not in index.kinds:
                report.error(base + ("reads", key), f"{key} is not the spec or status of a kind context")
                continue
            fields = index.object_fields(m.group(1), m.group(2))
            for f in read.get("fields") or []:
                if f not in fields:
                    report.error(base + ("reads", key), f"{m.group(1)} has no {m.group(2)} field {f}")
            reads.setdefault(key, set()).update(read.get("fields") or [])
            for i, src in enumerate(read.get("from") or []):
                if src == "applied":
                    applied_used.add(key)
                    if key not in applied:
                        report.error(base + ("reads", key, "from", i), f"applied, but nothing applies {key}")
                    continue
                producer = recs.get(src.get("rec"))
                if producer is not None and key not in (producer.get("writes") or []):
                    report.error(base + ("reads", key, "from", i), f"{src.get('rec')} does not write {key}")
                for w in src.get("wake") or []:
                    used_wakes.add(w)
                    if w not in wakes:
                        report.error(base + ("reads", key, "from", i), f"wake {w} not in reconcile.wakes")
    for w in sorted(set(wakes) - used_wakes):
        report.error(("reconcile", "wakes", w), "wake used by no read")
    for key in sorted(applied - applied_used):
        report.warn(("reconcile", "applied"), f"{key} is applied but no reconciler reads it as applied")
    for kind_id in index.kinds:
        found = passes.get(kind_id, [])
        if len(found) != 1:
            report.error(("reconcile",), f"{kind_id} needs exactly one reconcile pass, has {found}")
            continue
        unread = set(recs[found[0]].get("unread") or [])
        read = reads.get(f"{kind_id}.spec", set())
        spec = index.spec_fields(kind_id)
        base = ("reconcile", found[0], "unread")
        if unread & read:
            report.error(base, f"listed unread but read: {sorted(unread & read)}")
        if unread - spec:
            report.error(base, f"not spec fields of {kind_id}: {sorted(unread - spec)}")
        if spec - read - unread:
            report.error(base, f"spec fields of {kind_id} neither read by any reconciler nor listed unread: {sorted(spec - read - unread)}")


def check_orphans(doc, index, referenced, report):
    roots = set(as_dict(doc.get("metadata")).get("roots") or [])
    covered = set()
    for prefix in ORPHAN_PREFIXES:
        covered |= set(index.ids[prefix]) - referenced - index.inline
    for id_ in sorted(roots & referenced):
        report.error(("metadata", "roots"), f"{id_} is referenced elsewhere; not a root")
    for id_ in sorted(roots - covered - referenced):
        report.error(("metadata", "roots"), f"{id_} is not an unreferenced entry point")
    for id_ in sorted(covered - roots):
        report.warn((id_,), "orphan: not referenced anywhere and not in metadata.roots")
    unclassified = set(MAP_PREFIXES.values()) - set(ORPHAN_PREFIXES) - set(TERMINAL_PREFIXES)
    if unclassified:
        report.error(("metadata",), f"id maps with no orphan rule: {sorted(unclassified)}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("doc", nargs="?", default=str(HERE / "arch.yaml"))
    parser.add_argument("--schema", default=str(HERE / "arch.schema.json"))
    parser.add_argument("--quiet", action="store_true", help="print errors only")
    parser.add_argument("--outline", nargs="?", const="", default=None, metavar="ID", help="print the document's shape (ids, kinds, refs; no values) instead of validating; an optional ID limits it to one subtree")
    args = parser.parse_args()

    report = Report()
    with open(args.schema) as f:
        schema = json.load(f)
    check_schema_rules(schema, report)
    doc = load(args.doc, report)
    if args.outline is not None:
        outline(doc, sys.stdout, args.outline or None)
        return 0
    check_schema(doc, schema, report)
    index = Index(doc, report)
    referenced = check_refs(doc, index, report)
    check_axes(doc, index, report)
    check_paths(doc, report)
    check_pin_source(doc, report)
    check_contexts(index, report)
    check_boundaries(index, report)
    check_crossings(index, report)
    check_signs(index, report)
    check_flows(doc, index, report)
    check_risks(index, report)
    check_risk_coverage(index, report)
    check_principals(index, report)
    check_upstreams(index, report)
    check_kinds(index, report)
    check_values(doc, index, report)
    check_data_file_keys(doc, report)
    check_reconcile(doc, index, report)
    check_orphans(doc, index, referenced, report)

    for path, msg in report.errors:
        print(f"ERROR {path}: {msg}")
    if not args.quiet:
        for path, msg in report.warnings:
            print(f"WARN  {path}: {msg}")
        total = sum(len(v) for v in index.ids.values())
        print(f"{total} ids, {len(report.errors)} errors, {len(report.warnings)} warnings")
    return 1 if report.errors else 0


if __name__ == "__main__":
    sys.exit(main())
