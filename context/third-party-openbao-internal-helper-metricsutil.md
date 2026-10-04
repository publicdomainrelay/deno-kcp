# Context: third-party-openbao-internal-helper-metricsutil

Repository: `deno-kcp`

_(empty: write what this context is for)_

_The resolved code references are regenerated on every run. Cite the ids above rather than writing them here._

<!-- SPECD_MANAGED_BEGIN -->
## Resolved code references

- `file:third_party/openbao/internal/helper/metricsutil/bucket.go` file bucket.go (third_party/openbao/internal/helper/metricsutil/bucket.go)
- `file:third_party/openbao/internal/helper/metricsutil/bucket_test.go` file bucket_test.go (third_party/openbao/internal/helper/metricsutil/bucket_test.go)
- `file:third_party/openbao/internal/helper/metricsutil/gauge_process.go` file gauge_process.go (third_party/openbao/internal/helper/metricsutil/gauge_process.go)
- `file:third_party/openbao/internal/helper/metricsutil/gauge_process_test.go` file gauge_process_test.go (third_party/openbao/internal/helper/metricsutil/gauge_process_test.go)
- `file:third_party/openbao/internal/helper/metricsutil/metricsutil.go` file metricsutil.go (third_party/openbao/internal/helper/metricsutil/metricsutil.go)
- `file:third_party/openbao/internal/helper/metricsutil/metricsutil_test.go` file metricsutil_test.go (third_party/openbao/internal/helper/metricsutil/metricsutil_test.go)
- `file:third_party/openbao/internal/helper/metricsutil/wrapped_metrics.go` file wrapped_metrics.go (third_party/openbao/internal/helper/metricsutil/wrapped_metrics.go)
- `file:third_party/openbao/internal/helper/metricsutil/wrapped_metrics_test.go` file wrapped_metrics_test.go (third_party/openbao/internal/helper/metricsutil/wrapped_metrics_test.go)
- `function:06a1b4a9af383486f41af9ed08d00691` function FormatFromRequest (third_party/openbao/internal/helper/metricsutil/metricsutil.go)
- `function:09d38a2a272e5fc175f70fbf18d79a5c` function NewGaugeCollectionProcess (third_party/openbao/internal/helper/metricsutil/gauge_process.go)
- `function:133b46b64efe1450de4300ba37c909a4` function NamespaceLabel (third_party/openbao/internal/helper/metricsutil/wrapped_metrics.go)
- `function:3eb4035e4024e3fd2fdf61d6df948613` function NewClusterMetricSink (third_party/openbao/internal/helper/metricsutil/wrapped_metrics.go)
- `function:5292eae29ebbbca15c235ec4603b5b98` function TTLBucket (third_party/openbao/internal/helper/metricsutil/bucket.go)
- `function:6f5b66a4523240a3a7f1d98dfd95eec6` function ExpiryBucket (third_party/openbao/internal/helper/metricsutil/bucket.go)
- `function:7024718abeb00db63f6a581663177485` function BlackholeSink (third_party/openbao/internal/helper/metricsutil/wrapped_metrics.go)
- `function:cd7219ca548a1f92b7e8cb6b8f23f79f` function NewMetricsHelper (third_party/openbao/internal/helper/metricsutil/metricsutil.go)
- `interface:3c7d7a36eafbabeb5182d01503812c9c` interface Metrics (third_party/openbao/internal/helper/metricsutil/wrapped_metrics.go)
- `method:1eb73f58a13fd0e44ffafb2a7a451958` method ClusterMetricSink.AddDurationWithLabels (third_party/openbao/internal/helper/metricsutil/wrapped_metrics.go)
- `method:497863c2d57e7565269727bbe2bce923` method SinkWrapper.AddDurationWithLabels (third_party/openbao/internal/helper/metricsutil/wrapped_metrics.go)
- `method:4cb8ce0b09df550f2a2d516246c88402` method Metrics.MeasureSinceWithLabels (third_party/openbao/internal/helper/metricsutil/wrapped_metrics.go)
- `method:505da085c05d076d33e28d2c2515060d` method GaugeCollectionProcess.Stop (third_party/openbao/internal/helper/metricsutil/gauge_process.go)
- `method:5d193f69089919ef07a4f325ec817cd8` method ClusterMetricSink.MeasureSinceWithLabels (third_party/openbao/internal/helper/metricsutil/wrapped_metrics.go)
- `method:5f91279461293ea622bcca95e362a485` method ClusterMetricSink.NewGaugeCollectionProcess (third_party/openbao/internal/helper/metricsutil/gauge_process.go)
- `method:6e37bcdfdcceb97c6b69d258897db473` method MetricsHelper.PrometheusResponse (third_party/openbao/internal/helper/metricsutil/metricsutil.go)
- `method:72b053473a3b6b3fb0f40d5dd5a81b48` method ClusterMetricSink.IncrCounterWithLabels (third_party/openbao/internal/helper/metricsutil/wrapped_metrics.go)
- `method:797f0bed7ce9d409cedb64a64f43b9bd` method Metrics.IncrCounterWithLabels (third_party/openbao/internal/helper/metricsutil/wrapped_metrics.go)
- `method:8077cc54fbddffece3d556c1651d6c79` method MetricsHelper.ResponseForFormat (third_party/openbao/internal/helper/metricsutil/metricsutil.go)
- `method:966f82646c755e99c15bb69cf5b9e6b8` method ClusterMetricSink.AddSample (third_party/openbao/internal/helper/metricsutil/wrapped_metrics.go)
- `method:b3f08132607d29db698c021d02e07ac5` method Metrics.SetGaugeWithLabels (third_party/openbao/internal/helper/metricsutil/wrapped_metrics.go)
- `method:b5791bd39736f68d5701e7a5d42df54b` method SinkWrapper.MeasureSinceWithLabels (third_party/openbao/internal/helper/metricsutil/wrapped_metrics.go)
- `method:c268214f8aea3772881b0ef42a897e05` method ClusterMetricSink.SetDefaultClusterName (third_party/openbao/internal/helper/metricsutil/wrapped_metrics.go)
- `method:c444b5d2a6474b9646ffda159fea1dfa` method MetricsHelper.CreateMetricsCacheKeyName (third_party/openbao/internal/helper/metricsutil/metricsutil.go)
- `method:c5bb674e8e0fbc82c4c1be4688333167` method MetricsHelper.AddGaugeLoopMetric (third_party/openbao/internal/helper/metricsutil/metricsutil.go)
- `method:c9dc863e9bb7eaebbc7cc6f71ae99cdc` method MetricsHelper.GenericResponse (third_party/openbao/internal/helper/metricsutil/metricsutil.go)
- `method:d437478bf46e5f67e48f73334959c517` method ClusterMetricSink.SetGaugeWithLabels (third_party/openbao/internal/helper/metricsutil/wrapped_metrics.go)
- `method:e17167cb0abe6746a33298d92ec833e2` method Metrics.AddDurationWithLabels (third_party/openbao/internal/helper/metricsutil/wrapped_metrics.go)
- `method:e73fe13ede92e09e3c6eaf53c8298e50` method GaugeCollectionProcess.Run (third_party/openbao/internal/helper/metricsutil/gauge_process.go)
- `method:ef8c102b407bc8603e85647e49d633da` method ClusterMetricSink.SetGauge (third_party/openbao/internal/helper/metricsutil/wrapped_metrics.go)
- `method:f4e3dfdf20e02cdd97e7d09218b2dd62` method ClusterMetricSink.AddSampleWithLabels (third_party/openbao/internal/helper/metricsutil/wrapped_metrics.go)

_9 more reference(s) indexed but not listed here to stay inside the 1500-token budget._
<!-- SPECD_MANAGED_END -->
