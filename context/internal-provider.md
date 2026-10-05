# Context: internal-provider

Repository: `deno-kcp`

This context exists because the provider is the only place in the repository that knows both the deno.computer API surface and the kcp-libs machinery that reads and writes it. It exists to keep three concerns in one describable unit: the API facade (Registry plus the Instances, Reader, Runtime and TokenMinter seams that let tests substitute a fake or a watch cache), the controller loop (watch, admit, decide, write status, finalize), and the operational surfaces a deployment depends on (metrics endpoint, DNS shim, service FQDN resolution, OpenBao PKI, trust bundle). It also carries the live cluster harnesses, so the contract this document states is the contract those harnesses exercise against a real KCP.

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:internal/provider/admission.go` file admission.go (internal/provider/admission.go)
- `file:internal/provider/admission_test.go` file admission_test.go (internal/provider/admission_test.go)
- `file:internal/provider/cluster_path.go` file cluster_path.go (internal/provider/cluster_path.go)
- `file:internal/provider/driver.go` file driver.go (internal/provider/driver.go)
- `file:internal/provider/live_denojob_drain_test.go` file live_denojob_drain_test.go (internal/provider/live_denojob_drain_test.go)
- `file:internal/provider/live_denoruntime_test.go` file live_denoruntime_test.go (internal/provider/live_denoruntime_test.go)
- `file:internal/provider/live_helpers_test.go` file live_helpers_test.go (internal/provider/live_helpers_test.go)
- `file:internal/provider/live_maxconcurrent_test.go` file live_maxconcurrent_test.go (internal/provider/live_maxconcurrent_test.go)
- `file:internal/provider/live_native_admission_test.go` file live_native_admission_test.go (internal/provider/live_native_admission_test.go)
- `file:internal/provider/live_ttl_test.go` file live_ttl_test.go (internal/provider/live_ttl_test.go)
- `file:internal/provider/main_test.go` file main_test.go (internal/provider/main_test.go)
- `file:internal/provider/metrics.go` file metrics.go (internal/provider/metrics.go)
- `file:internal/provider/metrics_test.go` file metrics_test.go (internal/provider/metrics_test.go)
- `file:internal/provider/provider.go` file provider.go (internal/provider/provider.go)
- `file:internal/provider/provider_runtime.go` file provider_runtime.go (internal/provider/provider_runtime.go)
- `file:internal/provider/provider_runtime_test.go` file provider_runtime_test.go (internal/provider/provider_runtime_test.go)
- `file:internal/provider/provider_test.go` file provider_test.go (internal/provider/provider_test.go)
- `file:internal/provider/reconcile_engine.go` file reconcile_engine.go (internal/provider/reconcile_engine.go)
- `file:internal/provider/reconcile_job.go` file reconcile_job.go (internal/provider/reconcile_job.go)
- `file:internal/provider/reconcile_openbao.go` file reconcile_openbao.go (internal/provider/reconcile_openbao.go)
- `file:internal/provider/reconcile_openbao_test.go` file reconcile_openbao_test.go (internal/provider/reconcile_openbao_test.go)
- `file:internal/provider/reconcile_pod.go` file reconcile_pod.go (internal/provider/reconcile_pod.go)
- `file:internal/provider/reconcile_run.go` file reconcile_run.go (internal/provider/reconcile_run.go)
- `file:internal/provider/reconcile_trigger.go` file reconcile_trigger.go (internal/provider/reconcile_trigger.go)
- `file:internal/provider/reconcile_workflowpod.go` file reconcile_workflowpod.go (internal/provider/reconcile_workflowpod.go)
- `file:internal/provider/registry.go` file registry.go (internal/provider/registry.go)
- `file:internal/provider/registry_engine.go` file registry_engine.go (internal/provider/registry_engine.go)
- `file:internal/provider/registry_job.go` file registry_job.go (internal/provider/registry_job.go)
- `file:internal/provider/registry_openbao.go` file registry_openbao.go (internal/provider/registry_openbao.go)
- `file:internal/provider/registry_pod.go` file registry_pod.go (internal/provider/registry_pod.go)
- `file:internal/provider/registry_run.go` file registry_run.go (internal/provider/registry_run.go)
- `file:internal/provider/registry_runtime.go` file registry_runtime.go (internal/provider/registry_runtime.go)
- `file:internal/provider/registry_test.go` file registry_test.go (internal/provider/registry_test.go)
- `file:internal/provider/registry_trigger.go` file registry_trigger.go (internal/provider/registry_trigger.go)
- `file:internal/provider/registry_workflowpod.go` file registry_workflowpod.go (internal/provider/registry_workflowpod.go)
- `file:internal/provider/run_refs.go` file run_refs.go (internal/provider/run_refs.go)
- `file:internal/provider/run_refs_test.go` file run_refs_test.go (internal/provider/run_refs_test.go)
- `file:internal/provider/service_dns.go` file service_dns.go (internal/provider/service_dns.go)
- `file:internal/provider/service_dns_inject_test.go` file service_dns_inject_test.go (internal/provider/service_dns_inject_test.go)
- `file:internal/provider/watch.go` file watch.go (internal/provider/watch.go)
- `file:internal/provider/watch_cache.go` file watch_cache.go (internal/provider/watch_cache.go)
- `file:internal/provider/watch_test.go` file watch_test.go (internal/provider/watch_test.go)
- `function:d8299700880b325d38c3aa20aa84ac24` function NewRegistry (internal/provider/registry.go)
- `function:f4e5cfdbb89305e5310f8800b3c5e307` function New (internal/provider/provider.go)
- `interface:4823d030f55cc3629f5f52b93b924b77` interface Reader (internal/provider/provider.go)
- `interface:79e02cbf716ad7f732147264ef6ffc96` interface Instances (internal/provider/provider.go)
- `interface:c7e3ce30c0c4b864a4256ae1255ecf6f` interface Runtime (internal/provider/provider_runtime.go)
- `interface:d81c0020017b8c1b77c14748b34a1695` interface TokenMinter (internal/provider/provider_runtime.go)
- `method:01cb819eee51f5237be8f8e6f1639443` method Registry.CreateJob (internal/provider/registry_job.go)
- `method:0336e9c05327f7b15cb6ddb11d9ecda3` method Registry.Read (internal/provider/registry.go)
- `method:04c9c12ef6ee491671f3ef14f8486cee` method Runtime.WriteRunStatus (internal/provider/provider_runtime.go)
- `method:08cbdd1a97d2aeb9d9187918def0a3ff` method TokenMinter.MintServiceAccountToken (internal/provider/provider_runtime.go)
- `method:0a1baf118dfd1184e6e20c9bc6c2149d` method Runtime.WriteEngineStatus (internal/provider/provider_runtime.go)
- `method:0c338b727be3207f28cbf878427e832a` method cacheReader.Read (internal/provider/watch_cache.go)
- `method:0cb5c9e3b143e0c4ed9b5147fe59f6b3` method Registry.WriteJobStatus (internal/provider/registry_job.go)

_103 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
