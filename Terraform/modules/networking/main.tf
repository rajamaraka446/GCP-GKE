resource "google_compute_network" "gke_vpc" {
  name                    = "gke-prod-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "primary" {
  name          = "gke-primary-subnet"
  region        = var.region
  network       = google_compute_network.gke_vpc.id
  ip_cidr_range = "10.10.0.0/20"
}

resource "google_compute_subnetwork" "secondary" {
  name          = "gke-secondary-subnet"
  region        = var.secondary_region
  network       = google_compute_network.gke_vpc.id
  ip_cidr_range = "10.20.0.0/20"
}
