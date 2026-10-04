# Context: third-party-openbao-sdk-helper-docker

Repository: `deno-kcp`

This context exists so that OpenBao integration tests can stand up external services (databases, plugins, LDAP, and similar) in Docker and talk to them over the network without hand-rolling Docker client plumbing in each test package. The file centralizes container lifecycle, port and address discovery, in-container command execution, file provisioning, and image building behind one small runner API, so a caller supplies a RunOptions describing image, command, environment, ports and files, and gets back a started service plus the addresses needed to connect to it.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/helper/docker/testhelpers.go` file testhelpers.go (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `function:027659abee07bbb1f22f66b64670f7ca` function RunCmdInBackground (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `function:04f29607fa5c365f79559e4847b59eda` function PathContentsFromString (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `function:0fa8f3fc3096e8d0dadf33fc0c3a51d5` function NewBuildContext (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `function:372e27fd642fdd81548db64a253746eb` function NewServiceRunner (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `function:8bd6cb0ad6ef23b212cfda763eb0d5f3` function NewDockerAPI (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `function:a5a4c18c5bdd490405845f402a8c566f` function PathContentsFromBytes (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `function:adf178adbf827a175b03d2bbe4aa5a62` function NewServiceURL (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `function:dfefbe8ad9f3777864b0abfc546ef5fb` function RunCmdWithOutput (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `function:e47570b4b99eaba234dbfd1512a74b5c` function NewServiceHostPort (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `function:ed2f06fcd9f5afcc1c659f2ea69d24d8` function BuildContextFromTarball (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `function:ed64d8f3ff7b12c0710a6552de82c78d` function BuildImage (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `function:f61be835e23d55870bda470c202ea330` function NewServiceHostPortParse (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `function:f62059fd3220bc5d6c452507ace175b0` function NewServiceURLParse (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `interface:76a04c44131ea7f956ad9823764f251a` interface ServiceConfig (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `interface:acae64485063e7695f03fd283daf5bf4` interface RunCmdOpt (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `interface:ccd9724f792dae681d04f0ba3b7268dc` interface BuildOpt (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `interface:d7a471eff09b7445abab742056d2a251` interface PathContents (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `method:00191fa588d0556e1c5a368a61b0c22d` method Runner.Stop (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `method:13fa58ffca7238e617ac806d443eca48` method PathContents.Get (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `method:1698022a332a83b2b0f1d1acd98af8df` method Runner.Start (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `method:19038821dfcd10e814c23e8cdbe172d9` method Runner.RunCmdWithOutput (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `method:1e494bd7e1bc8824f6f4a40c6890fda4` method ServiceHostPort.Address (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `method:1ed689e9377f8e7e440940b8ca101b97` method BuildContext.ToTarball (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `method:32ee669ee075304ded15ed87b3af82f9` method BuildOpt.Apply (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `method:40680e298fa36128a35487b8fde8c44e` method Runner.StartNewService (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `method:4f7d86ba9bd998e55e0d7ccc32e5e1a2` method FileContents.Get (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `method:5c394080140517df88feef5ad7be8bbb` method BuildRemove.Apply (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `method:627302db609e5beda39059796a182547` method Runner.Restart (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `method:62e205e6f7a211ffffd6c01df87e3845` method FileContents.SetOwners (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `method:687b9b183edff47563863feb2b280901` method BuildArgs.Apply (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `method:6f9eaf5942277d526e0f84590b62f8eb` method ServiceURL.Address (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `method:80bd2a5c7ac933e1de9ce832f7bf2190` method ServiceHostPort.URL (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `method:86bc430fcfeb27e3f98083bcfe0f86ec` method ServiceConfig.Address (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `method:8c33414fdfbce554d2b592fa9a151fa7` method ServiceConfig.URL (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `method:8cd7bbfd0300a876b54f083af7efaa3d` method FileContents.SetMode (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `method:8d36c884b1f7f8ff92e006abd1888fe7` method PathContents.UpdateHeader (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `method:8d7bef7509bedcd9c91d89cb299fde51` method Runner.StartService (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `method:9138348dffd470d5c20805adb0b1ace9` method Runner.RunCmdInBackground (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `method:96bf8f9881a1f3c193d995b2965f20ed` method PathContents.SetOwners (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `method:9813d04e9afad26e6f01e75a9ea46e34` method LogConsumerWriter.Write (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `method:986cb96cf22e906aee57fcedcb5a1187` method ServiceURL.URL (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `method:9d073ce521d509a0990c6363223ba5ac` method Runner.CopyTo (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `method:9f6b0b4f40a4d2bad6f9af6229c466a6` method BuildTags.Apply (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `method:aa549a6fc1fda6205d479718ac95fe86` method FileContents.UpdateHeader (third_party/openbao/sdk/helper/docker/testhelpers.go)
- `method:acf33f96904e552d5d61a413f94b9d7c` method RunCmdUser.Apply (third_party/openbao/sdk/helper/docker/testhelpers.go)

_24 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
