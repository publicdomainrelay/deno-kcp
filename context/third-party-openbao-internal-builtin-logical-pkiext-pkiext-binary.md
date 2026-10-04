# Context: third-party-openbao-internal-builtin-logical-pkiext-pkiext-binary

Repository: `deno-kcp`

This context exists so the OpenBao PKI extension can exercise real ACME issuance against a real multi-node Vault/OpenBao cluster inside docker rather than against a mock. It provides the fixture layer: cluster bootstrap and topology inspection, DNS and host-file plumbing so ACME clients can resolve challenge domains, mount creation for PKI and ACME, and API-level operations for building certificate hierarchies and ACME configuration. The acme_test.go subtests are the consumers; everything here is test-support code guarded by the `BAO_BINARY` environment variable.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/acme_test.go` file acme_test.go (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/acme_test.go)
- `file:third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_cluster.go` file pki_cluster.go (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_cluster.go)
- `file:third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_mount.go` file pki_mount.go (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_mount.go)
- `function:9eaae345fdc57ae816fc40eb0786fa08` function NewVaultPkiClusterWithDNS (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_cluster.go)
- `function:c997624527a7b677725dde6d9e51cd3f` function NewVaultPkiCluster (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_cluster.go)
- `method:2192940a606ebfc5254769062c6fef69` method VaultPkiMount.UpdateAcmeConfig (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_mount.go)
- `method:272023ce0f6d0ba54f2c0b9d231b6b76` method VaultPkiCluster.AddNameToHostFiles (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_cluster.go)
- `method:2bbff707a0712d921b3c3e76f0d1d9d6` method VaultPkiCluster.GetListenerCACertPEM (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_cluster.go)
- `method:2dd0b692b59a28efdce91a8b728cfe36` method VaultPkiCluster.CreateMount (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_cluster.go)
- `method:463b87cdab66460f04c2e946fa0ea5a9` method VaultPkiMount.GenerateIntermediateInternal (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_mount.go)
- `method:4d9d1aca602ade0801d4626b02307809` method VaultPkiCluster.GetNonActiveNodes (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_cluster.go)
- `method:5592a94865af2c0cc40fdfc166cfad44` method VaultPkiCluster.RemoveDNSRecordsOfTypeForDomain (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_cluster.go)
- `method:5a05da1ae3644ea9574ed6c9adda789f` method VaultPkiCluster.GetContainerNetworkName (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_cluster.go)
- `method:7471a9800221a22f6c320f240f8c2b08` method VaultPkiCluster.RemoveDNSRecord (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_cluster.go)
- `method:765f4e34a7317219b406da4484a562a9` method VaultPkiMount.GetEabKey (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_mount.go)
- `method:766c97cabad6def992956a67235dec8c` method VaultPkiCluster.GetActiveNode (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_cluster.go)
- `method:782cfb8f1fcdedacfe38281788b9c47f` method VaultPkiMount.UpdateIssuer (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_mount.go)
- `method:81e31d3976a83aa28bd7a05ffa29f4e1` method VaultPkiCluster.RemoveDNSRecordsForDomain (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_cluster.go)
- `method:892278ed6844d08f864a570fd92fcfa6` method VaultPkiCluster.RemoveAllDNSRecords (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_cluster.go)
- `method:894299a2bb5070bf1ce58e073443c268` method VaultPkiCluster.AddDNSRecord (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_cluster.go)
- `method:8984fe72b80f3626cd5d97bc983a5d7a` method VaultPkiMount.ImportBundle (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_mount.go)
- `method:8fd3fd478b2bf259c102cb3e9bccb4cb` method VaultPkiMount.UpdateDefaultIssuer (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_mount.go)
- `method:9a8536a708a604691e34aa6126267a31` method VaultPkiCluster.Cleanup (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_cluster.go)
- `method:9be16e343bf52f3d11d9093c06054b8b` method VaultPkiCluster.AddHostname (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_cluster.go)
- `method:a0bb53a10c45f7f7b9756e37a8d20217` method VaultPkiMount.UpdateClusterConfig (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_mount.go)
- `method:c6f4d78b33dfc2896722daa9acdebf3a` method VaultPkiCluster.GetActiveContainerID (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_cluster.go)
- `method:cbc8183511af527b6fa02e64bdb66b07` method VaultPkiMount.SignIntermediary (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_mount.go)
- `method:d1fd934cc7870f5c5ae76e3c1b4b6098` method VaultPkiMount.UpdateRole (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_mount.go)
- `method:d51bc803931d37dae021f30d24b6cc48` method VaultPkiMount.GenerateRootInternal (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_mount.go)
- `method:dcaccd9c31d26ee0674de4e393597b13` method VaultPkiCluster.CreateAcmeMount (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_cluster.go)
- `method:e383767a1aa2d4027fcf4ca479fce31d` method VaultPkiMount.GetCACertPEM (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_mount.go)
- `method:e59db6b960c0e5b47bc518975cd9d5ef` method VaultPkiCluster.GetActiveClusterNode (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_cluster.go)
- `method:f02d0147d48ec1c0baa749dac63b63f9` method VaultPkiCluster.GetActiveContainerHostPort (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_cluster.go)
- `method:f637bfa6f3165a25614fa806acc5451a` method VaultPkiMount.UpdateClusterConfigLocalAddr (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_mount.go)
- `method:ff56478b91a4db4309b8983b4af1669c` method VaultPkiCluster.GetActiveContainerIP (third_party/openbao/internal/builtin/logical/pkiext/pkiext_binary/pki_cluster.go)

_2 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
