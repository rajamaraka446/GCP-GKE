output "bigquery_dataset" {
  value = google_bigquery_dataset.logs.dataset_id
}

output "grafana_workspace_endpoint" {
  value = null
}

output "uptime_check" {
  value = google_monitoring_uptime_check_config.customer.name
}