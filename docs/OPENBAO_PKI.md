# The OpenBao kind, and where a workload's certificate comes from

`OpenBao` is the eighth kind in `deno.computer/v1alpha1` and the only one that is
not a workload. It is a handle on a namespace's certificate authority, and this
document is the two things a reader needs to reason about it: the shape of the
hierarchy, and why each level exists.

## The shape

```
OpenBao root namespace            pki/  <- the root CA
  ^                                        the only key that can sign another
  |                                        namespace's authority
OpenBao namespace <labels>.<ns>   pki/  <- the namespace's intermediate
  ^                                        the key every leaf in that namespace
  |                                        is signed by
DenoPod leaf                               <name>.<ns>.<labels>.svc.<domain>
```

A Kubernetes namespace is served by an OpenBao namespace named
`<workspace service labels>.<kubernetes namespace>`: `alice.default` for the
`default` namespace of the workspace at `root:alice`, `root.default` for one in
`root` itself. The labels are the ones the FQDN layer already uses
(`internal/provider/service_dns.go:serviceLabels`), so a workload's name and the namespace
its certificate comes from read as the same path, and two namespaces with the
same name in two workspaces cannot collide.

The path is named in the object rather than derived from it -- a convention, not
a rule the code enforces:

```yaml
apiVersion: deno.computer/v1alpha1
kind: OpenBao
metadata:
  name: openbao
  namespace: default
  finalizers:
    - openbao.deno.computer/namespace
spec:
  namespace: alice.default
```

Naming it means the authority a workload is issued from is readable in the
object rather than implied by the workspace it sits in, and a reorganisation of
workspace paths does not silently move every authority.

## Why a level per namespace and not one CA

One CA signing every leaf would be one key whose leak is every workload's
identity, and one revocation list for all of them. An intermediate per namespace
puts the blast radius at the namespace, which is also the unit kcp gives
isolation: a namespace's authority can be replaced without touching any other
namespace's chain, and a peer that holds the root can still verify a leaf from a
namespace it has never heard of.

The root lives in the OpenBao root namespace and nowhere else. Provisioning a
namespace is two calls that cross that boundary in one direction only: the
namespace generates a CSR in its own mount, the root signs it
(`pki/root/sign-intermediate`), and the namespace installs the result
(`pki/intermediate/set-signed`). The private key of an intermediate never leaves
the namespace it belongs to, and the root's private key never leaves the root
namespace.

## How a DenoPod gets its certificate

`SERVICE_TLS=true` is the opt-in, as it was before OpenBao. At pod start the
provider:

1. lists the `OpenBao` objects in the pod's own Kubernetes namespace **from the
   API**, and takes the path from the spec of the single one it finds;
2. ensures that namespace exists and holds an intermediate signed by the root,
   which is idempotent and cached for `AuthorityTTL` (5 minutes);
3. issues a leaf for the pod's FQDN through the namespace's role, with
   `127.0.0.1` and `::1` as IP SANs.

It then injects three variables, unchanged in name from the mesh CA this
replaced:

| Variable | What it holds |
|---|---|
| `KCP_TLS_CERT` | the leaf, followed by its chain up to the root |
| `KCP_TLS_KEY` | the leaf's private key |
| `KCP_CA_BUNDLE` | the root CA and kcp's own CA, for a peer to trust |

A leaf is served **with its chain** because a peer holds only the root: it does
not carry every namespace's intermediate, and it should not have to be told when
a namespace it has never met is created. `ca.pem`, which `DENO_CERT` points at,
carries the root plus kcp's CA, and is written per run rather than at provider
startup, because the root does not exist until something asks for a certificate.

## Reaching the vault

`--openbao-addr` is a URL, so an `https` one is reached over TLS, and
`--openbao-ca-cert` names the PEM of the CA that listener's certificate chains
to. The CA is the whole of the client's trust: there is no fallback to the
system roots, because a vault's certificate is issued by whoever runs the vault
and a client that fell back would trust every public CA for it. Drop the flag
against an https address and the provider reports it as a provisioning failure
on the object -- `tls: failed to verify certificate: x509: certificate signed by
unknown authority` -- rather than reaching the listener anyway.

The live tests cover both directions: one runs the pinned OpenBao with `-dev-tls`
and provisions a namespace's authority over https, another runs it in plain
development mode, and both end with a DenoPod's leaf verified against the root.

## What happens when there is no authority

Three degradations, all of them deliberate, all of them leaving the workload
running and serving plain HTTP rather than failing to start:

- **No `--openbao-addr`.** The provider has no provisioner and skips the TLS
  block entirely. This is what every example that does not set `SERVICE_TLS`
  already relies on.
- **No `OpenBao` object in the pod's namespace.** The pod has no authority to be
  issued from. `authorityFor` reports which namespace and why.
- **Two `OpenBao` objects in one namespace.** The provider refuses to choose: the
  object goes not-Ready with the `Ambiguous` condition, and a workload in that
  namespace is not issued a certificate. One namespace, one authority.

The list in step 1 is the one place in this provider that does not read from the
informer cache, and it is deliberate. A list against an APIExport virtual
workspace can come back holding one workspace's objects and not another's --
measured with three bound workspaces, where the pod cache held all three and this
kind's held one, two, or none as the reflector re-listed. Every other reader
tolerates a stale cache because it is reporting on an object it was handed; this
one decides which authority signs a certificate, and a pod that gets the wrong
answer serves plain HTTP and says nothing about why. The ambiguity check in the
reconciler makes the same call for the same reason, so the condition it writes
and the refusal a pod meets cannot disagree.

Deleting an `OpenBao` object deletes its OpenBao namespace, and with it the
intermediate and everything issued under it. That is the declarative contract
and it is worth being deliberate about: the leaves of running pods stop verifying
when their namespace's authority goes.

## Where the code is

| File | What it holds |
|---|---|
| `impl/openbaoclient` (kcp-libs) | the HTTP client: namespaces, mounts, and the PKI calls. The only place that knows the wire format. |
| `impl/pkiprovisioner` + `abc/pki` (kcp-libs) | the hierarchy: ensure the root, ensure a namespace's intermediate and role, issue a leaf. Caches, so a pod start is one round trip after the first. |
| `internal/provider/reconcile_openbao.go` | the kind's reconciler: provisioning, status, the ambiguity check, deletion. |
| `internal/provider/service_dns.go` | `issueFor`, which is where a pod's environment is given its certificate. |
| `deploy/openbao-apiresourceschema.yaml` | the schema kcp serves the kind from. |

## Two things about the API that cost time to find

- **`X-Vault-Namespace` is absent at the root and present everywhere else.** A
  call inside a namespace carries it; creating a namespace, deleting one, and
  signing an intermediate at the root do not. `/sys/mounts` is per namespace, so
  a mount read that always asked the root reports a mount the namespace does not
  have, and the namespace's own name then routes nowhere.
- **IP addresses go in `ip_sans`, not `alt_names`.** An address written into
  `alt_names` is read as a DNS name, fails the hostname check, and is refused
  with `subject alternate name 127.0.0.1 not allowed by this role`, which reads
  like a policy problem and is a field-placement one. One more: `/cert/ca`
  answers with the certificate and no serial, so `CASerial` reads the serial out
  of the PEM. A read that trusted a serial field reports that a mount which has a
  CA has none, and the next start generates a second root that the first root's
  leaves do not chain to.

## The OpenBao the tests run

`third_party/openbao` is a submodule at v2.7.0. `internal/baoembed` is a second Go
module that imports `github.com/openbao/openbao/v2/internal/command` and builds a
`baoembed` binary from that checkout; the live tests run it in development mode.

The module exists because of Go's internal rule: an import of a path under
`internal/` is allowed only from a package whose own path sits under the parent.
Declaring the module path `github.com/openbao/openbao/v2/denokcp` is what makes
the import legal. Keeping it a separate module also keeps OpenBao's dependency
tree out of `deno-kcp`'s `go.mod`, which it would otherwise dominate.

OpenBao's README says importing the application is unsupported and always has
been. It is what the tests do, and the alternative -- testing against whatever
`bao` happens to be on `PATH` -- tests a version nobody pinned.
