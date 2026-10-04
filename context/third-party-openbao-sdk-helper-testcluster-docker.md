# Context: third-party-openbao-sdk-helper-testcluster-docker

Repository: `deno-kcp`

The context exists so that tests can stand up disposable, multi-node OpenBao clusters in Docker and drive failure scenarios against them without hand-managing containers. It defines the cluster and node lifecycle (create, start, stop, pause, upgrade, cleanup), the fault-injection surface (partition, unpartition, network delay), the secret accessors tests need to unseal or authenticate (barrier keys, recovery keys, root token), the transport accessors (TLS config, API client, CA PEM file), and the storage abstraction that lets a cluster run on in-memory or PostgreSQL-backed storage, including a mapper that assigns one database per node index.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/helper/testcluster/docker/cert.go` file cert.go (third_party/openbao/sdk/helper/testcluster/docker/cert.go)
- `file:third_party/openbao/sdk/helper/testcluster/docker/environment.go` file environment.go (third_party/openbao/sdk/helper/testcluster/docker/environment.go)
- `file:third_party/openbao/sdk/helper/testcluster/docker/storage.go` file storage.go (third_party/openbao/sdk/helper/testcluster/docker/storage.go)
- `function:28c1ae209259dc140e8b6f1ab62653bf` function NewTestDockerCluster (third_party/openbao/sdk/helper/testcluster/docker/environment.go)
- `function:2e5fea03573e7b814aa230b7a707ee25` function NewPostgreSQLClusterStorage (third_party/openbao/sdk/helper/testcluster/docker/storage.go)
- `function:936d9e6c5a7eacb61e5335e8b8da2678` function DefaultOptions (third_party/openbao/sdk/helper/testcluster/docker/environment.go)
- `function:94d4f70ff9e68bab894962876d43901c` function NewDockerCluster (third_party/openbao/sdk/helper/testcluster/docker/environment.go)
- `function:b11ad9ba34e8f7186f73f594b0d05ffe` function NewPostgreSQLStorage (third_party/openbao/sdk/helper/testcluster/docker/storage.go)
- `function:f3307f66cd7aae87db19bbba3c2686f8` function NewCertificateGetter (third_party/openbao/sdk/helper/testcluster/docker/cert.go)
- `function:fc4dac195ec0fd4f6df4adea8a5454f2` function NewStaticPostgreSQLStorage (third_party/openbao/sdk/helper/testcluster/docker/storage.go)
- `method:19d6f580b2568f327888c4851c392479` method DockerCluster.GetRootToken (third_party/openbao/sdk/helper/testcluster/docker/environment.go)
- `method:1a1831cd3a4b59fdd90d3c0f129e78d7` method DockerClusterNode.Upgrade (third_party/openbao/sdk/helper/testcluster/docker/environment.go)
- `method:1fe4fb82c37fc5ed16a36558781a4491` method PostgreSQLClusterStorage.ForNode (third_party/openbao/sdk/helper/testcluster/docker/storage.go)
- `method:2b5ec2ba8e60f0f9d882bccbb730d31a` method DockerCluster.AddNode (third_party/openbao/sdk/helper/testcluster/docker/environment.go)
- `method:339f59f0ac055a6c5d293e1c7e669b40` method DockerCluster.Nodes (third_party/openbao/sdk/helper/testcluster/docker/environment.go)
- `method:3877831773497cccf32c4b21103359ac` method CertificateGetter.Reload (third_party/openbao/sdk/helper/testcluster/docker/cert.go)
- `method:3bcae64b76e30bef4a9b3e2b040e6612` method DockerCluster.SetBarrierKeys (third_party/openbao/sdk/helper/testcluster/docker/environment.go)
- `method:449be918154ffed2cbceb9310a683bf2` method DockerCluster.GetRecoveryKeys (third_party/openbao/sdk/helper/testcluster/docker/environment.go)
- `method:46631632e37e56991909ed6b5810cf45` method DockerClusterNode.Stop (third_party/openbao/sdk/helper/testcluster/docker/environment.go)
- `method:488ae022b3f7534270f33caa4b925ecd` method InmemStorage.Opts (third_party/openbao/sdk/helper/testcluster/docker/storage.go)
- `method:4cb674d5a0367efa3aefd711329c5bf5` method PostgreSQLStorage.Client (third_party/openbao/sdk/helper/testcluster/docker/storage.go)
- `method:54fe38cf73d487daa79352d8cd5d6789` method DockerClusterNode.PartitionFromCluster (third_party/openbao/sdk/helper/testcluster/docker/environment.go)
- `method:57ecdd62b8c053bf0c479a4d226f2a3e` method DockerCluster.Cleanup (third_party/openbao/sdk/helper/testcluster/docker/environment.go)
- `method:5e5e96cbc57d1caae6550cda2022e7fa` method DockerClusterNode.Start (third_party/openbao/sdk/helper/testcluster/docker/environment.go)
- `method:6a8f0aabda16a476d8da3fd2e3917ea2` method DockerCluster.GetCACertPEMFile (third_party/openbao/sdk/helper/testcluster/docker/environment.go)
- `method:6d5c753355e962689831604bc6e2f5c1` method PostgreSQLStorage.Cleanup (third_party/openbao/sdk/helper/testcluster/docker/storage.go)
- `method:7d90c111a015e81f3dac7373d8a40d84` method PostgreSQLStorage.Type (third_party/openbao/sdk/helper/testcluster/docker/storage.go)
- `method:7d9ece15fddd462a1f8b56aa9222062a` method DockerCluster.GetBarrierOrRecoveryKeys (third_party/openbao/sdk/helper/testcluster/docker/environment.go)
- `method:87fedcf4f99fb571793a72aaa176ebf3` method DockerCluster.NamedLogger (third_party/openbao/sdk/helper/testcluster/docker/environment.go)
- `method:8c0c30f4ee5fbe13543d54975a5489e2` method InmemStorage.Cleanup (third_party/openbao/sdk/helper/testcluster/docker/storage.go)
- `method:9098203feb9525cbc1d047183e46da47` method InmemStorage.Type (third_party/openbao/sdk/helper/testcluster/docker/storage.go)
- `method:96eadda598d362f8fec3edf525f48666` method DockerClusterNode.AddNetworkDelay (third_party/openbao/sdk/helper/testcluster/docker/environment.go)
- `method:a0a6081590128bee572efd82778bebb0` method DockerCluster.GetBarrierKeys (third_party/openbao/sdk/helper/testcluster/docker/environment.go)
- `method:a6248f205895acafb18c2558cdd62da7` method DockerClusterNode.TLSConfig (third_party/openbao/sdk/helper/testcluster/docker/environment.go)
- `method:b0cd317f5590439e93c034608699390a` method DockerClusterNode.UnpartitionFromCluster (third_party/openbao/sdk/helper/testcluster/docker/environment.go)
- `method:bd37b86a1aa40dd0d107b60b45a67019` method DockerCluster.SetRecoveryKeys (third_party/openbao/sdk/helper/testcluster/docker/environment.go)
- `method:bfb62b87fd1f0f8ef909dd47c48e250b` method DockerCluster.ClusterID (third_party/openbao/sdk/helper/testcluster/docker/environment.go)
- `method:ca575a7aa36d4939219c37e39e2b688f` method LogConsumerWriter.Write (third_party/openbao/sdk/helper/testcluster/docker/environment.go)
- `method:cb9382be91b28bb321a2c5e010f85f61` method PostgreSQLClusterStorage.Type (third_party/openbao/sdk/helper/testcluster/docker/storage.go)
- `method:cef17f21ac315d39b6b0ef6943d33a52` method DockerClusterNode.APIClient (third_party/openbao/sdk/helper/testcluster/docker/environment.go)
- `method:cef9e3e4b1e71d4e9f3499c8d52a42ff` method DockerClusterNode.Pause (third_party/openbao/sdk/helper/testcluster/docker/environment.go)

_18 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
