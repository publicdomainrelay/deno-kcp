# Context: third-party-openbao-ui-app-components-sidebar-header

Repository: `deno-kcp`

This context documents the third-party OpenBao web UI sidebar header component that renders the home (logo) link's accessible label. It exists so that the vendored UI code keeps an explicit, checkable contract: the component takes exactly one typed argument, ariaLabel, and guards it with an assertion instead of silently rendering a link with no accessible name. The context is a small unit of the larger deno-kcp repository that vendors OpenBao's UI, and it is spec'd in its own right so changes to the argument shape, the assertion message, or the getter's behavior stay visible rather than being lost inside the vendored tree.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:bd5ab7677744ea05dd0bc6953d747b4f` class SidebarHeaderHomeLinkComponent (third_party/openbao/ui/app/components/sidebar/header/home-link.ts)
- `file:third_party/openbao/ui/app/components/sidebar/header/home-link.ts` file home-link.ts (third_party/openbao/ui/app/components/sidebar/header/home-link.ts)
- `interface:314e7aaffd44b5b7980edc80757e7370` interface SidebarHeaderHomeLinkSignature (third_party/openbao/ui/app/components/sidebar/header/home-link.ts)
- `method:ff7641a0943490c30b273bf834f1cdf2` method SidebarHeaderHomeLinkComponent.ariaLabel (third_party/openbao/ui/app/components/sidebar/header/home-link.ts)
<!-- SPECD_MANAGED_END -->
