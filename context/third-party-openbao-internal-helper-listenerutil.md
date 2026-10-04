# Context: third-party-openbao-internal-helper-listenerutil

Repository: `deno-kcp`

_(empty: write what this context is for)_

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/helper/listenerutil/bufconn.go` file bufconn.go (third_party/openbao/internal/helper/listenerutil/bufconn.go)
- `file:third_party/openbao/internal/helper/listenerutil/listener.go` file listener.go (third_party/openbao/internal/helper/listenerutil/listener.go)
- `file:third_party/openbao/internal/helper/listenerutil/listener_test.go` file listener_test.go (third_party/openbao/internal/helper/listenerutil/listener_test.go)
- `file:third_party/openbao/internal/helper/listenerutil/tls_acme.go` file tls_acme.go (third_party/openbao/internal/helper/listenerutil/tls_acme.go)
- `file:third_party/openbao/internal/helper/listenerutil/tls_acme_test.go` file tls_acme_test.go (third_party/openbao/internal/helper/listenerutil/tls_acme_test.go)
- `file:third_party/openbao/internal/helper/listenerutil/tls_autoreload.go` file tls_autoreload.go (third_party/openbao/internal/helper/listenerutil/tls_autoreload.go)
- `file:third_party/openbao/internal/helper/listenerutil/tls_autoreload_test.go` file tls_autoreload_test.go (third_party/openbao/internal/helper/listenerutil/tls_autoreload_test.go)
- `function:243cbb2c120f333647af6a079f7272ce` function NewCertificateGetter (third_party/openbao/internal/helper/listenerutil/tls_acme.go)
- `function:5510d98d2ab4d1fbcff27a3dcc84253f` function NewTLSReloadListener (third_party/openbao/internal/helper/listenerutil/tls_autoreload.go)
- `function:8d308b72974ac29a34f96bf99a2c94ea` function TLSConfig (third_party/openbao/internal/helper/listenerutil/listener.go)
- `function:a82b61c4d5b2635503aaae5496eb6481` function NewBufConnWrapper (third_party/openbao/internal/helper/listenerutil/bufconn.go)
- `function:ef7cace533196f8046df8aecdabca006` function UnixSocketListener (third_party/openbao/internal/helper/listenerutil/listener.go)
- `interface:4a249a739fb26e7b33bdd06aaccd8520` interface ReloadableCertGetter (third_party/openbao/internal/helper/listenerutil/tls_acme.go)
- `method:0b6c089432a914aa0f61ba9279b84029` method ReloadableCertGetter.GetCertificate (third_party/openbao/internal/helper/listenerutil/tls_acme.go)
- `method:0e078a8bd948f6ce462f5f6b4b07b00a` method zapHclCore.Sync (third_party/openbao/internal/helper/listenerutil/tls_acme.go)
- `method:506a7d9b4523e0d642bb5c388725de81` method ACMECertGetter.Reload (third_party/openbao/internal/helper/listenerutil/tls_acme.go)
- `method:534bb51f784d89dad3a8f22eba0a4202` method ACMECertGetter.HandleHTTPChallenge (third_party/openbao/internal/helper/listenerutil/tls_acme.go)
- `method:60acd45c90430863dcb73616a5764bd5` method ACMECertGetter.ALPNProtos (third_party/openbao/internal/helper/listenerutil/tls_acme.go)
- `method:6f0874635cf31f04e9abb3bc6b8e4f12` method tlsReloadListener.Close (third_party/openbao/internal/helper/listenerutil/tls_autoreload.go)
- `method:6fcfa9c9313be3dd282730630cc2ae71` method rmListener.Close (third_party/openbao/internal/helper/listenerutil/listener.go)
- `method:7094d903392bc0f180ed44c61e77ca28` method ACMECertGetter.Close (third_party/openbao/internal/helper/listenerutil/tls_acme.go)
- `method:80950f0bf26ac573a83d76b841f108ac` method BufConnWrapper.Dial (third_party/openbao/internal/helper/listenerutil/bufconn.go)
- `method:93f7278092bb45ca17a3fde4a6372ab9` method ReloadableCertGetter.Reload (third_party/openbao/internal/helper/listenerutil/tls_acme.go)
- `method:94b94801595d5e9238661e8d6a613726` method zapHclCore.Write (third_party/openbao/internal/helper/listenerutil/tls_acme.go)
- `method:9b045bb7e2f4878dfb93e81312e98c87` method ACMECertGetter.GetCertificate (third_party/openbao/internal/helper/listenerutil/tls_acme.go)
- `method:abedc81857554c1e51b7a810322a28bd` method BufConnWrapper.DialContext (third_party/openbao/internal/helper/listenerutil/bufconn.go)
- `method:af6c5d2b3f786880c1182f3d38622cdd` method zapHclCore.Enabled (third_party/openbao/internal/helper/listenerutil/tls_acme.go)
- `method:bce781b1ee92d45e198fbc225eb20939` method zapHclCore.Check (third_party/openbao/internal/helper/listenerutil/tls_acme.go)
- `method:e59b1974e9ea9d869607cb0324187cb8` method zapHclCore.With (third_party/openbao/internal/helper/listenerutil/tls_acme.go)
- `struct:01f8eea6c1bc5ccb81a3105665bc2100` struct UnixSocketsConfig (third_party/openbao/internal/helper/listenerutil/listener.go)
- `struct:69069c4c5bdb6e0af39fb1a2d70de474` struct BufConnWrapper (third_party/openbao/internal/helper/listenerutil/bufconn.go)
- `struct:6ebe737b4dbbb5ee1564c516b701d770` struct Listener (third_party/openbao/internal/helper/listenerutil/listener.go)
- `struct:d76bb3411f325b131d6ff332588c116c` struct ACMECertGetter (third_party/openbao/internal/helper/listenerutil/tls_acme.go)
<!-- SPECD_MANAGED_END -->
