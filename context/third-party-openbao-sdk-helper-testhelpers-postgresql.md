# Context: third-party-openbao-sdk-helper-testhelpers-postgresql

Repository: `deno-kcp`

This context exists so database plugin tests in OpenBao can obtain a real PostgreSQL instance, or a replication cluster, without hand-rolling Docker plumbing. It wraps sdk/helper/docker into reusable fixtures: container startup with readiness probing, a variant that skips readiness probing so retry logic in the container handler can be exercised, credential variants, a repmgr variant for multi-node replication tests, and a Cluster type that models primary/replica topology with slot-based base backup, promotion, and primary removal for failover tests.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/helper/testhelpers/postgresql/postgresqlhelper.go` file postgresqlhelper.go (third_party/openbao/sdk/helper/testhelpers/postgresql/postgresqlhelper.go)
- `function:3d2c9f3f0163d1e8e94a3f8576ccc97c` function DefaultClusterConfig (third_party/openbao/sdk/helper/testhelpers/postgresql/postgresqlhelper.go)
- `function:5e0727b2713bf72814c005c103873492` function PrepareTestContainer (third_party/openbao/sdk/helper/testhelpers/postgresql/postgresqlhelper.go)
- `function:6027711959b4c7fc94543900419ef075` function TestContainerNoWait (third_party/openbao/sdk/helper/testhelpers/postgresql/postgresqlhelper.go)
- `function:76bb2663f5605df1430bceeb1f166190` function PrepareTestContainerWithPassword (third_party/openbao/sdk/helper/testhelpers/postgresql/postgresqlhelper.go)
- `function:93c7140781ab96b439a9b73341149ad1` function RestartContainer (third_party/openbao/sdk/helper/testhelpers/postgresql/postgresqlhelper.go)
- `function:c4eca0d8a516127f03a45135a1b0d8a8` function PrepareTestContainerRepmgr (third_party/openbao/sdk/helper/testhelpers/postgresql/postgresqlhelper.go)
- `function:cdae3af70fb00ded7fc722df0f220b96` function PrepareTestContainerRaw (third_party/openbao/sdk/helper/testhelpers/postgresql/postgresqlhelper.go)
- `function:d5042eec516b76adade2c3580af94589` function PrepareTestContainerWithVaultUser (third_party/openbao/sdk/helper/testhelpers/postgresql/postgresqlhelper.go)
- `function:f396199f3a62550ad597962a97ac47f3` function StopContainer (third_party/openbao/sdk/helper/testhelpers/postgresql/postgresqlhelper.go)
- `method:042e9b92418ed493d01f7d550345806f` method Node.InternalURL (third_party/openbao/sdk/helper/testhelpers/postgresql/postgresqlhelper.go)
- `method:0f77c5f4ab16934dbcb77d3916910a86` method Cluster.PromoteNode (third_party/openbao/sdk/helper/testhelpers/postgresql/postgresqlhelper.go)
- `method:266795a31156798078ecf13c730c089b` method Cluster.Cleanup (third_party/openbao/sdk/helper/testhelpers/postgresql/postgresqlhelper.go)
- `method:4de8f897d99362b1bf3f726dcf264513` method Cluster.AddNode (third_party/openbao/sdk/helper/testhelpers/postgresql/postgresqlhelper.go)
- `method:62c8d1e4f860fb14913fdf08a94d7822` method Node.Network (third_party/openbao/sdk/helper/testhelpers/postgresql/postgresqlhelper.go)
- `method:79bd8af96c7e3fcd66d2622a3956cbc9` method Cluster.CleanupWithContext (third_party/openbao/sdk/helper/testhelpers/postgresql/postgresqlhelper.go)
- `method:969093956a3bbfb17d0ad85be8eaf684` method Node.Cleanup (third_party/openbao/sdk/helper/testhelpers/postgresql/postgresqlhelper.go)
- `method:c8ec22e50b5a59f7258b74b5b33eb529` method ClusterConfig.NewCluster (third_party/openbao/sdk/helper/testhelpers/postgresql/postgresqlhelper.go)
- `method:d19fb8eeb0337494a3598e64d6790cf4` method Node.NetworkIP (third_party/openbao/sdk/helper/testhelpers/postgresql/postgresqlhelper.go)
- `method:df77aff5d248437ca0d0824be0d2a345` method Node.Client (third_party/openbao/sdk/helper/testhelpers/postgresql/postgresqlhelper.go)
- `method:ee075a426170ac8ac17f4f07c4f45d1b` method Cluster.RemovePrimary (third_party/openbao/sdk/helper/testhelpers/postgresql/postgresqlhelper.go)
- `struct:279ddc37516b70d8ed3ec7ecb9cfc6b6` struct Node (third_party/openbao/sdk/helper/testhelpers/postgresql/postgresqlhelper.go)
- `struct:b631760469bf210d0400f9996c42e3c2` struct ClusterConfig (third_party/openbao/sdk/helper/testhelpers/postgresql/postgresqlhelper.go)
- `struct:f60335da0cc488dada2978d6d82ccf50` struct Cluster (third_party/openbao/sdk/helper/testhelpers/postgresql/postgresqlhelper.go)
<!-- SPECD_MANAGED_END -->
