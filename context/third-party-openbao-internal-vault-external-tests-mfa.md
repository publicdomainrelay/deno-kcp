# Context: third-party-openbao-internal-vault-external-tests-mfa

Repository: `deno-kcp`

The context exists to pin down the observable contract of the identity MFA API as exercised from outside the core: which provider types accept which config fields, that a method id is stable across re-writes of the same name, that a method read through the wrong type endpoint or a write to a non-existent method id fails, that global listing returns every method id and its key_info, that login enforcements require method ids plus at least one of auth_method_accessors, auth_method_types, identity_group_ids or identity_entity_ids, and that deleted entries stay deleted across seal and unseal. It is a black-box regression gate for the MFA subsystem, not production code.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/external_tests/mfa/login_mfa_test.go` file login_mfa_test.go (third_party/openbao/internal/vault/external_tests/mfa/login_mfa_test.go)
<!-- SPECD_MANAGED_END -->
