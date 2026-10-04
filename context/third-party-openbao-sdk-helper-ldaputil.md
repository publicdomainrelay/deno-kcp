# Context: third-party-openbao-sdk-helper-ldaputil

Repository: `deno-kcp`

This context exists so the repository can vendor and use OpenBao's LDAP helper as a third-party dependency: it fixes the shape of the LDAP client, the connection abstraction and the configuration entry so that any code in deno-kcp that authenticates users or resolves groups against an LDAP directory can call the same functions with the same signatures, and so the escaping and filter-rendering behavior that guards against LDAP injection stays exactly as upstream defines it.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/sdk/helper/ldaputil/client.go` file client.go (third_party/openbao/sdk/helper/ldaputil/client.go)
- `file:third_party/openbao/sdk/helper/ldaputil/client_test.go` file client_test.go (third_party/openbao/sdk/helper/ldaputil/client_test.go)
- `file:third_party/openbao/sdk/helper/ldaputil/config.go` file config.go (third_party/openbao/sdk/helper/ldaputil/config.go)
- `file:third_party/openbao/sdk/helper/ldaputil/config_test.go` file config_test.go (third_party/openbao/sdk/helper/ldaputil/config_test.go)
- `file:third_party/openbao/sdk/helper/ldaputil/connection.go` file connection.go (third_party/openbao/sdk/helper/ldaputil/connection.go)
- `file:third_party/openbao/sdk/helper/ldaputil/ldap.go` file ldap.go (third_party/openbao/sdk/helper/ldaputil/ldap.go)
- `function:36af85f1faca3106c10bcbe63baabcb4` function NewLDAP (third_party/openbao/sdk/helper/ldaputil/ldap.go)
- `function:80731a2c0c1e7ab58d52503166aebd35` function NewConfigEntry (third_party/openbao/sdk/helper/ldaputil/config.go)
- `function:887541decbc45fcf241c29b15de11095` function ConfigFields (third_party/openbao/sdk/helper/ldaputil/config.go)
- `function:b6dd5dc7a40159995f200a94ff42c126` function EscapeLDAPValue (third_party/openbao/sdk/helper/ldaputil/client.go)
- `interface:305a06cf4b4e6a8215f5ba864f6edebb` interface LDAP (third_party/openbao/sdk/helper/ldaputil/ldap.go)
- `interface:3b9af4bf8f5fb1ffb79bdadbdf666ebf` interface Connection (third_party/openbao/sdk/helper/ldaputil/connection.go)
- `interface:a2452b5b2d859deb8f9ae9a730534a93` interface PagingConnection (third_party/openbao/sdk/helper/ldaputil/connection.go)
- `method:09ff0b981e1cb1cea7a369416931c805` method ldapIfc.DialURL (third_party/openbao/sdk/helper/ldaputil/ldap.go)
- `method:13e5a4ed7a1476b08ab8fc6083ff13f8` method Client.DialLDAP (third_party/openbao/sdk/helper/ldaputil/client.go)
- `method:21e588180474cf39cb119930c9353df4` method Connection.Del (third_party/openbao/sdk/helper/ldaputil/connection.go)
- `method:26e80762b82df4bc2b84d56fb4f06ac4` method Connection.Search (third_party/openbao/sdk/helper/ldaputil/connection.go)
- `method:30d830fe5b12b3ebc3e6a1da6346f1a6` method Connection.Modify (third_party/openbao/sdk/helper/ldaputil/connection.go)
- `method:4974672a9c0f670414bba0a3ce8a1d78` method Client.GetUserBindDN (third_party/openbao/sdk/helper/ldaputil/client.go)
- `method:4b7bb073b0fe37555621258624ca1062` method PagingConnection.SearchWithPaging (third_party/openbao/sdk/helper/ldaputil/connection.go)
- `method:50ef833814a8dabc06e632a3e5520a03` method ConfigEntry.Map (third_party/openbao/sdk/helper/ldaputil/config.go)
- `method:73039199f4b528a6dc4ee9b21ace966f` method Client.GetUserAliasAttributeValue (third_party/openbao/sdk/helper/ldaputil/client.go)
- `method:7ddf3fecbc3bc265b95d08515a70134a` method Client.GetUserDN (third_party/openbao/sdk/helper/ldaputil/client.go)
- `method:81e6b6dc4b5cd16eabf93d22cdaf9fa2` method Client.GetLdapGroups (third_party/openbao/sdk/helper/ldaputil/client.go)
- `method:83e99d613179b279236ca011cca396eb` method LDAP.DialURL (third_party/openbao/sdk/helper/ldaputil/ldap.go)
- `method:86e35fc5ffc9501363670e480892cd59` method Connection.Close (third_party/openbao/sdk/helper/ldaputil/connection.go)
- `method:a21256d96530b8c261860357747b8fc9` method Client.RenderUserSearchFilter (third_party/openbao/sdk/helper/ldaputil/client.go)
- `method:c09f1b82ba8f22cd8e96623e4eac6651` method Connection.SetTimeout (third_party/openbao/sdk/helper/ldaputil/connection.go)
- `method:c5eeb84dc923c83b6bb08b6d719ef3f9` method Connection.UnauthenticatedBind (third_party/openbao/sdk/helper/ldaputil/connection.go)
- `method:c90a5834a68fe430bbed15f903bc19a6` method Connection.StartTLS (third_party/openbao/sdk/helper/ldaputil/connection.go)
- `method:d0dca584e5f2e58e6cc07e885514bfee` method ConfigEntry.PasswordlessMap (third_party/openbao/sdk/helper/ldaputil/config.go)
- `method:d5623f1b5a339b843f12796d7ff416e3` method Connection.Add (third_party/openbao/sdk/helper/ldaputil/connection.go)
- `method:d5ea325c6f77b97d44cdeb7075403ec8` method Connection.Bind (third_party/openbao/sdk/helper/ldaputil/connection.go)
- `method:dc530a868c994b2a4de5c18323eb280f` method ConfigEntry.Validate (third_party/openbao/sdk/helper/ldaputil/config.go)
- `struct:1bb05ab64209a2d68270899096b4f7c9` struct Client (third_party/openbao/sdk/helper/ldaputil/client.go)
- `struct:d9a5b1056a138af3f4885e847fcc87e0` struct ConfigEntry (third_party/openbao/sdk/helper/ldaputil/config.go)
<!-- SPECD_MANAGED_END -->
