# Context: third-party-openbao-ui-lib-pki-addon-controllers-tidy

Repository: `deno-kcp`

This context exists to describe the tidy-status polling behavior of the PKI addon's tidy index route. The controller gives the pki.tidy.index template a live view of the secret engine's tidy operation by refreshing tidyStatus on a fixed 5 second interval, while disabling polling under acceptance tests to keep promises settled and avoiding loop termination on transient request failures.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:a10e46a1c1ea70fb8bd55ac9fe989d4c` class PkiTidyIndexController (third_party/openbao/ui/lib/pki/addon/controllers/tidy/index.js)
- `file:third_party/openbao/ui/lib/pki/addon/controllers/tidy/index.js` file index.js (third_party/openbao/ui/lib/pki/addon/controllers/tidy/index.js)
<!-- SPECD_MANAGED_END -->
