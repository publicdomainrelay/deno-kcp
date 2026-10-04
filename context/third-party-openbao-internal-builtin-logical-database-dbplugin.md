# Context: third-party-openbao-internal-builtin-logical-database-dbplugin

Repository: `deno-kcp`

This context exists to verify the gRPC-backed database plugin client/server plumbing exposed by the dbplugin package. It pins the observable contract of a database plugin as seen through PluginFactoryVersion: Init must accept a single-entry configuration map, CreateUser must reject a duplicate display name and return the display name as the username, RenewUser must fail for unknown users and succeed for known ones, and RevokeUser must remove the user so that a later CreateUser with the same name succeeds. It also documents the out-of-process helper pattern in which one test function doubles as the plugin binary main when the go-plugin client execs it.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/builtin/logical/database/dbplugin/plugin_test.go` file plugin_test.go (third_party/openbao/internal/builtin/logical/database/dbplugin/plugin_test.go)
<!-- SPECD_MANAGED_END -->
