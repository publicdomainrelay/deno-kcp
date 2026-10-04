# Context: third-party-openbao-ui-app-decorators

Repository: `deno-kcp`

This context exists so the spec records the extension points the OpenBao UI uses to dress ember-data models with form and validation metadata. Consumers decorate model classes (namespace, secret-engine, pki tidy, kubernetes config and role, pki certificate and issuer models, and others) to get expanded attribute descriptors, grouped form fields, and declarative validation, without hand-writing that plumbing per model. The decorators are the contract between the model layer and the form rendering layer, so their guard behaviour, caching, key naming and validation result shape must stay stable.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/app/decorators/model-expanded-attributes.js` file model-expanded-attributes.js (third_party/openbao/ui/app/decorators/model-expanded-attributes.js)
- `file:third_party/openbao/ui/app/decorators/model-form-fields.js` file model-form-fields.js (third_party/openbao/ui/app/decorators/model-form-fields.js)
- `file:third_party/openbao/ui/app/decorators/model-validations.js` file model-validations.js (third_party/openbao/ui/app/decorators/model-validations.js)
- `function:00795d06d3612390aeda0a208077b716` function decorator (third_party/openbao/ui/app/decorators/model-expanded-attributes.js)
- `function:078310696418233c794effc6cf398319` function withFormFields (third_party/openbao/ui/app/decorators/model-form-fields.js)
- `function:326f30a1b627a85d702c7982e0cef873` function withExpandedAttributes (third_party/openbao/ui/app/decorators/model-expanded-attributes.js)
- `function:b62719b170881ccf45b15dcef4a3b508` function withModelValidations (third_party/openbao/ui/app/decorators/model-validations.js)
<!-- SPECD_MANAGED_END -->
