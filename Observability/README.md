# Observability

Terraform provisions the native telemetry foundation:

- Cloud Logging exports application and GKE logs to the `gke_observability` BigQuery dataset.
- GKE BackendConfig, VPC Flow Logs, and firewall logging capture edge and network telemetry.
- Cloud Monitoring provides uptime checks, alerting, GKE resource metrics, HPA metrics, and load-balancer metrics.
- Cloud Trace, Cloud Profiler, and Error Reporting APIs are enabled for instrumented workloads.
- Managed Service for Prometheus is enabled through the Monitoring/GKE APIs; workload scraping still requires a GKE `PodMonitoring` resource.
- `kubernetes/observability/pod-monitoring.yaml` scrapes both application `/metrics` endpoints every 30 seconds.
- `grafana/dashboard.json` contains the four dashboard panels for BigQuery errors, pod restarts, latency percentiles, and CPU/memory utilization.

The Google Terraform provider does not currently expose a Managed Service for Grafana workspace resource. After `terraform apply`, create the workspace in Cloud Console or with the Grafana API, use the generated Grafana service account, and import the dashboard JSON. The service account already receives Monitoring, Logging, and Trace viewer access.

Trace spans, live CPU profiling, and automatic exception reporting require OpenTelemetry, Cloud Profiler, and Error Reporting client libraries in the Flask and Node.js images. The corresponding APIs are enabled by Terraform; deploy those instrumented images before treating those three signals as complete.