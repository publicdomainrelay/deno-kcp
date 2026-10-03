# deno-kcp Open Architecture

## Status

Draft. `arch.yaml` validates against `arch.schema.json`.

## Description

`arch.yaml` encodes this repo as trees of system contexts
(dffml `0009-Open-Architecture`). Every context is `{upstream, overlay,
orchestrator}`. Everything else is described in kcp, Deno, OpenBao and
this repo's own terms. `arch.schema.json` is the format, this file is its
intent, `validate.py` checks both.

```
python3 .tools/open-architecture/validate.py          # errors, warnings, summary
python3 .tools/open-architecture/validate.py --quiet  # errors only
python3 .tools/open-architecture/validate.py --outline                 # the whole shape: every id, its kind/axis and its refs, no values
python3 .tools/open-architecture/validate.py --outline sc.deno-kcp     # one subtree
```

Exit 1 on any error. Warnings (orphans not listed in `metadata.roots`,
applied objects no reconciler reads) never fail; the document is kept at zero.

`--outline` is a printer, not a model: one line per id, the tree indented, and
the refs each node points at (an inline child is printed rather than repeated,
so a node's refs are the ones that leave its subtree). It prints no `data`
block, no `evidence` list and no value that is not an id, a ref or a closed
enum, so it is safe to read in a terminal. An optional id argument limits it to
that subtree - use it to jump into a tree the whole-document outline is too
tall to show at once.

## Context

- kcp is the upstream, the `deno.computer` kinds are the overlay, the
  provider orchestrates them.
- Each kind (DenoPod, DenoRun, ...) is a new system context whose upstream is
  its own manifest (APIResourceSchema + Go types), overlay `[]`.
- Each example under `deploy/examples/` is an instance context: upstream the
  kind context, first overlay the example manifest itself
  (`{id, manifest, data}`), orchestrator what runs it (the runner that starts
  its process, else the provider).
- The threat model is a living overlay on the repo context
  (`ov.living-threat-model`): execution contexts, credentials, crossings,
  risks. Every system context names its execution context in `context`.
- Open Architecture rules followed: upstream is the document itself when it
  is already a domain specific manifest; an overlay is applied to its
  upstream when given; the manifest data present is used; an orchestrator
  SHOULD be inspected against the top level system context's policy before
  it executes.
- Machine first: short keys, refs by id, enums, exact paths. No free-text
  notes: a condition, default, order or threshold is a key. One fact uses one
  key and one vocabulary: a run's resulting state is `outcome`, never `state`;
  a binary resolution order is `order`; `pin.by`, `decides`, `severity`,
  `cluster`, `mode`, `stored`, `wake.by`, `detached`, `already_up`, `use` and
  `listen.protocol` values are closed enums, listed in the schema.

## Intent

A consumer MUST read the document as follows. `arch.schema.json` is the
format; anything it does not allow is drift, change the schema in the same
change. Every key the format defines is named below and carries a description
in the schema; an open map (`data`, a reconciler's `rules`, `reconcile.model`,
or the keys an upstream manifest mirrors) holds code facts in the same
machine-first style rather than format keys.

- `metadata`: `$schema` is the schema this file validates against,
  `apiVersion` the document format version, `generated` the date written,
  `axes` the four axes below, `root` is the entry context, `format` the
  specification followed, `layout` how the trees are laid out. `roots` lists
  entry points
  besides the top-level trees that nothing references; a listed root that is
  referenced is an error, and `roots` MUST be exactly the unreferenced,
  non-inline entries of the orphan-checked maps. Every id map is classified:
  `upstreams`, `orchestrators`, `types`, `credentials` (plus the `tb.*` tree)
  are orphan-checked, so an unreferenced entry warns unless it is a listed
  root; `risks`, `crossings`, `flows` and `reconcilers` are terminal, reached
  by containment in their parent, and are not orphan-checked. An id map whose
  prefix is in neither set is an error, so a new map cannot skip the rule.
  `src` keys are the only valid values for every
  `src` field.
- `axes`: the four ways the document is sliced, each named in `metadata.axes`
  by the section, ref prefix or id suffix that carries it; the validator
  errors on an axis whose carrier is empty, so the mapping cannot rot.
  `trust_boundaries` is the `tb.*` tree of execution contexts under
  `ov.living-threat-model.contexts`. `systems` is the `system_contexts`
  section, one tree per system. `services` is the contexts whose id ends
  `.service`, the sibling service a workload serves. `concepts` is the eight
  `sc.kind.*` contexts plus the `type.*` shared types; every kind context
  carries `axis`, its lifecycle (`long_running`, `one_shot`, `binding`).
- Refs: a string `<prefix>.<id>` with prefix in
  `up orch type cred ov sc tb x r rec flow` is a ref and MUST resolve. An id
  is defined once: as a key of a map (`upstreams`, `orchestrators`, `types`,
  `credentials`, `crossings`, `risks`, `flows`, `reconcilers`, wherever it
  sits) or as the `id` of a node (system contexts, overlays, execution
  contexts). Every `id` MUST be such a ref. A kind context ref may
  continue with `.spec|.status[.<field>[.<key>]]`, a type ref with `.<field>`;
  the first field MUST exist and the tail MUST NOT go deeper than that form,
  so a stale tail is an error rather than a silent truncation.
- `upstreams`, `orchestrators`, `types` hold only entries used more than
  once; a single-use one is written inline where used (with its `id` for
  orchestrators and types, without for an external upstream).
- `upstreams` (`up.*`): external artifacts. Paths are relative to this repo.
  `executes` names the call or import site(s) that run or import it. `lang` is
  the implementation language and `modules` / `go_sdk` the Go module set it is
  built against. `pin.by`
  says how the version in use is fixed (`go_mod`, `git_submodule`, or unpinned
  `binary_on_path` / `sibling_path`); `pin.source` is `path:LINE` where a pinned
  version is written; `pin.rev` and `pin.commit` are the pinned tag and commit;
  `override` is the env var that swaps the binary;
  `preflight: path_only` says the preflight target checks the bare name on PATH
  and ignores the override; `go` is the Go version the artifact's go.mod
  declares. The pin is data only: nothing enforces the version it names.
- `orchestrators` (`orch.*`): what runs a context. `path` and `tests` MUST
  exist. `module` is a separate Go module and `imports` the package it exists
  to import across that module boundary. `stop` is its companion stop script
  and `stop_state` the state directory that script defaults to, when it differs
  from `state`; `composes` lists the orchestrators it invokes; `sets_env` the
  env vars it sets for its children; `per_workspace` the files it applies once
  per workspace. Test tiers are orchestrators keyed by
  Makefile `target`; `gate` names
  the orchestrator that decides skip versus fail. `cmd` is the command line,
  `bin` the resolution order for a binary it builds (a bare name, or an ordered
  list), `detached` how the process outlives the script, `ready` what the start waits
  for, `already_up` when a second start does nothing. `cluster` says whether
  the target starts kine and kcp itself (`own`), drives a cluster someone else
  started (`existing`), or needs none (`none`); `fails` how it fails;
  `used_by` lists the files that invoke it.
- `types` (`type.*`): shared Go types of `api/v1alpha1` (struct fields or
  string enum); `held_by` lists the kind fields holding one and MUST match
  those kinds' `field_types` (only fields the kind's own `field_types`
  declares: a kind that embeds a shared type names it in `embeds`, and that
  type carries the `field_types` for the inherited fields). `default` is the
  value in effect when the field holding the type is absent, `defaults` a
  field-to-default map (an unlisted field defaults to its Go zero value),
  `zero_default` says every field is the Go zero value, `unread` names fields
  no code path reads a value from, and `validate` the inputs the `gate`
  rejects. `permission` is the nested per-permission type (`type`, `fields`,
  and `used_by`, the parent fields that use it). A default established by code
  names that code under the `code`
  map: a kubebuilder marker would be the authority, the Go zero value
  otherwise.
- `system_contexts` (`sc.*`): a list of trees (`metadata.layout`). A child
  context or overlay (`ov.*`) sits inline, with its `id`, in the `upstream`,
  `overlay` or `introduces` of the context that first uses it, and is an id
  ref everywhere else. An upstream that is a document in this repo is an
  inline map: a kind (`manifest`, `types`, `api`, `spec`, `status`,
  `field_types`, `phases`, `conditions`, `condition_facts`, `status_facts`,
  `unset_phases`, `finalizer`;
  field names are the Go json names, `api` carries `group`, `version`, `kind`,
  `resource`, `schema`, `export` and `scope`, and `api.short` is the resource's
  `names.shortNames` entry,
  `conditions` lists the condition types set and `condition_facts` keys the
  same types to the code that sets them (`by`), the reasons each holds True
  or False (`true_reasons`, `false_reasons`), `cleared_by` the code that
  removes one instead of re-setting it (absent when it is only ever re-set),
  and `replaced_each_pass` when the list is rebuilt every pass,
  `status_facts` keys the `status` fields to what writes each (`by`), the
  transition it changes on (`when`), and the condition or phase a reader
  decides the same fact from (`decides`: `self` when the field is itself the
  decision, a condition type it mirrors, `none` when nothing is decided from
  it), with `also` naming a second field that must be read with it because
  neither alone carries the fact; `unset_phases` lists declared phase values
  no code path writes; and
  `finalizer` names the teardown the kind waits on: `name`, `set_by` (whether
  the example manifest or the provider puts it on the object) and the `code`
  sites that add its name and the sites that remove it), a provider component
  or interface (`code` plus what the code
  does, `implements` the interface context), or a script/workflow
  (`manifest` + `field`); `runtime` names the interpreter, never the
  upstream. An overlay is `data` applied to `target` (absent = the enclosing
  context's upstream), read from an example `manifest` or from code
  `source`; `data` mirrors that file, `applied_by` names who applies it and
  `purpose` why it exists. `id`, the triple and `context`
  are required, keys start `id, upstream, overlay, orchestrator, context,
  object`. `object.kind` MUST equal the kind reached by following
  `upstream`. Upstream/overlay/depends_on/introduces MUST be acyclic. A context with
  `object` MUST sit in a `kind: namespace` execution context whose ancestors
  list `object.workspace`. `owns`/`owned_by` only where the provider itself
  sets the ownerReference. `signs` walks the PKI top-down: OpenBao server
  context -> OpenBao instances (intermediates) -> pods (leaves). A `signs`
  target MUST be an instance context, never a kind; a target that itself
  carries `signs` is an intermediate and MUST reach the OpenBao kind, a target
  without is a leaf and MUST reach a workload kind (`DenoPod`, `DenoRun`); the
  walk is acyclic. `serves`
  lists the HTTP paths the context must serve for the examples to work: the
  path, the `required_by` refs that call or probe it, and the `manifest` that
  requires it. Other context keys: `binds` the implementation a kind fronts,
  `libs` the upstream libraries its code is built on, `toolchain` the upstream
  toolchain it is built with, `spec_from` the kind field whose value the
  provider copies into this context's spec, `output` the primary output field
  path, `calls`/`outputs` the endpoints called and output keys produced,
  `cancellation` the paths that cancel it (`via`), and `also_run_by` the other
  orchestrators that start it the same way. Children of
  an example tree are listed in the order its script applies them;
  `depends_on` names what the script waits for first. `harness` lists the test
  files under a test context: `file`, the `funcs` whose names are the
  invariants checked, `drives` (the example manifests or code paths it
  exercises), `creates` (the contexts or kinds it creates objects of) and
  `role` for a helper that holds no test function. The trees read upstream to
  downstream: `system_contexts` is the repo, then the examples, then the test
  tiers in the order they run (the unit-tier double, the integration cluster,
  the live cluster); within a tree a child is listed in the order it comes up,
  and a context that creates or names another (a kind's `owns`, a runtrigger's
  job) is listed before it.
- `ov.living-threat-model` (last overlay of `sc.deno-kcp`):
  - `contexts` (`tb.*`): execution contexts, one nested tree (the root, then
    `children`). `kind` says what draws the line; `runs_in` names the process
    context under a logical one. A logical cluster carries `workspaces`, the
    kcp workspaces it stands for; a view context carries `spans`, what it
    covers; `isolation` says what its children share (`os user`, `filesystem`);
    `entered_when` the condition under which a process lands here instead of
    its parent's process context; `policy_from` the field whose value sets a
    sandbox's rules. `contains` lists overlays held there
    (system contexts join via their own `context`). `principals` maps each
    credential to who authenticates inside with it. Every `tb.*` carries
    `enforced_by`, naming the mechanisms that draw its line: `[]` means
    nothing enforces it, and that is the inventory of enforcement gaps.
    `listen` is the listener it serves (`addr`, `scheme`,
    `client_auth`, and the `protocol`). `storage` is where its state lives
    (`kind`, `mode: dev`, `unsealed` when it comes up with no unseal key).
  - `addresses`: every address form the system uses, keyed by name. `form`
    is the template, `written_by` the contexts or code that form it, `read_by`
    who resolves or connects to it, `precedence` the sources that set it in
    order (first wins), `unresolved` what happens when it does not resolve,
    and `code` the sites that build, inject or rewrite it. `route` on a
    crossing is the same fact at the call site.
  - `surfaces`: everything the system leaves behind that a human or another
    program can read, keyed by name. `written_by` who writes it, `at` the
    location template, `when` when it is written, `contains` what a reader
    finds there, `survives` how long it outlives its writer (`none` for a
    stream consumed as written, `process_exit` for a file that stays,
    `forever` for state that outlives the cluster), `read_by` who can read it
    and `mode` the file mode. The per-workload run directory and the files the
    runner writes are the provider model's `run_dirs`, not a surface.
  - `failures`: every way the system fails, keyed by name. `trigger` the
    conditions it happens under, `signal` what a human or another program can
    observe, `alerts` what raises an alert (`[]` when nothing does), and
    `risk` the risk recorded for it when one exists; a failure with an empty
    `signal` is one nothing observes, and its `risk` is why it is known.
  - `credentials` (`cred.*`): `holder` = contexts holding the secret,
    `grants` = contexts it opens or signs for. The lifecycle is four
    machine facts: `issued_by` who creates it, `issued_at` the moment it
    comes into being, `ttl` how long it lives (a duration, `{from, default}`
    when a flag sets it, `{never: true}` when nothing expires it), and
    `reissue` the event that makes a new one in place of it (`none` when it
    is made once). `renewal` is `none` when no code path renews it in place
    while it is valid. `at` is a location template, or
    `{precedence, file_default, else_create}` when several sources are tried
    in order; `file_mode` is the mode of the file it rests in; `carried_as`
    lists the env var, flag, header or file names it travels under. A `stored`
    list without `file` is the explicit statement that the secret is never
    written to disk. `holder` is where the material sits and `principals` is
    who authenticates with it inside a boundary: the two answer different
    questions, so a holder need not appear in any `principals` map, but a
    principal named by a `tb.*` or `sc.*` ref MUST lie inside the subtree of
    one of that credential's holders.
  - `crossings` (`x.*`): grouped under the system context, orchestrator or
    overlay code that performs them; each is
    `from, to, carries, auth, gate, code`: the performer runs in `from` and
    reaches `to`, `carries` is sent, `returns` comes back. `from` and `to` MUST
    be execution contexts in the boundary tree. `auth` is a
    credential or `none`, `gate: []` means unchecked. Optional: `when`
    (conditions, all must hold), `route` (address form, endpoint sources in
    precedence order, or case -> destination), `into` (where carried data
    lands), `omits` (fields held but not sent).
  - `risks` (`r.*`), ordered high, medium, low, info: `severity`, `context`,
    optional `crossing` or `upstream`, one-line `finding`, `evidence`
    (`path:Symbol`). When `crossing` is set, `context` MUST be its `from` or
    `to`; when `upstream` is set the risk is about that external artifact, and
    every unpinned executing upstream (`pin.by` `binary_on_path` /
    `sibling_path` with `executes`) MUST be named by one. Every crossing with
    `auth: none` or `gate: []` MUST be named by a risk whose `crossing` is that
    crossing. A risk is a verified
    fact about current code, not a recommendation.
  - `identity`: the identity systems this repo touches, keyed by name. Each is
    `system` (`x509` | `did`), `proves` what holding it establishes, `names`
    what it names, `checked_by` who can check it, optional `minted_by` and
    `minted_at` where it comes into being, `implemented_here` when code in this
    repo produces it, `signature_verified` when this repo verifies a signature
    over it, `methods` the methods it offers (each with `basis` and
    `implemented_here`), and `check` what a checker reads from it: the `reads`
    fields, the `decides` read a verdict comes from, and the `records_only`
    fields read and recorded but not acted on. `meets` lists the value forms
    the systems share: `value_form`, `carries` the fields or objects holding
    it, `value` the literal placeholder, `forwarded_to` where it is handed,
    `assumed_by` the examples that assume it, and `unread_by` the contexts that
    hold it without reading it.
- `sc.deno-kcp-provider.upstream.reconcile`: the provider's own code is its
  upstream; `reconcile` is what that code does, as reconcilers (`rec.*`). One `mode: reconcile`
  pass per kind plus `mode: finalize` teardowns. Every `mode: reconcile` pass
  reads its own status: `reads` carries `sc.kind.<kind>.status` listing the
  status fields the pass reads, from `{rec: <itself>, wake: [informer]}`,
  because the decider copies its whole status and the provider
  compares it before writing. A `scope`-marked read lists every field read
  from that kind, its own object's included. `reads` maps a whole
  `<kind>.spec|status` to the `fields` read and `from`: `applied` (an object
  applied from outside, see `applied`) or `{rec, wake}` (another reconciler
  writes it; `wake` names how this one is re-run). `from.rec` MUST write that
  object. `unread` lists own spec fields nothing reads; every spec field MUST
  be read or unread. A reconcile pass MUST write its own status. A
  `mode: finalize` pass carries `teardown`: `order` (the steps it runs, in
  order), `deletes` (what it removes outside kcp, a process or an OpenBao
  namespace, each with code) and `if_gone` (the absences it treats as already
  removed). A pass carries its own `deletes` for the objects it removes that
  are neither a status write nor its finalize teardown: `what` (the kind or
  object deleted), `by` the pass that deletes it, `when` the conditions, the
  `trigger` field and `base` status field of the delay with `default` and
  `negative`, `siblings` for the other objects of the kind that go with it,
  `then` the steps in order, what happens to the `process`, and `already_gone`
  when a missing object is treated as already removed. The run directory a
  deletion leaves behind is a fact of the provider model (`run_dirs`), not of
  each deletion.
  `runner`
  is the context whose code does the pass's I/O, `target` the process or
  server it acts on beyond kcp objects. Both MUST resolve to non-kind system
  contexts, and `target` MUST differ from `runner`. `scope`
  marks reads wider than one named object. `wakes`: informer event, label
  `fanout`, `direct` enqueue, `requeue`, each with code and, for a requeue,
  `after` its delay. A pass may carry `admission`, the gate in front of it
  (`by`, `capacity`, `policy`, and `lease: counting`), and `select`, how a list
  read is narrowed (`label`, `equals`, `pick`). `model`:
  provider-wide facts with code. `model.run_dirs` describes the runner's
  per-workload directory: `dir_mode`, each file's `mode` and `secret`
  (`true` when it holds credential material, `false` when it does not, `may`
  when its contents are whatever the tenant or workload put there), a
  `workload_written` entry for files the workload itself writes there, and
  `read_by` the contexts that can read it.
- `flows` (`flow.*`) on a context: application-level `[from, to, attrs]`
  edges between the contexts under it (the market e2e protocol on
  `sc.example.atproto-market`). `attr.op` is the operation, `url` the env
  var holding the endpoint, `transport` the wire, `auth` the credential
  presented (a `cred.*` ref, or `none` when the call carries none), `when`
  the condition the call happens under. Both endpoints MUST be system contexts
  under the flow's owning context. Provider-internal flow is
  `reconcile`; crossings carry the trust view.
- Paths in `source`, `file`, `code`, `evidence`, `manifest`, `types`, upstream
  `executes`, and orchestrator `path` fields MUST exist in the repo. A
  `path:Symbol` suffix
  is an identifier (dotted allowed, no expressions) and MUST occur as a whole
  word in that file (the validator greps it). A value under `data` held by a
  key naming a file (`script`, `entry`, `file`, `manifest`) MUST be an existing
  repo path or a `path:Symbol`, never a bare identifier.
