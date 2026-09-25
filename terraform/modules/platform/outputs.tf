output "project_id" {
  value = var.project_id
}

output "folder_id" {
  value = local.effective_folder_id
}

output "logging_bucket" {
  value = google_logging_project_bucket_config.central.bucket_id
}