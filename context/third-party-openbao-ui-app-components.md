# Context: third-party-openbao-ui-app-components

Repository: `deno-kcp`

The context exists so that the vendored OpenBao console components can be described, referenced and reasoned about from the deno-kcp repository without reading every upstream file. It exists because the Bao/OpenBao UI is embedded as third_party source rather than a dependency, so its component contracts, args and storage interactions need to stay visible in this repository's own specification graph, and because reviewers must be able to tell what each vendored component does, and what it depends on, before touching it.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:0512d14d3621ea65897ca23805f8ceca` class ConfigureSshSecretComponent (third_party/openbao/ui/app/components/configure-ssh-secret.js)
- `class:090abf69e24dc903a7f4f07c60254891` class SectionTabs (third_party/openbao/ui/app/components/section-tabs.js)
- `class:0f8cd80e96c67a9863b0e49142868be5` class WrapTtlComponent (third_party/openbao/ui/app/components/wrap-ttl.js)
- `class:1bf4fc4333d16d7ac499f290e0dfb6bc` class DatabaseRoleEdit (third_party/openbao/ui/app/components/database-role-edit.js)
- `class:24acf05e7e75779581c639ae907479b0` class DateDropdown (third_party/openbao/ui/app/components/date-dropdown.js)
- `class:2777181492397e7c6e5b53ce4e1f80e7` class ToolRandom (third_party/openbao/ui/app/components/tool-random.js)
- `class:2d6213249042658f3474d29cabaa0e57` class FlashMessageComponent (third_party/openbao/ui/app/components/flash-message.js)
- `class:2e714ec04949bd0a23b001ea0a356c81` class ToolbarSecretLink (third_party/openbao/ui/app/components/toolbar-secret-link.js)
- `class:3113d7352bef6079a8146ea93ef17e3c` class SecretEditToolbar (third_party/openbao/ui/app/components/secret-edit-toolbar.js)
- `class:334ffe6a093c82707d7e0731156dd285` class MountBackendForm (third_party/openbao/ui/app/components/mount-backend-form.js)
- `class:47448cee51ee94901cc7a7ff509aefcb` class OidcConsentBlockComponent (third_party/openbao/ui/app/components/oidc-consent-block.js)
- `class:48dee34c07e778e0cbef575d077012f7` class DatabaseRoleSettingForm (third_party/openbao/ui/app/components/database-role-setting-form.js)
- `class:4a0e74f4d3f1e7b0d11b2be3e7764c64` class CalendarWidget (third_party/openbao/ui/app/components/calendar-widget.js)
- `class:54955339ef5d4102cb5a160fb8c99a6e` class ToolLookup (third_party/openbao/ui/app/components/tool-lookup.js)
- `class:596595350ff7de2a32d76dfdc7a41984` class SecretEdit (third_party/openbao/ui/app/components/secret-edit.js)
- `class:63729015590b2ece6257ab08b7b76b56` class SelectableCard (third_party/openbao/ui/app/components/selectable-card.js)
- `class:68210e9990e6c7a298697868ed2efea9` class PolicyFormComponent (third_party/openbao/ui/app/components/policy-form.js)
- `class:697864b5bf84d49dc5308f11b9f9aed0` class ToolRewrap (third_party/openbao/ui/app/components/tool-rewrap.js)
- `class:78cad6d82b28af57840c897e88e292fb` class SecretEditMetadata (third_party/openbao/ui/app/components/secret-edit-metadata.js)
- `class:7c9ca874fd625e11c296574f43f31d0c` class SplashPage (third_party/openbao/ui/app/components/splash-page.js)
- `class:87e999f620fb7b6b103f90a1f47727b3` class GenerateCredentialsDatabase (third_party/openbao/ui/app/components/generate-credentials-database.js)
- `class:8b721371c90163e6d186b5df662de260` class TokenExpireWarning (third_party/openbao/ui/app/components/token-expire-warning.js)
- `class:9c64a6338130117d5644c8eb3b6e96b4` class GeneratedItemList (third_party/openbao/ui/app/components/generated-item-list.js)
- `class:a2aa241ec82f0ea8ed44fc2f7be88a66` class ToolWrap (third_party/openbao/ui/app/components/tool-wrap.js)
- `class:a58b7c428d6e6bff3e0cd0c891b7fb00` class DatabaseConnectionEdit (third_party/openbao/ui/app/components/database-connection.js)
- `class:a6cc99ed09ac6ea37ac2517179b6d786` class ToolHash (third_party/openbao/ui/app/components/tool-hash.js)
- `class:a8e00213305261566b1efd61662c5729` class ToolUnwrap (third_party/openbao/ui/app/components/tool-unwrap.js)
- `class:af48eaca9343a52bbf55069dbc17a84f` class SecretVersionMenu (third_party/openbao/ui/app/components/secret-version-menu.js)
- `class:b208259f86d787419674c7f7f3cb33b3` class MountAccessorSelect (third_party/openbao/ui/app/components/mount-accessor-select.js)
- `class:b3c31ae4b15a40967cc8c40edbf14716` class HoverCopyButton (third_party/openbao/ui/app/components/hover-copy-button.js)
- `class:bcf1facc050bc82db5d7b31450c3d1a0` class SecretLink (third_party/openbao/ui/app/components/secret-link.js)
- `class:cf5a38cc7d6b9edf87a22e142c6eeefc` class PaginationControls (third_party/openbao/ui/app/components/pagination-controls.js)
- `class:cfe4f7faa697bde938a3ead58dd5dd84` class SecretDeleteMenu (third_party/openbao/ui/app/components/secret-delete-menu.js)
- `class:d8aea563b2be09561e762fd0c608d4fb` class RegexValidator (third_party/openbao/ui/app/components/regex-validator.js)
- `class:e79c402a8d34bbb5ea5438c598c80662` class ConfigureAwsSecretComponent (third_party/openbao/ui/app/components/configure-aws-secret.js)
- `class:e7dc30b32cc046709b7656bea5564579` class GetCredentialsCard (third_party/openbao/ui/app/components/get-credentials-card.js)
- `class:ee669438eb5020628b82c2841922b0af` class SecretCreateOrUpdate (third_party/openbao/ui/app/components/secret-create-or-update.js)
- `class:facc46287237c39f58512dce1fb176a2` class DiffVersionSelector (third_party/openbao/ui/app/components/diff-version-selector.js)
- `file:third_party/openbao/ui/app/components/auth-form-options.js` file auth-form-options.js (third_party/openbao/ui/app/components/auth-form-options.js)
- `file:third_party/openbao/ui/app/components/auth-form.js` file auth-form.js (third_party/openbao/ui/app/components/auth-form.js)
- `file:third_party/openbao/ui/app/components/auth-jwt.js` file auth-jwt.js (third_party/openbao/ui/app/components/auth-jwt.js)
- `file:third_party/openbao/ui/app/components/b64-toggle.js` file b64-toggle.js (third_party/openbao/ui/app/components/b64-toggle.js)
- `file:third_party/openbao/ui/app/components/calendar-widget.js` file calendar-widget.js (third_party/openbao/ui/app/components/calendar-widget.js)
- `file:third_party/openbao/ui/app/components/configure-aws-secret.js` file configure-aws-secret.js (third_party/openbao/ui/app/components/configure-aws-secret.js)
- `file:third_party/openbao/ui/app/components/configure-ssh-secret.js` file configure-ssh-secret.js (third_party/openbao/ui/app/components/configure-ssh-secret.js)

_59 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
