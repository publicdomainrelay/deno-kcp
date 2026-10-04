# Context: third-party-openbao-internal-helper-systemd

Repository: `deno-kcp`

This context exists because the OpenBao server, agent, and proxy commands need to tell systemd that the process has finished starting up, and the vendored helper provides that capability in-tree. Keeping the sd_notify logic in its own package means the command layer only needs to call Notify with a state string such as "READY=1", and the helper decides from NOTIFY_SOCKET whether a systemd supervisor is actually present. It is a third-party vendored component inside this repository, so its behavior must keep matching upstream.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/helper/systemd/notify.go` file notify.go (third_party/openbao/internal/helper/systemd/notify.go)
- `function:5a861bf0e5d16ced0557d16459574b49` function Notify (third_party/openbao/internal/helper/systemd/notify.go)
<!-- SPECD_MANAGED_END -->
