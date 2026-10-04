# Context: third-party-openbao-ui-lib-pki-addon-controllers-certificates

Repository: `deno-kcp`

The context exists so that the certificates index controller has a describable specification. Downstream tooling needs to know that the controller is the state holder for the certificates list view: the template binds its filter input to the controller's filter property and its focus state to filterFocused, and it renders the PKI mount path from mountPoint. Capturing these three members as requirements lets a consumer reimplement or stub the controller without reading the vendored file.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `class:a0a47a7a63c178fa46676e5a09be7401` class PkiCertificatesIndexController (third_party/openbao/ui/lib/pki/addon/controllers/certificates/index.js)
- `file:third_party/openbao/ui/lib/pki/addon/controllers/certificates/index.js` file index.js (third_party/openbao/ui/lib/pki/addon/controllers/certificates/index.js)
<!-- SPECD_MANAGED_END -->
