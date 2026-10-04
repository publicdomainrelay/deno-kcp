# Context: third-party-openbao-internal-vault-quotas

Repository: `deno-kcp`

_(empty: write what this context is for)_

_Write the prose above and the fields in the spec block. `codeRefs` and the resolved references below are maintained by the tool; an edit there is lost._

## spec

```yaml spec
upstream: self
```

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/vault/quotas/quotas.go` file quotas.go (third_party/openbao/internal/vault/quotas/quotas.go)
- `file:third_party/openbao/internal/vault/quotas/quotas_rate_limit.go` file quotas_rate_limit.go (third_party/openbao/internal/vault/quotas/quotas_rate_limit.go)
- `file:third_party/openbao/internal/vault/quotas/quotas_rate_limit_test.go` file quotas_rate_limit_test.go (third_party/openbao/internal/vault/quotas/quotas_rate_limit_test.go)
- `file:third_party/openbao/internal/vault/quotas/quotas_test.go` file quotas_test.go (third_party/openbao/internal/vault/quotas/quotas_test.go)
- `function:1e822443d40412d154744c5b32332eda` function QuotaStoragePath (third_party/openbao/internal/vault/quotas/quotas.go)
- `function:3bc9e607eb7a16b985d7f82a699a5886` function NewManager (third_party/openbao/internal/vault/quotas/quotas.go)
- `function:d0b2b03b55f13ab460ea4e664ce940f3` function NewRateLimitQuota (third_party/openbao/internal/vault/quotas/quotas_rate_limit.go)
- `interface:7e7585dad23c0d68c364c80d6698b10a` interface Quota (third_party/openbao/internal/vault/quotas/quotas.go)
- `interface:e266dbf69d4ac222bf687dadffbaa42f` interface Access (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:013497d025f117fe4d3a813d236e75ac` method Manager.LoadQuota (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:09025260cc516c79f082580f11156d23` method Manager.QueryResolveRoleQuotas (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:1889682ba37f711e3025b8b70ff041f5` method RateLimitQuota.Clone (third_party/openbao/internal/vault/quotas/quotas_rate_limit.go)
- `method:192f69f4eaba60df7f6560c98cb1d092` method Access.QuotaID (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:19933149ad04d389e6caa100f7215da9` method Manager.RateLimitResponseHeadersEnabled (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:1da5112b6ebd64a311fa1ef933e7fddb` method Manager.QueryQuota (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:1f7908361501fd4d496530db73ee485e` method Quota.IsInheritable (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:27f0d881c669ea2b6d6f0e19af0e3d55` method access.QuotaID (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:2c83757b5a79968be050786b05670fe8` method Manager.QuotaByFactors (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:32814d5f932975ee37cfda321e8d95b8` method Type.String (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:3bb069fa0ea4c484313ac0c5c2ad2e88` method Manager.Config (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:44976361c652e12e6e1fee5ebc749f36` method Manager.QuotaNames (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:500ac6a4a3a78cded562f9c91b005150` method Manager.RateLimitAuditLoggingEnabled (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:51fa587878c4d978c636415b5f56acda` method Manager.DetectDeadlocks (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:5faea9a09230ae3b432bc3d22e1f7a17` method RateLimitQuota.QuotaName (third_party/openbao/internal/vault/quotas/quotas_rate_limit.go)
- `method:66b1b119e79a1b5ba6f538084e5c4476` method Manager.HandleNamespaceDeletion (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:6a6445f5fe3ac0b57c1fb2ba82e5012b` method RateLimitQuota.IsInheritable (third_party/openbao/internal/vault/quotas/quotas_rate_limit.go)
- `method:7418e5e959ef5d904f6d78a0bfc3b45d` method Manager.SetEnableRateLimitResponseHeaders (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:79662e1afc452a3e9e2538caffc51845` method Manager.Setup (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:7be34ff186980b2afbc84e3c823ad56e` method Manager.DeleteQuota (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:7f7f878d26f33d8bc96ead5f129e0221` method Quota.QuotaName (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:8b54eff50e5e03d3214089771328e86e` method Manager.RateLimitPathExempt (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:a9d201befac661a69c7fdf217110386d` method LeaseAction.String (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:b2cee10169fbabe08791515449d8d52a` method Manager.HandleBackendDisabling (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:b629803ef457140097c89b3efb6d62f4` method Manager.ApplyQuota (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:be48f82547148750ae4ee3d2d3c2d5f3` method Manager.QuotaByID (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:bf638c54088bc6262e2aed76b6ac10a2` method Manager.SetQuota (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:c55f949286b0a87e53f569e3ac02360c` method Quota.Clone (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:c70a2234c6bdd81db6b24c1879443480` method Manager.HandleRemount (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:c86ef90ba96d7f49920d4d31f83ef623` method Manager.QuotaByName (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:c9cf9904e263d5ff89ea47ff55050f6d` method Manager.LoadConfig (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:cb783e8155dd305bbfea9ee5229c8710` method Manager.SetRateLimitExemptPaths (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:cf7f686d2dfa1c564bffb7aa7d7b300c` method Manager.Invalidate (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:f5d707e5396670f5d2682ec388669191` method Manager.Reset (third_party/openbao/internal/vault/quotas/quotas.go)
- `method:f9239888f983b595326d21505cf80491` method Manager.SetEnableRateLimitAuditLogging (third_party/openbao/internal/vault/quotas/quotas.go)
- `struct:2d6122a7ef8f9a5b01e6187d6a70c0fd` struct Response (third_party/openbao/internal/vault/quotas/quotas.go)

_7 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
