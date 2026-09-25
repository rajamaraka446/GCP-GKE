resource "google_compute_network" "vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "primary" {
  name          = "${var.network_name}-primary"
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.primary_subnet_cidr

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }

  secondary_ip_range {
    range_name    = "pods-primary"
    ip_cidr_range = var.pod_range_primary
  }

  secondary_ip_range {
    range_name    = "services-primary"
    ip_cidr_range = var.service_range_primary
  }
}

resource "google_compute_subnetwork" "secondary" {
  name          = "${var.network_name}-secondary"
  region        = var.secondary_region
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.secondary_subnet_cidr

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }

  secondary_ip_range {
    range_name    = "pods-secondary"
    ip_cidr_range = var.pod_range_secondary
  }

  secondary_ip_range {
    range_name    = "services-secondary"
    ip_cidr_range = var.service_range_secondary
  }
}

resource "google_compute_subnetwork" "lb_primary" {
  name          = "${var.network_name}-lb-primary"
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.lb_subnet_cidr_primary
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
}

resource "google_compute_subnetwork" "lb_secondary" {
  name          = "${var.network_name}-lb-secondary"
  region        = var.secondary_region
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.lb_subnet_cidr_secondary
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
}

resource "google_compute_subnetwork" "ops_primary" {
  name          = "${var.network_name}-ops-primary"
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.ops_subnet_cidr_primary

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_subnetwork" "ops_secondary" {
  name          = "${var.network_name}-ops-secondary"
  region        = var.secondary_region
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.ops_subnet_cidr_secondary

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_router" "primary" {
  name    = "${var.network_name}-router-primary"
  region  = var.region
  network = google_compute_network.vpc.id
}

resource "google_compute_router" "secondary" {
  name    = "${var.network_name}-router-secondary"
  region  = var.secondary_region
  network = google_compute_network.vpc.id
}

resource "google_compute_address" "nat_primary" {
  count  = var.nat_ip_count_primary
  name   = "${var.network_name}-nat-primary-${count.index + 1}"
  region = var.region
}

resource "google_compute_address" "nat_secondary" {
  count  = var.nat_ip_count_secondary
  name   = "${var.network_name}-nat-secondary-${count.index + 1}"
  region = var.secondary_region
}

resource "google_compute_router_nat" "primary" {
  name                               = "${var.network_name}-nat-primary"
  router                             = google_compute_router.primary.name
  region                             = var.region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.nat_primary[*].self_link
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.primary.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  subnetwork {
    name                    = google_compute_subnetwork.ops_primary.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

resource "google_compute_router_nat" "secondary" {
  name                               = "${var.network_name}-nat-secondary"
  router                             = google_compute_router.secondary.name
  region                             = var.secondary_region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.nat_secondary[*].self_link
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.secondary.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  subnetwork {
    name                    = google_compute_subnetwork.ops_secondary.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

resource "google_compute_global_address" "private_service_access" {
  name          = "${var.network_name}-googleapis-psa"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
}

resource "google_service_networking_connection" "private_service_access" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_service_access.name]
}

resource "google_compute_firewall" "gke_nodes_internal" {
  name    = "${var.network_name}-allow-gke-internal"
  network = google_compute_network.vpc.name

  allow {
    protocol = "all"
  }

  source_ranges = [
    var.primary_subnet_cidr,
    var.secondary_subnet_cidr,
    var.pod_range_primary,
    var.pod_range_secondary,
    var.service_range_primary,
    var.service_range_secondary,
  ]

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_firewall" "health_checks" {
  name    = "${var.network_name}-allow-lb-health-checks"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080"]
  }

  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
  target_tags   = ["gke-node"]

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_firewall" "iap_ssh" {
  name    = "${var.network_name}-allow-iap-ssh"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["gke-node"]

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}
