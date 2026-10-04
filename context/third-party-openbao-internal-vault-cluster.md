# Context: third-party-openbao-internal-vault-cluster

Repository: `deno-kcp`

_(empty: write what this context is for)_

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/cluster/cluster.go` file cluster.go (third_party/openbao/internal/vault/cluster/cluster.go)
- `file:third_party/openbao/internal/vault/cluster/inmem_layer.go` file inmem_layer.go (third_party/openbao/internal/vault/cluster/inmem_layer.go)
- `file:third_party/openbao/internal/vault/cluster/inmem_layer_test.go` file inmem_layer_test.go (third_party/openbao/internal/vault/cluster/inmem_layer_test.go)
- `file:third_party/openbao/internal/vault/cluster/simulations.go` file simulations.go (third_party/openbao/internal/vault/cluster/simulations.go)
- `file:third_party/openbao/internal/vault/cluster/tcp_layer.go` file tcp_layer.go (third_party/openbao/internal/vault/cluster/tcp_layer.go)
- `function:22163f32ef7794864b5402a7c9fe7568` function NewInmemLayer (third_party/openbao/internal/vault/cluster/inmem_layer.go)
- `function:3d4f64af8fe4777e3954b6a402a3b584` function NewListener (third_party/openbao/internal/vault/cluster/cluster.go)
- `function:a778a9ed5d0c450df106838ce10a60cc` function NewInmemLayerCluster (third_party/openbao/internal/vault/cluster/inmem_layer.go)
- `function:b2a650e7e67bb0d0fbb7074d1c867468` function NewTCPLayer (third_party/openbao/internal/vault/cluster/tcp_layer.go)
- `interface:834b6ca810f0eaa7a814e2fddfba7010` interface NetworkListener (third_party/openbao/internal/vault/cluster/cluster.go)
- `interface:90400cb02dd8f7f94942824f00c72e8f` interface NetworkLayer (third_party/openbao/internal/vault/cluster/cluster.go)
- `interface:9089e97d8de5eb5805f5829944023a1f` interface ClusterHook (third_party/openbao/internal/vault/cluster/cluster.go)
- `interface:93af514afcd58017b78185393350c137` interface NetworkLayerSet (third_party/openbao/internal/vault/cluster/cluster.go)
- `interface:bb0c5cd23712cec05b59ffc77715de03` interface Handler (third_party/openbao/internal/vault/cluster/cluster.go)
- `interface:bd3e4088a240967d4b66db6d1e1f4238` interface Client (third_party/openbao/internal/vault/cluster/cluster.go)
- `method:006c61c90de4117e9f05db48df2eff39` method ClusterHook.TLSConfig (third_party/openbao/internal/vault/cluster/cluster.go)
- `method:0149dd4e6474ea3931bb20fd622b4bdc` method InmemLayer.SetReaderDelay (third_party/openbao/internal/vault/cluster/inmem_layer.go)
- `method:0960b7824a1af9b1fe813ed0adc77ace` method Listener.Addr (third_party/openbao/internal/vault/cluster/cluster.go)
- `method:13ef0416fcfbc777e60868168fafd8d9` method NetAddr.String (third_party/openbao/internal/vault/cluster/cluster.go)
- `method:1ad96db05d9ea35fb6547715d2b9863d` method Listener.Run (third_party/openbao/internal/vault/cluster/cluster.go)
- `method:1c0880dadecea6d2d04889f96231d667` method ClusterHook.GetContextDialerFunc (third_party/openbao/internal/vault/cluster/cluster.go)
- `method:1d21b2e78fc94d5f4e9eb979f3fb32b6` method inmemListener.SetDeadline (third_party/openbao/internal/vault/cluster/inmem_layer.go)
- `method:210448717e033ad3e418a43bdb98cc46` method TCPLayer.DialContext (third_party/openbao/internal/vault/cluster/tcp_layer.go)
- `method:24059c9506c000d62619017425f941c1` method InmemLayer.DisconnectAll (third_party/openbao/internal/vault/cluster/inmem_layer.go)
- `method:243617987e12d09f0de6d09eb6f06775` method InmemLayer.SetConnectionCh (third_party/openbao/internal/vault/cluster/inmem_layer.go)
- `method:2569ba408af039d57dc11c32acaf035b` method InmemLayer.DialContext (third_party/openbao/internal/vault/cluster/inmem_layer.go)
- `method:282388beef133d32eddd3952b25f87c6` method delayedReader.Read (third_party/openbao/internal/vault/cluster/simulations.go)
- `method:285e1dbde717c1fd8256815c067f572e` method InmemLayerCluster.SetConnectionCh (third_party/openbao/internal/vault/cluster/inmem_layer.go)
- `method:2aada24dfb8c8caf9d054817e299e52e` method InmemLayerCluster.Layers (third_party/openbao/internal/vault/cluster/inmem_layer.go)
- `method:30dc18847ed58bf97548927f1408318f` method InmemLayer.Close (third_party/openbao/internal/vault/cluster/inmem_layer.go)
- `method:3a2023f0c86b59a90478b9de3d00b8b3` method Listener.TLSConfig (third_party/openbao/internal/vault/cluster/cluster.go)
- `method:3b1fb4cd77d3f3ff05273d174087a26c` method Client.ClientLookup (third_party/openbao/internal/vault/cluster/cluster.go)
- `method:3bac8b3f3b1ab9fcf1f0b39fb24e4255` method Handler.Stop (third_party/openbao/internal/vault/cluster/cluster.go)
- `method:42f5b0986712402d162f5c45dc42e343` method TCPLayer.Close (third_party/openbao/internal/vault/cluster/tcp_layer.go)
- `method:4ac1dd819078ec721551ebe3ef4e889b` method InmemLayer.Listeners (third_party/openbao/internal/vault/cluster/inmem_layer.go)
- `method:5ad3c17eec12ba8b96c89f71a530c3b4` method ClusterHook.AddClient (third_party/openbao/internal/vault/cluster/cluster.go)
- `method:5e9ada630cdf4c92b8090ca01161f4c5` method Listener.Handler (third_party/openbao/internal/vault/cluster/cluster.go)
- `method:5e9e5b01d53e72c0da7c2b1dbe87e39a` method ClusterHook.RemoveClient (third_party/openbao/internal/vault/cluster/cluster.go)
- `method:5fa4add7ec5d60e130b6a6991d014549` method InmemLayer.Addrs (third_party/openbao/internal/vault/cluster/inmem_layer.go)
- `method:63c47babb063cedfdf113ce3e2daaf4c` method InmemLayer.Connect (third_party/openbao/internal/vault/cluster/inmem_layer.go)
- `method:664f81cd4cc456942ceae6e2031cea7f` method deadlineError.Error (third_party/openbao/internal/vault/cluster/inmem_layer.go)
- `method:6b5c4c11151cedf4062682003ac6aa1b` method InmemLayer.SetForceTimeout (third_party/openbao/internal/vault/cluster/inmem_layer.go)
- `method:6d3f1227fea70b40f16850f71086db52` method inmemListener.Addr (third_party/openbao/internal/vault/cluster/inmem_layer.go)
- `method:746c638dd06359c022304e46058cd1b1` method Listener.StopHandler (third_party/openbao/internal/vault/cluster/cluster.go)
- `method:74bba6576ab4f4d037fbf549872339ac` method InmemLayerCluster.SetReaderDelay (third_party/openbao/internal/vault/cluster/inmem_layer.go)

_42 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
