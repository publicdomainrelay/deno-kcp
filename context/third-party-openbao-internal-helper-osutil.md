# Context: third-party-openbao-internal-helper-osutil

Repository: `deno-kcp`

This context exists so that callers that must refuse to read secrets from world- or group-writable files, or that must confirm a file is owned by a specific uid, have one audited place to ask. It separates the checks that are meaningful everywhere (mode-bit inspection, digesting, permission comparison) from the ones that need POSIX uid/gid data (fileinfo_unix.go) and the stubs that keep Windows builds compiling, so a security check written once behaves the same wherever it is called.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/helper/osutil/fileinfo.go` file fileinfo.go (third_party/openbao/internal/helper/osutil/fileinfo.go)
- `file:third_party/openbao/internal/helper/osutil/fileinfo_test.go` file fileinfo_test.go (third_party/openbao/internal/helper/osutil/fileinfo_test.go)
- `file:third_party/openbao/internal/helper/osutil/fileinfo_unix.go` file fileinfo_unix.go (third_party/openbao/internal/helper/osutil/fileinfo_unix.go)
- `file:third_party/openbao/internal/helper/osutil/fileinfo_unix_test.go` file fileinfo_unix_test.go (third_party/openbao/internal/helper/osutil/fileinfo_unix_test.go)
- `file:third_party/openbao/internal/helper/osutil/fileinfo_windows.go` file fileinfo_windows.go (third_party/openbao/internal/helper/osutil/fileinfo_windows.go)
- `function:326475f15a2124fab7a15d850ad9d1cb` function OwnerPermissionsMatchFile (third_party/openbao/internal/helper/osutil/fileinfo.go)
- `function:5230917cbf1f74829a48e450c17f4c02` function IsWriteGroup (third_party/openbao/internal/helper/osutil/fileinfo.go)
- `function:52c64b528a752fb717f7078d441e4fcc` function FileUIDEqual (third_party/openbao/internal/helper/osutil/fileinfo_unix.go)
- `function:58ca6e3f55b39d24aa29a0b8244f6ee5` function FilePermissionsMatch (third_party/openbao/internal/helper/osutil/fileinfo.go)
- `function:8b40f313720b4a1000c81f4f8809823d` function FileGIDEqual (third_party/openbao/internal/helper/osutil/fileinfo_unix.go)
- `function:8f224eea6f12efae1e65a6e97cb53e96` function FileSha256Sum (third_party/openbao/internal/helper/osutil/fileinfo.go)
- `function:b5834146fd9a9b6aa4b8fd13f3cc3c6e` function FileUidMatch (third_party/openbao/internal/helper/osutil/fileinfo_unix.go)
- `function:c36bb0a2244e95f9eb9f055f6003c362` function Umask (third_party/openbao/internal/helper/osutil/fileinfo_unix.go)
- `function:d8871c7888dc2d4bed6db09ddc5955ac` function IsWriteOther (third_party/openbao/internal/helper/osutil/fileinfo.go)
- `function:f6f7b35960500a40f8def96ad643c344` function OwnerPermissionsMatch (third_party/openbao/internal/helper/osutil/fileinfo.go)
<!-- SPECD_MANAGED_END -->
