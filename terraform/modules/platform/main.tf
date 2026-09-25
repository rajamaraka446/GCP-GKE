locals {
  folder_parent = var.organization_id == "" ? "" : (
    startswith(var.organization_id, "organizations/") ? var.organization_id : "organizations/${var.organization_id}"
  )
  effective_folder_id = var.create_folder ? google_folder.platform[0].name : var.folder_id
  api_services = toset([
    "compute.googleapis.com",
    "container.googleapis.com",
    "dns.googleapis.com",
    "bigquery.googleapis.com",
    "clouderrorreporting.googleapis.com",
    "cloudprofiler.googleapis.com",
    "cloudtrace.googleapis.com",
    "grafana.googleapis.com",
    "iamcredentials.googleapis.com",
    "gkehub.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "servicenetworking.googleapis.com",
    "serviceusage.googleapis.com",
  ])
  iam_bindings = merge(
    { for role in ["roles/viewer", "roles/container.developer", "roles/logging.viewer"] : "dev-${replace(role, "/", "-")}" => { role = role, member = "group:${var.dev_group}" } if var.dev_group != "" },
    { for role in ["roles/container.viewer", "roles/logging.viewer", "roles/monitoring.viewer"] : "ops-${replace(role, "/", "-")}" => { role = role, member = "group:${var.ops_group}" } if var.ops_group != "" },
    { for role in ["roles/container.admin", "roles/logging.viewer", "roles/monitoring.editor"] : "sre-${replace(role, "/", "-")}" => { role = role, member = "group:${var.sre_group}" } if var.sre_group != "" },
    { for role in ["roles/container.developer", "roles/artifactregistry.reader", "roles/iam.serviceAccountUser"] : "cicd-${replace(role, "/", "-")}" => { role = role, member = "serviceAccount:${var.cicd_service_account}" } if var.cicd_service_account != "" },
  )
}

resource "google_folder" "platform" {
  count        = var.create_folder ? 1 : 0
  display_name = "${var.project_name} Platform"
  parent       = local.folder_parent
}

resource "google_project" "platform" {
  count           = var.create_project ? 1 : 0
  project_id      = var.project_id
  name            = var.project_name
  billing_account = var.billing_account
  folder_id       = local.effective_folder_id
}

resource "google_project_service" "platform" {
  for_each           = local.api_services
  project            = var.project_id
  service            = each.value
  disable_on_destroy = false

  depends_on = [google_project.platform]
}

resource "google_project_iam_member" "team" {
  for_each = local.iam_bindings
  project  = var.project_id
  role     = each.value.role
  member   = each.value.member

  depends_on = [google_project_service.platform]
}

resource "google_logging_project_bucket_config" "central" {
  project        = var.project_id
  location       = "global"
  bucket_id      = "central-platform-logs"
  retention_days = 30

  depends_on = [google_project_service.platform]
}

resource "google_logging_project_sink" "central" {
  name        = "central-platform-logs"
  project     = var.project_id
  destination = "logging.googleapis.com/projects/${var.project_id}/locations/global/buckets/${google_logging_project_bucket_config.central.bucket_id}"
  filter      = "NOT LOG_ID(\"cloudaudit.googleapis.com/data_access\") OR severity >= ERROR"

  unique_writer_identity = false
}

resource "google_monitoring_monitored_project" "central" {
  count         = var.monitoring_project_id == "" ? 0 : 1
  metrics_scope = "locations/global/metricsScopes/${var.monitoring_project_id}"
  name          = var.project_id

  depends_on = [google_project_service.platform]
}

resource "google_compute_shared_vpc_host_project" "host" {
  count   = var.shared_vpc_host_project_id == "" ? 0 : 1
  project = var.shared_vpc_host_project_id
}

resource "google_compute_shared_vpc_service_project" "service" {
  for_each        = var.shared_vpc_host_project_id == "" ? toset([]) : var.shared_vpc_service_projects
  host_project    = var.shared_vpc_host_project_id
  service_project = each.value

  depends_on = [google_compute_shared_vpc_host_project.host]
}