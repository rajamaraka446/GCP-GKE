resource "google_bigquery_dataset" "logs" {
  project                     = var.project_id
  dataset_id                  = var.bigquery_dataset_id
  location                    = "US"
  description                 = "Application and GKE logs exported from Cloud Logging."
  delete_contents_on_destroy  = false
  default_table_expiration_ms = 2592000000
}

resource "google_logging_project_sink" "application_logs" {
  name        = "application-logs-to-bigquery"
  project     = var.project_id
  destination = "bigquery.googleapis.com/projects/${var.project_id}/datasets/${google_bigquery_dataset.logs.dataset_id}"
  filter      = "resource.type=\"k8s_container\" AND (labels.k8s-pod/app=\"webapp-a\" OR labels.k8s-pod/app=\"webapp-b\")"

  unique_writer_identity = true
}

resource "google_logging_project_sink" "gke_logs" {
  name        = "gke-platform-logs-to-bigquery"
  project     = var.project_id
  destination = "bigquery.googleapis.com/projects/${var.project_id}/datasets/${google_bigquery_dataset.logs.dataset_id}"
  filter      = "resource.type=\"k8s_node\" OR resource.type=\"k8s_control_plane_component\" OR resource.type=\"k8s_container\""

  unique_writer_identity = true
}

resource "google_bigquery_dataset_iam_member" "application_writer" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.logs.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = google_logging_project_sink.application_logs.writer_identity
}

resource "google_bigquery_dataset_iam_member" "gke_writer" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.logs.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = google_logging_project_sink.gke_logs.writer_identity
}

resource "google_service_account" "grafana" {
  count        = var.enable_grafana ? 1 : 0
  project      = var.project_id
  account_id   = "managed-grafana"
  display_name = "Managed Grafana observability"
}

resource "google_project_iam_member" "grafana_monitoring" {
  count   = var.enable_grafana ? 1 : 0
  project = var.project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.grafana[0].email}"
}

resource "google_project_iam_member" "grafana_logging" {
  count   = var.enable_grafana ? 1 : 0
  project = var.project_id
  role    = "roles/logging.viewer"
  member  = "serviceAccount:${google_service_account.grafana[0].email}"
}

resource "google_project_iam_member" "grafana_trace" {
  count   = var.enable_grafana ? 1 : 0
  project = var.project_id
  role    = "roles/cloudtrace.user"
  member  = "serviceAccount:${google_service_account.grafana[0].email}"
}

resource "google_monitoring_uptime_check_config" "customer" {
  project      = var.project_id
  display_name = "Customer HTTPS endpoint"
  timeout      = "10s"
  period       = "60s"

  http_check {
    path         = "/"
    port         = 443
    use_ssl      = true
    validate_ssl = true
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      host = var.customer_domain
    }
  }
}

resource "google_monitoring_alert_policy" "uptime" {
  project      = var.project_id
  display_name = "Customer endpoint unavailable"
  combiner     = "OR"

  conditions {
    display_name = "HTTPS uptime check failed"

    condition_threshold {
      filter          = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND resource.type=\"uptime_url\""
      comparison      = "COMPARISON_LT"
      threshold_value = 1
      duration        = "300s"

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_FRACTION_TRUE"
      }
    }
  }
}