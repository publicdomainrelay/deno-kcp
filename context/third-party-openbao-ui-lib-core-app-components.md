# Context: third-party-openbao-ui-lib-core-app-components

Repository: `deno-kcp`

This context exists so the host OpenBao UI application, and any code that resolves components out of app/components, can reach the addon's component implementations through app-local paths. Each file is a thin forwarding module rather than an implementation: it pins the public name of a component (the file basename, which drives Ember's component resolution) to the addon module that actually implements it, keeping the vendored third_party tree free of duplicated component source while preserving the standard app/components lookup path. The spec records that forwarding contract, the licence header convention, and the one deliberate name divergence, so edits to this directory do not silently break resolution or drop attribution.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/lib/core/app/components/alert-banner.js` file alert-banner.js (third_party/openbao/ui/lib/core/app/components/alert-banner.js)
- `file:third_party/openbao/ui/lib/core/app/components/alert-inline.js` file alert-inline.js (third_party/openbao/ui/lib/core/app/components/alert-inline.js)
- `file:third_party/openbao/ui/lib/core/app/components/alert-popup.js` file alert-popup.js (third_party/openbao/ui/lib/core/app/components/alert-popup.js)
- `file:third_party/openbao/ui/lib/core/app/components/autocomplete-input.js` file autocomplete-input.js (third_party/openbao/ui/lib/core/app/components/autocomplete-input.js)
- `file:third_party/openbao/ui/lib/core/app/components/box-radio.js` file box-radio.js (third_party/openbao/ui/lib/core/app/components/box-radio.js)
- `file:third_party/openbao/ui/lib/core/app/components/checkbox-grid.js` file checkbox-grid.js (third_party/openbao/ui/lib/core/app/components/checkbox-grid.js)
- `file:third_party/openbao/ui/lib/core/app/components/chevron.js` file chevron.js (third_party/openbao/ui/lib/core/app/components/chevron.js)
- `file:third_party/openbao/ui/lib/core/app/components/confirm-action.js` file confirm-action.js (third_party/openbao/ui/lib/core/app/components/confirm-action.js)
- `file:third_party/openbao/ui/lib/core/app/components/confirm.js` file confirm.js (third_party/openbao/ui/lib/core/app/components/confirm.js)
- `file:third_party/openbao/ui/lib/core/app/components/confirmation-modal.js` file confirmation-modal.js (third_party/openbao/ui/lib/core/app/components/confirmation-modal.js)
- `file:third_party/openbao/ui/lib/core/app/components/doc-link.js` file doc-link.js (third_party/openbao/ui/lib/core/app/components/doc-link.js)
- `file:third_party/openbao/ui/lib/core/app/components/download-button.js` file download-button.js (third_party/openbao/ui/lib/core/app/components/download-button.js)
- `file:third_party/openbao/ui/lib/core/app/components/edit-form.js` file edit-form.js (third_party/openbao/ui/lib/core/app/components/edit-form.js)
- `file:third_party/openbao/ui/lib/core/app/components/empty-state.js` file empty-state.js (third_party/openbao/ui/lib/core/app/components/empty-state.js)
- `file:third_party/openbao/ui/lib/core/app/components/external-link.js` file external-link.js (third_party/openbao/ui/lib/core/app/components/external-link.js)
- `file:third_party/openbao/ui/lib/core/app/components/field-group-show.js` file field-group-show.js (third_party/openbao/ui/lib/core/app/components/field-group-show.js)
- `file:third_party/openbao/ui/lib/core/app/components/form-error.js` file form-error.js (third_party/openbao/ui/lib/core/app/components/form-error.js)
- `file:third_party/openbao/ui/lib/core/app/components/form-field-groups-loop.js` file form-field-groups-loop.js (third_party/openbao/ui/lib/core/app/components/form-field-groups-loop.js)
- `file:third_party/openbao/ui/lib/core/app/components/form-field-groups.js` file form-field-groups.js (third_party/openbao/ui/lib/core/app/components/form-field-groups.js)
- `file:third_party/openbao/ui/lib/core/app/components/form-field-label.js` file form-field-label.js (third_party/openbao/ui/lib/core/app/components/form-field-label.js)
- `file:third_party/openbao/ui/lib/core/app/components/form-field.js` file form-field.js (third_party/openbao/ui/lib/core/app/components/form-field.js)
- `file:third_party/openbao/ui/lib/core/app/components/form-save-buttons.js` file form-save-buttons.js (third_party/openbao/ui/lib/core/app/components/form-save-buttons.js)
- `file:third_party/openbao/ui/lib/core/app/components/icon.js` file icon.js (third_party/openbao/ui/lib/core/app/components/icon.js)
- `file:third_party/openbao/ui/lib/core/app/components/info-table-item-array.js` file info-table-item-array.js (third_party/openbao/ui/lib/core/app/components/info-table-item-array.js)
- `file:third_party/openbao/ui/lib/core/app/components/info-table-row.js` file info-table-row.js (third_party/openbao/ui/lib/core/app/components/info-table-row.js)
- `file:third_party/openbao/ui/lib/core/app/components/info-table.js` file info-table.js (third_party/openbao/ui/lib/core/app/components/info-table.js)
- `file:third_party/openbao/ui/lib/core/app/components/info-tooltip.js` file info-tooltip.js (third_party/openbao/ui/lib/core/app/components/info-tooltip.js)
- `file:third_party/openbao/ui/lib/core/app/components/input-search.js` file input-search.js (third_party/openbao/ui/lib/core/app/components/input-search.js)
- `file:third_party/openbao/ui/lib/core/app/components/json-editor.js` file json-editor.js (third_party/openbao/ui/lib/core/app/components/json-editor.js)
- `file:third_party/openbao/ui/lib/core/app/components/key-value-header.js` file key-value-header.js (third_party/openbao/ui/lib/core/app/components/key-value-header.js)
- `file:third_party/openbao/ui/lib/core/app/components/kv-object-editor.js` file kv-object-editor.js (third_party/openbao/ui/lib/core/app/components/kv-object-editor.js)
- `file:third_party/openbao/ui/lib/core/app/components/layout-loading.js` file layout-loading.js (third_party/openbao/ui/lib/core/app/components/layout-loading.js)
- `file:third_party/openbao/ui/lib/core/app/components/linked-block.js` file linked-block.js (third_party/openbao/ui/lib/core/app/components/linked-block.js)
- `file:third_party/openbao/ui/lib/core/app/components/list-item.js` file list-item.js (third_party/openbao/ui/lib/core/app/components/list-item.js)
- `file:third_party/openbao/ui/lib/core/app/components/list-pagination.js` file list-pagination.js (third_party/openbao/ui/lib/core/app/components/list-pagination.js)
- `file:third_party/openbao/ui/lib/core/app/components/list-view.js` file list-view.js (third_party/openbao/ui/lib/core/app/components/list-view.js)
- `file:third_party/openbao/ui/lib/core/app/components/masked-input.js` file masked-input.js (third_party/openbao/ui/lib/core/app/components/masked-input.js)

_34 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
