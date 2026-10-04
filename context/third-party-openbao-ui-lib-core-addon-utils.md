# Context: third-party-openbao-ui-lib-core-addon-utils

Repository: `deno-kcp`

This context exists so that the shared, non-visual helpers of the OpenBao core addon have one described specification instead of being re-derived from source each time. The helpers exist because several components need the same primitive operations: base64 round-tripping for transit and copy-toggle widgets, consistent API-timestamp parsing and chart labelling for the clients and calendar views, a single seconds/unit conversion surface shared by the TTL picker and info table row so a duration entered in days and a duration stored in seconds agree, and one place that knows how to write a has-many selection back onto an Ember Data model. The context records the observable contract of each exported function, the input shapes they accept, the fallback behaviour on bad input, and the unit-selection rule that duration display depends on.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/ui/lib/core/addon/utils/b64.js` file b64.js (third_party/openbao/ui/lib/core/addon/utils/b64.js)
- `file:third_party/openbao/ui/lib/core/addon/utils/common-prefix.js` file common-prefix.js (third_party/openbao/ui/lib/core/addon/utils/common-prefix.js)
- `file:third_party/openbao/ui/lib/core/addon/utils/date-formatters.js` file date-formatters.js (third_party/openbao/ui/lib/core/addon/utils/date-formatters.js)
- `file:third_party/openbao/ui/lib/core/addon/utils/duration-utils.ts` file duration-utils.ts (third_party/openbao/ui/lib/core/addon/utils/duration-utils.ts)
- `file:third_party/openbao/ui/lib/core/addon/utils/parse-url.js` file parse-url.js (third_party/openbao/ui/lib/core/addon/utils/parse-url.js)
- `file:third_party/openbao/ui/lib/core/addon/utils/search-select-has-many.js` file search-select-has-many.js (third_party/openbao/ui/lib/core/addon/utils/search-select-has-many.js)
- `file:third_party/openbao/ui/lib/core/addon/utils/timestamp.js` file timestamp.js (third_party/openbao/ui/lib/core/addon/utils/timestamp.js)
- `function:4883e25fd659500dddab0e7cb7167f6c` function largestUnitFromSeconds (third_party/openbao/ui/lib/core/addon/utils/duration-utils.ts)
- `function:880ff6cadc7123538d3b7ba208f1ff2f` function convertToSeconds (third_party/openbao/ui/lib/core/addon/utils/duration-utils.ts)
- `function:8ee96ffe8fcdd8fe63a85e242a7c0d26` function convertFromSeconds (third_party/openbao/ui/lib/core/addon/utils/duration-utils.ts)
- `function:a1a11e18e8d9536d1a1b9d284dec6698` function formatChartDate (third_party/openbao/ui/lib/core/addon/utils/date-formatters.js)
- `function:aec97de0630778f834a60ada6511e3a2` function handleHasManySelection (third_party/openbao/ui/lib/core/addon/utils/search-select-has-many.js)
- `function:b84b4c3e73b94b65de385a0caba1d311` function decodeString (third_party/openbao/ui/lib/core/addon/utils/b64.js)
- `function:da93833cd88a359145d99c922952423e` function encodeString (third_party/openbao/ui/lib/core/addon/utils/b64.js)
- `function:f6f7d4b2a6461178b24f810c6b690b24` function parseAPITimestamp (third_party/openbao/ui/lib/core/addon/utils/date-formatters.js)
- `function:fe68eefde45a1e689b83dc55bc675a4f` function goSafeConvertFromSeconds (third_party/openbao/ui/lib/core/addon/utils/duration-utils.ts)
<!-- SPECD_MANAGED_END -->
