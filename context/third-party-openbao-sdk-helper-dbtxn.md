# Context: third-party-openbao-sdk-helper-dbtxn

Repository: `deno-kcp`

This context exists so backend database plugins and storage code in OpenBao can run small parameterised SQL statements without repeating prepare, execute, and resource-release boilerplate. Callers pick a prepared variant when a statement benefits from reuse within the driver, and a direct variant when the statement runs once. The package isolates the template substitution of {{name}} tokens behind an unexported parseQuery helper, so no caller must do string replacement on SQL by hand. Only the four Execute* entry points are exported; parseQuery and execute stay internal to the file.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/helper/dbtxn/dbtxn.go` file dbtxn.go (third_party/openbao/sdk/helper/dbtxn/dbtxn.go)
- `function:0a158cecb80a3a8c10637412fa09a53a` function ExecuteDBQueryDirect (third_party/openbao/sdk/helper/dbtxn/dbtxn.go)
- `function:3425084f5e86168aaebb7f5cfeb53f0e` function ExecuteTxQuery (third_party/openbao/sdk/helper/dbtxn/dbtxn.go)
- `function:77c9c70ae684912661590dc7bd08d0b7` function ExecuteTxQueryDirect (third_party/openbao/sdk/helper/dbtxn/dbtxn.go)
- `function:f0e460014493f1673ed1e45d1c19f042` function ExecuteDBQuery (third_party/openbao/sdk/helper/dbtxn/dbtxn.go)
<!-- SPECD_MANAGED_END -->
