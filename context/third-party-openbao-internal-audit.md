# Context: third-party-openbao-internal-audit

Repository: `deno-kcp`

_(empty: write what this context is for)_

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/audit/audit.go` file audit.go (third_party/openbao/internal/audit/audit.go)
- `file:third_party/openbao/internal/audit/format.go` file format.go (third_party/openbao/internal/audit/format.go)
- `file:third_party/openbao/internal/audit/format_json.go` file format_json.go (third_party/openbao/internal/audit/format_json.go)
- `file:third_party/openbao/internal/audit/format_json_test.go` file format_json_test.go (third_party/openbao/internal/audit/format_json_test.go)
- `file:third_party/openbao/internal/audit/format_test.go` file format_test.go (third_party/openbao/internal/audit/format_test.go)
- `file:third_party/openbao/internal/audit/formatter.go` file formatter.go (third_party/openbao/internal/audit/formatter.go)
- `file:third_party/openbao/internal/audit/hashstructure.go` file hashstructure.go (third_party/openbao/internal/audit/hashstructure.go)
- `file:third_party/openbao/internal/audit/hashstructure_test.go` file hashstructure_test.go (third_party/openbao/internal/audit/hashstructure_test.go)
- `function:376b505131db62fa9bbb477cf7acd5c1` function HashRequest (third_party/openbao/internal/audit/hashstructure.go)
- `function:42ef4700f6e217b28c6d1edd344ae593` function HashWrapInfo (third_party/openbao/internal/audit/hashstructure.go)
- `function:4ccd60a576f8ea73994d61927166709d` function HashStructure (third_party/openbao/internal/audit/hashstructure.go)
- `function:60d1929ca7075c2de1f0b57733c0abcc` function NewTemporaryFormatter (third_party/openbao/internal/audit/format.go)
- `function:65f63968a54e3a6a036c304235793f90` function HashString (third_party/openbao/internal/audit/hashstructure.go)
- `function:d6efa5e0eac024519ba054edb053d5aa` function HashResponse (third_party/openbao/internal/audit/hashstructure.go)
- `function:ee7174e5166f767948eada2027879352` function HashAuth (third_party/openbao/internal/audit/hashstructure.go)
- `interface:23c825ce647c9812d840833aa38a0658` interface Backend (third_party/openbao/internal/audit/audit.go)
- `interface:6a5eec8047829c0c5bc34eb14f08bfb9` interface Formatter (third_party/openbao/internal/audit/formatter.go)
- `interface:e63f743f08baad296a54e41616c836bb` interface AuditFormatWriter (third_party/openbao/internal/audit/format.go)
- `method:0822276a47ec0f91db5c37e2d09a9f9a` method JSONFormatWriter.WriteRequest (third_party/openbao/internal/audit/format_json.go)
- `method:0d02854465c1cb0437d918f06da7a813` method hashWalker.Enter (third_party/openbao/internal/audit/hashstructure.go)
- `method:32dd1ae3ae6fd8f479c03186d25c7919` method Backend.Invalidate (third_party/openbao/internal/audit/audit.go)
- `method:37cbf8689e8eb68c8c3115d5dae9742d` method AuditFormatWriter.WriteResponse (third_party/openbao/internal/audit/format.go)
- `method:442a99c51a0c6063a23f51a22761ead5` method hashWalker.Primitive (third_party/openbao/internal/audit/hashstructure.go)
- `method:58e85ff15e1cefa152f5d6a6be9ae0bc` method hashWalker.MapElem (third_party/openbao/internal/audit/hashstructure.go)
- `method:5a403e47e6e79c05be32ee9bbf861a5d` method Backend.LogResponse (third_party/openbao/internal/audit/audit.go)
- `method:6143d753818759479d079b783f08f044` method JSONFormatWriter.WriteResponse (third_party/openbao/internal/audit/format_json.go)
- `method:61705e5d4da223dc06bff50079bece16` method hashWalker.Slice (third_party/openbao/internal/audit/hashstructure.go)
- `method:75bc2961eee3ea15ed6f5f7df9e8b494` method hashWalker.Map (third_party/openbao/internal/audit/hashstructure.go)
- `method:785bdb8bbf0a7bb1a7ae47b60cb9e494` method AuditFormatWriter.Salt (third_party/openbao/internal/audit/format.go)
- `method:8118533452ddf75b7d46a9f9103c7e94` method Backend.LogTestMessage (third_party/openbao/internal/audit/audit.go)
- `method:8e5ddb8540b43e121955facc7a6913fd` method Backend.Reload (third_party/openbao/internal/audit/audit.go)
- `method:9de2b6bd047b7f0dbf282e413f5e955f` method hashWalker.Exit (third_party/openbao/internal/audit/hashstructure.go)
- `method:a7dbd6949fcb390c2f1f31eb5abdda07` method Formatter.FormatRequest (third_party/openbao/internal/audit/formatter.go)
- `method:b718fbf8320836492f2a4f6cb31f7c8c` method Backend.LogRequest (third_party/openbao/internal/audit/audit.go)
- `method:ba986a0a56bca6e430b0b9238ea5332d` method Formatter.FormatResponse (third_party/openbao/internal/audit/formatter.go)
- `method:c056772154a009aadf08b07400cd96a0` method JSONFormatWriter.Salt (third_party/openbao/internal/audit/format_json.go)
- `method:c4cba218c2b876bee3e4432e07448e32` method AuditFormatter.FormatRequest (third_party/openbao/internal/audit/format.go)
- `method:dc5c23a8d5b62c4427df8d3a4bc4019b` method AuditFormatter.FormatResponse (third_party/openbao/internal/audit/format.go)
- `method:ee41c765c3eb45cc649b844606c7defe` method Backend.GetHash (third_party/openbao/internal/audit/audit.go)
- `method:ef509901b843a16f09883ee11736ad03` method AuditFormatWriter.WriteRequest (third_party/openbao/internal/audit/format.go)
- `method:f06df9356da06ee81af806f2c3c58309` method hashWalker.SliceElem (third_party/openbao/internal/audit/hashstructure.go)
- `struct:16c537701052343971118579ab743897` struct BackendConfig (third_party/openbao/internal/audit/audit.go)
- `struct:1aea965b64c60bd43a12ccb264151fb3` struct AuditResponseEntry (third_party/openbao/internal/audit/format.go)
- `struct:5134606d51df693c8140708e7e4cedc1` struct JSONFormatWriter (third_party/openbao/internal/audit/format_json.go)
- `struct:741695d429d289a7aa4dcccfc349269d` struct AuditNamespace (third_party/openbao/internal/audit/format.go)
- `struct:78233e32820c7bb1b4062d3295a7a923` struct AuditRequestEntry (third_party/openbao/internal/audit/format.go)
- `struct:7a2a5f7c2bb3f70828ef9dc2c367fec7` struct AuditPolicyResults (third_party/openbao/internal/audit/format.go)
- `struct:8182c0f1d05df2008bcee20ad198315e` struct AuditResponse (third_party/openbao/internal/audit/format.go)

_9 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
