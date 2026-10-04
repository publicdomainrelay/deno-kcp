# Context: third-party-openbao-internal-helper-testhelpers-seal

Repository: `deno-kcp`

The context exists so that seal-migration and related tests can get a working transit seal without hand-building a cluster: one call starts a single-core in-memory OpenBao with transit mounted, and two methods create the transit key and produce the vault.Seal that wraps it. It isolates all the cluster, mount, wrapper-config and CA-cert plumbing behind a small helper so test bodies only name a key and receive a seal. It is not production code; it is a test helper, and its contract is that it fails the test through testing.T rather than returning setup errors for the cluster and key steps.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/helper/testhelpers/seal/sealhelper.go` file sealhelper.go (third_party/openbao/internal/helper/testhelpers/seal/sealhelper.go)
- `function:6154c2b5f91b0a3797a19e9242a685d0` function NewTransitSealServer (third_party/openbao/internal/helper/testhelpers/seal/sealhelper.go)
- `method:5879ba126d86f2800029a1a2453177c5` method TransitSealServer.MakeKey (third_party/openbao/internal/helper/testhelpers/seal/sealhelper.go)
- `method:f9f3bd86a14fd197bb1b7d6ab12600a1` method TransitSealServer.MakeSeal (third_party/openbao/internal/helper/testhelpers/seal/sealhelper.go)
- `struct:d74013fb41678c8875095071efe2fe8f` struct TransitSealServer (third_party/openbao/internal/helper/testhelpers/seal/sealhelper.go)
<!-- SPECD_MANAGED_END -->
