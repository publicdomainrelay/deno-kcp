# Context: third-party-openbao-ui-lib-service-worker-authenticated-download-service-worker

Repository: `deno-kcp`

This context exists so the OpenBao web UI can download protected server-generated files, notably Raft snapshots, without exposing the Vault token to plain anchor or window downloads. The service worker sits between the page and the API, injects the token fetched from an open window client at request time, and leaves all other traffic untouched, keeping the interception surface limited to the snapshot endpoint.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/lib/service-worker-authenticated-download/service-worker/index.js` file index.js (third_party/openbao/ui/lib/service-worker-authenticated-download/service-worker/index.js)
<!-- SPECD_MANAGED_END -->
