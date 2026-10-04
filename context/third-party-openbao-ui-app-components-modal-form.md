# Context: third-party-openbao-ui-app-components-modal-form

Repository: `deno-kcp`

These components exist so the UI can open a modal before the record's concrete type is known. PolicyTemplate defers record creation until the operator picks a policy type from `policyOptions`, offering the ACL template as a starting point, while OidcAssignmentTemplate knows its single type up front and creates the record immediately. Each component owns the lifetime of the in-progress record: it creates the Ember Data record from the modal's `nameInput`, hands that record to the type-specific form, and clears its own tracked reference after save so the modal can be reused.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:92b5b3ab4cc1bf8c9a52a4af972a7387` class PolicyTemplate (third_party/openbao/ui/app/components/modal-form/policy-template.js)
- `class:c6201a0d3b1e1050851b276ebe9d3ea1` class OidcAssignmentTemplate (third_party/openbao/ui/app/components/modal-form/oidc-assignment-template.js)
- `file:third_party/openbao/ui/app/components/modal-form/oidc-assignment-template.js` file oidc-assignment-template.js (third_party/openbao/ui/app/components/modal-form/oidc-assignment-template.js)
- `file:third_party/openbao/ui/app/components/modal-form/policy-template.js` file policy-template.js (third_party/openbao/ui/app/components/modal-form/policy-template.js)
<!-- SPECD_MANAGED_END -->
