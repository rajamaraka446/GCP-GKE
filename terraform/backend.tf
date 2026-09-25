terraform {
  backend "gcs" {
    bucket = "iris-gke-prod-tf-state"
    prefix = "terraform/state"
  }
}
