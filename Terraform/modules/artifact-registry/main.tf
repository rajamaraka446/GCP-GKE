resource "google_artifact_registry_repository" "docker" {
  location      = var.region
  repository_id = "production-images"
  format        = "DOCKER"
}
