resource "google_container_cluster" "primary" {
  name     = "primary-gke-cluster"
  location = var.region
  remove_default_node_pool = true
  initial_node_count = 1
}

resource "google_container_node_pool" "web_pool" {
  name       = "web-pool"
  cluster    = google_container_cluster.primary.name
  location   = var.region
  node_count = 2

  node_config {
    machine_type = "e2-standard-2"
  }
}
