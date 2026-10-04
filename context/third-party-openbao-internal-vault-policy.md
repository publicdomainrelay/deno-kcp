# Context: third-party-openbao-internal-vault-policy

Repository: `deno-kcp`

_(empty: write what this context is for)_

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/policy/acl.go` file acl.go (third_party/openbao/internal/vault/policy/acl.go)
- `file:third_party/openbao/internal/vault/policy/acl_test.go` file acl_test.go (third_party/openbao/internal/vault/policy/acl_test.go)
- `file:third_party/openbao/internal/vault/policy/policy.go` file policy.go (third_party/openbao/internal/vault/policy/policy.go)
- `file:third_party/openbao/internal/vault/policy/policy_store.go` file policy_store.go (third_party/openbao/internal/vault/policy/policy_store.go)
- `file:third_party/openbao/internal/vault/policy/policy_test.go` file policy_test.go (third_party/openbao/internal/vault/policy/policy_test.go)
- `function:1d9c2c3940c5da04dbce8d9e331379c4` function ParseACLPolicy (third_party/openbao/internal/vault/policy/policy.go)
- `function:5772199666331f7c0f94f82198491e7c` function NewACL (third_party/openbao/internal/vault/policy/acl.go)
- `function:ce5e405b18d53239274e1cde29e712e0` function ParseACLPolicyWithTemplating (third_party/openbao/internal/vault/policy/policy.go)
- `function:ec220b62b95c7485cc8fd78e4854e006` function NewStore (third_party/openbao/internal/vault/policy/policy_store.go)
- `method:01c2ad9feafa4ceb043e92af913fc35f` method Policy.Decode (third_party/openbao/internal/vault/policy/policy.go)
- `method:0d126139abdd9136786de2f6ffb1d1d8` method core.NamespaceView (third_party/openbao/internal/vault/policy/policy_store.go)
- `method:1728f8a4efd8925dc0f89123c8b08bfb` method Store.PurgeCache (third_party/openbao/internal/vault/policy/policy_store.go)
- `method:207ba1a4feab95a4024bf1f0f7429b3d` method Store.SetPolicy (third_party/openbao/internal/vault/policy/policy_store.go)
- `method:2184800defb24e18f0dba03a3ecc5c39` method ACLPermissions.Clone (third_party/openbao/internal/vault/policy/policy.go)
- `method:385c4428fe000811076219ea30564019` method ACL.Capabilities (third_party/openbao/internal/vault/policy/acl.go)
- `method:3a2f0325460fe600950e469ee8b73c1e` method Store.ListPoliciesWithPrefix (third_party/openbao/internal/vault/policy/policy_store.go)
- `method:4ab79a60637351660208f7c4f2c7deda` method ACL.AllowOperation (third_party/openbao/internal/vault/policy/acl.go)
- `method:501ef09c8dae79bd9770e5826c4db6cf` method core.IdentityStore (third_party/openbao/internal/vault/policy/policy_store.go)
- `method:552774ae484b2143f6b5bd4511e31143` method ACL.ExactRules (third_party/openbao/internal/vault/policy/acl.go)
- `method:56de26f3a784e2f2c3445714a7f84130` method Store.LoadACLPolicy (third_party/openbao/internal/vault/policy/policy_store.go)
- `method:5a2df33b3cc0b32c53bb39f6f0546e3e` method core.NamespaceByID (third_party/openbao/internal/vault/policy/policy_store.go)
- `method:67024fed08405b79aea3c4df54ea9b4e` method Store.InvalidateNamespace (third_party/openbao/internal/vault/policy/policy_store.go)
- `method:6c6dfc6162a91e1f7c299f2536cfc1e5` method Store.DeletePolicyForce (third_party/openbao/internal/vault/policy/policy_store.go)
- `method:798df78fa8b25a2d25259650b35b811d` method Store.ListPolicies (third_party/openbao/internal/vault/policy/policy_store.go)
- `method:82e9d15f9e34778eeca7bd3a7209880c` method Store.DeletePolicy (third_party/openbao/internal/vault/policy/policy_store.go)
- `method:862e5a93cdad4e55579a070d96e86a2c` method Store.LoadDefaultPolicies (third_party/openbao/internal/vault/policy/policy_store.go)
- `method:8be19924c6ef7697f8e558f70cee8749` method Store.SanitizeName (third_party/openbao/internal/vault/policy/policy_store.go)
- `method:8f33ee80e8bbe8f111a332cb8b2d33fd` method ControlGroup.Clone (third_party/openbao/internal/vault/policy/policy.go)
- `method:9c5bb123f79dec394830b362c902d972` method ACL.PrefixRules (third_party/openbao/internal/vault/policy/acl.go)
- `method:a9f33f7f348d42e360c597d841e489fa` method ACL.Root (third_party/openbao/internal/vault/policy/acl.go)
- `method:b10e674c11742296bbd9abf79070307c` method Store.Invalidate (third_party/openbao/internal/vault/policy/policy_store.go)
- `method:c79bd3b75e88d2fd9c26607baad52176` method ACL.CheckAllowedFromNonExactPaths (third_party/openbao/internal/vault/policy/acl.go)
- `method:c90ecedb2a9deed751092ccf278372f3` method Store.GetNonEGPPolicyType (third_party/openbao/internal/vault/policy/policy_store.go)
- `method:cbcfaa9c7bcac2d27131232d89f8f77a` method Store.GetPolicy (third_party/openbao/internal/vault/policy/policy_store.go)
- `method:d83a713f7ea4d281722e0ef8e988b427` method Policy.ShallowClone (third_party/openbao/internal/vault/policy/policy.go)
- `method:d9104fe028812ab6b4227fae29cf9c5e` method Store.GetACLView (third_party/openbao/internal/vault/policy/policy_store.go)
- `method:dd0ae629ad8c7b89df9a52d973cd6ab6` method Store.ACL (third_party/openbao/internal/vault/policy/policy_store.go)
- `method:deb628b9c3bba5d41c6afa6a68b3846f` method Type.String (third_party/openbao/internal/vault/policy/policy.go)
- `struct:05f347d1fbdc6c51bbdab5a7415843b7` struct ControlGroupFactor (third_party/openbao/internal/vault/policy/policy.go)
- `struct:371d5c892dfcdf97850cdaf02babeab2` struct ACLResults (third_party/openbao/internal/vault/policy/acl.go)
- `struct:436d5b1c473a3ddb04137ad40ba1f640` struct ControlGroupIdentity (third_party/openbao/internal/vault/policy/policy.go)
- `struct:55589b5678c147cb581a7c6ccfc78f8a` struct Store (third_party/openbao/internal/vault/policy/policy_store.go)
- `struct:559109d5bbd2034ca10c2370c75c77cc` struct ControlGroup (third_party/openbao/internal/vault/policy/policy.go)
- `struct:57a79c9c6bfdb92f3ab2ba33495f8638` struct CheckOpts (third_party/openbao/internal/vault/policy/acl.go)
- `struct:62b5160d9e68721a22ab930b4b1938b3` struct ACL (third_party/openbao/internal/vault/policy/acl.go)
- `struct:88615c2a235941916f17e6ba0a35d97c` struct IdentityFactor (third_party/openbao/internal/vault/policy/policy.go)
- `struct:8b3dac7fc8f3ab481be70c7b3793fae8` struct PathRules (third_party/openbao/internal/vault/policy/policy.go)

_5 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
