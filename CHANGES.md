# Changes on `open-architecture/deno-kcp--spec-bidder-and-bob-pds-policy-20261005`

The requirement-level delta against `open-architecture/deno-kcp--spec-bidder-and-bob-pds-policy-20261005`, and what this branch realized.

## Requirements

### cmd-deno-kcp-provider

- intent: "" -> "This context exists to pin down the provider's process boundary: the single main that turns operator input (flags and environment) into the registry, engine runner, pod runner and provider the controller needs, and the failure and shutdown behaviour around them. Everything else in the repository assumes a configured provider already exists; this context is what makes one."
- added `r.bundled-actions-default` (MUST): "When --bundled-actions-dir is empty, main derives it as the policy engine directory joined with "/../policies/gha-lite/bundled-actions" rather than leaving it unset."
- added `r.ca-data-fallback` (MUST): "caData returns the REST config's CAData when it is non-empty, otherwise the contents of CAFile when that file reads successfully, otherwise nil."
- added `r.config-surface` (MUST): "Every setting is a flag whose default is the environment variable and then a fixed fallback, in the order flag, then environment, then default: --kubeconfig (KUBECONFIG, empty), --host (KCP_HOST, empty), --runs-dir (RUNS_DIR, "runs"), --policy-engine-dir (POLICY_ENGINE_DIR, "../policy-engine/lib/policy-engine-server-gha-lite"), --bundled-actions-dir (BUNDLED_ACTIONS_DIR, empty), --deno-bin (DENO_BIN, "deno"), --pod-timeout (no environment variable, 5m), --token-ttl (no environment variable, 1h), --metrics-listen (METRICS_LISTEN, empty, disabling the endpoint), --run-ttl-seconds (RUN_TTL_SECONDS, 3600, negative disables), --write-status (no environment variable, true), --service-domain (KCP_SERVICE_DOMAIN, "kcp.local"), --openbao-addr (OPENBAO_ADDR, empty), --openbao-token (OPENBAO_TOKEN, empty), --openbao-ca-cert (OPENBAO_CACERT, empty), --openbao-mount (OPENBAO_MOUNT, "pki"), --openbao-role (OPENBAO_ROLE, "denopod"), --openbao-intermediate-ttl (OPENBAO_INTERMEDIATE_TTL, "43800h") and --openbao-leaf-ttl (OPENBAO_LEAF_TTL, "720h")."
- added `r.construction-order` (MUST): "main builds the registry with provider.NewRegistry, the engine runner with execrunner.NewEngine, the exec pod runner with execrunner.NewPod, and then the provider with provider.New, passing the registry as runtime and minter and the pod and engine runners in; each failure logs its own message ("building registry", "building engine runner", "building exec pod runner", "building provider") and exits with status 1."
- added `r.deferred-trust-bundle` (MUST): "The exec pod runner's TrustBundle is a closure that returns caData(restCfg) while the provider is still nil and providerImpl.TrustBundle() once it exists, because the OpenBao root CA does not exist until a namespace has asked for a certificate and the provider that generates it is built from this runner."
- added `r.disable-watch-list-client` (MUST): "main sets KUBE_FEATURE_WatchListClient to false before any client-go call, because kcp's APIExport virtual workspace sends no bookmark and an informer's initial list would otherwise never complete, leaving a provider that looks healthy and reconciles nothing."
- added `r.flag-env-fallback` (MUST): "envOr answers the environment variable when it is non-empty and the fallback otherwise, and envOrInt64 answers the parsed base-10 64-bit value when the variable is non-empty and parses, otherwise the fallback; both feed flag defaults so an unset or unparseable variable never overrides the compiled-in value."
- added `r.negative-run-ttl-disables` (MUST): "defaultRunTTL answers nil for a negative seconds value, which disables the default run TTL, and otherwise returns a pointer to a copy of the value, which main passes on as DefaultRunTTLSeconds."
- added `r.openbao-ca-read-nonfatal` (SHOULD): "readIfSet returns nil for an empty path, and for a path it cannot read it logs a warning naming the path and returns nil rather than failing startup, so a mistyped CA path surfaces as failed TLS verification instead of a provider that will not start."
- added `r.require-kubeconfig` (MUST): "main writes "deno-kcp-provider: --kubeconfig or KUBECONFIG is required" to stderr and exits with status 2 when the kubeconfig setting is empty."
- added `r.rest-config-and-host` (MUST): "main builds the REST config with clientcmd.BuildConfigFromFlags from the kubeconfig path, exits 1 with a logged "loading kubeconfig" error when that fails, and passes the same host to the registry and the provider: the kubeconfig's server unless --host is set, in which case the flag wins."
- added `r.run-until-signal` (MUST): "main runs providerImpl.Run under a context cancelled by SIGINT or SIGTERM and exits with status 1 after logging "provider stopped" if Run returns an error."
- added `r.single-binary-entrypoint` (MUST): "The package provides one main function that acts as the provider process entrypoint, declares a config struct for its settings, and holds no reconcile logic; the remaining behaviour lives in the helpers envOr, envOrInt64, defaultRunTTL, caData and readIfSet."

## Realization

| change | direction | phase | commit | verify | acceptance | coverage |
| --- | --- | --- | --- | --- | --- | --- |
| api-v1alpha1-c2s-25d10f922ec7-25d10f922ec7 | CodeToSpec | Running |  | 0 | - | - |
| cmd-deno-kcp-provider-c2s-25d10f922ec7-25d10f922ec7 | CodeToSpec | Succeeded |  | 0 | - | - |
