# Context: third-party-openbao-ui-app-adapters-clients

Repository: `deno-kcp`

The context exists to capture the contract of the OpenBao UI's client adapters for activity-log and version-history data. These adapters are the only place where the UI turns a user's month selection into backend query parameters and where the response shape is given an Ember-compatible `id`. Recording them as a specification keeps the URL paths, the UTC month-boundary arithmetic, the unix-second conversion, and the response normalization stable, because the server-side counters endpoints and the Ember store both depend on exactly those values.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:28703c7716f3a70051305eeb6dcb96c8` class ActivityAdapter (third_party/openbao/ui/app/adapters/clients/activity.js)
- `class:8c7e3e983f41cdb65cb1e6ff766773d7` class VersionHistoryAdapter (third_party/openbao/ui/app/adapters/clients/version-history.js)
- `file:third_party/openbao/ui/app/adapters/clients/activity.js` file activity.js (third_party/openbao/ui/app/adapters/clients/activity.js)
- `file:third_party/openbao/ui/app/adapters/clients/config.js` file config.js (third_party/openbao/ui/app/adapters/clients/config.js)
- `file:third_party/openbao/ui/app/adapters/clients/version-history.js` file version-history.js (third_party/openbao/ui/app/adapters/clients/version-history.js)
<!-- SPECD_MANAGED_END -->
