# Context: third-party-openbao-sdk-helper-compressutil

Repository: `deno-kcp`

This context exists so the rest of the repository can persist and read back compressed values without knowing which codec wrote them. The canary byte makes the format self-identifying, which lets a reader accept old data after the writer switches codecs. Support for lz4 and lzw was removed, and the decompressor now rejects their canaries explicitly instead of silently misreading the payload. The context is a verbatim third-party copy from the OpenBao SDK, kept under third_party so the repository can depend on a fixed version of the helper.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/helper/compressutil/compress.go` file compress.go (third_party/openbao/sdk/helper/compressutil/compress.go)
- `file:third_party/openbao/sdk/helper/compressutil/compress_test.go` file compress_test.go (third_party/openbao/sdk/helper/compressutil/compress_test.go)
- `function:0d7a37d172b1410b62e949783beded54` function DecompressWithCanary (third_party/openbao/sdk/helper/compressutil/compress.go)
- `function:0e252cba289fbd093df390706a8f173c` function Compress (third_party/openbao/sdk/helper/compressutil/compress.go)
- `function:e0525818b7f5434aa5538c1d4f0769c6` function Decompress (third_party/openbao/sdk/helper/compressutil/compress.go)
- `method:97cb9a317f637f0243de2cc5c16045eb` method CompressUtilReadCloser.Close (third_party/openbao/sdk/helper/compressutil/compress.go)
- `struct:95185603a0dbf488e78b75d03b1ca85e` struct CompressionConfig (third_party/openbao/sdk/helper/compressutil/compress.go)
- `struct:beb86a077c23327275ee046c8bd99a71` struct CompressUtilReadCloser (third_party/openbao/sdk/helper/compressutil/compress.go)
<!-- SPECD_MANAGED_END -->
