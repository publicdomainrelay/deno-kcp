# Context: third-party-openbao-internal-command-healthcheck

Repository: `deno-kcp`

This context exists so that PKI health can be checked against a live OpenBao server through one uniform executor, instead of one bespoke script per concern. The Executor gives every check the same client, mount, config plumbing and path cache, so a check only has to declare what it needs and how to judge it. The documented surface is what the surrounding command code depends on: the Check interface and the constructors that produce checks, the Executor lifecycle (add, build config, execute), the cached fetch and its classification predicates, and the shared parsing and formatting helpers used across the individual PKI checks.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/command/healthcheck/healthcheck.go` file healthcheck.go (third_party/openbao/internal/command/healthcheck/healthcheck.go)
- `file:third_party/openbao/internal/command/healthcheck/pki.go` file pki.go (third_party/openbao/internal/command/healthcheck/pki.go)
- `file:third_party/openbao/internal/command/healthcheck/pki_allow_acme_headers.go` file pki_allow_acme_headers.go (third_party/openbao/internal/command/healthcheck/pki_allow_acme_headers.go)
- `file:third_party/openbao/internal/command/healthcheck/pki_allow_if_modified_since.go` file pki_allow_if_modified_since.go (third_party/openbao/internal/command/healthcheck/pki_allow_if_modified_since.go)
- `file:third_party/openbao/internal/command/healthcheck/pki_audit_visibility.go` file pki_audit_visibility.go (third_party/openbao/internal/command/healthcheck/pki_audit_visibility.go)
- `file:third_party/openbao/internal/command/healthcheck/pki_ca_validity_period.go` file pki_ca_validity_period.go (third_party/openbao/internal/command/healthcheck/pki_ca_validity_period.go)
- `file:third_party/openbao/internal/command/healthcheck/pki_crl_validity_period.go` file pki_crl_validity_period.go (third_party/openbao/internal/command/healthcheck/pki_crl_validity_period.go)
- `file:third_party/openbao/internal/command/healthcheck/pki_enable_acme_issuance.go` file pki_enable_acme_issuance.go (third_party/openbao/internal/command/healthcheck/pki_enable_acme_issuance.go)
- `file:third_party/openbao/internal/command/healthcheck/pki_enable_auto_tidy.go` file pki_enable_auto_tidy.go (third_party/openbao/internal/command/healthcheck/pki_enable_auto_tidy.go)
- `file:third_party/openbao/internal/command/healthcheck/pki_hardware_backed_root.go` file pki_hardware_backed_root.go (third_party/openbao/internal/command/healthcheck/pki_hardware_backed_root.go)
- `file:third_party/openbao/internal/command/healthcheck/pki_role_allows_glob_wildcards.go` file pki_role_allows_glob_wildcards.go (third_party/openbao/internal/command/healthcheck/pki_role_allows_glob_wildcards.go)
- `file:third_party/openbao/internal/command/healthcheck/pki_role_allows_localhost.go` file pki_role_allows_localhost.go (third_party/openbao/internal/command/healthcheck/pki_role_allows_localhost.go)
- `file:third_party/openbao/internal/command/healthcheck/pki_role_no_store_false.go` file pki_role_no_store_false.go (third_party/openbao/internal/command/healthcheck/pki_role_no_store_false.go)
- `file:third_party/openbao/internal/command/healthcheck/pki_root_issued_leaves.go` file pki_root_issued_leaves.go (third_party/openbao/internal/command/healthcheck/pki_root_issued_leaves.go)
- `file:third_party/openbao/internal/command/healthcheck/pki_tidy_last_run.go` file pki_tidy_last_run.go (third_party/openbao/internal/command/healthcheck/pki_tidy_last_run.go)
- `file:third_party/openbao/internal/command/healthcheck/pki_too_many_certs.go` file pki_too_many_certs.go (third_party/openbao/internal/command/healthcheck/pki_too_many_certs.go)
- `file:third_party/openbao/internal/command/healthcheck/shared.go` file shared.go (third_party/openbao/internal/command/healthcheck/shared.go)
- `file:third_party/openbao/internal/command/healthcheck/util.go` file util.go (third_party/openbao/internal/command/healthcheck/util.go)
- `function:095916289a578670387e0c999a08558f` function NewEnableAutoTidyCheck (third_party/openbao/internal/command/healthcheck/pki_enable_auto_tidy.go)
- `function:0ef5f642d30a554a0000f2cd937b320e` function ParsePEMCert (third_party/openbao/internal/command/healthcheck/pki.go)
- `function:1e1246a377112ae07852c5297cbfc93f` function NewAllowIfModifiedSinceCheck (third_party/openbao/internal/command/healthcheck/pki_allow_if_modified_since.go)
- `function:29c57787bee6a0f0aaaea01696396bb2` function NewRootIssuedLeavesCheck (third_party/openbao/internal/command/healthcheck/pki_root_issued_leaves.go)
- `function:2fae00b4adc47924ab586547fae4c624` function NewEnableAcmeIssuance (third_party/openbao/internal/command/healthcheck/pki_enable_acme_issuance.go)
- `function:33a4632b3c7ba9d554a2aad89a88864d` function NewCRLValidityPeriodCheck (third_party/openbao/internal/command/healthcheck/pki_crl_validity_period.go)
- `function:525a8f3a99ef64f1fc0a155612e676f5` function NewTidyLastRunCheck (third_party/openbao/internal/command/healthcheck/pki_tidy_last_run.go)
- `function:54151063fbf0369ccf78f584562776b5` function FormatDuration (third_party/openbao/internal/command/healthcheck/util.go)
- `function:6f16c4461b84933efd80d7ad5a028896` function NewHardwareBackedRootCheck (third_party/openbao/internal/command/healthcheck/pki_hardware_backed_root.go)
- `function:830d611f7e5599ce053a0bbcd4a239d0` function NewRoleAllowsGlobWildcardsCheck (third_party/openbao/internal/command/healthcheck/pki_role_allows_glob_wildcards.go)
- `function:8b24c7f72f2aa1a37b4edf282a607373` function NewAuditVisibilityCheck (third_party/openbao/internal/command/healthcheck/pki_audit_visibility.go)
- `function:a240f05e1200f40f0e8fefbfd9b4505a` function StringList (third_party/openbao/internal/command/healthcheck/shared.go)
- `function:a9cc1007b9b56fe138dbf440ce6d99c0` function ValidateMountType (third_party/openbao/internal/command/healthcheck/healthcheck.go)
- `function:c24e52358e5abe8d906baeb02bc8b1e0` function NewExecutor (third_party/openbao/internal/command/healthcheck/healthcheck.go)
- `function:c2e7757edd9294fa5bbcecdd3fbeb87b` function NewRoleAllowsLocalhostCheck (third_party/openbao/internal/command/healthcheck/pki_role_allows_localhost.go)
- `function:d5a14ada5df01ecebbc5101d6149b1de` function NewTooManyCertsCheck (third_party/openbao/internal/command/healthcheck/pki_too_many_certs.go)
- `function:d7a2768569c134402c572a052a60cb71` function NewAllowAcmeHeaders (third_party/openbao/internal/command/healthcheck/pki_allow_acme_headers.go)

_122 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
