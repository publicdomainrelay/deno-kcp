# Context: third-party-openbao-ui-app-models

Repository: `deno-kcp`

The context exists so the UI can describe each OpenBao API resource once, as a typed client-side record, and let routes, serializers, and form components share that description. The models carry the field list, defaults, labels and help text the form layer renders, the derived flags (for example whether a secret engine is KV v2, whether a secret version is deleted, whether an auth method can be edited or disabled), and the API path each record reads and writes, so that the rest of the UI never hard-codes those details per screen.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:25c2f24e84876c1c4bf1e4c29ea651df` class MfaLoginEnforcementModel (third_party/openbao/ui/app/models/mfa-login-enforcement.js)
- `class:4ca0f0334095a295066c7608a584b7f4` class ModelExport (third_party/openbao/ui/app/models/auth-method.js)
- `class:4e9bb96f12a72a84d3fd92d8f643fcc5` class MfaMethod (third_party/openbao/ui/app/models/mfa-method.js)
- `class:98e1972dd659a70f6f6e99cdbb97d1f5` class SecretEngineModel (third_party/openbao/ui/app/models/secret-engine.js)
- `class:a24afb65e7f21f4e12c1dde187d38419` class SecretV2VersionModel (third_party/openbao/ui/app/models/secret-v2-version.js)
- `class:ad5c72b7f37378f2c16e6db9248f415c` class MountConfigModel (third_party/openbao/ui/app/models/mount-config.js)
- `class:aee0d851e8d0b10aee21043bfdeceea5` class RoleJwtModel (third_party/openbao/ui/app/models/role-jwt.js)
- `class:c3be2b86c02c76447ef0cf30f85cff7d` class NamespaceModel (third_party/openbao/ui/app/models/namespace.js)
- `file:third_party/openbao/ui/app/models/auth-config.js` file auth-config.js (third_party/openbao/ui/app/models/auth-config.js)
- `file:third_party/openbao/ui/app/models/auth-method.js` file auth-method.js (third_party/openbao/ui/app/models/auth-method.js)
- `file:third_party/openbao/ui/app/models/aws-credential.js` file aws-credential.js (third_party/openbao/ui/app/models/aws-credential.js)
- `file:third_party/openbao/ui/app/models/capabilities.js` file capabilities.js (third_party/openbao/ui/app/models/capabilities.js)
- `file:third_party/openbao/ui/app/models/cluster.js` file cluster.js (third_party/openbao/ui/app/models/cluster.js)
- `file:third_party/openbao/ui/app/models/lease.js` file lease.js (third_party/openbao/ui/app/models/lease.js)
- `file:third_party/openbao/ui/app/models/license.js` file license.js (third_party/openbao/ui/app/models/license.js)
- `file:third_party/openbao/ui/app/models/mfa-login-enforcement.js` file mfa-login-enforcement.js (third_party/openbao/ui/app/models/mfa-login-enforcement.js)
- `file:third_party/openbao/ui/app/models/mfa-method.js` file mfa-method.js (third_party/openbao/ui/app/models/mfa-method.js)
- `file:third_party/openbao/ui/app/models/mount-config.js` file mount-config.js (third_party/openbao/ui/app/models/mount-config.js)
- `file:third_party/openbao/ui/app/models/namespace.js` file namespace.js (third_party/openbao/ui/app/models/namespace.js)
- `file:third_party/openbao/ui/app/models/node.js` file node.js (third_party/openbao/ui/app/models/node.js)
- `file:third_party/openbao/ui/app/models/path-filter-config.js` file path-filter-config.js (third_party/openbao/ui/app/models/path-filter-config.js)
- `file:third_party/openbao/ui/app/models/policy.js` file policy.js (third_party/openbao/ui/app/models/policy.js)
- `file:third_party/openbao/ui/app/models/raft-join.js` file raft-join.js (third_party/openbao/ui/app/models/raft-join.js)
- `file:third_party/openbao/ui/app/models/role-aws.js` file role-aws.js (third_party/openbao/ui/app/models/role-aws.js)
- `file:third_party/openbao/ui/app/models/role-jwt.js` file role-jwt.js (third_party/openbao/ui/app/models/role-jwt.js)
- `file:third_party/openbao/ui/app/models/role-ssh.js` file role-ssh.js (third_party/openbao/ui/app/models/role-ssh.js)
- `file:third_party/openbao/ui/app/models/secret-engine.js` file secret-engine.js (third_party/openbao/ui/app/models/secret-engine.js)
- `file:third_party/openbao/ui/app/models/secret-v2-version.js` file secret-v2-version.js (third_party/openbao/ui/app/models/secret-v2-version.js)
- `file:third_party/openbao/ui/app/models/secret-v2.js` file secret-v2.js (third_party/openbao/ui/app/models/secret-v2.js)
- `file:third_party/openbao/ui/app/models/secret.js` file secret.js (third_party/openbao/ui/app/models/secret.js)
- `file:third_party/openbao/ui/app/models/server.js` file server.js (third_party/openbao/ui/app/models/server.js)
- `file:third_party/openbao/ui/app/models/ssh-otp-credential.js` file ssh-otp-credential.js (third_party/openbao/ui/app/models/ssh-otp-credential.js)
- `file:third_party/openbao/ui/app/models/ssh-sign.js` file ssh-sign.js (third_party/openbao/ui/app/models/ssh-sign.js)
- `file:third_party/openbao/ui/app/models/test-form-model.js` file test-form-model.js (third_party/openbao/ui/app/models/test-form-model.js)
- `file:third_party/openbao/ui/app/models/transit-key.js` file transit-key.js (third_party/openbao/ui/app/models/transit-key.js)
<!-- SPECD_MANAGED_END -->
