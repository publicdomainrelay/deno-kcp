# Context: third-party-openbao-internal-helper-forwarding

Repository: `deno-kcp`

This context exists so a request that arrives at one OpenBao node can be serialized, shipped to another node, and replayed there with no observable difference. The forwarding package is that wire contract: the protobuf types define what travels, GenerateForwardedRequest and ParseForwardedRequest define the two directions of the translation, and RPCResponseWriter defines the symmetric path back, letting a remote handler write an HTTP response that is later reconstructed on the origin node. It is vendored third-party code inside deno-kcp, so the spec records the behavior deno-kcp depends on rather than behavior deno-kcp owns.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/helper/forwarding/types.pb.go` file types.pb.go (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `file:third_party/openbao/internal/helper/forwarding/util.go` file util.go (third_party/openbao/internal/helper/forwarding/util.go)
- `file:third_party/openbao/internal/helper/forwarding/util_test.go` file util_test.go (third_party/openbao/internal/helper/forwarding/util_test.go)
- `function:0529bc4b1fcefbc7fdbc2346d8fd9213` function NewRPCResponseWriter (third_party/openbao/internal/helper/forwarding/util.go)
- `function:082e936a1c00963155cc670a2fe46313` function ParseForwardedRequest (third_party/openbao/internal/helper/forwarding/util.go)
- `function:b8568c161515348cfb8ef657bace5561` function GenerateForwardedRequest (third_party/openbao/internal/helper/forwarding/util.go)
- `method:05d9a1031d8bdf3f1a3fb793cd8acd22` method Request.GetHeaderEntries (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:061890f7b7cd27f07cea82ea910e9d65` method URL.ProtoReflect (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:0907af7baf3826385ff446e5982625a8` method Request.GetUrl (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:1347bb480406752b342a722de55b02a2` method RPCResponseWriter.Header (third_party/openbao/internal/helper/forwarding/util.go)
- `method:13a6261d028d646098b751550c2f615a` method HeaderEntry.GetValues (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:15a22bfef564e01876fe7e0df8d28f38` method Request.ProtoMessage (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:166db75dde33ccd2881abb8315b2decb` method HeaderEntry.Reset (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:247026ba0f0c70414219936367e326b5` method RPCResponseWriter.Write (third_party/openbao/internal/helper/forwarding/util.go)
- `method:2949e079d49b8b2b2bc96a567b5f0304` method HeaderEntry.ProtoMessage (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:38daa9079160fb9dcb07e2ea4c11a91c` method RPCResponseWriter.WriteHeader (third_party/openbao/internal/helper/forwarding/util.go)
- `method:3a51396072f3854c4c686fd86b3ba62f` method Response.ProtoMessage (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:3d8b88f0b5f09ec6105369579c27b8c0` method URL.GetRawQuery (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:401c02c7f59adec9c29666d7af4cf15d` method URL.Reset (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:4c3b777458d7c60a3de9241da96c5760` method RPCResponseWriter.Body (third_party/openbao/internal/helper/forwarding/util.go)
- `method:4cc358c15f9d99ada9addfb32ff450b9` method URL.GetPath (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:5787534743a49a88d2a1966189e87c35` method URL.String (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:59998409e2e1385fc8cc9fa7c5b207ca` method URL.GetRawPath (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:5f0d0ac0f7e5beee1ea6fbc18cce15be` method Request.ProtoReflect (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:70b5b987b382ff167cae83aa609119b7` method Response.GetBody (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:72b312d54025afb1b09c9c3498b1c8bc` method HeaderEntry.ProtoReflect (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:7c463df0e506427717da44c2b3fc585f` method RPCResponseWriter.StatusCode (third_party/openbao/internal/helper/forwarding/util.go)
- `method:855ca89d5a821c2733f018f4e9af0189` method Request.GetHost (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:89a086791e0375bcea9f76454c2f5071` method Response.Descriptor (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:8fee0003c423b0aac55bff87ac6aa8b5` method Response.ProtoReflect (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:919e77e4f3f03f833306fb3b13dc271d` method URL.GetScheme (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:98491b48464b9a184d94381466d3c463` method Response.GetLastRemoteWal (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:9976a1d446de524031e8eca4d9e9fd36` method URL.ProtoMessage (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:a06f0de6ab12dced65208463d457b269` method Response.GetStatusCode (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:a8eabbca4c18d736e03bd730006f71b8` method Response.GetHeaderEntries (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:a96091a913d16a253b68b1bff7872e26` method HeaderEntry.String (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:afa4f96f5512e360b5dc5f7836318191` method Request.GetRemoteAddr (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:b30736d14e51cbc76996664ab1181e04` method Request.Reset (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:b8ec8af3f3d2d681181f6d8d1d90082c` method HeaderEntry.Descriptor (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:bff9fb60c92b273439d0c5e2e672ed99` method Response.String (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:c04e90ea67db87e4bb4390ae9aea2960` method URL.GetHost (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:d39f028f6b6a3bd1bdb83d4d9bb1ec35` method bufCloser.Close (third_party/openbao/internal/helper/forwarding/util.go)
- `method:d4cf1e41267a5fd399e2a2dd53d237c7` method Response.Reset (third_party/openbao/internal/helper/forwarding/types.pb.go)
- `method:dbc0b9359bf5e8994d60516ac37b2559` method URL.GetOpaque (third_party/openbao/internal/helper/forwarding/types.pb.go)

_12 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
